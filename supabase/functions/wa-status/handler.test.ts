import { test } from "node:test";
import assert from "node:assert/strict";
import { createHandler } from "./handler.ts";

const owner = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa";
const instance = "laurum-aaaaaaaa";
const config = {
  url: "http://local.test",
  publicKey: "test-public",
  serviceKey: "test-secret",
  evolutionUrl: "http://evolution.test",
  evolutionKey: "evolution-secret",
};

const input = () => new Request("http://local.test/wa-status", {
  method: "POST",
  headers: { Authorization: "Bearer test-user-session" },
});

type Call = { url: string; method: string; body: any };

function fake(routes: (call: Call) => Response | undefined) {
  const calls: Call[] = [];
  const fetcher = async (url: string | URL | Request, init?: RequestInit) => {
    const call: Call = {
      url: String(url),
      method: init?.method ?? "GET",
      body: init?.body ? JSON.parse(String(init.body)) : undefined,
    };
    calls.push(call);
    const response = routes(call);
    if (!response) throw new Error(`unexpected ${call.method} ${call.url}`);
    return response;
  };
  return { calls, fetcher };
}

test("Requires POST, a verified owner and every secret", async () => {
  let calls = 0;
  const handler = createHandler(config, async () => { calls++; return new Response(null, { status: 401 }); });
  assert.equal((await handler(new Request("http://local.test/wa-status"))).status, 405);
  assert.equal((await handler(new Request("http://local.test/wa-status", { method: "POST" }))).status, 401);
  assert.equal(calls, 0);
  assert.equal((await handler(input())).status, 401);
  assert.equal(calls, 1);
});

test("An owner without a connection gets the empty status", async () => {
  const { calls, fetcher } = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("/rest/v1/wa_connections?owner_id=")) return Response.json([]);
    return undefined;
  });
  const response = await createHandler(config, fetcher)(input());
  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), { code: "no_connection", status: "belum", connectedAt: null });
  assert.ok(!calls.some((c) => c.url.includes("/rpc/")));
});

test("Maps Evolution state to the owner row and stamps connected_at once", async () => {
  const states: Record<string, string> = {
    "http://evolution.test/instance/connectionState/laurum-aaaaaaaa": "open",
  };
  const { calls, fetcher } = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("/rest/v1/wa_connections?owner_id=")) {
      if (call.url.includes("select=instance_id,status")) {
        return Response.json([{ instance_id: instance, status: "menunggu" }]);
      }
      return Response.json([{ status: "terhubung", connected_at: "2026-11-20T15:00:00Z" }]);
    }
    if (call.url in states) return Response.json({ instance: { instanceName: instance, state: states[call.url] } });
    if (call.url.endsWith("/rest/v1/rpc/set_wa_connection_status")) {
      return Response.json({ code: "updated" });
    }
    return undefined;
  });
  const response = await createHandler(config, fetcher)(input());
  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), {
    code: "ok", status: "terhubung", connectedAt: "2026-11-20T15:00:00Z",
  });
  const rpc = calls.find((c) => c.url.includes("/rpc/"));
  assert.deepEqual(rpc?.body, { p_instance_id: instance, p_status: "terhubung" });
});

test("Repeated polls with the same state never write connected_at again", async () => {
  const { calls, fetcher } = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("/rest/v1/wa_connections?owner_id=")) {
      if (call.url.includes("select=instance_id,status")) {
        return Response.json([{ instance_id: instance, status: "terhubung" }]);
      }
      return Response.json([{ status: "terhubung", connected_at: "2026-11-20T15:00:00Z" }]);
    }
    if (call.url.includes("/instance/connectionState/")) {
      return Response.json({ instance: { instanceName: instance, state: "open" } });
    }
    return undefined;
  });
  const response = await createHandler(config, fetcher)(input());
  assert.equal(response.status, 200);
  assert.ok(!calls.some((c) => c.url.includes("/rpc/")));
});

test("Lost instances become disconnected and upstream failures stay opaque", async () => {
  const lost = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("select=instance_id,status")) {
      return Response.json([{ instance_id: instance, status: "terhubung" }]);
    }
    if (call.url.includes("/instance/connectionState/")) return new Response(null, { status: 404 });
    if (call.url.endsWith("/rest/v1/rpc/set_wa_connection_status")) {
      return Response.json({ code: "updated" });
    }
    if (call.url.includes("select=status,connected_at")) {
      return Response.json([{ status: "terputus", connected_at: "2026-11-20T15:00:00Z" }]);
    }
    return undefined;
  });
  const response = await createHandler(config, lost.fetcher)(input());
  assert.equal(response.status, 200, JSON.stringify(lost.calls.map((c) => `${c.method} ${c.url}`)));
  assert.equal((await response.json()).status, "terputus");
  assert.deepEqual(lost.calls.find((c) => c.url.includes("/rpc/"))?.body, {
    p_instance_id: instance, p_status: "terputus",
  });

  const broken = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("select=instance_id,status")) {
      return Response.json([{ instance_id: instance, status: "menunggu" }]);
    }
    if (call.url.includes("/instance/connectionState/")) {
      return new Response("upstream-private-details", { status: 503 });
    }
    return undefined;
  });
  const failed = await createHandler(config, broken.fetcher)(input());
  assert.equal(failed.status, 503);
  assert.equal(await failed.text(), '{"code":"unavailable"}');
});
