import { test } from "node:test";
import assert from "node:assert/strict";
import { createHandler } from "./handler.ts";

const owner = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa";
const config = { url: "http://local.test", publicKey: "test-public", serviceKey: "test-secret" };
const input = () => new Request("http://local.test/delete-account", {
  method: "POST", headers: { Authorization: "Bearer test-user-session" },
  body: JSON.stringify({ owner_id: "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb" }),
});

test("Requires POST and a verified Auth user before any deletion", async () => {
  let calls = 0;
  const handler = createHandler(config, async () => { calls++; return new Response(null, { status: 401 }); });
  assert.equal((await handler(new Request("http://local.test"))).status, 405);
  assert.equal((await handler(new Request("http://local.test", { method: "POST" }))).status, 401);
  assert.equal(calls, 0);
  assert.equal((await handler(input())).status, 401);
  assert.equal(calls, 1);
});

test("Purge rows, paginate/recurse own Storage, then delete verified Auth identity", async () => {
  const calls: { path: string; body: any }[] = [];
  const handler = createHandler(config, async (url, options) => {
    const path = new URL(String(url)).pathname;
    const body = options?.body ? JSON.parse(String(options.body)) : undefined;
    const auth = new Headers(options?.headers).get("authorization");
    calls.push({ path, body });
    if (path === "/auth/v1/user") {
      assert.equal(auth, "Bearer test-user-session");
      return Response.json({ id: owner });
    }
    if (path === "/rest/v1/rpc/delete_my_account") {
      assert.equal(auth, "Bearer test-user-session");
      return Response.json(null);
    }
    assert.equal(auth, "Bearer test-secret");
    if (path.includes("/object/list/")) {
      assert.ok(body.prefix === owner || body.prefix === `${owner}/nested`);
      if (body.prefix.endsWith("/nested")) return Response.json([{ id: "nested", name: "receipt.jpg" }]);
      if (body.offset === 100) return Response.json([{ id: null, name: "nested" }]);
      return Response.json(Array.from({ length: 100 }, (_, i) => ({ id: String(i), name: `${i}.jpg` })));
    }
    if (path === "/storage/v1/object/expense-photos") {
      assert.ok(body.prefixes.every((p: string) => p.startsWith(`${owner}/`)));
      return Response.json([]);
    }
    assert.equal(path, `/auth/v1/admin/users/${owner}`);
    return Response.json({});
  });
  assert.equal((await handler(input())).status, 200);
  assert.equal(calls[1].path, "/rest/v1/rpc/delete_my_account");
  assert.equal(calls.at(-1)?.path, `/auth/v1/admin/users/${owner}`);
  assert.equal(calls.filter(c => c.path === "/storage/v1/object/expense-photos").length, 2);
});

for (const failure of ["database", "list", "remove"]) {
  test(`Failure at ${failure} preserves Auth identity for retry and hides error details`, async () => {
    let authDeleted = false;
    const handler = createHandler(config, async (url) => {
      const path = String(url);
      if (path.endsWith("/user")) return Response.json({ id: owner });
      if (path.includes("admin/users")) { authDeleted = true; return Response.json({}); }
      if ((failure === "database" && path.includes("rpc")) ||
          (failure === "list" && path.includes("/list/")) ||
          (failure === "remove" && path.endsWith("/object/expense-photos"))) {
        return new Response("upstream-private-details", { status: 500 });
      }
      return Response.json(path.includes("/list/") ? [{ id: "1", name: "receipt.jpg" }] : null);
    });
    const response = await handler(input());
    assert.equal(response.status, 503);
    assert.equal(await response.text(), '{"code":"retry_deletion"}');
    assert.equal(authDeleted, false);
  });
}

test("Refuses Storage paths escaping the verified owner", async () => {
  let calls = 0;
  const handler = createHandler(config, async () => {
    calls++;
    return Response.json(calls === 1 ? { id: owner } : calls === 2 ? null : [{ id: "1", name: "../other.jpg" }]);
  });
  assert.equal((await handler(input())).status, 503);
  assert.equal(calls, 3);
});
