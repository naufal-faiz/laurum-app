import { test } from "node:test";
import assert from "node:assert/strict";
import { randomUUID } from "node:crypto";

// Keys stay in process memory. This test can only address the local API.
const base = "http://127.0.0.1:54321";
const publicKey = process.env.LAURUM_LOCAL_PUBLIC_KEY;
const serviceKey = process.env.LAURUM_LOCAL_SERVICE_KEY;
if (!publicKey || !serviceKey) throw new Error("Local test keys must be supplied in process environment");

test("Local Auth, Storage isolation and deployed account deletion", async () => {
  const users = [];
  const api = (path, { token, admin = false, method = "GET", body, binary = false } = {}) => fetch(base + path, {
    method, signal: AbortSignal.timeout(30000),
    headers: {
      apikey: admin ? serviceKey : publicKey,
      Authorization: `Bearer ${admin ? serviceKey : token ?? publicKey}`,
      "Content-Type": binary ? "image/jpeg" : "application/json",
    },
    body: body === undefined ? undefined : binary ? body : JSON.stringify(body),
  });
  try {
    const missing = await api("/functions/v1/delete-account", { method: "POST" });
    assert.equal(missing.status, 401, "Edge requires a verified user JWT");
    const weak = await api("/auth/v1/signup", { method: "POST", body: {
      email: `b0-${randomUUID()}@example.test`, password: "short",
    } });
    assert.equal(weak.status, 422, "Auth enforces password length");
    assert.equal((await weak.json()).error_code, "weak_password", "Failure is password validation");
    const settings = await (await api("/auth/v1/settings")).json();
    assert.equal(settings.mailer_autoconfirm, false, "Email confirmation is required");
    for (let i = 0; i < 2; i++) {
      const email = `b0-${randomUUID()}@example.test`;
      const password = randomUUID();
      const created = await api("/auth/v1/admin/users", { admin: true, method: "POST", body: {
        email, password, email_confirm: true,
      } });
      assert.equal(created.status, 200, "Synthetic confirmed test user created");
      const identity = await created.json();
      const user = { id: identity.id, token: null, paths: [] };
      users.push(user);
      const signedIn = await api("/auth/v1/token?grant_type=password", { method: "POST", body: { email, password } });
      assert.equal(signedIn.status, 200, "Synthetic test user signed in");
      user.token = (await signedIn.json()).access_token;
    }
    const [a, b] = users;
    for (const user of users) {
      const response = await api("/rest/v1/rpc/sync_push", { token: user.token, method: "POST", body: { changes: [{
        table: "customers", row_id: user.id, op: "upsert", schema_version: 4,
        payload: { id: user.id, owner_id: user === a ? b.id : a.id, name: "B0 synthetic" },
      }] } });
      assert.equal(response.status, 200, "Authenticated RPC available");
      assert.equal((await response.json())[0].status, "ok", "JWT owner overrides forged payload owner");
      user.paths = [`${user.id}/test.jpg`, `${user.id}/nested/test.jpg`];
      for (const path of user.paths) {
        const uploaded = await api(`/storage/v1/object/expense-photos/${path}`, {
          token: user.token, method: "POST", binary: true, body: new Uint8Array([255, 216, 255, 217]),
        });
        assert.equal(uploaded.status, 200, "Owner may upload private JPEG");
      }
    }
    const forbidden = await api(`/storage/v1/object/expense-photos/${b.paths[0]}`, { token: a.token });
    assert.notEqual(forbidden.status, 200, "A cannot download B private object");
    const removed = await api("/functions/v1/delete-account", {
      token: a.token, method: "POST", body: { owner_id: b.id },
    });
    assert.equal(removed.status, 200, "Edge purges verified A even if body claims B");
    const remaining = await api("/rest/v1/customers?select=id", { token: b.token });
    assert.equal((await remaining.json()).length, 1, "B domain rows remain accessible");
    assert.equal((await api(`/storage/v1/object/expense-photos/${b.paths[0]}`, { token: b.token })).status,
      200, "B Storage bytes retained");
    assert.equal((await api(`/auth/v1/admin/users/${a.id}`, { admin: true })).status, 404, "A Auth user removed");
    assert.equal((await api(`/auth/v1/admin/users/${b.id}`, { admin: true })).status, 200, "B Auth user retained");
    const objects = await api("/storage/v1/object/list/expense-photos", {
      admin: true, method: "POST", body: { prefix: a.id, limit: 100 },
    });
    assert.equal((await objects.json()).length, 0, "A Storage bytes removed including nested paths");
    const rows = await api(`/rest/v1/customers?owner_id=eq.${a.id}&select=id`, { admin: true });
    assert.equal((await rows.json()).length, 0, "A domain rows removed");
  } finally {
    // Best-effort cleanup targets only UUIDs allocated by this test.
    for (const user of users) {
      if (user.token) await api("/rest/v1/rpc/delete_my_account", { token: user.token, method: "POST", body: {} });
      if (user.paths.length) await api("/storage/v1/object/expense-photos", {
        admin: true, method: "DELETE", body: { prefixes: user.paths },
      });
      await api(`/auth/v1/admin/users/${user.id}`, { admin: true, method: "DELETE" });
    }
  }
});
