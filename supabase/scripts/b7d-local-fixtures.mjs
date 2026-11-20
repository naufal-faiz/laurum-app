import { randomUUID, randomBytes } from 'node:crypto';

export async function openLocalFixtures() {
  const url = process.env.LAURUM_LOCAL_SUPABASE_URL;
  if (url !== 'http://127.0.0.1:54321') throw Error('Only local Supabase is allowed');
  const key = process.env.LAURUM_LOCAL_SERVICE_KEY;
  const publicKey = process.env.LAURUM_LOCAL_PUBLIC_KEY;
  if (!key || !publicKey) throw Error('Local test keys missing');
  async function request(path, body, method = 'POST', token = key, apiKey = key) {
    const res = await fetch(url + path, {
      method,
      headers: { apikey: apiKey, Authorization: 'Bearer ' + token,
        'Content-Type': 'application/json', Prefer: 'return=representation' },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
    if (!res.ok) throw Error('Local API ' + method + ' ' + path.split('?')[0] + ' returned ' + res.status);
    if (res.status === 204) return null;
    const text = await res.text();
    return text ? JSON.parse(text) : null;
  }
  const users = [];
  async function close() {
    for (const u of users) {
      const session = await request('/auth/v1/token?grant_type=password',
        { email: u.email, password: u.password }, 'POST', publicKey, publicKey);
      await request('/rest/v1/rpc/delete_my_account', {}, 'POST', session.access_token, publicKey);
      await request('/auth/v1/admin/users/' + u.id, undefined, 'DELETE');
    }
  }
  try {
    for (const label of ['a', 'b']) {
      const email = 'b7d-' + randomUUID() + '@example.test';
      const password = randomBytes(24).toString('hex');
      const created = await request('/auth/v1/admin/users', { email, password, email_confirm: true });
      const id = created.id || created.user?.id;
      if (!id) throw Error('Local test identity missing');
      const user = { id, email, password, instance: 'local-b7d-' + label + '-' + randomUUID() };
      users.push(user);
      await request('/rest/v1/wa_connections', { id: randomUUID(), owner_id: id,
        instance_id: user.instance, status: 'terhubung',
        connected_at: new Date(Date.now() - 3600000).toISOString() });
      await request('/rest/v1/services', { id: randomUUID(), owner_id: id,
        name: 'Cuci', kind: 'kiloan', price: 7000, duration_days: 2, is_active: true });
    }
    return { users, close, headers: { apikey: key, Authorization: 'Bearer ' + key },
      rows: async (table, owner) => request('/rest/v1/' + table + '?owner_id=eq.' + owner, undefined, 'GET') };
  } catch (e) {
    await close();
    throw e;
  }
}
