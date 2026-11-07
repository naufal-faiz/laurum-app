// Owner tables accepted by sync_push. Entitlements stay pull-only on purpose.
const syncPushTables = <String>{
  'businesses',
  'customers',
  'services',
  'orders',
  'order_items',
  'payments',
  'savings_entries',
  'order_events',
  'expense_categories',
  'expenses',
  'receipt_settings',
  'devices',
};

const syncPullTables = <String>{...syncPushTables, 'entitlements'};

// Applied in dependency order so SQLite foreign keys never point at a missing row.
const syncPullOrder = <String>[
  'businesses',
  'customers',
  'services',
  'expense_categories',
  'receipt_settings',
  'devices',
  'entitlements',
  'orders',
  'order_items',
  'payments',
  'savings_entries',
  'order_events',
  'expenses',
];
