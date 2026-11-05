import 'dart:io';

import 'package:laurum/core/persistence/app_database.dart';
import 'package:laurum/core/persistence/drift_transaction_runner.dart';
import 'package:laurum/core/persistence/outbox_writer.dart';
import 'package:laurum/core/services/transaction_runner.dart';
import 'package:laurum/features/business/data/drift_business_repository.dart';
import 'package:laurum/features/customers/data/drift_customer_repository.dart';
import 'package:laurum/features/customers/data/drift_savings_repository.dart';
import 'package:laurum/features/expenses/data/drift_expense_repository.dart';
import 'package:laurum/features/expenses/data/expense_photo_store.dart';
import 'package:laurum/features/orders/data/drift_order_repository.dart';
import 'package:laurum/features/reports/data/drift_report_repository.dart';
import 'package:laurum/features/services/data/drift_service_repository.dart';

class AccountRepositories {
  AccountRepositories(
    this.db,
    this.ownerId, {
    required Future<Directory> Function() directory,
    Iterable<TransactionParticipant> Function()? participants,
    DateTime Function()? clock,
  }) {
    runner = DriftTransactionRunner(db, participants: participants);
    writer = OutboxWriter(db, runner, clock: clock);
    business = DriftBusinessRepository(db, ownerId, writer, clock: clock);
    customers = DriftCustomerRepository(db, ownerId, writer, clock: clock);
    services = DriftServiceRepository(db, ownerId, writer, clock: clock);
    orders = DriftOrderRepository(db, ownerId, writer, clock: clock);
    savings = DriftSavingsRepository(db, ownerId, writer, clock: clock);
    expenses = DriftExpenseRepository(
      db,
      ownerId,
      writer,
      clock: clock,
      photos: ExpensePhotoStore(ownerId, directory: directory),
    );
    reports = DriftReportRepository(db, ownerId);
  }
  final AppDatabase db;
  final String ownerId;
  late final DriftTransactionRunner runner;
  late final OutboxWriter writer;
  late final DriftBusinessRepository business;
  late final DriftCustomerRepository customers;
  late final DriftServiceRepository services;
  late final DriftOrderRepository orders;
  late final DriftSavingsRepository savings;
  late final DriftExpenseRepository expenses;
  late final DriftReportRepository reports;
}
