import { test } from "node:test";
import assert from "node:assert/strict";
import { createHandler, normalizeNumber } from "./handler.ts";

const owner = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa";
const instance = "laurum-aaaaaaaa";
const config = {
  url: "http://local.test",
  publicKey: "test-public",
  serviceKey: "test-secret",
  evolutionUrl: "http://evolution.test",
  evolutionKey: "evolution-secret",
};

const input = (body?: unknown) => new Request("http://local.test/wa-connect", {
  method: "POST",
  headers: { Authorization: "Bearer test-user-session", "Content-Type": "application/json" },
  body: body === undefined ? undefined : JSON.stringify(body),
});

type Call = { url: string; method: string; body: any };
const noWait = async () => {};

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

test("Authenticates against the server and needs every secret", async () => {
  let calls = 0;
  const handler = createHandler(config, async () => { calls++; return new Response(null, { status: 401 }); }, noWait);
  assert.equal((await handler(new Request("http://local.test/wa-connect"))).status, 405);
  assert.equal((await handler(new Request("http://local.test/wa-connect", { method: "POST" }))).status, 401);
  assert.equal(calls, 0);
  assert.equal((await handler(input())).status, 401);
  assert.equal(calls, 1);
  const missing = createHandler({ ...config, evolutionKey: "" }, async () => {
    calls++;
    return new Response(null, { status: 200 });
  }, noWait);
  assert.equal((await missing(input())).status, 503);
  assert.equal(calls, 1);
});

test("Creates the owner instance and returns a QR without a phone number", async () => {
  const { calls, fetcher } = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("/rest/v1/wa_connections?owner_id=")) return Response.json([]);
    if (call.url.endsWith(`/instance/connectionState/${instance}`)) {
      return call.method === "GET" ? new Response(null, { status: 404 }) : undefined;
    }
    if (call.url.endsWith("/instance/create")) return Response.json({ instance: { status: "close" } });
    if (call.url.endsWith("/rest/v1/wa_connections")) return Response.json(null, { status: 201 });
    if (call.url.endsWith(`/instance/connect/${instance}`)) {
      return Response.json({ base64: "data:image/png;base64,QR", code: "2@qr", pairingCode: null, count: 1 });
    }
    return undefined;
  });
  const response = await createHandler(config, fetcher, noWait)(input({}));
  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), {
    code: "qr", instanceId: instance, qr: "data:image/png;base64,QR", expiresInSeconds: 60,
  });
  const created = calls.find((c) => c.url.endsWith("/instance/create"));
  assert.equal(created?.body.integration, "WHATSAPP-BAILEYS");
  assert.equal(created?.body.qrcode, false);
  const inserted = calls.find((c) => c.url.endsWith("/rest/v1/wa_connections") && c.method === "POST");
  assert.equal(inserted?.body.owner_id, owner);
  assert.equal(inserted?.body.instance_id, instance);
  assert.ok(!calls.some((c) => c.url.includes("number=")));
});

test("Resets a pending session and returns QR plus pairing code", async () => {
  let polls = 0;
  const { calls, fetcher } = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("/rest/v1/wa_connections?owner_id=")) {
      return Response.json([{ id: "row", instance_id: instance, status: "menunggu" }]);
    }
    if (call.url.endsWith(`/instance/connectionState/${instance}`)) {
      return Response.json({ instance: { instanceName: instance, state: "connecting" } });
    }
    if (call.url.endsWith(`/instance/logout/${instance}`)) return Response.json({ status: "SUCCESS" });
    if (call.url.endsWith(`/instance/connect/${instance}?number=6281234567890`)) {
      return Response.json({ count: 1 });
    }
    if (call.url.endsWith(`/instance/connect/${instance}`)) {
      polls++;
      return Response.json(polls === 1
        ? { count: 1 }
        : { base64: "data:image/png;base64,QR", code: "2@qr", pairingCode: "ABCD1234", count: 1 });
    }
    return undefined;
  });
  const response = await createHandler(config, fetcher, noWait)(input({ number: "0812-3456-7890" }));
  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), {
    code: "pairing",
    instanceId: instance,
    qr: "data:image/png;base64,QR",
    pairingCode: "ABCD1234",
    expiresInSeconds: 60,
  });
  assert.ok(calls.some((c) => c.url.endsWith(`/instance/logout/${instance}`)));
  assert.equal(polls, 2);
});

test("Does not touch Evolution when already linked or when the number is invalid", async () => {
  const linked = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("/rest/v1/wa_connections?owner_id=")) {
      return Response.json([{ id: "row", instance_id: instance, status: "terhubung" }]);
    }
    if (call.url.endsWith(`/instance/connectionState/${instance}`)) {
      return Response.json({ instance: { instanceName: instance, state: "open" } });
    }
    return undefined;
  });
  const first = await createHandler(config, linked.fetcher, noWait)(input({ number: "081234567890" }));
  assert.equal(first.status, 200);
  assert.equal((await first.json()).code, "already_connected");
  assert.ok(!linked.calls.some((c) => c.url.includes("/connect/")));

  const invalid = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    return undefined;
  });
  const second = await createHandler(config, invalid.fetcher, noWait)(input({ number: "12345" }));
  assert.equal(second.status, 400);
  assert.equal((await second.json()).code, "invalid_number");
  assert.equal(invalid.calls.length, 1);
});

test("Hides Evolution failures and reports an unready pairing session", async () => {
  const broken = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("/rest/v1/wa_connections?owner_id=")) return Response.json([]);
    if (call.url.includes("/instance/connectionState/")) {
      return new Response("upstream-private-details", { status: 500 });
    }
    return undefined;
  });
  const failed = await createHandler(config, broken.fetcher, noWait)(input({}));
  assert.equal(failed.status, 503);
  assert.equal(await failed.text(), '{"code":"unavailable"}');

  const slow = fake((call) => {
    if (call.url.endsWith("/auth/v1/user")) return Response.json({ id: owner });
    if (call.url.includes("/rest/v1/wa_connections?owner_id=")) return Response.json([]);
    if (call.url.endsWith(`/instance/connectionState/${instance}`)) {
      return Response.json({ instance: { instanceName: instance, state: "close" } });
    }
    if (call.url.endsWith("/instance/create")) return Response.json({});
    if (call.url.endsWith("/rest/v1/wa_connections")) return Response.json(null, { status: 201 });
    if (call.url.endsWith(`/instance/connect/${instance}`)) return Response.json({ count: 1 });
    return undefined;
  });
  const waited = await createHandler(config, slow.fetcher, noWait)(input({}));
  assert.equal(waited.status, 504);
  assert.equal((await waited.json()).code, "not_ready");
});

test("Normalizes Indonesian numbers and rejects junk", () => {
  assert.equal(normalizeNumber(undefined), null);
  assert.equal(normalizeNumber(""), null);
  assert.equal(normalizeNumber("0812-3456-7890"), "6281234567890");
  assert.equal(normalizeNumber("+62 812 3456 7890"), "6281234567890");
  assert.equal(normalizeNumber("12345"), undefined);
  assert.equal(normalizeNumber("abc"), undefined);
  assert.equal(normalizeNumber(812), undefined);
  assert.equal(normalizeNumber("00000000"), undefined);
});
