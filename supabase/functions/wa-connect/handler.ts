type Config = {
  url: string;
  publicKey: string;
  serviceKey: string;
  evolutionUrl: string;
  evolutionKey: string;
};

type Row = { id: string; instance_id: string; status: string };

const UUID = /^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$/i;
const INSTANCE = /^[A-Za-z0-9][A-Za-z0-9._-]{0,119}$/;
const sleep = (ms: number) => new Promise((resolve) => {
  setTimeout(resolve, ms);
});

// The owner comes from the verified JWT, never from the request body (AI-4a).
// Upstream bodies are never echoed: they can carry tokens or phone numbers.
export function createHandler(
  config: Config,
  request: typeof fetch = fetch,
  pause: (ms: number) => Promise<unknown> = sleep,
) {
  return async (req: Request): Promise<Response> => {
    const reply = (status: number, payload: Record<string, unknown>) =>
      Response.json(payload, { status });
    if (req.method !== "POST") return reply(405, { code: "method_not_allowed" });
    const authorization = req.headers.get("authorization") ?? "";
    if (!/^Bearer \S+$/i.test(authorization)) {
      return reply(401, { code: "authentication_required" });
    }
    if (!config.url || !config.publicKey || !config.serviceKey ||
        !config.evolutionUrl || !config.evolutionKey) {
      return reply(503, { code: "unavailable" });
    }

    const admin = {
      apikey: config.serviceKey,
      Authorization: `Bearer ${config.serviceKey}`,
      "Content-Type": "application/json",
    };
    const evolution = async (path: string, method = "GET", body?: unknown) =>
      request(`${config.evolutionUrl}${path}`, {
        method,
        headers: { apikey: config.evolutionKey, "Content-Type": "application/json" },
        body: body === undefined ? undefined : JSON.stringify(body),
        signal: AbortSignal.timeout(20000),
      });

    try {
      const verified = await request(`${config.url}/auth/v1/user`, {
        headers: { apikey: config.publicKey, Authorization: authorization },
        signal: AbortSignal.timeout(15000),
      });
      if (!verified.ok) {
        return reply(verified.status >= 500 ? 503 : 401, {
          code: verified.status >= 500 ? "unavailable" : "authentication_required",
        });
      }
      const user = await verified.json();
      if (typeof user?.id !== "string" || !UUID.test(user.id)) {
        return reply(401, { code: "authentication_required" });
      }
      const ownerId: string = user.id;

      let body: Record<string, unknown> = {};
      try {
        const parsed = await req.json();
        if (parsed && typeof parsed === "object") body = parsed;
      } catch {
        body = {};
      }
      const wanted = normalizeNumber(body.number);
      if (wanted === undefined) return reply(400, { code: "invalid_number" });

      const listed = await request(
        `${config.url}/rest/v1/wa_connections?owner_id=eq.${ownerId}` +
          `&deleted_at=is.null&select=id,instance_id,status&limit=1`,
        { headers: admin, signal: AbortSignal.timeout(15000) },
      );
      if (!listed.ok) return reply(503, { code: "unavailable" });
      const existing = await listed.json();
      const row: Row | null = Array.isArray(existing) && existing.length > 0 ? existing[0] : null;

      const instanceId: string = row?.instance_id ??
        `laurum-${ownerId.replace(/-/g, "").slice(0, 8)}`;
      if (!INSTANCE.test(instanceId)) return reply(503, { code: "unavailable" });

      let state = await connectionState(evolution, instanceId);
      if (state === undefined) return reply(503, { code: "unavailable" });

      if (state === null) {
        const created = await evolution("/instance/create", "POST", {
          instanceName: instanceId,
          qrcode: false,
          integration: "WHATSAPP-BAILEYS",
          groupsIgnore: true,
          readMessages: true,
          alwaysOnline: false,
          syncFullHistory: false,
        });
        if (!created.ok && created.status !== 409) return reply(503, { code: "unavailable" });
        state = "close";
      }

      if (!row) {
        const inserted = await request(`${config.url}/rest/v1/wa_connections`, {
          method: "POST",
          headers: { ...admin, Prefer: "return=minimal" },
          body: JSON.stringify({
            id: crypto.randomUUID(),
            owner_id: ownerId,
            instance_id: instanceId,
            status: "menunggu",
          }),
          signal: AbortSignal.timeout(15000),
        });
        if (!inserted.ok && inserted.status !== 409) {
          return reply(503, { code: "unavailable" });
        }
      }

      if (state === "open") {
        return reply(200, { code: "already_connected", instanceId });
      }

      if (wanted !== null && state === "connecting") {
        const closed = await evolution(`/instance/logout/${instanceId}`, "DELETE");
        if (!closed.ok) return reply(503, { code: "unavailable" });
        for (let attempt = 0; attempt < 5; attempt++) {
          await pause(500);
          const next = await connectionState(evolution, instanceId);
          if (next === undefined) return reply(503, { code: "unavailable" });
          if (next !== "connecting") break;
        }
      }

      const trigger = await evolution(
        `/instance/connect/${instanceId}${wanted === null ? "" : `?number=${wanted}`}`,
      );
      if (trigger.status === 404) {
        return reply(503, { code: "unavailable" });
      }

      for (let attempt = 0; attempt < 8; attempt++) {
        await pause(1000);
        const codes = await evolution(`/instance/connect/${instanceId}`);
        if (!codes.ok) return reply(503, { code: "unavailable" });
        const qrcode = await codes.json();
        const qr = typeof qrcode?.base64 === "string" ? qrcode.base64 : "";
        const pairingCode = typeof qrcode?.pairingCode === "string" ? qrcode.pairingCode : "";
        if (!qr) continue;
        if (wanted !== null && !pairingCode) continue;
        if (wanted === null) {
          return reply(200, { code: "qr", instanceId, qr, expiresInSeconds: 60 });
        }
        return reply(200, {
          code: "pairing",
          instanceId,
          qr,
          pairingCode,
          expiresInSeconds: 60,
        });
      }
      return reply(504, { code: "not_ready" });
    } catch {
      return reply(503, { code: "unavailable" });
    }
  };
}

// Baileys expects international digits; Indonesian owners type a leading zero.
export function normalizeNumber(value: unknown): string | null | undefined {
  if (value === undefined || value === null || value === "") return null;
  if (typeof value !== "string") return undefined;
  const digits = value.replace(/[\s+\-().]/g, "");
  if (!/^\d+$/.test(digits) || digits.startsWith("00")) return undefined;
  const international = digits.startsWith("0") ? `62${digits.slice(1)}` : digits;
  if (international.length < 8 || international.length > 15) return undefined;
  return international;
}

async function connectionState(
  evolution: (path: string, method?: string, body?: unknown) => Promise<Response>,
  instanceId: string,
): Promise<string | null | undefined> {
  const response = await evolution(`/instance/connectionState/${instanceId}`);
  if (response.status === 404) return null;
  if (!response.ok) return undefined;
  const payload = await response.json();
  const state = payload?.instance?.state;
  return typeof state === "string" ? state : undefined;
}
