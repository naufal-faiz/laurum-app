type Config = {
  url: string;
  publicKey: string;
  serviceKey: string;
  evolutionUrl: string;
  evolutionKey: string;
};

type Row = { instance_id: string; status: string };

const UUID = /^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$/i;
const INSTANCE = /^[A-Za-z0-9][A-Za-z0-9._-]{0,119}$/;
const STATUS: Record<string, string> = {
  open: "terhubung",
  connecting: "menunggu",
  close: "terputus",
};

// Status is derived from Evolution and written only through the service-role RPC.
// The connection row is stamped once per change: connected_at drives the worker's
// "ignore messages older than pairing" filter, so it must not move on every poll.
export function createHandler(config: Config, request: typeof fetch = fetch) {
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
    const call = async (path: string, init: RequestInit) =>
      request(`${config.url}${path}`, {
        ...init,
        headers: { ...admin, ...(init.headers ?? {}) },
        signal: AbortSignal.timeout(15000),
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

      const listed = await call(
        `/rest/v1/wa_connections?owner_id=eq.${ownerId}` +
          `&deleted_at=is.null&select=instance_id,status&limit=1`,
        { method: "GET" },
      );
      if (!listed.ok) return reply(503, { code: "unavailable" });
      const rows = await listed.json();
      const row: Row | null = Array.isArray(rows) && rows.length > 0 ? rows[0] : null;
      if (!row) return reply(200, { code: "no_connection", status: "belum", connectedAt: null });
      if (!INSTANCE.test(row.instance_id)) return reply(503, { code: "unavailable" });

      let live = "terputus";
      const response = await request(
        `${config.evolutionUrl}/instance/connectionState/${row.instance_id}`,
        {
          headers: { apikey: config.evolutionKey },
          signal: AbortSignal.timeout(20000),
        },
      );
      if (response.ok) {
        const payload = await response.json();
        const state = payload?.instance?.state;
        live = STATUS[state as string] ?? "terputus";
      } else if (response.status >= 500) {
        return reply(503, { code: "unavailable" });
      }

      if (row.status !== live) {
        const updated = await call("/rest/v1/rpc/set_wa_connection_status", {
          method: "POST",
          body: JSON.stringify({ p_instance_id: row.instance_id, p_status: live }),
        });
        if (!updated.ok) return reply(503, { code: "unavailable" });
        const result = await updated.json();
        if (result?.code !== "updated") return reply(503, { code: "unavailable" });
      }

      const current = await call(
        `/rest/v1/wa_connections?owner_id=eq.${ownerId}` +
          `&deleted_at=is.null&select=status,connected_at&limit=1`,
        { method: "GET" },
      );
      if (!current.ok) return reply(503, { code: "unavailable" });
      const final = await current.json();
      const saved = Array.isArray(final) && final.length > 0 ? final[0] : {};
      return reply(200, {
        code: "ok",
        status: saved.status ?? live,
        connectedAt: saved.connected_at ?? null,
      });
    } catch {
      return reply(503, { code: "unavailable" });
    }
  };
}
