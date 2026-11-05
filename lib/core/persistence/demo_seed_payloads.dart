import 'package:laurum/features/business/data/business_fixtures.dart';
import 'package:laurum/features/business/data/business_storage_mapping.dart';
import 'package:laurum/features/customers/data/customer_fixtures.dart';
import 'package:laurum/features/customers/data/customer_storage_mapping.dart';
import 'package:laurum/features/customers/data/savings_fixtures.dart';
import 'package:laurum/features/customers/data/savings_storage_mapping.dart';
import 'package:laurum/features/expenses/data/expense_category_storage.dart';
import 'package:laurum/features/expenses/data/expense_fixtures.dart';
import 'package:laurum/features/expenses/data/expense_storage.dart';
import 'package:laurum/features/orders/data/order_event_fixtures.dart';
import 'package:laurum/features/orders/data/order_event_storage.dart';
import 'package:laurum/features/orders/data/order_fixtures.dart';
import 'package:laurum/features/orders/data/order_item_fixtures.dart';
import 'package:laurum/features/orders/data/order_item_storage.dart';
import 'package:laurum/features/orders/data/order_storage_write.dart';
import 'package:laurum/features/orders/data/payment_fixtures.dart';
import 'package:laurum/features/orders/data/payment_storage.dart';
import 'package:laurum/features/printer/data/receipt_storage_mapping.dart';
import 'package:laurum/features/services/data/service_fixtures.dart';
import 'package:laurum/features/services/data/service_storage_mapping.dart';

// Only DATA MASTER fixtures; maps preserve the production wire field names.
Map<String, List<Map<String, Object?>>> demoSeedPayloads() => {
  'businesses': [businessPayload(businessProfileFixture, businessProfileFixture.createdAt)],
  'receipt_settings': [receiptPayload(receiptSettingsFixture, receiptSettingsFixture.createdAt)],
  'customers': [for (final v in customerFixtures) customerPayload(v, v.createdAt)],
  'services': [for (final v in serviceFixtures) servicePayload(v, v.createdAt)],
  'expense_categories': [for (final v in expenseCategoryFixtures) categoryPayload(v, v.createdAt)],
  'orders': [for (final v in orderFixtures) orderPayload(v, v.createdAt)],
  'order_items': [for (final v in orderItemFixtures) itemPayload(v, v.createdAt)],
  'payments': [for (final v in paymentFixtures) paymentPayload(v, v.createdAt)],
  'order_events': [for (final v in orderEventFixtures) eventPayload(v, v.createdAt)],
  'expenses': [for (final v in expenseFixtures) expensePayload(v, v.createdAt)],
  'savings_entries': [for (final v in savingsFixtures) savingsPayload(v, v.createdAt)],
};
