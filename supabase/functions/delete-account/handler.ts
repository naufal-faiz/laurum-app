type Config = { url: string; publicKey: string; serviceKey: string };
type ObjectEntry = { id: string | null; name: string };

// Auth is checked against the server, never by decoding untrusted JWT claims.
// Errors deliberately omit upstream bodies, which can contain PII or credentials.
export function createHandler(config: Config, request: typeof fetch = fetch) {
  return async (req: Request): Promise<Response> => {
    const reply = (status: number, code: string) => Response.json({ code }, { status });
    if (req.method !== "POST") return reply(405, "method_not_allowed");
    const authorization = req.headers.get("authorization") ?? "";
    if (!/^Bearer \S+$/i.test(authorization)) return reply(401, "authentication_required");
    if (!config.url || !config.publicKey || !config.serviceKey) return reply(503, "unavailable");
    const call = async (path: string, method: string, admin: boolean, body?: unknown) => {
      const response = await request(`${config.url}${path}`, {
        method,
        headers: {
          apikey: admin ? config.serviceKey : config.publicKey,
          Authorization: admin ? `Bearer ${config.serviceKey}` : authorization,
          "Content-Type": "application/json",
        },
        body: body === undefined ? undefined : JSON.stringify(body),
        signal: AbortSignal.timeout(15000),
      });
      return response;
    };
    try {
      const verification = await call("/auth/v1/user", "GET", false);
      if (!verification.ok) return reply(verification.status >= 500 ? 503 : 401, "authentication_required");
      const user = await verification.json();
      if (typeof user.id !== "string" || !/^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$/i.test(user.id)) {
        return reply(401, "authentication_required");
      }
      const owner: string = user.id;
      const purge = await call("/rest/v1/rpc/delete_my_account", "POST", false, {});
      if (!purge.ok) return reply(503, "retry_deletion");
      const paths: string[] = [];
      const list = async (prefix: string, depth = 0): Promise<void> => {
        if (depth > 10) throw new Error("path_depth");
        for (let offset = 0; ; offset += 100) {
          const response = await call("/storage/v1/object/list/expense-photos", "POST", true, {
            prefix, limit: 100, offset, sortBy: { column: "name", order: "asc" },
          });
          if (!response.ok) throw new Error("storage_list");
          const entries: ObjectEntry[] = await response.json();
          if (!Array.isArray(entries)) throw new Error("storage_list");
          for (const entry of entries) {
            if (!entry.name || entry.name.includes("/") || entry.name === "." || entry.name === "..") {
              throw new Error("storage_path");
            }
            const path = `${prefix}/${entry.name}`;
            if (!path.startsWith(`${owner}/`)) throw new Error("storage_owner");
            if (entry.id === null) await list(path, depth + 1);
            else paths.push(path);
          }
          if (entries.length < 100) return;
        }
      };
      await list(owner);
      for (let offset = 0; offset < paths.length; offset += 100) {
        const removed = await call("/storage/v1/object/expense-photos", "DELETE", true, {
          prefixes: paths.slice(offset, offset + 100),
        });
        if (!removed.ok) return reply(503, "retry_deletion");
      }
      const deleted = await call(`/auth/v1/admin/users/${owner}`, "DELETE", true);
      if (!deleted.ok) return reply(503, "retry_deletion");
      return reply(200, "account_deleted");
    } catch {
      return reply(503, "retry_deletion");
    }
  };
}
