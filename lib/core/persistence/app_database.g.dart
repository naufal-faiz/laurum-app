// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BusinessRecordsTable extends BusinessRecords
    with TableInfo<$BusinessRecordsTable, BusinessRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _receiptFooterMeta = const VerificationMeta(
    'receiptFooter',
  );
  @override
  late final GeneratedColumn<String> receiptFooter = GeneratedColumn<String>(
    'receipt_footer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _receiptNoteMeta = const VerificationMeta(
    'receiptNote',
  );
  @override
  late final GeneratedColumn<String> receiptNote = GeneratedColumn<String>(
    'receipt_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _useOrderStatusMeta = const VerificationMeta(
    'useOrderStatus',
  );
  @override
  late final GeneratedColumn<bool> useOrderStatus = GeneratedColumn<bool>(
    'use_order_status',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_order_status" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    name,
    address,
    phone,
    receiptFooter,
    receiptNote,
    useOrderStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'businesses';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('receipt_footer')) {
      context.handle(
        _receiptFooterMeta,
        receiptFooter.isAcceptableOrUnknown(
          data['receipt_footer']!,
          _receiptFooterMeta,
        ),
      );
    }
    if (data.containsKey('receipt_note')) {
      context.handle(
        _receiptNoteMeta,
        receiptNote.isAcceptableOrUnknown(
          data['receipt_note']!,
          _receiptNoteMeta,
        ),
      );
    }
    if (data.containsKey('use_order_status')) {
      context.handle(
        _useOrderStatusMeta,
        useOrderStatus.isAcceptableOrUnknown(
          data['use_order_status']!,
          _useOrderStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      receiptFooter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_footer'],
      )!,
      receiptNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_note'],
      )!,
      useOrderStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_order_status'],
      )!,
    );
  }

  @override
  $BusinessRecordsTable createAlias(String alias) {
    return $BusinessRecordsTable(attachedDatabase, alias);
  }
}

class BusinessRow extends DataClass implements Insertable<BusinessRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String name;
  final String address;
  final String phone;
  final String receiptFooter;
  final String receiptNote;
  final bool useOrderStatus;
  const BusinessRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.name,
    required this.address,
    required this.phone,
    required this.receiptFooter,
    required this.receiptNote,
    required this.useOrderStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['phone'] = Variable<String>(phone);
    map['receipt_footer'] = Variable<String>(receiptFooter);
    map['receipt_note'] = Variable<String>(receiptNote);
    map['use_order_status'] = Variable<bool>(useOrderStatus);
    return map;
  }

  BusinessRecordsCompanion toCompanion(bool nullToAbsent) {
    return BusinessRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      name: Value(name),
      address: Value(address),
      phone: Value(phone),
      receiptFooter: Value(receiptFooter),
      receiptNote: Value(receiptNote),
      useOrderStatus: Value(useOrderStatus),
    );
  }

  factory BusinessRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      phone: serializer.fromJson<String>(json['phone']),
      receiptFooter: serializer.fromJson<String>(json['receiptFooter']),
      receiptNote: serializer.fromJson<String>(json['receiptNote']),
      useOrderStatus: serializer.fromJson<bool>(json['useOrderStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'phone': serializer.toJson<String>(phone),
      'receiptFooter': serializer.toJson<String>(receiptFooter),
      'receiptNote': serializer.toJson<String>(receiptNote),
      'useOrderStatus': serializer.toJson<bool>(useOrderStatus),
    };
  }

  BusinessRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    String? address,
    String? phone,
    String? receiptFooter,
    String? receiptNote,
    bool? useOrderStatus,
  }) => BusinessRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    receiptFooter: receiptFooter ?? this.receiptFooter,
    receiptNote: receiptNote ?? this.receiptNote,
    useOrderStatus: useOrderStatus ?? this.useOrderStatus,
  );
  BusinessRow copyWithCompanion(BusinessRecordsCompanion data) {
    return BusinessRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      receiptFooter: data.receiptFooter.present ? data.receiptFooter.value : this.receiptFooter,
      receiptNote: data.receiptNote.present ? data.receiptNote.value : this.receiptNote,
      useOrderStatus: data.useOrderStatus.present ? data.useOrderStatus.value : this.useOrderStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('receiptFooter: $receiptFooter, ')
          ..write('receiptNote: $receiptNote, ')
          ..write('useOrderStatus: $useOrderStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    name,
    address,
    phone,
    receiptFooter,
    receiptNote,
    useOrderStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.receiptFooter == this.receiptFooter &&
          other.receiptNote == this.receiptNote &&
          other.useOrderStatus == this.useOrderStatus);
}

class BusinessRecordsCompanion extends UpdateCompanion<BusinessRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String> address;
  final Value<String> phone;
  final Value<String> receiptFooter;
  final Value<String> receiptNote;
  final Value<bool> useOrderStatus;
  final Value<int> rowid;
  const BusinessRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.receiptFooter = const Value.absent(),
    this.receiptNote = const Value.absent(),
    this.useOrderStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.receiptFooter = const Value.absent(),
    this.receiptNote = const Value.absent(),
    this.useOrderStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       name = Value(name);
  static Insertable<BusinessRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? receiptFooter,
    Expression<String>? receiptNote,
    Expression<bool>? useOrderStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (receiptFooter != null) 'receipt_footer': receiptFooter,
      if (receiptNote != null) 'receipt_note': receiptNote,
      if (useOrderStatus != null) 'use_order_status': useOrderStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String>? address,
    Value<String>? phone,
    Value<String>? receiptFooter,
    Value<String>? receiptNote,
    Value<bool>? useOrderStatus,
    Value<int>? rowid,
  }) {
    return BusinessRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      receiptNote: receiptNote ?? this.receiptNote,
      useOrderStatus: useOrderStatus ?? this.useOrderStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (receiptFooter.present) {
      map['receipt_footer'] = Variable<String>(receiptFooter.value);
    }
    if (receiptNote.present) {
      map['receipt_note'] = Variable<String>(receiptNote.value);
    }
    if (useOrderStatus.present) {
      map['use_order_status'] = Variable<bool>(useOrderStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('receiptFooter: $receiptFooter, ')
          ..write('receiptNote: $receiptNote, ')
          ..write('useOrderStatus: $useOrderStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceRecordsTable extends DeviceRecords with TableInfo<$DeviceRecordsTable, DeviceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    code,
    name,
    lastSeenAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      ),
    );
  }

  @override
  $DeviceRecordsTable createAlias(String alias) {
    return $DeviceRecordsTable(attachedDatabase, alias);
  }
}

class DeviceRow extends DataClass implements Insertable<DeviceRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String code;
  final String name;
  final DateTime? lastSeenAt;
  const DeviceRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.code,
    required this.name,
    this.lastSeenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    }
    return map;
  }

  DeviceRecordsCompanion toCompanion(bool nullToAbsent) {
    return DeviceRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      code: Value(code),
      name: Value(name),
      lastSeenAt: lastSeenAt == null && nullToAbsent ? const Value.absent() : Value(lastSeenAt),
    );
  }

  factory DeviceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      lastSeenAt: serializer.fromJson<DateTime?>(json['lastSeenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'lastSeenAt': serializer.toJson<DateTime?>(lastSeenAt),
    };
  }

  DeviceRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? code,
    String? name,
    Value<DateTime?> lastSeenAt = const Value.absent(),
  }) => DeviceRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    code: code ?? this.code,
    name: name ?? this.name,
    lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
  );
  DeviceRow copyWithCompanion(DeviceRecordsCompanion data) {
    return DeviceRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      lastSeenAt: data.lastSeenAt.present ? data.lastSeenAt.value : this.lastSeenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('lastSeenAt: $lastSeenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    code,
    name,
    lastSeenAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.code == this.code &&
          other.name == this.name &&
          other.lastSeenAt == this.lastSeenAt);
}

class DeviceRecordsCompanion extends UpdateCompanion<DeviceRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> code;
  final Value<String> name;
  final Value<DateTime?> lastSeenAt;
  final Value<int> rowid;
  const DeviceRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String code,
    required String name,
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       code = Value(code),
       name = Value(name);
  static Insertable<DeviceRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? code,
    Expression<String>? name,
    Expression<DateTime>? lastSeenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? code,
    Value<String>? name,
    Value<DateTime?>? lastSeenAt,
    Value<int>? rowid,
  }) {
    return DeviceRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      code: code ?? this.code,
      name: name ?? this.name,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomerRecordsTable extends CustomerRecords
    with TableInfo<$CustomerRecordsTable, CustomerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneKeyMeta = const VerificationMeta(
    'phoneKey',
  );
  @override
  late final GeneratedColumn<String> phoneKey = GeneratedColumn<String>(
    'phone_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    name,
    phone,
    nameKey,
    phoneKey,
    address,
    notes,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    }
    if (data.containsKey('phone_key')) {
      context.handle(
        _phoneKeyMeta,
        phoneKey.isAcceptableOrUnknown(data['phone_key']!, _phoneKeyMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      phoneKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_key'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $CustomerRecordsTable createAlias(String alias) {
    return $CustomerRecordsTable(attachedDatabase, alias);
  }
}

class CustomerRow extends DataClass implements Insertable<CustomerRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String name;
  final String phone;
  final String nameKey;
  final String phoneKey;
  final String address;
  final String notes;
  final bool isActive;
  const CustomerRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.name,
    required this.phone,
    required this.nameKey,
    required this.phoneKey,
    required this.address,
    required this.notes,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['name_key'] = Variable<String>(nameKey);
    map['phone_key'] = Variable<String>(phoneKey);
    map['address'] = Variable<String>(address);
    map['notes'] = Variable<String>(notes);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CustomerRecordsCompanion toCompanion(bool nullToAbsent) {
    return CustomerRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      name: Value(name),
      phone: Value(phone),
      nameKey: Value(nameKey),
      phoneKey: Value(phoneKey),
      address: Value(address),
      notes: Value(notes),
      isActive: Value(isActive),
    );
  }

  factory CustomerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      phoneKey: serializer.fromJson<String>(json['phoneKey']),
      address: serializer.fromJson<String>(json['address']),
      notes: serializer.fromJson<String>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'nameKey': serializer.toJson<String>(nameKey),
      'phoneKey': serializer.toJson<String>(phoneKey),
      'address': serializer.toJson<String>(address),
      'notes': serializer.toJson<String>(notes),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  CustomerRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    String? phone,
    String? nameKey,
    String? phoneKey,
    String? address,
    String? notes,
    bool? isActive,
  }) => CustomerRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    nameKey: nameKey ?? this.nameKey,
    phoneKey: phoneKey ?? this.phoneKey,
    address: address ?? this.address,
    notes: notes ?? this.notes,
    isActive: isActive ?? this.isActive,
  );
  CustomerRow copyWithCompanion(CustomerRecordsCompanion data) {
    return CustomerRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      phoneKey: data.phoneKey.present ? data.phoneKey.value : this.phoneKey,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('nameKey: $nameKey, ')
          ..write('phoneKey: $phoneKey, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    name,
    phone,
    nameKey,
    phoneKey,
    address,
    notes,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.nameKey == this.nameKey &&
          other.phoneKey == this.phoneKey &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.isActive == this.isActive);
}

class CustomerRecordsCompanion extends UpdateCompanion<CustomerRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> nameKey;
  final Value<String> phoneKey;
  final Value<String> address;
  final Value<String> notes;
  final Value<bool> isActive;
  final Value<int> rowid;
  const CustomerRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.phoneKey = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomerRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.phoneKey = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       name = Value(name);
  static Insertable<CustomerRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? nameKey,
    Expression<String>? phoneKey,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (nameKey != null) 'name_key': nameKey,
      if (phoneKey != null) 'phone_key': phoneKey,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomerRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? nameKey,
    Value<String>? phoneKey,
    Value<String>? address,
    Value<String>? notes,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return CustomerRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      nameKey: nameKey ?? this.nameKey,
      phoneKey: phoneKey ?? this.phoneKey,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (phoneKey.present) {
      map['phone_key'] = Variable<String>(phoneKey.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('nameKey: $nameKey, ')
          ..write('phoneKey: $phoneKey, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceRecordsTable extends ServiceRecords with TableInfo<$ServiceRecordsTable, ServiceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationDaysMeta = const VerificationMeta(
    'durationDays',
  );
  @override
  late final GeneratedColumn<int> durationDays = GeneratedColumn<int>(
    'duration_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    name,
    kind,
    price,
    durationDays,
    isActive,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('duration_days')) {
      context.handle(
        _durationDaysMeta,
        durationDays.isAcceptableOrUnknown(
          data['duration_days']!,
          _durationDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationDaysMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      durationDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_days'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ServiceRecordsTable createAlias(String alias) {
    return $ServiceRecordsTable(attachedDatabase, alias);
  }
}

class ServiceRow extends DataClass implements Insertable<ServiceRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String name;
  final String kind;
  final int price;
  final int durationDays;
  final bool isActive;
  final int sortOrder;
  const ServiceRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.name,
    required this.kind,
    required this.price,
    required this.durationDays,
    required this.isActive,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    map['price'] = Variable<int>(price);
    map['duration_days'] = Variable<int>(durationDays);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ServiceRecordsCompanion toCompanion(bool nullToAbsent) {
    return ServiceRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      name: Value(name),
      kind: Value(kind),
      price: Value(price),
      durationDays: Value(durationDays),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
    );
  }

  factory ServiceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      price: serializer.fromJson<int>(json['price']),
      durationDays: serializer.fromJson<int>(json['durationDays']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'price': serializer.toJson<int>(price),
      'durationDays': serializer.toJson<int>(durationDays),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ServiceRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    String? kind,
    int? price,
    int? durationDays,
    bool? isActive,
    int? sortOrder,
  }) => ServiceRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    price: price ?? this.price,
    durationDays: durationDays ?? this.durationDays,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ServiceRow copyWithCompanion(ServiceRecordsCompanion data) {
    return ServiceRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      price: data.price.present ? data.price.value : this.price,
      durationDays: data.durationDays.present ? data.durationDays.value : this.durationDays,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('price: $price, ')
          ..write('durationDays: $durationDays, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    name,
    kind,
    price,
    durationDays,
    isActive,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.price == this.price &&
          other.durationDays == this.durationDays &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder);
}

class ServiceRecordsCompanion extends UpdateCompanion<ServiceRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String> kind;
  final Value<int> price;
  final Value<int> durationDays;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ServiceRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.price = const Value.absent(),
    this.durationDays = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    required String kind,
    required int price,
    required int durationDays,
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       name = Value(name),
       kind = Value(kind),
       price = Value(price),
       durationDays = Value(durationDays);
  static Insertable<ServiceRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? price,
    Expression<int>? durationDays,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (price != null) 'price': price,
      if (durationDays != null) 'duration_days': durationDays,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String>? kind,
    Value<int>? price,
    Value<int>? durationDays,
    Value<bool>? isActive,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ServiceRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (durationDays.present) {
      map['duration_days'] = Variable<int>(durationDays.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('price: $price, ')
          ..write('durationDays: $durationDays, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderRecordsTable extends OrderRecords with TableInfo<$OrderRecordsTable, OrderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderNoMeta = const VerificationMeta(
    'orderNo',
  );
  @override
  late final GeneratedColumn<String> orderNo = GeneratedColumn<String>(
    'order_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payTermMeta = const VerificationMeta(
    'payTerm',
  );
  @override
  late final GeneratedColumn<String> payTerm = GeneratedColumn<String>(
    'pay_term',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('sekarang'),
  );
  static const VerificationMeta _proposalIdMeta = const VerificationMeta(
    'proposalId',
  );
  @override
  late final GeneratedColumn<String> proposalId = GeneratedColumn<String>(
    'proposal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _enteredAtMeta = const VerificationMeta(
    'enteredAt',
  );
  @override
  late final GeneratedColumn<DateTime> enteredAt = GeneratedColumn<DateTime>(
    'entered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedAtMeta = const VerificationMeta(
    'estimatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> estimatedAt = GeneratedColumn<DateTime>(
    'estimated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    orderNo,
    customerId,
    status,
    source,
    payTerm,
    proposalId,
    discount,
    note,
    enteredAt,
    estimatedAt,
    subtotal,
    total,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('order_no')) {
      context.handle(
        _orderNoMeta,
        orderNo.isAcceptableOrUnknown(data['order_no']!, _orderNoMeta),
      );
    } else if (isInserting) {
      context.missing(_orderNoMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('pay_term')) {
      context.handle(
        _payTermMeta,
        payTerm.isAcceptableOrUnknown(data['pay_term']!, _payTermMeta),
      );
    }
    if (data.containsKey('proposal_id')) {
      context.handle(
        _proposalIdMeta,
        proposalId.isAcceptableOrUnknown(data['proposal_id']!, _proposalIdMeta),
      );
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('entered_at')) {
      context.handle(
        _enteredAtMeta,
        enteredAt.isAcceptableOrUnknown(data['entered_at']!, _enteredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_enteredAtMeta);
    }
    if (data.containsKey('estimated_at')) {
      context.handle(
        _estimatedAtMeta,
        estimatedAt.isAcceptableOrUnknown(
          data['estimated_at']!,
          _estimatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedAtMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      orderNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_no'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      payTerm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pay_term'],
      )!,
      proposalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proposal_id'],
      ),
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      enteredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entered_at'],
      )!,
      estimatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}estimated_at'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
    );
  }

  @override
  $OrderRecordsTable createAlias(String alias) {
    return $OrderRecordsTable(attachedDatabase, alias);
  }
}

class OrderRow extends DataClass implements Insertable<OrderRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String orderNo;
  final String customerId;
  final String status;
  final String source;
  final String payTerm;
  final String? proposalId;
  final int discount;
  final String note;
  final DateTime enteredAt;
  final DateTime estimatedAt;
  final int subtotal;
  final int total;
  const OrderRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.orderNo,
    required this.customerId,
    required this.status,
    required this.source,
    required this.payTerm,
    this.proposalId,
    required this.discount,
    required this.note,
    required this.enteredAt,
    required this.estimatedAt,
    required this.subtotal,
    required this.total,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['order_no'] = Variable<String>(orderNo);
    map['customer_id'] = Variable<String>(customerId);
    map['status'] = Variable<String>(status);
    map['source'] = Variable<String>(source);
    map['pay_term'] = Variable<String>(payTerm);
    if (!nullToAbsent || proposalId != null) {
      map['proposal_id'] = Variable<String>(proposalId);
    }
    map['discount'] = Variable<int>(discount);
    map['note'] = Variable<String>(note);
    map['entered_at'] = Variable<DateTime>(enteredAt);
    map['estimated_at'] = Variable<DateTime>(estimatedAt);
    map['subtotal'] = Variable<int>(subtotal);
    map['total'] = Variable<int>(total);
    return map;
  }

  OrderRecordsCompanion toCompanion(bool nullToAbsent) {
    return OrderRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      orderNo: Value(orderNo),
      customerId: Value(customerId),
      status: Value(status),
      source: Value(source),
      payTerm: Value(payTerm),
      proposalId: proposalId == null && nullToAbsent ? const Value.absent() : Value(proposalId),
      discount: Value(discount),
      note: Value(note),
      enteredAt: Value(enteredAt),
      estimatedAt: Value(estimatedAt),
      subtotal: Value(subtotal),
      total: Value(total),
    );
  }

  factory OrderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      orderNo: serializer.fromJson<String>(json['orderNo']),
      customerId: serializer.fromJson<String>(json['customerId']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String>(json['source']),
      payTerm: serializer.fromJson<String>(json['payTerm']),
      proposalId: serializer.fromJson<String?>(json['proposalId']),
      discount: serializer.fromJson<int>(json['discount']),
      note: serializer.fromJson<String>(json['note']),
      enteredAt: serializer.fromJson<DateTime>(json['enteredAt']),
      estimatedAt: serializer.fromJson<DateTime>(json['estimatedAt']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      total: serializer.fromJson<int>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'orderNo': serializer.toJson<String>(orderNo),
      'customerId': serializer.toJson<String>(customerId),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String>(source),
      'payTerm': serializer.toJson<String>(payTerm),
      'proposalId': serializer.toJson<String?>(proposalId),
      'discount': serializer.toJson<int>(discount),
      'note': serializer.toJson<String>(note),
      'enteredAt': serializer.toJson<DateTime>(enteredAt),
      'estimatedAt': serializer.toJson<DateTime>(estimatedAt),
      'subtotal': serializer.toJson<int>(subtotal),
      'total': serializer.toJson<int>(total),
    };
  }

  OrderRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? orderNo,
    String? customerId,
    String? status,
    String? source,
    String? payTerm,
    Value<String?> proposalId = const Value.absent(),
    int? discount,
    String? note,
    DateTime? enteredAt,
    DateTime? estimatedAt,
    int? subtotal,
    int? total,
  }) => OrderRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    orderNo: orderNo ?? this.orderNo,
    customerId: customerId ?? this.customerId,
    status: status ?? this.status,
    source: source ?? this.source,
    payTerm: payTerm ?? this.payTerm,
    proposalId: proposalId.present ? proposalId.value : this.proposalId,
    discount: discount ?? this.discount,
    note: note ?? this.note,
    enteredAt: enteredAt ?? this.enteredAt,
    estimatedAt: estimatedAt ?? this.estimatedAt,
    subtotal: subtotal ?? this.subtotal,
    total: total ?? this.total,
  );
  OrderRow copyWithCompanion(OrderRecordsCompanion data) {
    return OrderRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      orderNo: data.orderNo.present ? data.orderNo.value : this.orderNo,
      customerId: data.customerId.present ? data.customerId.value : this.customerId,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      payTerm: data.payTerm.present ? data.payTerm.value : this.payTerm,
      proposalId: data.proposalId.present ? data.proposalId.value : this.proposalId,
      discount: data.discount.present ? data.discount.value : this.discount,
      note: data.note.present ? data.note.value : this.note,
      enteredAt: data.enteredAt.present ? data.enteredAt.value : this.enteredAt,
      estimatedAt: data.estimatedAt.present ? data.estimatedAt.value : this.estimatedAt,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderNo: $orderNo, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('payTerm: $payTerm, ')
          ..write('proposalId: $proposalId, ')
          ..write('discount: $discount, ')
          ..write('note: $note, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('estimatedAt: $estimatedAt, ')
          ..write('subtotal: $subtotal, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    orderNo,
    customerId,
    status,
    source,
    payTerm,
    proposalId,
    discount,
    note,
    enteredAt,
    estimatedAt,
    subtotal,
    total,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.orderNo == this.orderNo &&
          other.customerId == this.customerId &&
          other.status == this.status &&
          other.source == this.source &&
          other.payTerm == this.payTerm &&
          other.proposalId == this.proposalId &&
          other.discount == this.discount &&
          other.note == this.note &&
          other.enteredAt == this.enteredAt &&
          other.estimatedAt == this.estimatedAt &&
          other.subtotal == this.subtotal &&
          other.total == this.total);
}

class OrderRecordsCompanion extends UpdateCompanion<OrderRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> orderNo;
  final Value<String> customerId;
  final Value<String> status;
  final Value<String> source;
  final Value<String> payTerm;
  final Value<String?> proposalId;
  final Value<int> discount;
  final Value<String> note;
  final Value<DateTime> enteredAt;
  final Value<DateTime> estimatedAt;
  final Value<int> subtotal;
  final Value<int> total;
  final Value<int> rowid;
  const OrderRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.orderNo = const Value.absent(),
    this.customerId = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.payTerm = const Value.absent(),
    this.proposalId = const Value.absent(),
    this.discount = const Value.absent(),
    this.note = const Value.absent(),
    this.enteredAt = const Value.absent(),
    this.estimatedAt = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.total = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String orderNo,
    required String customerId,
    required String status,
    required String source,
    this.payTerm = const Value.absent(),
    this.proposalId = const Value.absent(),
    this.discount = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime enteredAt,
    required DateTime estimatedAt,
    required int subtotal,
    required int total,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       orderNo = Value(orderNo),
       customerId = Value(customerId),
       status = Value(status),
       source = Value(source),
       enteredAt = Value(enteredAt),
       estimatedAt = Value(estimatedAt),
       subtotal = Value(subtotal),
       total = Value(total);
  static Insertable<OrderRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? orderNo,
    Expression<String>? customerId,
    Expression<String>? status,
    Expression<String>? source,
    Expression<String>? payTerm,
    Expression<String>? proposalId,
    Expression<int>? discount,
    Expression<String>? note,
    Expression<DateTime>? enteredAt,
    Expression<DateTime>? estimatedAt,
    Expression<int>? subtotal,
    Expression<int>? total,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (orderNo != null) 'order_no': orderNo,
      if (customerId != null) 'customer_id': customerId,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (payTerm != null) 'pay_term': payTerm,
      if (proposalId != null) 'proposal_id': proposalId,
      if (discount != null) 'discount': discount,
      if (note != null) 'note': note,
      if (enteredAt != null) 'entered_at': enteredAt,
      if (estimatedAt != null) 'estimated_at': estimatedAt,
      if (subtotal != null) 'subtotal': subtotal,
      if (total != null) 'total': total,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? orderNo,
    Value<String>? customerId,
    Value<String>? status,
    Value<String>? source,
    Value<String>? payTerm,
    Value<String?>? proposalId,
    Value<int>? discount,
    Value<String>? note,
    Value<DateTime>? enteredAt,
    Value<DateTime>? estimatedAt,
    Value<int>? subtotal,
    Value<int>? total,
    Value<int>? rowid,
  }) {
    return OrderRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      orderNo: orderNo ?? this.orderNo,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      source: source ?? this.source,
      payTerm: payTerm ?? this.payTerm,
      proposalId: proposalId ?? this.proposalId,
      discount: discount ?? this.discount,
      note: note ?? this.note,
      enteredAt: enteredAt ?? this.enteredAt,
      estimatedAt: estimatedAt ?? this.estimatedAt,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (orderNo.present) {
      map['order_no'] = Variable<String>(orderNo.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (payTerm.present) {
      map['pay_term'] = Variable<String>(payTerm.value);
    }
    if (proposalId.present) {
      map['proposal_id'] = Variable<String>(proposalId.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (enteredAt.present) {
      map['entered_at'] = Variable<DateTime>(enteredAt.value);
    }
    if (estimatedAt.present) {
      map['estimated_at'] = Variable<DateTime>(estimatedAt.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderNo: $orderNo, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('payTerm: $payTerm, ')
          ..write('proposalId: $proposalId, ')
          ..write('discount: $discount, ')
          ..write('note: $note, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('estimatedAt: $estimatedAt, ')
          ..write('subtotal: $subtotal, ')
          ..write('total: $total, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemRecordsTable extends OrderItemRecords
    with TableInfo<$OrderItemRecordsTable, OrderItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES services (id)',
    ),
  );
  static const VerificationMeta _serviceNameMeta = const VerificationMeta(
    'serviceName',
  );
  @override
  late final GeneratedColumn<String> serviceName = GeneratedColumn<String>(
    'service_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMilliMeta = const VerificationMeta(
    'qtyMilli',
  );
  @override
  late final GeneratedColumn<int> qtyMilli = GeneratedColumn<int>(
    'qty_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<int> lineTotal = GeneratedColumn<int>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    orderId,
    serviceId,
    serviceName,
    unit,
    qtyMilli,
    unitPrice,
    lineTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('service_name')) {
      context.handle(
        _serviceNameMeta,
        serviceName.isAcceptableOrUnknown(
          data['service_name']!,
          _serviceNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceNameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('qty_milli')) {
      context.handle(
        _qtyMilliMeta,
        qtyMilli.isAcceptableOrUnknown(data['qty_milli']!, _qtyMilliMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMilliMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_id'],
      )!,
      serviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      qtyMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_milli'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_total'],
      )!,
    );
  }

  @override
  $OrderItemRecordsTable createAlias(String alias) {
    return $OrderItemRecordsTable(attachedDatabase, alias);
  }
}

class OrderItemRow extends DataClass implements Insertable<OrderItemRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String orderId;
  final String serviceId;
  final String serviceName;
  final String unit;
  final int qtyMilli;
  final int unitPrice;
  final int lineTotal;
  const OrderItemRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.orderId,
    required this.serviceId,
    required this.serviceName,
    required this.unit,
    required this.qtyMilli,
    required this.unitPrice,
    required this.lineTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['order_id'] = Variable<String>(orderId);
    map['service_id'] = Variable<String>(serviceId);
    map['service_name'] = Variable<String>(serviceName);
    map['unit'] = Variable<String>(unit);
    map['qty_milli'] = Variable<int>(qtyMilli);
    map['unit_price'] = Variable<int>(unitPrice);
    map['line_total'] = Variable<int>(lineTotal);
    return map;
  }

  OrderItemRecordsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      orderId: Value(orderId),
      serviceId: Value(serviceId),
      serviceName: Value(serviceName),
      unit: Value(unit),
      qtyMilli: Value(qtyMilli),
      unitPrice: Value(unitPrice),
      lineTotal: Value(lineTotal),
    );
  }

  factory OrderItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      orderId: serializer.fromJson<String>(json['orderId']),
      serviceId: serializer.fromJson<String>(json['serviceId']),
      serviceName: serializer.fromJson<String>(json['serviceName']),
      unit: serializer.fromJson<String>(json['unit']),
      qtyMilli: serializer.fromJson<int>(json['qtyMilli']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      lineTotal: serializer.fromJson<int>(json['lineTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'orderId': serializer.toJson<String>(orderId),
      'serviceId': serializer.toJson<String>(serviceId),
      'serviceName': serializer.toJson<String>(serviceName),
      'unit': serializer.toJson<String>(unit),
      'qtyMilli': serializer.toJson<int>(qtyMilli),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'lineTotal': serializer.toJson<int>(lineTotal),
    };
  }

  OrderItemRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? orderId,
    String? serviceId,
    String? serviceName,
    String? unit,
    int? qtyMilli,
    int? unitPrice,
    int? lineTotal,
  }) => OrderItemRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    orderId: orderId ?? this.orderId,
    serviceId: serviceId ?? this.serviceId,
    serviceName: serviceName ?? this.serviceName,
    unit: unit ?? this.unit,
    qtyMilli: qtyMilli ?? this.qtyMilli,
    unitPrice: unitPrice ?? this.unitPrice,
    lineTotal: lineTotal ?? this.lineTotal,
  );
  OrderItemRow copyWithCompanion(OrderItemRecordsCompanion data) {
    return OrderItemRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      serviceName: data.serviceName.present ? data.serviceName.value : this.serviceName,
      unit: data.unit.present ? data.unit.value : this.unit,
      qtyMilli: data.qtyMilli.present ? data.qtyMilli.value : this.qtyMilli,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderId: $orderId, ')
          ..write('serviceId: $serviceId, ')
          ..write('serviceName: $serviceName, ')
          ..write('unit: $unit, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    orderId,
    serviceId,
    serviceName,
    unit,
    qtyMilli,
    unitPrice,
    lineTotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.orderId == this.orderId &&
          other.serviceId == this.serviceId &&
          other.serviceName == this.serviceName &&
          other.unit == this.unit &&
          other.qtyMilli == this.qtyMilli &&
          other.unitPrice == this.unitPrice &&
          other.lineTotal == this.lineTotal);
}

class OrderItemRecordsCompanion extends UpdateCompanion<OrderItemRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> orderId;
  final Value<String> serviceId;
  final Value<String> serviceName;
  final Value<String> unit;
  final Value<int> qtyMilli;
  final Value<int> unitPrice;
  final Value<int> lineTotal;
  final Value<int> rowid;
  const OrderItemRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.orderId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.unit = const Value.absent(),
    this.qtyMilli = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String orderId,
    required String serviceId,
    required String serviceName,
    required String unit,
    required int qtyMilli,
    required int unitPrice,
    required int lineTotal,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       orderId = Value(orderId),
       serviceId = Value(serviceId),
       serviceName = Value(serviceName),
       unit = Value(unit),
       qtyMilli = Value(qtyMilli),
       unitPrice = Value(unitPrice),
       lineTotal = Value(lineTotal);
  static Insertable<OrderItemRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? orderId,
    Expression<String>? serviceId,
    Expression<String>? serviceName,
    Expression<String>? unit,
    Expression<int>? qtyMilli,
    Expression<int>? unitPrice,
    Expression<int>? lineTotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (orderId != null) 'order_id': orderId,
      if (serviceId != null) 'service_id': serviceId,
      if (serviceName != null) 'service_name': serviceName,
      if (unit != null) 'unit': unit,
      if (qtyMilli != null) 'qty_milli': qtyMilli,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (lineTotal != null) 'line_total': lineTotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? orderId,
    Value<String>? serviceId,
    Value<String>? serviceName,
    Value<String>? unit,
    Value<int>? qtyMilli,
    Value<int>? unitPrice,
    Value<int>? lineTotal,
    Value<int>? rowid,
  }) {
    return OrderItemRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      orderId: orderId ?? this.orderId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      unit: unit ?? this.unit,
      qtyMilli: qtyMilli ?? this.qtyMilli,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    if (serviceName.present) {
      map['service_name'] = Variable<String>(serviceName.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (qtyMilli.present) {
      map['qty_milli'] = Variable<int>(qtyMilli.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<int>(lineTotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderId: $orderId, ')
          ..write('serviceId: $serviceId, ')
          ..write('serviceName: $serviceName, ')
          ..write('unit: $unit, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentRecordsTable extends PaymentRecords with TableInfo<$PaymentRecordsTable, PaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedMeta = const VerificationMeta(
    'received',
  );
  @override
  late final GeneratedColumn<int> received = GeneratedColumn<int>(
    'received',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    orderId,
    method,
    amount,
    received,
    paidAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('received')) {
      context.handle(
        _receivedMeta,
        received.isAcceptableOrUnknown(data['received']!, _receivedMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      received: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}received'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $PaymentRecordsTable createAlias(String alias) {
    return $PaymentRecordsTable(attachedDatabase, alias);
  }
}

class PaymentRow extends DataClass implements Insertable<PaymentRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String orderId;
  final String method;
  final int amount;
  final int received;
  final DateTime paidAt;
  final String note;
  const PaymentRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.orderId,
    required this.method,
    required this.amount,
    required this.received,
    required this.paidAt,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['order_id'] = Variable<String>(orderId);
    map['method'] = Variable<String>(method);
    map['amount'] = Variable<int>(amount);
    map['received'] = Variable<int>(received);
    map['paid_at'] = Variable<DateTime>(paidAt);
    map['note'] = Variable<String>(note);
    return map;
  }

  PaymentRecordsCompanion toCompanion(bool nullToAbsent) {
    return PaymentRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      orderId: Value(orderId),
      method: Value(method),
      amount: Value(amount),
      received: Value(received),
      paidAt: Value(paidAt),
      note: Value(note),
    );
  }

  factory PaymentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      orderId: serializer.fromJson<String>(json['orderId']),
      method: serializer.fromJson<String>(json['method']),
      amount: serializer.fromJson<int>(json['amount']),
      received: serializer.fromJson<int>(json['received']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'orderId': serializer.toJson<String>(orderId),
      'method': serializer.toJson<String>(method),
      'amount': serializer.toJson<int>(amount),
      'received': serializer.toJson<int>(received),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'note': serializer.toJson<String>(note),
    };
  }

  PaymentRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? orderId,
    String? method,
    int? amount,
    int? received,
    DateTime? paidAt,
    String? note,
  }) => PaymentRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    orderId: orderId ?? this.orderId,
    method: method ?? this.method,
    amount: amount ?? this.amount,
    received: received ?? this.received,
    paidAt: paidAt ?? this.paidAt,
    note: note ?? this.note,
  );
  PaymentRow copyWithCompanion(PaymentRecordsCompanion data) {
    return PaymentRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      method: data.method.present ? data.method.value : this.method,
      amount: data.amount.present ? data.amount.value : this.amount,
      received: data.received.present ? data.received.value : this.received,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderId: $orderId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('received: $received, ')
          ..write('paidAt: $paidAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    orderId,
    method,
    amount,
    received,
    paidAt,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.orderId == this.orderId &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.received == this.received &&
          other.paidAt == this.paidAt &&
          other.note == this.note);
}

class PaymentRecordsCompanion extends UpdateCompanion<PaymentRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> orderId;
  final Value<String> method;
  final Value<int> amount;
  final Value<int> received;
  final Value<DateTime> paidAt;
  final Value<String> note;
  final Value<int> rowid;
  const PaymentRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.orderId = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.received = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String orderId,
    required String method,
    required int amount,
    required int received,
    required DateTime paidAt,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       orderId = Value(orderId),
       method = Value(method),
       amount = Value(amount),
       received = Value(received),
       paidAt = Value(paidAt);
  static Insertable<PaymentRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? orderId,
    Expression<String>? method,
    Expression<int>? amount,
    Expression<int>? received,
    Expression<DateTime>? paidAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (orderId != null) 'order_id': orderId,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (received != null) 'received': received,
      if (paidAt != null) 'paid_at': paidAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? orderId,
    Value<String>? method,
    Value<int>? amount,
    Value<int>? received,
    Value<DateTime>? paidAt,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return PaymentRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      orderId: orderId ?? this.orderId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      received: received ?? this.received,
      paidAt: paidAt ?? this.paidAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (received.present) {
      map['received'] = Variable<int>(received.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderId: $orderId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('received: $received, ')
          ..write('paidAt: $paidAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsRecordsTable extends SavingsRecords with TableInfo<$SavingsRecordsTable, SavingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdKeyMeta = const VerificationMeta(
    'createdKey',
  );
  @override
  late final GeneratedColumn<String> createdKey = GeneratedColumn<String>(
    'created_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    createdKey,
    customerId,
    kind,
    amount,
    method,
    orderId,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('created_key')) {
      context.handle(
        _createdKeyMeta,
        createdKey.isAcceptableOrUnknown(data['created_key']!, _createdKeyMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      createdKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_key'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $SavingsRecordsTable createAlias(String alias) {
    return $SavingsRecordsTable(attachedDatabase, alias);
  }
}

class SavingsRow extends DataClass implements Insertable<SavingsRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final String createdKey;
  final String customerId;
  final String kind;
  final int amount;
  final String method;
  final String? orderId;
  final String note;
  const SavingsRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    required this.createdKey,
    required this.customerId,
    required this.kind,
    required this.amount,
    required this.method,
    this.orderId,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    map['created_key'] = Variable<String>(createdKey);
    map['customer_id'] = Variable<String>(customerId);
    map['kind'] = Variable<String>(kind);
    map['amount'] = Variable<int>(amount);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || orderId != null) {
      map['order_id'] = Variable<String>(orderId);
    }
    map['note'] = Variable<String>(note);
    return map;
  }

  SavingsRecordsCompanion toCompanion(bool nullToAbsent) {
    return SavingsRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      createdKey: Value(createdKey),
      customerId: Value(customerId),
      kind: Value(kind),
      amount: Value(amount),
      method: Value(method),
      orderId: orderId == null && nullToAbsent ? const Value.absent() : Value(orderId),
      note: Value(note),
    );
  }

  factory SavingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      createdKey: serializer.fromJson<String>(json['createdKey']),
      customerId: serializer.fromJson<String>(json['customerId']),
      kind: serializer.fromJson<String>(json['kind']),
      amount: serializer.fromJson<int>(json['amount']),
      method: serializer.fromJson<String>(json['method']),
      orderId: serializer.fromJson<String?>(json['orderId']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'createdKey': serializer.toJson<String>(createdKey),
      'customerId': serializer.toJson<String>(customerId),
      'kind': serializer.toJson<String>(kind),
      'amount': serializer.toJson<int>(amount),
      'method': serializer.toJson<String>(method),
      'orderId': serializer.toJson<String?>(orderId),
      'note': serializer.toJson<String>(note),
    };
  }

  SavingsRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    String? createdKey,
    String? customerId,
    String? kind,
    int? amount,
    String? method,
    Value<String?> orderId = const Value.absent(),
    String? note,
  }) => SavingsRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    createdKey: createdKey ?? this.createdKey,
    customerId: customerId ?? this.customerId,
    kind: kind ?? this.kind,
    amount: amount ?? this.amount,
    method: method ?? this.method,
    orderId: orderId.present ? orderId.value : this.orderId,
    note: note ?? this.note,
  );
  SavingsRow copyWithCompanion(SavingsRecordsCompanion data) {
    return SavingsRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      createdKey: data.createdKey.present ? data.createdKey.value : this.createdKey,
      customerId: data.customerId.present ? data.customerId.value : this.customerId,
      kind: data.kind.present ? data.kind.value : this.kind,
      amount: data.amount.present ? data.amount.value : this.amount,
      method: data.method.present ? data.method.value : this.method,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('createdKey: $createdKey, ')
          ..write('customerId: $customerId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('orderId: $orderId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    createdKey,
    customerId,
    kind,
    amount,
    method,
    orderId,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.createdKey == this.createdKey &&
          other.customerId == this.customerId &&
          other.kind == this.kind &&
          other.amount == this.amount &&
          other.method == this.method &&
          other.orderId == this.orderId &&
          other.note == this.note);
}

class SavingsRecordsCompanion extends UpdateCompanion<SavingsRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<String> createdKey;
  final Value<String> customerId;
  final Value<String> kind;
  final Value<int> amount;
  final Value<String> method;
  final Value<String?> orderId;
  final Value<String> note;
  final Value<int> rowid;
  const SavingsRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.createdKey = const Value.absent(),
    this.customerId = const Value.absent(),
    this.kind = const Value.absent(),
    this.amount = const Value.absent(),
    this.method = const Value.absent(),
    this.orderId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.createdKey = const Value.absent(),
    required String customerId,
    required String kind,
    required int amount,
    required String method,
    this.orderId = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       customerId = Value(customerId),
       kind = Value(kind),
       amount = Value(amount),
       method = Value(method);
  static Insertable<SavingsRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<String>? createdKey,
    Expression<String>? customerId,
    Expression<String>? kind,
    Expression<int>? amount,
    Expression<String>? method,
    Expression<String>? orderId,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (createdKey != null) 'created_key': createdKey,
      if (customerId != null) 'customer_id': customerId,
      if (kind != null) 'kind': kind,
      if (amount != null) 'amount': amount,
      if (method != null) 'method': method,
      if (orderId != null) 'order_id': orderId,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<String>? createdKey,
    Value<String>? customerId,
    Value<String>? kind,
    Value<int>? amount,
    Value<String>? method,
    Value<String?>? orderId,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return SavingsRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      createdKey: createdKey ?? this.createdKey,
      customerId: customerId ?? this.customerId,
      kind: kind ?? this.kind,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      orderId: orderId ?? this.orderId,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (createdKey.present) {
      map['created_key'] = Variable<String>(createdKey.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('createdKey: $createdKey, ')
          ..write('customerId: $customerId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('orderId: $orderId, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoryRecordsTable extends ExpenseCategoryRecords
    with TableInfo<$ExpenseCategoryRecordsTable, ExpenseCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoryRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    name,
    isDefault,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
    );
  }

  @override
  $ExpenseCategoryRecordsTable createAlias(String alias) {
    return $ExpenseCategoryRecordsTable(attachedDatabase, alias);
  }
}

class ExpenseCategoryRow extends DataClass implements Insertable<ExpenseCategoryRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String name;
  final bool isDefault;
  const ExpenseCategoryRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.name,
    required this.isDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  ExpenseCategoryRecordsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoryRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      name: Value(name),
      isDefault: Value(isDefault),
    );
  }

  factory ExpenseCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategoryRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  ExpenseCategoryRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    bool? isDefault,
  }) => ExpenseCategoryRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    isDefault: isDefault ?? this.isDefault,
  );
  ExpenseCategoryRow copyWithCompanion(ExpenseCategoryRecordsCompanion data) {
    return ExpenseCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoryRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    name,
    isDefault,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategoryRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.isDefault == this.isDefault);
}

class ExpenseCategoryRecordsCompanion extends UpdateCompanion<ExpenseCategoryRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<bool> isDefault;
  final Value<int> rowid;
  const ExpenseCategoryRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseCategoryRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       name = Value(name);
  static Insertable<ExpenseCategoryRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<bool>? isDefault,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (isDefault != null) 'is_default': isDefault,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseCategoryRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<bool>? isDefault,
    Value<int>? rowid,
  }) {
    return ExpenseCategoryRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoryRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('isDefault: $isDefault, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseRecordsTable extends ExpenseRecords with TableInfo<$ExpenseRecordsTable, ExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expense_categories (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendorMeta = const VerificationMeta('vendor');
  @override
  late final GeneratedColumn<String> vendor = GeneratedColumn<String>(
    'vendor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _spentAtMeta = const VerificationMeta(
    'spentAt',
  );
  @override
  late final GeneratedColumn<DateTime> spentAt = GeneratedColumn<DateTime>(
    'spent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    categoryId,
    amount,
    vendor,
    note,
    spentAt,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('vendor')) {
      context.handle(
        _vendorMeta,
        vendor.isAcceptableOrUnknown(data['vendor']!, _vendorMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('spent_at')) {
      context.handle(
        _spentAtMeta,
        spentAt.isAcceptableOrUnknown(data['spent_at']!, _spentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_spentAtMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      vendor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      spentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}spent_at'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $ExpenseRecordsTable createAlias(String alias) {
    return $ExpenseRecordsTable(attachedDatabase, alias);
  }
}

class ExpenseRow extends DataClass implements Insertable<ExpenseRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String categoryId;
  final int amount;
  final String vendor;
  final String note;
  final DateTime spentAt;
  final String? photoPath;
  const ExpenseRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.categoryId,
    required this.amount,
    required this.vendor,
    required this.note,
    required this.spentAt,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['category_id'] = Variable<String>(categoryId);
    map['amount'] = Variable<int>(amount);
    map['vendor'] = Variable<String>(vendor);
    map['note'] = Variable<String>(note);
    map['spent_at'] = Variable<DateTime>(spentAt);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  ExpenseRecordsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      categoryId: Value(categoryId),
      amount: Value(amount),
      vendor: Value(vendor),
      note: Value(note),
      spentAt: Value(spentAt),
      photoPath: photoPath == null && nullToAbsent ? const Value.absent() : Value(photoPath),
    );
  }

  factory ExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      amount: serializer.fromJson<int>(json['amount']),
      vendor: serializer.fromJson<String>(json['vendor']),
      note: serializer.fromJson<String>(json['note']),
      spentAt: serializer.fromJson<DateTime>(json['spentAt']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'categoryId': serializer.toJson<String>(categoryId),
      'amount': serializer.toJson<int>(amount),
      'vendor': serializer.toJson<String>(vendor),
      'note': serializer.toJson<String>(note),
      'spentAt': serializer.toJson<DateTime>(spentAt),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  ExpenseRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? categoryId,
    int? amount,
    String? vendor,
    String? note,
    DateTime? spentAt,
    Value<String?> photoPath = const Value.absent(),
  }) => ExpenseRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    categoryId: categoryId ?? this.categoryId,
    amount: amount ?? this.amount,
    vendor: vendor ?? this.vendor,
    note: note ?? this.note,
    spentAt: spentAt ?? this.spentAt,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  ExpenseRow copyWithCompanion(ExpenseRecordsCompanion data) {
    return ExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
      amount: data.amount.present ? data.amount.value : this.amount,
      vendor: data.vendor.present ? data.vendor.value : this.vendor,
      note: data.note.present ? data.note.value : this.note,
      spentAt: data.spentAt.present ? data.spentAt.value : this.spentAt,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('vendor: $vendor, ')
          ..write('note: $note, ')
          ..write('spentAt: $spentAt, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    categoryId,
    amount,
    vendor,
    note,
    spentAt,
    photoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.categoryId == this.categoryId &&
          other.amount == this.amount &&
          other.vendor == this.vendor &&
          other.note == this.note &&
          other.spentAt == this.spentAt &&
          other.photoPath == this.photoPath);
}

class ExpenseRecordsCompanion extends UpdateCompanion<ExpenseRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> categoryId;
  final Value<int> amount;
  final Value<String> vendor;
  final Value<String> note;
  final Value<DateTime> spentAt;
  final Value<String?> photoPath;
  final Value<int> rowid;
  const ExpenseRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amount = const Value.absent(),
    this.vendor = const Value.absent(),
    this.note = const Value.absent(),
    this.spentAt = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String categoryId,
    required int amount,
    this.vendor = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime spentAt,
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       categoryId = Value(categoryId),
       amount = Value(amount),
       spentAt = Value(spentAt);
  static Insertable<ExpenseRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? categoryId,
    Expression<int>? amount,
    Expression<String>? vendor,
    Expression<String>? note,
    Expression<DateTime>? spentAt,
    Expression<String>? photoPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (categoryId != null) 'category_id': categoryId,
      if (amount != null) 'amount': amount,
      if (vendor != null) 'vendor': vendor,
      if (note != null) 'note': note,
      if (spentAt != null) 'spent_at': spentAt,
      if (photoPath != null) 'photo_path': photoPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? categoryId,
    Value<int>? amount,
    Value<String>? vendor,
    Value<String>? note,
    Value<DateTime>? spentAt,
    Value<String?>? photoPath,
    Value<int>? rowid,
  }) {
    return ExpenseRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      vendor: vendor ?? this.vendor,
      note: note ?? this.note,
      spentAt: spentAt ?? this.spentAt,
      photoPath: photoPath ?? this.photoPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (vendor.present) {
      map['vendor'] = Variable<String>(vendor.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (spentAt.present) {
      map['spent_at'] = Variable<DateTime>(spentAt.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('vendor: $vendor, ')
          ..write('note: $note, ')
          ..write('spentAt: $spentAt, ')
          ..write('photoPath: $photoPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReceiptSettingRecordsTable extends ReceiptSettingRecords
    with TableInfo<$ReceiptSettingRecordsTable, ReceiptSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptSettingRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paperMmMeta = const VerificationMeta(
    'paperMm',
  );
  @override
  late final GeneratedColumn<int> paperMm = GeneratedColumn<int>(
    'paper_mm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(58),
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<int> fontSize = GeneratedColumn<int>(
    'font_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(11),
  );
  static const VerificationMeta _showAddressMeta = const VerificationMeta(
    'showAddress',
  );
  @override
  late final GeneratedColumn<bool> showAddress = GeneratedColumn<bool>(
    'show_address',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_address" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showCustomerMeta = const VerificationMeta(
    'showCustomer',
  );
  @override
  late final GeneratedColumn<bool> showCustomer = GeneratedColumn<bool>(
    'show_customer',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_customer" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showSavingsMeta = const VerificationMeta(
    'showSavings',
  );
  @override
  late final GeneratedColumn<bool> showSavings = GeneratedColumn<bool>(
    'show_savings',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_savings" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showNoteMeta = const VerificationMeta(
    'showNote',
  );
  @override
  late final GeneratedColumn<bool> showNote = GeneratedColumn<bool>(
    'show_note',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_note" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    paperMm,
    fontSize,
    showAddress,
    showCustomer,
    showSavings,
    showNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipt_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReceiptSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('paper_mm')) {
      context.handle(
        _paperMmMeta,
        paperMm.isAcceptableOrUnknown(data['paper_mm']!, _paperMmMeta),
      );
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    }
    if (data.containsKey('show_address')) {
      context.handle(
        _showAddressMeta,
        showAddress.isAcceptableOrUnknown(
          data['show_address']!,
          _showAddressMeta,
        ),
      );
    }
    if (data.containsKey('show_customer')) {
      context.handle(
        _showCustomerMeta,
        showCustomer.isAcceptableOrUnknown(
          data['show_customer']!,
          _showCustomerMeta,
        ),
      );
    }
    if (data.containsKey('show_savings')) {
      context.handle(
        _showSavingsMeta,
        showSavings.isAcceptableOrUnknown(
          data['show_savings']!,
          _showSavingsMeta,
        ),
      );
    }
    if (data.containsKey('show_note')) {
      context.handle(
        _showNoteMeta,
        showNote.isAcceptableOrUnknown(data['show_note']!, _showNoteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReceiptSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceiptSettingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      paperMm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paper_mm'],
      )!,
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}font_size'],
      )!,
      showAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_address'],
      )!,
      showCustomer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_customer'],
      )!,
      showSavings: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_savings'],
      )!,
      showNote: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_note'],
      )!,
    );
  }

  @override
  $ReceiptSettingRecordsTable createAlias(String alias) {
    return $ReceiptSettingRecordsTable(attachedDatabase, alias);
  }
}

class ReceiptSettingRow extends DataClass implements Insertable<ReceiptSettingRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final int paperMm;
  final int fontSize;
  final bool showAddress;
  final bool showCustomer;
  final bool showSavings;
  final bool showNote;
  const ReceiptSettingRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.paperMm,
    required this.fontSize,
    required this.showAddress,
    required this.showCustomer,
    required this.showSavings,
    required this.showNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['paper_mm'] = Variable<int>(paperMm);
    map['font_size'] = Variable<int>(fontSize);
    map['show_address'] = Variable<bool>(showAddress);
    map['show_customer'] = Variable<bool>(showCustomer);
    map['show_savings'] = Variable<bool>(showSavings);
    map['show_note'] = Variable<bool>(showNote);
    return map;
  }

  ReceiptSettingRecordsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptSettingRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      paperMm: Value(paperMm),
      fontSize: Value(fontSize),
      showAddress: Value(showAddress),
      showCustomer: Value(showCustomer),
      showSavings: Value(showSavings),
      showNote: Value(showNote),
    );
  }

  factory ReceiptSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceiptSettingRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      paperMm: serializer.fromJson<int>(json['paperMm']),
      fontSize: serializer.fromJson<int>(json['fontSize']),
      showAddress: serializer.fromJson<bool>(json['showAddress']),
      showCustomer: serializer.fromJson<bool>(json['showCustomer']),
      showSavings: serializer.fromJson<bool>(json['showSavings']),
      showNote: serializer.fromJson<bool>(json['showNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'paperMm': serializer.toJson<int>(paperMm),
      'fontSize': serializer.toJson<int>(fontSize),
      'showAddress': serializer.toJson<bool>(showAddress),
      'showCustomer': serializer.toJson<bool>(showCustomer),
      'showSavings': serializer.toJson<bool>(showSavings),
      'showNote': serializer.toJson<bool>(showNote),
    };
  }

  ReceiptSettingRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? paperMm,
    int? fontSize,
    bool? showAddress,
    bool? showCustomer,
    bool? showSavings,
    bool? showNote,
  }) => ReceiptSettingRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    paperMm: paperMm ?? this.paperMm,
    fontSize: fontSize ?? this.fontSize,
    showAddress: showAddress ?? this.showAddress,
    showCustomer: showCustomer ?? this.showCustomer,
    showSavings: showSavings ?? this.showSavings,
    showNote: showNote ?? this.showNote,
  );
  ReceiptSettingRow copyWithCompanion(ReceiptSettingRecordsCompanion data) {
    return ReceiptSettingRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      paperMm: data.paperMm.present ? data.paperMm.value : this.paperMm,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      showAddress: data.showAddress.present ? data.showAddress.value : this.showAddress,
      showCustomer: data.showCustomer.present ? data.showCustomer.value : this.showCustomer,
      showSavings: data.showSavings.present ? data.showSavings.value : this.showSavings,
      showNote: data.showNote.present ? data.showNote.value : this.showNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptSettingRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('paperMm: $paperMm, ')
          ..write('fontSize: $fontSize, ')
          ..write('showAddress: $showAddress, ')
          ..write('showCustomer: $showCustomer, ')
          ..write('showSavings: $showSavings, ')
          ..write('showNote: $showNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    paperMm,
    fontSize,
    showAddress,
    showCustomer,
    showSavings,
    showNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceiptSettingRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.paperMm == this.paperMm &&
          other.fontSize == this.fontSize &&
          other.showAddress == this.showAddress &&
          other.showCustomer == this.showCustomer &&
          other.showSavings == this.showSavings &&
          other.showNote == this.showNote);
}

class ReceiptSettingRecordsCompanion extends UpdateCompanion<ReceiptSettingRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<int> paperMm;
  final Value<int> fontSize;
  final Value<bool> showAddress;
  final Value<bool> showCustomer;
  final Value<bool> showSavings;
  final Value<bool> showNote;
  final Value<int> rowid;
  const ReceiptSettingRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.paperMm = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.showAddress = const Value.absent(),
    this.showCustomer = const Value.absent(),
    this.showSavings = const Value.absent(),
    this.showNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceiptSettingRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.paperMm = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.showAddress = const Value.absent(),
    this.showCustomer = const Value.absent(),
    this.showSavings = const Value.absent(),
    this.showNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt);
  static Insertable<ReceiptSettingRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<int>? paperMm,
    Expression<int>? fontSize,
    Expression<bool>? showAddress,
    Expression<bool>? showCustomer,
    Expression<bool>? showSavings,
    Expression<bool>? showNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (paperMm != null) 'paper_mm': paperMm,
      if (fontSize != null) 'font_size': fontSize,
      if (showAddress != null) 'show_address': showAddress,
      if (showCustomer != null) 'show_customer': showCustomer,
      if (showSavings != null) 'show_savings': showSavings,
      if (showNote != null) 'show_note': showNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceiptSettingRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<int>? paperMm,
    Value<int>? fontSize,
    Value<bool>? showAddress,
    Value<bool>? showCustomer,
    Value<bool>? showSavings,
    Value<bool>? showNote,
    Value<int>? rowid,
  }) {
    return ReceiptSettingRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      paperMm: paperMm ?? this.paperMm,
      fontSize: fontSize ?? this.fontSize,
      showAddress: showAddress ?? this.showAddress,
      showCustomer: showCustomer ?? this.showCustomer,
      showSavings: showSavings ?? this.showSavings,
      showNote: showNote ?? this.showNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (paperMm.present) {
      map['paper_mm'] = Variable<int>(paperMm.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<int>(fontSize.value);
    }
    if (showAddress.present) {
      map['show_address'] = Variable<bool>(showAddress.value);
    }
    if (showCustomer.present) {
      map['show_customer'] = Variable<bool>(showCustomer.value);
    }
    if (showSavings.present) {
      map['show_savings'] = Variable<bool>(showSavings.value);
    }
    if (showNote.present) {
      map['show_note'] = Variable<bool>(showNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptSettingRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('paperMm: $paperMm, ')
          ..write('fontSize: $fontSize, ')
          ..write('showAddress: $showAddress, ')
          ..write('showCustomer: $showCustomer, ')
          ..write('showSavings: $showSavings, ')
          ..write('showNote: $showNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntitlementRecordsTable extends EntitlementRecords
    with TableInfo<$EntitlementRecordsTable, EntitlementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitlementRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('free'),
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    plan,
    validUntil,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entitlements';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntitlementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntitlementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntitlementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      )!,
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_until'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $EntitlementRecordsTable createAlias(String alias) {
    return $EntitlementRecordsTable(attachedDatabase, alias);
  }
}

class EntitlementRow extends DataClass implements Insertable<EntitlementRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String plan;
  final DateTime? validUntil;
  final String source;
  const EntitlementRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.plan,
    this.validUntil,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['plan'] = Variable<String>(plan);
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<DateTime>(validUntil);
    }
    map['source'] = Variable<String>(source);
    return map;
  }

  EntitlementRecordsCompanion toCompanion(bool nullToAbsent) {
    return EntitlementRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      plan: Value(plan),
      validUntil: validUntil == null && nullToAbsent ? const Value.absent() : Value(validUntil),
      source: Value(source),
    );
  }

  factory EntitlementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntitlementRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      plan: serializer.fromJson<String>(json['plan']),
      validUntil: serializer.fromJson<DateTime?>(json['validUntil']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'plan': serializer.toJson<String>(plan),
      'validUntil': serializer.toJson<DateTime?>(validUntil),
      'source': serializer.toJson<String>(source),
    };
  }

  EntitlementRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? plan,
    Value<DateTime?> validUntil = const Value.absent(),
    String? source,
  }) => EntitlementRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    plan: plan ?? this.plan,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    source: source ?? this.source,
  );
  EntitlementRow copyWithCompanion(EntitlementRecordsCompanion data) {
    return EntitlementRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      plan: data.plan.present ? data.plan.value : this.plan,
      validUntil: data.validUntil.present ? data.validUntil.value : this.validUntil,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('plan: $plan, ')
          ..write('validUntil: $validUntil, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    plan,
    validUntil,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntitlementRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.plan == this.plan &&
          other.validUntil == this.validUntil &&
          other.source == this.source);
}

class EntitlementRecordsCompanion extends UpdateCompanion<EntitlementRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> plan;
  final Value<DateTime?> validUntil;
  final Value<String> source;
  final Value<int> rowid;
  const EntitlementRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.plan = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitlementRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.plan = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt);
  static Insertable<EntitlementRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? plan,
    Expression<DateTime>? validUntil,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (plan != null) 'plan': plan,
      if (validUntil != null) 'valid_until': validUntil,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitlementRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? plan,
    Value<DateTime?>? validUntil,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return EntitlementRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      plan: plan ?? this.plan,
      validUntil: validUntil ?? this.validUntil,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('plan: $plan, ')
          ..write('validUntil: $validUntil, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderEventRecordsTable extends OrderEventRecords
    with TableInfo<$OrderEventRecordsTable, OrderEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderEventRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fromStatusMeta = const VerificationMeta(
    'fromStatus',
  );
  @override
  late final GeneratedColumn<String> fromStatus = GeneratedColumn<String>(
    'from_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toStatusMeta = const VerificationMeta(
    'toStatus',
  );
  @override
  late final GeneratedColumn<String> toStatus = GeneratedColumn<String>(
    'to_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    orderId,
    occurredAt,
    kind,
    note,
    fromStatus,
    toStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('from_status')) {
      context.handle(
        _fromStatusMeta,
        fromStatus.isAcceptableOrUnknown(data['from_status']!, _fromStatusMeta),
      );
    }
    if (data.containsKey('to_status')) {
      context.handle(
        _toStatusMeta,
        toStatus.isAcceptableOrUnknown(data['to_status']!, _toStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      fromStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_status'],
      ),
      toStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_status'],
      ),
    );
  }

  @override
  $OrderEventRecordsTable createAlias(String alias) {
    return $OrderEventRecordsTable(attachedDatabase, alias);
  }
}

class OrderEventRow extends DataClass implements Insertable<OrderEventRow> {
  final String id;
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String syncState;
  final DateTime? deletedAt;
  final String orderId;
  final DateTime occurredAt;
  final String kind;
  final String note;
  final String? fromStatus;
  final String? toStatus;
  const OrderEventRow({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
    required this.syncState,
    this.deletedAt,
    required this.orderId,
    required this.occurredAt,
    required this.kind,
    required this.note,
    this.fromStatus,
    this.toStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['order_id'] = Variable<String>(orderId);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['kind'] = Variable<String>(kind);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || fromStatus != null) {
      map['from_status'] = Variable<String>(fromStatus);
    }
    if (!nullToAbsent || toStatus != null) {
      map['to_status'] = Variable<String>(toStatus);
    }
    return map;
  }

  OrderEventRecordsCompanion toCompanion(bool nullToAbsent) {
    return OrderEventRecordsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      syncState: Value(syncState),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      orderId: Value(orderId),
      occurredAt: Value(occurredAt),
      kind: Value(kind),
      note: Value(note),
      fromStatus: fromStatus == null && nullToAbsent ? const Value.absent() : Value(fromStatus),
      toStatus: toStatus == null && nullToAbsent ? const Value.absent() : Value(toStatus),
    );
  }

  factory OrderEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderEventRow(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      orderId: serializer.fromJson<String>(json['orderId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      kind: serializer.fromJson<String>(json['kind']),
      note: serializer.fromJson<String>(json['note']),
      fromStatus: serializer.fromJson<String?>(json['fromStatus']),
      toStatus: serializer.fromJson<String?>(json['toStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncState': serializer.toJson<String>(syncState),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'orderId': serializer.toJson<String>(orderId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'kind': serializer.toJson<String>(kind),
      'note': serializer.toJson<String>(note),
      'fromStatus': serializer.toJson<String?>(fromStatus),
      'toStatus': serializer.toJson<String?>(toStatus),
    };
  }

  OrderEventRow copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? syncState,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? orderId,
    DateTime? occurredAt,
    String? kind,
    String? note,
    Value<String?> fromStatus = const Value.absent(),
    Value<String?> toStatus = const Value.absent(),
  }) => OrderEventRow(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    syncState: syncState ?? this.syncState,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    orderId: orderId ?? this.orderId,
    occurredAt: occurredAt ?? this.occurredAt,
    kind: kind ?? this.kind,
    note: note ?? this.note,
    fromStatus: fromStatus.present ? fromStatus.value : this.fromStatus,
    toStatus: toStatus.present ? toStatus.value : this.toStatus,
  );
  OrderEventRow copyWithCompanion(OrderEventRecordsCompanion data) {
    return OrderEventRow(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      occurredAt: data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      note: data.note.present ? data.note.value : this.note,
      fromStatus: data.fromStatus.present ? data.fromStatus.value : this.fromStatus,
      toStatus: data.toStatus.present ? data.toStatus.value : this.toStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderEventRow(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderId: $orderId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('kind: $kind, ')
          ..write('note: $note, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    createdAt,
    updatedAt,
    syncState,
    deletedAt,
    orderId,
    occurredAt,
    kind,
    note,
    fromStatus,
    toStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderEventRow &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncState == this.syncState &&
          other.deletedAt == this.deletedAt &&
          other.orderId == this.orderId &&
          other.occurredAt == this.occurredAt &&
          other.kind == this.kind &&
          other.note == this.note &&
          other.fromStatus == this.fromStatus &&
          other.toStatus == this.toStatus);
}

class OrderEventRecordsCompanion extends UpdateCompanion<OrderEventRow> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> syncState;
  final Value<DateTime?> deletedAt;
  final Value<String> orderId;
  final Value<DateTime> occurredAt;
  final Value<String> kind;
  final Value<String> note;
  final Value<String?> fromStatus;
  final Value<String?> toStatus;
  final Value<int> rowid;
  const OrderEventRecordsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.orderId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.note = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderEventRecordsCompanion.insert({
    required String id,
    required String ownerId,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String orderId,
    required DateTime occurredAt,
    required String kind,
    this.note = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt),
       orderId = Value(orderId),
       occurredAt = Value(occurredAt),
       kind = Value(kind);
  static Insertable<OrderEventRow> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncState,
    Expression<DateTime>? deletedAt,
    Expression<String>? orderId,
    Expression<DateTime>? occurredAt,
    Expression<String>? kind,
    Expression<String>? note,
    Expression<String>? fromStatus,
    Expression<String>? toStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncState != null) 'sync_state': syncState,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (orderId != null) 'order_id': orderId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (kind != null) 'kind': kind,
      if (note != null) 'note': note,
      if (fromStatus != null) 'from_status': fromStatus,
      if (toStatus != null) 'to_status': toStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderEventRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? syncState,
    Value<DateTime?>? deletedAt,
    Value<String>? orderId,
    Value<DateTime>? occurredAt,
    Value<String>? kind,
    Value<String>? note,
    Value<String?>? fromStatus,
    Value<String?>? toStatus,
    Value<int>? rowid,
  }) {
    return OrderEventRecordsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncState: syncState ?? this.syncState,
      deletedAt: deletedAt ?? this.deletedAt,
      orderId: orderId ?? this.orderId,
      occurredAt: occurredAt ?? this.occurredAt,
      kind: kind ?? this.kind,
      note: note ?? this.note,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (fromStatus.present) {
      map['from_status'] = Variable<String>(fromStatus.value);
    }
    if (toStatus.present) {
      map['to_status'] = Variable<String>(toStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderEventRecordsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncState: $syncState, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('orderId: $orderId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('kind: $kind, ')
          ..write('note: $note, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxRecordsTable extends OutboxRecords with TableInfo<$OutboxRecordsTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetTable,
    rowId,
    op,
    payload,
    createdAt,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['table_name']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $OutboxRecordsTable createAlias(String alias) {
    return $OutboxRecordsTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final String id;
  final String targetTable;
  final String rowId;
  final String op;
  final String payload;
  final DateTime createdAt;
  final int attempts;
  final String? lastError;
  const OutboxEntry({
    required this.id,
    required this.targetTable,
    required this.rowId,
    required this.op,
    required this.payload,
    required this.createdAt,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['table_name'] = Variable<String>(targetTable);
    map['row_id'] = Variable<String>(rowId);
    map['op'] = Variable<String>(op);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  OutboxRecordsCompanion toCompanion(bool nullToAbsent) {
    return OutboxRecordsCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      rowId: Value(rowId),
      op: Value(op),
      payload: Value(payload),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent ? const Value.absent() : Value(lastError),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<String>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      rowId: serializer.fromJson<String>(json['rowId']),
      op: serializer.fromJson<String>(json['op']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'rowId': serializer.toJson<String>(rowId),
      'op': serializer.toJson<String>(op),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  OutboxEntry copyWith({
    String? id,
    String? targetTable,
    String? rowId,
    String? op,
    String? payload,
    DateTime? createdAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    targetTable: targetTable ?? this.targetTable,
    rowId: rowId ?? this.rowId,
    op: op ?? this.op,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  OutboxEntry copyWithCompanion(OutboxRecordsCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      targetTable: data.targetTable.present ? data.targetTable.value : this.targetTable,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      op: data.op.present ? data.op.value : this.op,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetTable,
    rowId,
    op,
    payload,
    createdAt,
    attempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.rowId == this.rowId &&
          other.op == this.op &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class OutboxRecordsCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<String> id;
  final Value<String> targetTable;
  final Value<String> rowId;
  final Value<String> op;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<int> rowid;
  const OutboxRecordsCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.rowId = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxRecordsCompanion.insert({
    required String id,
    required String targetTable,
    required String rowId,
    required String op,
    required String payload,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       targetTable = Value(targetTable),
       rowId = Value(rowId),
       op = Value(op),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<String>? id,
    Expression<String>? targetTable,
    Expression<String>? rowId,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'table_name': targetTable,
      if (rowId != null) 'row_id': rowId,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? targetTable,
    Value<String>? rowId,
    Value<String>? op,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return OutboxRecordsCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      rowId: rowId ?? this.rowId,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (targetTable.present) {
      map['table_name'] = Variable<String>(targetTable.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRecordsCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSettingRecordsTable extends LocalSettingRecords
    with TableInfo<$LocalSettingRecordsTable, LocalSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSettingRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stringValueMeta = const VerificationMeta(
    'stringValue',
  );
  @override
  late final GeneratedColumn<String> stringValue = GeneratedColumn<String>(
    'string_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intValueMeta = const VerificationMeta(
    'intValue',
  );
  @override
  late final GeneratedColumn<int> intValue = GeneratedColumn<int>(
    'int_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, stringValue, intValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('string_value')) {
      context.handle(
        _stringValueMeta,
        stringValue.isAcceptableOrUnknown(
          data['string_value']!,
          _stringValueMeta,
        ),
      );
    }
    if (data.containsKey('int_value')) {
      context.handle(
        _intValueMeta,
        intValue.isAcceptableOrUnknown(data['int_value']!, _intValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  LocalSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      stringValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}string_value'],
      ),
      intValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}int_value'],
      ),
    );
  }

  @override
  $LocalSettingRecordsTable createAlias(String alias) {
    return $LocalSettingRecordsTable(attachedDatabase, alias);
  }
}

class LocalSettingRow extends DataClass implements Insertable<LocalSettingRow> {
  final String key;
  final String? stringValue;
  final int? intValue;
  const LocalSettingRow({required this.key, this.stringValue, this.intValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || stringValue != null) {
      map['string_value'] = Variable<String>(stringValue);
    }
    if (!nullToAbsent || intValue != null) {
      map['int_value'] = Variable<int>(intValue);
    }
    return map;
  }

  LocalSettingRecordsCompanion toCompanion(bool nullToAbsent) {
    return LocalSettingRecordsCompanion(
      key: Value(key),
      stringValue: stringValue == null && nullToAbsent ? const Value.absent() : Value(stringValue),
      intValue: intValue == null && nullToAbsent ? const Value.absent() : Value(intValue),
    );
  }

  factory LocalSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSettingRow(
      key: serializer.fromJson<String>(json['key']),
      stringValue: serializer.fromJson<String?>(json['stringValue']),
      intValue: serializer.fromJson<int?>(json['intValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'stringValue': serializer.toJson<String?>(stringValue),
      'intValue': serializer.toJson<int?>(intValue),
    };
  }

  LocalSettingRow copyWith({
    String? key,
    Value<String?> stringValue = const Value.absent(),
    Value<int?> intValue = const Value.absent(),
  }) => LocalSettingRow(
    key: key ?? this.key,
    stringValue: stringValue.present ? stringValue.value : this.stringValue,
    intValue: intValue.present ? intValue.value : this.intValue,
  );
  LocalSettingRow copyWithCompanion(LocalSettingRecordsCompanion data) {
    return LocalSettingRow(
      key: data.key.present ? data.key.value : this.key,
      stringValue: data.stringValue.present ? data.stringValue.value : this.stringValue,
      intValue: data.intValue.present ? data.intValue.value : this.intValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettingRow(')
          ..write('key: $key, ')
          ..write('stringValue: $stringValue, ')
          ..write('intValue: $intValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, stringValue, intValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSettingRow &&
          other.key == this.key &&
          other.stringValue == this.stringValue &&
          other.intValue == this.intValue);
}

class LocalSettingRecordsCompanion extends UpdateCompanion<LocalSettingRow> {
  final Value<String> key;
  final Value<String?> stringValue;
  final Value<int?> intValue;
  final Value<int> rowid;
  const LocalSettingRecordsCompanion({
    this.key = const Value.absent(),
    this.stringValue = const Value.absent(),
    this.intValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSettingRecordsCompanion.insert({
    required String key,
    this.stringValue = const Value.absent(),
    this.intValue = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<LocalSettingRow> custom({
    Expression<String>? key,
    Expression<String>? stringValue,
    Expression<int>? intValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (stringValue != null) 'string_value': stringValue,
      if (intValue != null) 'int_value': intValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSettingRecordsCompanion copyWith({
    Value<String>? key,
    Value<String?>? stringValue,
    Value<int?>? intValue,
    Value<int>? rowid,
  }) {
    return LocalSettingRecordsCompanion(
      key: key ?? this.key,
      stringValue: stringValue ?? this.stringValue,
      intValue: intValue ?? this.intValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (stringValue.present) {
      map['string_value'] = Variable<String>(stringValue.value);
    }
    if (intValue.present) {
      map['int_value'] = Variable<int>(intValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettingRecordsCompanion(')
          ..write('key: $key, ')
          ..write('stringValue: $stringValue, ')
          ..write('intValue: $intValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorRecordsTable extends SyncCursorRecords
    with TableInfo<$SyncCursorRecordsTable, SyncCursorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastIdMeta = const VerificationMeta('lastId');
  @override
  late final GeneratedColumn<String> lastId = GeneratedColumn<String>(
    'last_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [targetTable, updatedAt, lastId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_name')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['table_name']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('last_id')) {
      context.handle(
        _lastIdMeta,
        lastId.isAcceptableOrUnknown(data['last_id']!, _lastIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {targetTable};
  @override
  SyncCursorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursorRow(
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      lastId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_id'],
      ),
    );
  }

  @override
  $SyncCursorRecordsTable createAlias(String alias) {
    return $SyncCursorRecordsTable(attachedDatabase, alias);
  }
}

class SyncCursorRow extends DataClass implements Insertable<SyncCursorRow> {
  final String targetTable;
  final DateTime? updatedAt;
  final String? lastId;
  const SyncCursorRow({required this.targetTable, this.updatedAt, this.lastId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_name'] = Variable<String>(targetTable);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || lastId != null) {
      map['last_id'] = Variable<String>(lastId);
    }
    return map;
  }

  SyncCursorRecordsCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorRecordsCompanion(
      targetTable: Value(targetTable),
      updatedAt: updatedAt == null && nullToAbsent ? const Value.absent() : Value(updatedAt),
      lastId: lastId == null && nullToAbsent ? const Value.absent() : Value(lastId),
    );
  }

  factory SyncCursorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursorRow(
      targetTable: serializer.fromJson<String>(json['targetTable']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      lastId: serializer.fromJson<String?>(json['lastId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'targetTable': serializer.toJson<String>(targetTable),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'lastId': serializer.toJson<String?>(lastId),
    };
  }

  SyncCursorRow copyWith({
    String? targetTable,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<String?> lastId = const Value.absent(),
  }) => SyncCursorRow(
    targetTable: targetTable ?? this.targetTable,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    lastId: lastId.present ? lastId.value : this.lastId,
  );
  SyncCursorRow copyWithCompanion(SyncCursorRecordsCompanion data) {
    return SyncCursorRow(
      targetTable: data.targetTable.present ? data.targetTable.value : this.targetTable,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastId: data.lastId.present ? data.lastId.value : this.lastId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorRow(')
          ..write('targetTable: $targetTable, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastId: $lastId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(targetTable, updatedAt, lastId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursorRow &&
          other.targetTable == this.targetTable &&
          other.updatedAt == this.updatedAt &&
          other.lastId == this.lastId);
}

class SyncCursorRecordsCompanion extends UpdateCompanion<SyncCursorRow> {
  final Value<String> targetTable;
  final Value<DateTime?> updatedAt;
  final Value<String?> lastId;
  final Value<int> rowid;
  const SyncCursorRecordsCompanion({
    this.targetTable = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorRecordsCompanion.insert({
    required String targetTable,
    this.updatedAt = const Value.absent(),
    this.lastId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : targetTable = Value(targetTable);
  static Insertable<SyncCursorRow> custom({
    Expression<String>? targetTable,
    Expression<DateTime>? updatedAt,
    Expression<String>? lastId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (targetTable != null) 'table_name': targetTable,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastId != null) 'last_id': lastId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorRecordsCompanion copyWith({
    Value<String>? targetTable,
    Value<DateTime?>? updatedAt,
    Value<String?>? lastId,
    Value<int>? rowid,
  }) {
    return SyncCursorRecordsCompanion(
      targetTable: targetTable ?? this.targetTable,
      updatedAt: updatedAt ?? this.updatedAt,
      lastId: lastId ?? this.lastId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (targetTable.present) {
      map['table_name'] = Variable<String>(targetTable.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastId.present) {
      map['last_id'] = Variable<String>(lastId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorRecordsCompanion(')
          ..write('targetTable: $targetTable, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastId: $lastId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $BusinessRecordsTable businessRecords = $BusinessRecordsTable(
    this,
  );
  late final $DeviceRecordsTable deviceRecords = $DeviceRecordsTable(this);
  late final $CustomerRecordsTable customerRecords = $CustomerRecordsTable(
    this,
  );
  late final $ServiceRecordsTable serviceRecords = $ServiceRecordsTable(this);
  late final $OrderRecordsTable orderRecords = $OrderRecordsTable(this);
  late final $OrderItemRecordsTable orderItemRecords = $OrderItemRecordsTable(
    this,
  );
  late final $PaymentRecordsTable paymentRecords = $PaymentRecordsTable(this);
  late final $SavingsRecordsTable savingsRecords = $SavingsRecordsTable(this);
  late final $ExpenseCategoryRecordsTable expenseCategoryRecords = $ExpenseCategoryRecordsTable(
    this,
  );
  late final $ExpenseRecordsTable expenseRecords = $ExpenseRecordsTable(this);
  late final $ReceiptSettingRecordsTable receiptSettingRecords = $ReceiptSettingRecordsTable(this);
  late final $EntitlementRecordsTable entitlementRecords = $EntitlementRecordsTable(this);
  late final $OrderEventRecordsTable orderEventRecords = $OrderEventRecordsTable(this);
  late final $OutboxRecordsTable outboxRecords = $OutboxRecordsTable(this);
  late final $LocalSettingRecordsTable localSettingRecords = $LocalSettingRecordsTable(this);
  late final $SyncCursorRecordsTable syncCursorRecords = $SyncCursorRecordsTable(this);
  late final Index devicesOwnerCode = Index(
    'devices_owner_code',
    'CREATE UNIQUE INDEX devices_owner_code ON devices (owner_id, code)',
  );
  late final Index customersActivePhone = Index(
    'customers_active_phone',
    'CREATE UNIQUE INDEX customers_active_phone ON customers (owner_id, phone_key) WHERE is_active = 1 AND deleted_at IS NULL AND phone_key <> \'\'',
  );
  late final Index customersNamePrefix = Index(
    'customers_name_prefix',
    'CREATE INDEX customers_name_prefix ON customers (owner_id, name_key COLLATE NOCASE)',
  );
  late final Index customersPhonePrefix = Index(
    'customers_phone_prefix',
    'CREATE INDEX customers_phone_prefix ON customers (owner_id, phone_key COLLATE NOCASE)',
  );
  late final Index customersOwnerUpdated = Index(
    'customers_owner_updated',
    'CREATE INDEX customers_owner_updated ON customers (owner_id, updated_at)',
  );
  late final Index ordersOwnerNumber = Index(
    'orders_owner_number',
    'CREATE UNIQUE INDEX orders_owner_number ON orders (owner_id, order_no)',
  );
  late final Index ordersEntered = Index(
    'orders_entered',
    'CREATE INDEX orders_entered ON orders (entered_at)',
  );
  late final Index ordersStatusEntered = Index(
    'orders_status_entered',
    'CREATE INDEX orders_status_entered ON orders (status, entered_at)',
  );
  late final Index ordersOwnerStatus = Index(
    'orders_owner_status',
    'CREATE INDEX orders_owner_status ON orders (owner_id, status)',
  );
  late final Index ordersOwnerEntered = Index(
    'orders_owner_entered',
    'CREATE INDEX orders_owner_entered ON orders (owner_id, entered_at)',
  );
  late final Index itemsOrder = Index(
    'items_order',
    'CREATE INDEX items_order ON order_items (order_id)',
  );
  late final Index paymentsOrder = Index(
    'payments_order',
    'CREATE INDEX payments_order ON payments (order_id)',
  );
  late final Index paymentsPaid = Index(
    'payments_paid',
    'CREATE INDEX payments_paid ON payments (paid_at)',
  );
  late final Index paymentsOwnerPaid = Index(
    'payments_owner_paid',
    'CREATE INDEX payments_owner_paid ON payments (owner_id, paid_at)',
  );
  late final Index savingsOwnerCreated = Index(
    'savings_owner_created',
    'CREATE INDEX savings_owner_created ON savings_entries (owner_id, created_key)',
  );
  late final Index savingsOwnerUpdated = Index(
    'savings_owner_updated',
    'CREATE INDEX savings_owner_updated ON savings_entries (owner_id, updated_at)',
  );
  late final Index savingsCustomerCreated = Index(
    'savings_customer_created',
    'CREATE INDEX savings_customer_created ON savings_entries (customer_id, created_at)',
  );
  late final Index expensesOwnerSpent = Index(
    'expenses_owner_spent',
    'CREATE INDEX expenses_owner_spent ON expenses (owner_id, spent_at)',
  );
  late final Index expensesSpent = Index(
    'expenses_spent',
    'CREATE INDEX expenses_spent ON expenses (spent_at)',
  );
  late final Index eventsOrderTime = Index(
    'events_order_time',
    'CREATE INDEX events_order_time ON order_events (order_id, occurred_at)',
  );
  late final Index outboxCreated = Index(
    'outbox_created',
    'CREATE INDEX outbox_created ON outbox (created_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    businessRecords,
    deviceRecords,
    customerRecords,
    serviceRecords,
    orderRecords,
    orderItemRecords,
    paymentRecords,
    savingsRecords,
    expenseCategoryRecords,
    expenseRecords,
    receiptSettingRecords,
    entitlementRecords,
    orderEventRecords,
    outboxRecords,
    localSettingRecords,
    syncCursorRecords,
    devicesOwnerCode,
    customersActivePhone,
    customersNamePrefix,
    customersPhonePrefix,
    customersOwnerUpdated,
    ordersOwnerNumber,
    ordersEntered,
    ordersStatusEntered,
    ordersOwnerStatus,
    ordersOwnerEntered,
    itemsOrder,
    paymentsOrder,
    paymentsPaid,
    paymentsOwnerPaid,
    savingsOwnerCreated,
    savingsOwnerUpdated,
    savingsCustomerCreated,
    expensesOwnerSpent,
    expensesSpent,
    eventsOrderTime,
    outboxCreated,
  ];
  @override
  DriftDatabaseOptions get options => const DriftDatabaseOptions(storeDateTimeAsText: true);
}
