// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedKelasTable extends CachedKelas
    with TableInfo<$CachedKelasTable, CachedKela> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedKelasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaKelasMeta = const VerificationMeta(
    'namaKelas',
  );
  @override
  late final GeneratedColumn<String> namaKelas = GeneratedColumn<String>(
    'nama_kelas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _guruIdMeta = const VerificationMeta('guruId');
  @override
  late final GeneratedColumn<String> guruId = GeneratedColumn<String>(
    'guru_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<bool> status = GeneratedColumn<bool>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("status" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    namaKelas,
    guruId,
    status,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_kelas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedKela> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama_kelas')) {
      context.handle(
        _namaKelasMeta,
        namaKelas.isAcceptableOrUnknown(data['nama_kelas']!, _namaKelasMeta),
      );
    } else if (isInserting) {
      context.missing(_namaKelasMeta);
    }
    if (data.containsKey('guru_id')) {
      context.handle(
        _guruIdMeta,
        guruId.isAcceptableOrUnknown(data['guru_id']!, _guruIdMeta),
      );
    } else if (isInserting) {
      context.missing(_guruIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
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
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedKela map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedKela(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      namaKelas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_kelas'],
      )!,
      guruId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guru_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CachedKelasTable createAlias(String alias) {
    return $CachedKelasTable(attachedDatabase, alias);
  }
}

class CachedKela extends DataClass implements Insertable<CachedKela> {
  final String id;
  final String namaKelas;
  final String guruId;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedKela({
    required this.id,
    required this.namaKelas,
    required this.guruId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama_kelas'] = Variable<String>(namaKelas);
    map['guru_id'] = Variable<String>(guruId);
    map['status'] = Variable<bool>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedKelasCompanion toCompanion(bool nullToAbsent) {
    return CachedKelasCompanion(
      id: Value(id),
      namaKelas: Value(namaKelas),
      guruId: Value(guruId),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedKela.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedKela(
      id: serializer.fromJson<String>(json['id']),
      namaKelas: serializer.fromJson<String>(json['namaKelas']),
      guruId: serializer.fromJson<String>(json['guruId']),
      status: serializer.fromJson<bool>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'namaKelas': serializer.toJson<String>(namaKelas),
      'guruId': serializer.toJson<String>(guruId),
      'status': serializer.toJson<bool>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedKela copyWith({
    String? id,
    String? namaKelas,
    String? guruId,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedKela(
    id: id ?? this.id,
    namaKelas: namaKelas ?? this.namaKelas,
    guruId: guruId ?? this.guruId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedKela copyWithCompanion(CachedKelasCompanion data) {
    return CachedKela(
      id: data.id.present ? data.id.value : this.id,
      namaKelas: data.namaKelas.present ? data.namaKelas.value : this.namaKelas,
      guruId: data.guruId.present ? data.guruId.value : this.guruId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedKela(')
          ..write('id: $id, ')
          ..write('namaKelas: $namaKelas, ')
          ..write('guruId: $guruId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    namaKelas,
    guruId,
    status,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedKela &&
          other.id == this.id &&
          other.namaKelas == this.namaKelas &&
          other.guruId == this.guruId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedKelasCompanion extends UpdateCompanion<CachedKela> {
  final Value<String> id;
  final Value<String> namaKelas;
  final Value<String> guruId;
  final Value<bool> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedKelasCompanion({
    this.id = const Value.absent(),
    this.namaKelas = const Value.absent(),
    this.guruId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedKelasCompanion.insert({
    required String id,
    required String namaKelas,
    required String guruId,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       namaKelas = Value(namaKelas),
       guruId = Value(guruId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedKela> custom({
    Expression<String>? id,
    Expression<String>? namaKelas,
    Expression<String>? guruId,
    Expression<bool>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (namaKelas != null) 'nama_kelas': namaKelas,
      if (guruId != null) 'guru_id': guruId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedKelasCompanion copyWith({
    Value<String>? id,
    Value<String>? namaKelas,
    Value<String>? guruId,
    Value<bool>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedKelasCompanion(
      id: id ?? this.id,
      namaKelas: namaKelas ?? this.namaKelas,
      guruId: guruId ?? this.guruId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (namaKelas.present) {
      map['nama_kelas'] = Variable<String>(namaKelas.value);
    }
    if (guruId.present) {
      map['guru_id'] = Variable<String>(guruId.value);
    }
    if (status.present) {
      map['status'] = Variable<bool>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedKelasCompanion(')
          ..write('id: $id, ')
          ..write('namaKelas: $namaKelas, ')
          ..write('guruId: $guruId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedMapelTable extends CachedMapel
    with TableInfo<$CachedMapelTable, CachedMapelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedMapelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMapelMeta = const VerificationMeta(
    'namaMapel',
  );
  @override
  late final GeneratedColumn<String> namaMapel = GeneratedColumn<String>(
    'nama_mapel',
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    namaMapel,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_mapel';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMapelData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama_mapel')) {
      context.handle(
        _namaMapelMeta,
        namaMapel.isAcceptableOrUnknown(data['nama_mapel']!, _namaMapelMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMapelMeta);
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
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedMapelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMapelData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      namaMapel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_mapel'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CachedMapelTable createAlias(String alias) {
    return $CachedMapelTable(attachedDatabase, alias);
  }
}

class CachedMapelData extends DataClass implements Insertable<CachedMapelData> {
  final String id;
  final String namaMapel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedMapelData({
    required this.id,
    required this.namaMapel,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama_mapel'] = Variable<String>(namaMapel);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedMapelCompanion toCompanion(bool nullToAbsent) {
    return CachedMapelCompanion(
      id: Value(id),
      namaMapel: Value(namaMapel),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedMapelData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMapelData(
      id: serializer.fromJson<String>(json['id']),
      namaMapel: serializer.fromJson<String>(json['namaMapel']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'namaMapel': serializer.toJson<String>(namaMapel),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedMapelData copyWith({
    String? id,
    String? namaMapel,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedMapelData(
    id: id ?? this.id,
    namaMapel: namaMapel ?? this.namaMapel,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedMapelData copyWithCompanion(CachedMapelCompanion data) {
    return CachedMapelData(
      id: data.id.present ? data.id.value : this.id,
      namaMapel: data.namaMapel.present ? data.namaMapel.value : this.namaMapel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMapelData(')
          ..write('id: $id, ')
          ..write('namaMapel: $namaMapel, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, namaMapel, createdAt, updatedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMapelData &&
          other.id == this.id &&
          other.namaMapel == this.namaMapel &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedMapelCompanion extends UpdateCompanion<CachedMapelData> {
  final Value<String> id;
  final Value<String> namaMapel;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedMapelCompanion({
    this.id = const Value.absent(),
    this.namaMapel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedMapelCompanion.insert({
    required String id,
    required String namaMapel,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       namaMapel = Value(namaMapel),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedMapelData> custom({
    Expression<String>? id,
    Expression<String>? namaMapel,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (namaMapel != null) 'nama_mapel': namaMapel,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedMapelCompanion copyWith({
    Value<String>? id,
    Value<String>? namaMapel,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedMapelCompanion(
      id: id ?? this.id,
      namaMapel: namaMapel ?? this.namaMapel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (namaMapel.present) {
      map['nama_mapel'] = Variable<String>(namaMapel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedMapelCompanion(')
          ..write('id: $id, ')
          ..write('namaMapel: $namaMapel, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedKelasNgajarTable extends CachedKelasNgajar
    with TableInfo<$CachedKelasNgajarTable, CachedKelasNgajarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedKelasNgajarTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idGuruMeta = const VerificationMeta('idGuru');
  @override
  late final GeneratedColumn<String> idGuru = GeneratedColumn<String>(
    'id_guru',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idKelasMeta = const VerificationMeta(
    'idKelas',
  );
  @override
  late final GeneratedColumn<String> idKelas = GeneratedColumn<String>(
    'id_kelas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMapelMeta = const VerificationMeta(
    'idMapel',
  );
  @override
  late final GeneratedColumn<String> idMapel = GeneratedColumn<String>(
    'id_mapel',
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idGuru,
    idKelas,
    idMapel,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_kelas_ngajar';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedKelasNgajarData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_guru')) {
      context.handle(
        _idGuruMeta,
        idGuru.isAcceptableOrUnknown(data['id_guru']!, _idGuruMeta),
      );
    } else if (isInserting) {
      context.missing(_idGuruMeta);
    }
    if (data.containsKey('id_kelas')) {
      context.handle(
        _idKelasMeta,
        idKelas.isAcceptableOrUnknown(data['id_kelas']!, _idKelasMeta),
      );
    } else if (isInserting) {
      context.missing(_idKelasMeta);
    }
    if (data.containsKey('id_mapel')) {
      context.handle(
        _idMapelMeta,
        idMapel.isAcceptableOrUnknown(data['id_mapel']!, _idMapelMeta),
      );
    } else if (isInserting) {
      context.missing(_idMapelMeta);
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
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedKelasNgajarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedKelasNgajarData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idGuru: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_guru'],
      )!,
      idKelas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_kelas'],
      )!,
      idMapel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_mapel'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CachedKelasNgajarTable createAlias(String alias) {
    return $CachedKelasNgajarTable(attachedDatabase, alias);
  }
}

class CachedKelasNgajarData extends DataClass
    implements Insertable<CachedKelasNgajarData> {
  final String id;
  final String idGuru;
  final String idKelas;
  final String idMapel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedKelasNgajarData({
    required this.id,
    required this.idGuru,
    required this.idKelas,
    required this.idMapel,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_guru'] = Variable<String>(idGuru);
    map['id_kelas'] = Variable<String>(idKelas);
    map['id_mapel'] = Variable<String>(idMapel);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedKelasNgajarCompanion toCompanion(bool nullToAbsent) {
    return CachedKelasNgajarCompanion(
      id: Value(id),
      idGuru: Value(idGuru),
      idKelas: Value(idKelas),
      idMapel: Value(idMapel),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedKelasNgajarData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedKelasNgajarData(
      id: serializer.fromJson<String>(json['id']),
      idGuru: serializer.fromJson<String>(json['idGuru']),
      idKelas: serializer.fromJson<String>(json['idKelas']),
      idMapel: serializer.fromJson<String>(json['idMapel']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idGuru': serializer.toJson<String>(idGuru),
      'idKelas': serializer.toJson<String>(idKelas),
      'idMapel': serializer.toJson<String>(idMapel),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedKelasNgajarData copyWith({
    String? id,
    String? idGuru,
    String? idKelas,
    String? idMapel,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedKelasNgajarData(
    id: id ?? this.id,
    idGuru: idGuru ?? this.idGuru,
    idKelas: idKelas ?? this.idKelas,
    idMapel: idMapel ?? this.idMapel,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedKelasNgajarData copyWithCompanion(CachedKelasNgajarCompanion data) {
    return CachedKelasNgajarData(
      id: data.id.present ? data.id.value : this.id,
      idGuru: data.idGuru.present ? data.idGuru.value : this.idGuru,
      idKelas: data.idKelas.present ? data.idKelas.value : this.idKelas,
      idMapel: data.idMapel.present ? data.idMapel.value : this.idMapel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedKelasNgajarData(')
          ..write('id: $id, ')
          ..write('idGuru: $idGuru, ')
          ..write('idKelas: $idKelas, ')
          ..write('idMapel: $idMapel, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idGuru, idKelas, idMapel, createdAt, updatedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedKelasNgajarData &&
          other.id == this.id &&
          other.idGuru == this.idGuru &&
          other.idKelas == this.idKelas &&
          other.idMapel == this.idMapel &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedKelasNgajarCompanion
    extends UpdateCompanion<CachedKelasNgajarData> {
  final Value<String> id;
  final Value<String> idGuru;
  final Value<String> idKelas;
  final Value<String> idMapel;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedKelasNgajarCompanion({
    this.id = const Value.absent(),
    this.idGuru = const Value.absent(),
    this.idKelas = const Value.absent(),
    this.idMapel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedKelasNgajarCompanion.insert({
    required String id,
    required String idGuru,
    required String idKelas,
    required String idMapel,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idGuru = Value(idGuru),
       idKelas = Value(idKelas),
       idMapel = Value(idMapel),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedKelasNgajarData> custom({
    Expression<String>? id,
    Expression<String>? idGuru,
    Expression<String>? idKelas,
    Expression<String>? idMapel,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idGuru != null) 'id_guru': idGuru,
      if (idKelas != null) 'id_kelas': idKelas,
      if (idMapel != null) 'id_mapel': idMapel,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedKelasNgajarCompanion copyWith({
    Value<String>? id,
    Value<String>? idGuru,
    Value<String>? idKelas,
    Value<String>? idMapel,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedKelasNgajarCompanion(
      id: id ?? this.id,
      idGuru: idGuru ?? this.idGuru,
      idKelas: idKelas ?? this.idKelas,
      idMapel: idMapel ?? this.idMapel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idGuru.present) {
      map['id_guru'] = Variable<String>(idGuru.value);
    }
    if (idKelas.present) {
      map['id_kelas'] = Variable<String>(idKelas.value);
    }
    if (idMapel.present) {
      map['id_mapel'] = Variable<String>(idMapel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedKelasNgajarCompanion(')
          ..write('id: $id, ')
          ..write('idGuru: $idGuru, ')
          ..write('idKelas: $idKelas, ')
          ..write('idMapel: $idMapel, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPengumumanTable extends CachedPengumuman
    with TableInfo<$CachedPengumumanTable, CachedPengumumanData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPengumumanTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _judulMeta = const VerificationMeta('judul');
  @override
  late final GeneratedColumn<String> judul = GeneratedColumn<String>(
    'judul',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isiMeta = const VerificationMeta('isi');
  @override
  late final GeneratedColumn<String> isi = GeneratedColumn<String>(
    'isi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipeMeta = const VerificationMeta('tipe');
  @override
  late final GeneratedColumn<String> tipe = GeneratedColumn<String>(
    'tipe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tanggalDibuatMeta = const VerificationMeta(
    'tanggalDibuat',
  );
  @override
  late final GeneratedColumn<DateTime> tanggalDibuat =
      GeneratedColumn<DateTime>(
        'tanggal_dibuat',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    judul,
    isi,
    tipe,
    tanggalDibuat,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_pengumuman';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPengumumanData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('judul')) {
      context.handle(
        _judulMeta,
        judul.isAcceptableOrUnknown(data['judul']!, _judulMeta),
      );
    } else if (isInserting) {
      context.missing(_judulMeta);
    }
    if (data.containsKey('isi')) {
      context.handle(
        _isiMeta,
        isi.isAcceptableOrUnknown(data['isi']!, _isiMeta),
      );
    } else if (isInserting) {
      context.missing(_isiMeta);
    }
    if (data.containsKey('tipe')) {
      context.handle(
        _tipeMeta,
        tipe.isAcceptableOrUnknown(data['tipe']!, _tipeMeta),
      );
    } else if (isInserting) {
      context.missing(_tipeMeta);
    }
    if (data.containsKey('tanggal_dibuat')) {
      context.handle(
        _tanggalDibuatMeta,
        tanggalDibuat.isAcceptableOrUnknown(
          data['tanggal_dibuat']!,
          _tanggalDibuatMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tanggalDibuatMeta);
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
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedPengumumanData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPengumumanData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      judul: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}judul'],
      )!,
      isi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isi'],
      )!,
      tipe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipe'],
      )!,
      tanggalDibuat: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal_dibuat'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CachedPengumumanTable createAlias(String alias) {
    return $CachedPengumumanTable(attachedDatabase, alias);
  }
}

class CachedPengumumanData extends DataClass
    implements Insertable<CachedPengumumanData> {
  final String id;
  final String judul;
  final String isi;
  final String tipe;
  final DateTime tanggalDibuat;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedPengumumanData({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tipe,
    required this.tanggalDibuat,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['judul'] = Variable<String>(judul);
    map['isi'] = Variable<String>(isi);
    map['tipe'] = Variable<String>(tipe);
    map['tanggal_dibuat'] = Variable<DateTime>(tanggalDibuat);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedPengumumanCompanion toCompanion(bool nullToAbsent) {
    return CachedPengumumanCompanion(
      id: Value(id),
      judul: Value(judul),
      isi: Value(isi),
      tipe: Value(tipe),
      tanggalDibuat: Value(tanggalDibuat),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedPengumumanData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPengumumanData(
      id: serializer.fromJson<String>(json['id']),
      judul: serializer.fromJson<String>(json['judul']),
      isi: serializer.fromJson<String>(json['isi']),
      tipe: serializer.fromJson<String>(json['tipe']),
      tanggalDibuat: serializer.fromJson<DateTime>(json['tanggalDibuat']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'judul': serializer.toJson<String>(judul),
      'isi': serializer.toJson<String>(isi),
      'tipe': serializer.toJson<String>(tipe),
      'tanggalDibuat': serializer.toJson<DateTime>(tanggalDibuat),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedPengumumanData copyWith({
    String? id,
    String? judul,
    String? isi,
    String? tipe,
    DateTime? tanggalDibuat,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedPengumumanData(
    id: id ?? this.id,
    judul: judul ?? this.judul,
    isi: isi ?? this.isi,
    tipe: tipe ?? this.tipe,
    tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedPengumumanData copyWithCompanion(CachedPengumumanCompanion data) {
    return CachedPengumumanData(
      id: data.id.present ? data.id.value : this.id,
      judul: data.judul.present ? data.judul.value : this.judul,
      isi: data.isi.present ? data.isi.value : this.isi,
      tipe: data.tipe.present ? data.tipe.value : this.tipe,
      tanggalDibuat: data.tanggalDibuat.present
          ? data.tanggalDibuat.value
          : this.tanggalDibuat,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPengumumanData(')
          ..write('id: $id, ')
          ..write('judul: $judul, ')
          ..write('isi: $isi, ')
          ..write('tipe: $tipe, ')
          ..write('tanggalDibuat: $tanggalDibuat, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    judul,
    isi,
    tipe,
    tanggalDibuat,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPengumumanData &&
          other.id == this.id &&
          other.judul == this.judul &&
          other.isi == this.isi &&
          other.tipe == this.tipe &&
          other.tanggalDibuat == this.tanggalDibuat &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedPengumumanCompanion extends UpdateCompanion<CachedPengumumanData> {
  final Value<String> id;
  final Value<String> judul;
  final Value<String> isi;
  final Value<String> tipe;
  final Value<DateTime> tanggalDibuat;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedPengumumanCompanion({
    this.id = const Value.absent(),
    this.judul = const Value.absent(),
    this.isi = const Value.absent(),
    this.tipe = const Value.absent(),
    this.tanggalDibuat = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPengumumanCompanion.insert({
    required String id,
    required String judul,
    required String isi,
    required String tipe,
    required DateTime tanggalDibuat,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       judul = Value(judul),
       isi = Value(isi),
       tipe = Value(tipe),
       tanggalDibuat = Value(tanggalDibuat),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedPengumumanData> custom({
    Expression<String>? id,
    Expression<String>? judul,
    Expression<String>? isi,
    Expression<String>? tipe,
    Expression<DateTime>? tanggalDibuat,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (judul != null) 'judul': judul,
      if (isi != null) 'isi': isi,
      if (tipe != null) 'tipe': tipe,
      if (tanggalDibuat != null) 'tanggal_dibuat': tanggalDibuat,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPengumumanCompanion copyWith({
    Value<String>? id,
    Value<String>? judul,
    Value<String>? isi,
    Value<String>? tipe,
    Value<DateTime>? tanggalDibuat,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedPengumumanCompanion(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      tipe: tipe ?? this.tipe,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (judul.present) {
      map['judul'] = Variable<String>(judul.value);
    }
    if (isi.present) {
      map['isi'] = Variable<String>(isi.value);
    }
    if (tipe.present) {
      map['tipe'] = Variable<String>(tipe.value);
    }
    if (tanggalDibuat.present) {
      map['tanggal_dibuat'] = Variable<DateTime>(tanggalDibuat.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPengumumanCompanion(')
          ..write('id: $id, ')
          ..write('judul: $judul, ')
          ..write('isi: $isi, ')
          ..write('tipe: $tipe, ')
          ..write('tanggalDibuat: $tanggalDibuat, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedGuruTable extends CachedGuru
    with TableInfo<$CachedGuruTable, CachedGuruData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedGuruTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaLengkapMeta = const VerificationMeta(
    'namaLengkap',
  );
  @override
  late final GeneratedColumn<String> namaLengkap = GeneratedColumn<String>(
    'nama_lengkap',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nigMeta = const VerificationMeta('nig');
  @override
  late final GeneratedColumn<int> nig = GeneratedColumn<int>(
    'nig',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    namaLengkap,
    email,
    nig,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_guru';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedGuruData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama_lengkap')) {
      context.handle(
        _namaLengkapMeta,
        namaLengkap.isAcceptableOrUnknown(
          data['nama_lengkap']!,
          _namaLengkapMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_namaLengkapMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('nig')) {
      context.handle(
        _nigMeta,
        nig.isAcceptableOrUnknown(data['nig']!, _nigMeta),
      );
    } else if (isInserting) {
      context.missing(_nigMeta);
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
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedGuruData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedGuruData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      namaLengkap: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_lengkap'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      nig: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nig'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CachedGuruTable createAlias(String alias) {
    return $CachedGuruTable(attachedDatabase, alias);
  }
}

class CachedGuruData extends DataClass implements Insertable<CachedGuruData> {
  final String id;
  final String namaLengkap;
  final String email;
  final int nig;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedGuruData({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.nig,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama_lengkap'] = Variable<String>(namaLengkap);
    map['email'] = Variable<String>(email);
    map['nig'] = Variable<int>(nig);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedGuruCompanion toCompanion(bool nullToAbsent) {
    return CachedGuruCompanion(
      id: Value(id),
      namaLengkap: Value(namaLengkap),
      email: Value(email),
      nig: Value(nig),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedGuruData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedGuruData(
      id: serializer.fromJson<String>(json['id']),
      namaLengkap: serializer.fromJson<String>(json['namaLengkap']),
      email: serializer.fromJson<String>(json['email']),
      nig: serializer.fromJson<int>(json['nig']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'namaLengkap': serializer.toJson<String>(namaLengkap),
      'email': serializer.toJson<String>(email),
      'nig': serializer.toJson<int>(nig),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedGuruData copyWith({
    String? id,
    String? namaLengkap,
    String? email,
    int? nig,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedGuruData(
    id: id ?? this.id,
    namaLengkap: namaLengkap ?? this.namaLengkap,
    email: email ?? this.email,
    nig: nig ?? this.nig,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedGuruData copyWithCompanion(CachedGuruCompanion data) {
    return CachedGuruData(
      id: data.id.present ? data.id.value : this.id,
      namaLengkap: data.namaLengkap.present
          ? data.namaLengkap.value
          : this.namaLengkap,
      email: data.email.present ? data.email.value : this.email,
      nig: data.nig.present ? data.nig.value : this.nig,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedGuruData(')
          ..write('id: $id, ')
          ..write('namaLengkap: $namaLengkap, ')
          ..write('email: $email, ')
          ..write('nig: $nig, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, namaLengkap, email, nig, createdAt, updatedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedGuruData &&
          other.id == this.id &&
          other.namaLengkap == this.namaLengkap &&
          other.email == this.email &&
          other.nig == this.nig &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedGuruCompanion extends UpdateCompanion<CachedGuruData> {
  final Value<String> id;
  final Value<String> namaLengkap;
  final Value<String> email;
  final Value<int> nig;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedGuruCompanion({
    this.id = const Value.absent(),
    this.namaLengkap = const Value.absent(),
    this.email = const Value.absent(),
    this.nig = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedGuruCompanion.insert({
    required String id,
    required String namaLengkap,
    required String email,
    required int nig,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       namaLengkap = Value(namaLengkap),
       email = Value(email),
       nig = Value(nig),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedGuruData> custom({
    Expression<String>? id,
    Expression<String>? namaLengkap,
    Expression<String>? email,
    Expression<int>? nig,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (namaLengkap != null) 'nama_lengkap': namaLengkap,
      if (email != null) 'email': email,
      if (nig != null) 'nig': nig,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedGuruCompanion copyWith({
    Value<String>? id,
    Value<String>? namaLengkap,
    Value<String>? email,
    Value<int>? nig,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedGuruCompanion(
      id: id ?? this.id,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      email: email ?? this.email,
      nig: nig ?? this.nig,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (namaLengkap.present) {
      map['nama_lengkap'] = Variable<String>(namaLengkap.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (nig.present) {
      map['nig'] = Variable<int>(nig.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedGuruCompanion(')
          ..write('id: $id, ')
          ..write('namaLengkap: $namaLengkap, ')
          ..write('email: $email, ')
          ..write('nig: $nig, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedSiswaTable extends CachedSiswa
    with TableInfo<$CachedSiswaTable, CachedSiswaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSiswaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nisMeta = const VerificationMeta('nis');
  @override
  late final GeneratedColumn<String> nis = GeneratedColumn<String>(
    'nis',
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    email,
    nis,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_siswa';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSiswaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('nis')) {
      context.handle(
        _nisMeta,
        nis.isAcceptableOrUnknown(data['nis']!, _nisMeta),
      );
    } else if (isInserting) {
      context.missing(_nisMeta);
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
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedSiswaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSiswaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      nis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nis'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CachedSiswaTable createAlias(String alias) {
    return $CachedSiswaTable(attachedDatabase, alias);
  }
}

class CachedSiswaData extends DataClass implements Insertable<CachedSiswaData> {
  final String id;
  final String nama;
  final String email;
  final String nis;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedSiswaData({
    required this.id,
    required this.nama,
    required this.email,
    required this.nis,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    map['email'] = Variable<String>(email);
    map['nis'] = Variable<String>(nis);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedSiswaCompanion toCompanion(bool nullToAbsent) {
    return CachedSiswaCompanion(
      id: Value(id),
      nama: Value(nama),
      email: Value(email),
      nis: Value(nis),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedSiswaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSiswaData(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      email: serializer.fromJson<String>(json['email']),
      nis: serializer.fromJson<String>(json['nis']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'email': serializer.toJson<String>(email),
      'nis': serializer.toJson<String>(nis),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedSiswaData copyWith({
    String? id,
    String? nama,
    String? email,
    String? nis,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedSiswaData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    email: email ?? this.email,
    nis: nis ?? this.nis,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedSiswaData copyWithCompanion(CachedSiswaCompanion data) {
    return CachedSiswaData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      email: data.email.present ? data.email.value : this.email,
      nis: data.nis.present ? data.nis.value : this.nis,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSiswaData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('email: $email, ')
          ..write('nis: $nis, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nama, email, nis, createdAt, updatedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSiswaData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.email == this.email &&
          other.nis == this.nis &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedSiswaCompanion extends UpdateCompanion<CachedSiswaData> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String> email;
  final Value<String> nis;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedSiswaCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.email = const Value.absent(),
    this.nis = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSiswaCompanion.insert({
    required String id,
    required String nama,
    required String email,
    required String nis,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama),
       email = Value(email),
       nis = Value(nis),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedSiswaData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? email,
    Expression<String>? nis,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (email != null) 'email': email,
      if (nis != null) 'nis': nis,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSiswaCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<String>? email,
    Value<String>? nis,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedSiswaCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      nis: nis ?? this.nis,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (nis.present) {
      map['nis'] = Variable<String>(nis.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSiswaCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('email: $email, ')
          ..write('nis: $nis, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedSiswaKelasTable extends CachedSiswaKelas
    with TableInfo<$CachedSiswaKelasTable, CachedSiswaKela> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSiswaKelasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siswaIdMeta = const VerificationMeta(
    'siswaId',
  );
  @override
  late final GeneratedColumn<String> siswaId = GeneratedColumn<String>(
    'siswa_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kelasIdMeta = const VerificationMeta(
    'kelasId',
  );
  @override
  late final GeneratedColumn<String> kelasId = GeneratedColumn<String>(
    'kelas_id',
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    siswaId,
    kelasId,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_siswa_kelas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSiswaKela> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('siswa_id')) {
      context.handle(
        _siswaIdMeta,
        siswaId.isAcceptableOrUnknown(data['siswa_id']!, _siswaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siswaIdMeta);
    }
    if (data.containsKey('kelas_id')) {
      context.handle(
        _kelasIdMeta,
        kelasId.isAcceptableOrUnknown(data['kelas_id']!, _kelasIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kelasIdMeta);
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
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedSiswaKela map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSiswaKela(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      siswaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}siswa_id'],
      )!,
      kelasId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kelas_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CachedSiswaKelasTable createAlias(String alias) {
    return $CachedSiswaKelasTable(attachedDatabase, alias);
  }
}

class CachedSiswaKela extends DataClass implements Insertable<CachedSiswaKela> {
  final String id;
  final String siswaId;
  final String kelasId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedSiswaKela({
    required this.id,
    required this.siswaId,
    required this.kelasId,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['siswa_id'] = Variable<String>(siswaId);
    map['kelas_id'] = Variable<String>(kelasId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedSiswaKelasCompanion toCompanion(bool nullToAbsent) {
    return CachedSiswaKelasCompanion(
      id: Value(id),
      siswaId: Value(siswaId),
      kelasId: Value(kelasId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedSiswaKela.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSiswaKela(
      id: serializer.fromJson<String>(json['id']),
      siswaId: serializer.fromJson<String>(json['siswaId']),
      kelasId: serializer.fromJson<String>(json['kelasId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'siswaId': serializer.toJson<String>(siswaId),
      'kelasId': serializer.toJson<String>(kelasId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedSiswaKela copyWith({
    String? id,
    String? siswaId,
    String? kelasId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedSiswaKela(
    id: id ?? this.id,
    siswaId: siswaId ?? this.siswaId,
    kelasId: kelasId ?? this.kelasId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedSiswaKela copyWithCompanion(CachedSiswaKelasCompanion data) {
    return CachedSiswaKela(
      id: data.id.present ? data.id.value : this.id,
      siswaId: data.siswaId.present ? data.siswaId.value : this.siswaId,
      kelasId: data.kelasId.present ? data.kelasId.value : this.kelasId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSiswaKela(')
          ..write('id: $id, ')
          ..write('siswaId: $siswaId, ')
          ..write('kelasId: $kelasId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, siswaId, kelasId, createdAt, updatedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSiswaKela &&
          other.id == this.id &&
          other.siswaId == this.siswaId &&
          other.kelasId == this.kelasId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedSiswaKelasCompanion extends UpdateCompanion<CachedSiswaKela> {
  final Value<String> id;
  final Value<String> siswaId;
  final Value<String> kelasId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedSiswaKelasCompanion({
    this.id = const Value.absent(),
    this.siswaId = const Value.absent(),
    this.kelasId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSiswaKelasCompanion.insert({
    required String id,
    required String siswaId,
    required String kelasId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       siswaId = Value(siswaId),
       kelasId = Value(kelasId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedSiswaKela> custom({
    Expression<String>? id,
    Expression<String>? siswaId,
    Expression<String>? kelasId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siswaId != null) 'siswa_id': siswaId,
      if (kelasId != null) 'kelas_id': kelasId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSiswaKelasCompanion copyWith({
    Value<String>? id,
    Value<String>? siswaId,
    Value<String>? kelasId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedSiswaKelasCompanion(
      id: id ?? this.id,
      siswaId: siswaId ?? this.siswaId,
      kelasId: kelasId ?? this.kelasId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (siswaId.present) {
      map['siswa_id'] = Variable<String>(siswaId.value);
    }
    if (kelasId.present) {
      map['kelas_id'] = Variable<String>(kelasId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSiswaKelasCompanion(')
          ..write('id: $id, ')
          ..write('siswaId: $siswaId, ')
          ..write('kelasId: $kelasId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tableNameMeta = const VerificationMeta(
    'tableName',
  );
  @override
  late final GeneratedColumn<String> tableName = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableName,
    recordId,
    operation,
    data,
    createdAt,
    synced,
    syncedAt,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _tableNameMeta,
        tableName.isAcceptableOrUnknown(data['table_name']!, _tableNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tableNameMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tableName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String tableName;
  final String recordId;
  final String operation;
  final String? data;
  final DateTime createdAt;
  final bool synced;
  final DateTime? syncedAt;
  final String? errorMessage;
  const SyncQueueData({
    required this.id,
    required this.tableName,
    required this.recordId,
    required this.operation,
    this.data,
    required this.createdAt,
    required this.synced,
    this.syncedAt,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_name'] = Variable<String>(tableName);
    map['record_id'] = Variable<String>(recordId);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      tableName: Value(tableName),
      recordId: Value(recordId),
      operation: Value(operation),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      createdAt: Value(createdAt),
      synced: Value(synced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      tableName: serializer.fromJson<String>(json['tableName']),
      recordId: serializer.fromJson<String>(json['recordId']),
      operation: serializer.fromJson<String>(json['operation']),
      data: serializer.fromJson<String?>(json['data']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tableName': serializer.toJson<String>(tableName),
      'recordId': serializer.toJson<String>(recordId),
      'operation': serializer.toJson<String>(operation),
      'data': serializer.toJson<String?>(data),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'synced': serializer.toJson<bool>(synced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? tableName,
    String? recordId,
    String? operation,
    Value<String?> data = const Value.absent(),
    DateTime? createdAt,
    bool? synced,
    Value<DateTime?> syncedAt = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    tableName: tableName ?? this.tableName,
    recordId: recordId ?? this.recordId,
    operation: operation ?? this.operation,
    data: data.present ? data.value : this.data,
    createdAt: createdAt ?? this.createdAt,
    synced: synced ?? this.synced,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      tableName: data.tableName.present ? data.tableName.value : this.tableName,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      operation: data.operation.present ? data.operation.value : this.operation,
      data: data.data.present ? data.data.value : this.data,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('tableName: $tableName, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tableName,
    recordId,
    operation,
    data,
    createdAt,
    synced,
    syncedAt,
    errorMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.tableName == this.tableName &&
          other.recordId == this.recordId &&
          other.operation == this.operation &&
          other.data == this.data &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced &&
          other.syncedAt == this.syncedAt &&
          other.errorMessage == this.errorMessage);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> tableName;
  final Value<String> recordId;
  final Value<String> operation;
  final Value<String?> data;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  final Value<DateTime?> syncedAt;
  final Value<String?> errorMessage;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.tableName = const Value.absent(),
    this.recordId = const Value.absent(),
    this.operation = const Value.absent(),
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String tableName,
    required String recordId,
    required String operation,
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
  }) : tableName = Value(tableName),
       recordId = Value(recordId),
       operation = Value(operation);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? tableName,
    Expression<String>? recordId,
    Expression<String>? operation,
    Expression<String>? data,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
    Expression<DateTime>? syncedAt,
    Expression<String>? errorMessage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableName != null) 'table_name': tableName,
      if (recordId != null) 'record_id': recordId,
      if (operation != null) 'operation': operation,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (errorMessage != null) 'error_message': errorMessage,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? tableName,
    Value<String>? recordId,
    Value<String>? operation,
    Value<String?>? data,
    Value<DateTime>? createdAt,
    Value<bool>? synced,
    Value<DateTime?>? syncedAt,
    Value<String?>? errorMessage,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      syncedAt: syncedAt ?? this.syncedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tableName.present) {
      map['table_name'] = Variable<String>(tableName.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('tableName: $tableName, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedKelasTable cachedKelas = $CachedKelasTable(this);
  late final $CachedMapelTable cachedMapel = $CachedMapelTable(this);
  late final $CachedKelasNgajarTable cachedKelasNgajar =
      $CachedKelasNgajarTable(this);
  late final $CachedPengumumanTable cachedPengumuman = $CachedPengumumanTable(
    this,
  );
  late final $CachedGuruTable cachedGuru = $CachedGuruTable(this);
  late final $CachedSiswaTable cachedSiswa = $CachedSiswaTable(this);
  late final $CachedSiswaKelasTable cachedSiswaKelas = $CachedSiswaKelasTable(
    this,
  );
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedKelas,
    cachedMapel,
    cachedKelasNgajar,
    cachedPengumuman,
    cachedGuru,
    cachedSiswa,
    cachedSiswaKelas,
    syncQueue,
  ];
}

typedef $$CachedKelasTableCreateCompanionBuilder =
    CachedKelasCompanion Function({
      required String id,
      required String namaKelas,
      required String guruId,
      Value<bool> status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedKelasTableUpdateCompanionBuilder =
    CachedKelasCompanion Function({
      Value<String> id,
      Value<String> namaKelas,
      Value<String> guruId,
      Value<bool> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedKelasTableFilterComposer
    extends Composer<_$AppDatabase, $CachedKelasTable> {
  $$CachedKelasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaKelas => $composableBuilder(
    column: $table.namaKelas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guruId => $composableBuilder(
    column: $table.guruId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedKelasTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedKelasTable> {
  $$CachedKelasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaKelas => $composableBuilder(
    column: $table.namaKelas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guruId => $composableBuilder(
    column: $table.guruId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedKelasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedKelasTable> {
  $$CachedKelasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namaKelas =>
      $composableBuilder(column: $table.namaKelas, builder: (column) => column);

  GeneratedColumn<String> get guruId =>
      $composableBuilder(column: $table.guruId, builder: (column) => column);

  GeneratedColumn<bool> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedKelasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedKelasTable,
          CachedKela,
          $$CachedKelasTableFilterComposer,
          $$CachedKelasTableOrderingComposer,
          $$CachedKelasTableAnnotationComposer,
          $$CachedKelasTableCreateCompanionBuilder,
          $$CachedKelasTableUpdateCompanionBuilder,
          (
            CachedKela,
            BaseReferences<_$AppDatabase, $CachedKelasTable, CachedKela>,
          ),
          CachedKela,
          PrefetchHooks Function()
        > {
  $$CachedKelasTableTableManager(_$AppDatabase db, $CachedKelasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedKelasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedKelasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedKelasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> namaKelas = const Value.absent(),
                Value<String> guruId = const Value.absent(),
                Value<bool> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedKelasCompanion(
                id: id,
                namaKelas: namaKelas,
                guruId: guruId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String namaKelas,
                required String guruId,
                Value<bool> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedKelasCompanion.insert(
                id: id,
                namaKelas: namaKelas,
                guruId: guruId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedKelasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedKelasTable,
      CachedKela,
      $$CachedKelasTableFilterComposer,
      $$CachedKelasTableOrderingComposer,
      $$CachedKelasTableAnnotationComposer,
      $$CachedKelasTableCreateCompanionBuilder,
      $$CachedKelasTableUpdateCompanionBuilder,
      (
        CachedKela,
        BaseReferences<_$AppDatabase, $CachedKelasTable, CachedKela>,
      ),
      CachedKela,
      PrefetchHooks Function()
    >;
typedef $$CachedMapelTableCreateCompanionBuilder =
    CachedMapelCompanion Function({
      required String id,
      required String namaMapel,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedMapelTableUpdateCompanionBuilder =
    CachedMapelCompanion Function({
      Value<String> id,
      Value<String> namaMapel,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedMapelTableFilterComposer
    extends Composer<_$AppDatabase, $CachedMapelTable> {
  $$CachedMapelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaMapel => $composableBuilder(
    column: $table.namaMapel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedMapelTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedMapelTable> {
  $$CachedMapelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaMapel => $composableBuilder(
    column: $table.namaMapel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedMapelTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedMapelTable> {
  $$CachedMapelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namaMapel =>
      $composableBuilder(column: $table.namaMapel, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedMapelTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedMapelTable,
          CachedMapelData,
          $$CachedMapelTableFilterComposer,
          $$CachedMapelTableOrderingComposer,
          $$CachedMapelTableAnnotationComposer,
          $$CachedMapelTableCreateCompanionBuilder,
          $$CachedMapelTableUpdateCompanionBuilder,
          (
            CachedMapelData,
            BaseReferences<_$AppDatabase, $CachedMapelTable, CachedMapelData>,
          ),
          CachedMapelData,
          PrefetchHooks Function()
        > {
  $$CachedMapelTableTableManager(_$AppDatabase db, $CachedMapelTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedMapelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedMapelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedMapelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> namaMapel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMapelCompanion(
                id: id,
                namaMapel: namaMapel,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String namaMapel,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMapelCompanion.insert(
                id: id,
                namaMapel: namaMapel,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedMapelTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedMapelTable,
      CachedMapelData,
      $$CachedMapelTableFilterComposer,
      $$CachedMapelTableOrderingComposer,
      $$CachedMapelTableAnnotationComposer,
      $$CachedMapelTableCreateCompanionBuilder,
      $$CachedMapelTableUpdateCompanionBuilder,
      (
        CachedMapelData,
        BaseReferences<_$AppDatabase, $CachedMapelTable, CachedMapelData>,
      ),
      CachedMapelData,
      PrefetchHooks Function()
    >;
typedef $$CachedKelasNgajarTableCreateCompanionBuilder =
    CachedKelasNgajarCompanion Function({
      required String id,
      required String idGuru,
      required String idKelas,
      required String idMapel,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedKelasNgajarTableUpdateCompanionBuilder =
    CachedKelasNgajarCompanion Function({
      Value<String> id,
      Value<String> idGuru,
      Value<String> idKelas,
      Value<String> idMapel,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedKelasNgajarTableFilterComposer
    extends Composer<_$AppDatabase, $CachedKelasNgajarTable> {
  $$CachedKelasNgajarTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idGuru => $composableBuilder(
    column: $table.idGuru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idKelas => $composableBuilder(
    column: $table.idKelas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idMapel => $composableBuilder(
    column: $table.idMapel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedKelasNgajarTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedKelasNgajarTable> {
  $$CachedKelasNgajarTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idGuru => $composableBuilder(
    column: $table.idGuru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idKelas => $composableBuilder(
    column: $table.idKelas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idMapel => $composableBuilder(
    column: $table.idMapel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedKelasNgajarTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedKelasNgajarTable> {
  $$CachedKelasNgajarTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idGuru =>
      $composableBuilder(column: $table.idGuru, builder: (column) => column);

  GeneratedColumn<String> get idKelas =>
      $composableBuilder(column: $table.idKelas, builder: (column) => column);

  GeneratedColumn<String> get idMapel =>
      $composableBuilder(column: $table.idMapel, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedKelasNgajarTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedKelasNgajarTable,
          CachedKelasNgajarData,
          $$CachedKelasNgajarTableFilterComposer,
          $$CachedKelasNgajarTableOrderingComposer,
          $$CachedKelasNgajarTableAnnotationComposer,
          $$CachedKelasNgajarTableCreateCompanionBuilder,
          $$CachedKelasNgajarTableUpdateCompanionBuilder,
          (
            CachedKelasNgajarData,
            BaseReferences<
              _$AppDatabase,
              $CachedKelasNgajarTable,
              CachedKelasNgajarData
            >,
          ),
          CachedKelasNgajarData,
          PrefetchHooks Function()
        > {
  $$CachedKelasNgajarTableTableManager(
    _$AppDatabase db,
    $CachedKelasNgajarTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedKelasNgajarTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedKelasNgajarTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedKelasNgajarTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idGuru = const Value.absent(),
                Value<String> idKelas = const Value.absent(),
                Value<String> idMapel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedKelasNgajarCompanion(
                id: id,
                idGuru: idGuru,
                idKelas: idKelas,
                idMapel: idMapel,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idGuru,
                required String idKelas,
                required String idMapel,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedKelasNgajarCompanion.insert(
                id: id,
                idGuru: idGuru,
                idKelas: idKelas,
                idMapel: idMapel,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedKelasNgajarTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedKelasNgajarTable,
      CachedKelasNgajarData,
      $$CachedKelasNgajarTableFilterComposer,
      $$CachedKelasNgajarTableOrderingComposer,
      $$CachedKelasNgajarTableAnnotationComposer,
      $$CachedKelasNgajarTableCreateCompanionBuilder,
      $$CachedKelasNgajarTableUpdateCompanionBuilder,
      (
        CachedKelasNgajarData,
        BaseReferences<
          _$AppDatabase,
          $CachedKelasNgajarTable,
          CachedKelasNgajarData
        >,
      ),
      CachedKelasNgajarData,
      PrefetchHooks Function()
    >;
typedef $$CachedPengumumanTableCreateCompanionBuilder =
    CachedPengumumanCompanion Function({
      required String id,
      required String judul,
      required String isi,
      required String tipe,
      required DateTime tanggalDibuat,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedPengumumanTableUpdateCompanionBuilder =
    CachedPengumumanCompanion Function({
      Value<String> id,
      Value<String> judul,
      Value<String> isi,
      Value<String> tipe,
      Value<DateTime> tanggalDibuat,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedPengumumanTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPengumumanTable> {
  $$CachedPengumumanTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isi => $composableBuilder(
    column: $table.isi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipe => $composableBuilder(
    column: $table.tipe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggalDibuat => $composableBuilder(
    column: $table.tanggalDibuat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedPengumumanTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPengumumanTable> {
  $$CachedPengumumanTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isi => $composableBuilder(
    column: $table.isi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipe => $composableBuilder(
    column: $table.tipe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggalDibuat => $composableBuilder(
    column: $table.tanggalDibuat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedPengumumanTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPengumumanTable> {
  $$CachedPengumumanTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get judul =>
      $composableBuilder(column: $table.judul, builder: (column) => column);

  GeneratedColumn<String> get isi =>
      $composableBuilder(column: $table.isi, builder: (column) => column);

  GeneratedColumn<String> get tipe =>
      $composableBuilder(column: $table.tipe, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggalDibuat => $composableBuilder(
    column: $table.tanggalDibuat,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedPengumumanTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedPengumumanTable,
          CachedPengumumanData,
          $$CachedPengumumanTableFilterComposer,
          $$CachedPengumumanTableOrderingComposer,
          $$CachedPengumumanTableAnnotationComposer,
          $$CachedPengumumanTableCreateCompanionBuilder,
          $$CachedPengumumanTableUpdateCompanionBuilder,
          (
            CachedPengumumanData,
            BaseReferences<
              _$AppDatabase,
              $CachedPengumumanTable,
              CachedPengumumanData
            >,
          ),
          CachedPengumumanData,
          PrefetchHooks Function()
        > {
  $$CachedPengumumanTableTableManager(
    _$AppDatabase db,
    $CachedPengumumanTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPengumumanTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPengumumanTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPengumumanTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> judul = const Value.absent(),
                Value<String> isi = const Value.absent(),
                Value<String> tipe = const Value.absent(),
                Value<DateTime> tanggalDibuat = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPengumumanCompanion(
                id: id,
                judul: judul,
                isi: isi,
                tipe: tipe,
                tanggalDibuat: tanggalDibuat,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String judul,
                required String isi,
                required String tipe,
                required DateTime tanggalDibuat,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPengumumanCompanion.insert(
                id: id,
                judul: judul,
                isi: isi,
                tipe: tipe,
                tanggalDibuat: tanggalDibuat,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedPengumumanTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedPengumumanTable,
      CachedPengumumanData,
      $$CachedPengumumanTableFilterComposer,
      $$CachedPengumumanTableOrderingComposer,
      $$CachedPengumumanTableAnnotationComposer,
      $$CachedPengumumanTableCreateCompanionBuilder,
      $$CachedPengumumanTableUpdateCompanionBuilder,
      (
        CachedPengumumanData,
        BaseReferences<
          _$AppDatabase,
          $CachedPengumumanTable,
          CachedPengumumanData
        >,
      ),
      CachedPengumumanData,
      PrefetchHooks Function()
    >;
typedef $$CachedGuruTableCreateCompanionBuilder =
    CachedGuruCompanion Function({
      required String id,
      required String namaLengkap,
      required String email,
      required int nig,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedGuruTableUpdateCompanionBuilder =
    CachedGuruCompanion Function({
      Value<String> id,
      Value<String> namaLengkap,
      Value<String> email,
      Value<int> nig,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedGuruTableFilterComposer
    extends Composer<_$AppDatabase, $CachedGuruTable> {
  $$CachedGuruTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaLengkap => $composableBuilder(
    column: $table.namaLengkap,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nig => $composableBuilder(
    column: $table.nig,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedGuruTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedGuruTable> {
  $$CachedGuruTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaLengkap => $composableBuilder(
    column: $table.namaLengkap,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nig => $composableBuilder(
    column: $table.nig,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedGuruTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedGuruTable> {
  $$CachedGuruTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namaLengkap => $composableBuilder(
    column: $table.namaLengkap,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get nig =>
      $composableBuilder(column: $table.nig, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedGuruTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedGuruTable,
          CachedGuruData,
          $$CachedGuruTableFilterComposer,
          $$CachedGuruTableOrderingComposer,
          $$CachedGuruTableAnnotationComposer,
          $$CachedGuruTableCreateCompanionBuilder,
          $$CachedGuruTableUpdateCompanionBuilder,
          (
            CachedGuruData,
            BaseReferences<_$AppDatabase, $CachedGuruTable, CachedGuruData>,
          ),
          CachedGuruData,
          PrefetchHooks Function()
        > {
  $$CachedGuruTableTableManager(_$AppDatabase db, $CachedGuruTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedGuruTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedGuruTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedGuruTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> namaLengkap = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<int> nig = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedGuruCompanion(
                id: id,
                namaLengkap: namaLengkap,
                email: email,
                nig: nig,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String namaLengkap,
                required String email,
                required int nig,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedGuruCompanion.insert(
                id: id,
                namaLengkap: namaLengkap,
                email: email,
                nig: nig,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedGuruTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedGuruTable,
      CachedGuruData,
      $$CachedGuruTableFilterComposer,
      $$CachedGuruTableOrderingComposer,
      $$CachedGuruTableAnnotationComposer,
      $$CachedGuruTableCreateCompanionBuilder,
      $$CachedGuruTableUpdateCompanionBuilder,
      (
        CachedGuruData,
        BaseReferences<_$AppDatabase, $CachedGuruTable, CachedGuruData>,
      ),
      CachedGuruData,
      PrefetchHooks Function()
    >;
typedef $$CachedSiswaTableCreateCompanionBuilder =
    CachedSiswaCompanion Function({
      required String id,
      required String nama,
      required String email,
      required String nis,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedSiswaTableUpdateCompanionBuilder =
    CachedSiswaCompanion Function({
      Value<String> id,
      Value<String> nama,
      Value<String> email,
      Value<String> nis,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedSiswaTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSiswaTable> {
  $$CachedSiswaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nis => $composableBuilder(
    column: $table.nis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSiswaTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSiswaTable> {
  $$CachedSiswaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nis => $composableBuilder(
    column: $table.nis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSiswaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSiswaTable> {
  $$CachedSiswaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get nis =>
      $composableBuilder(column: $table.nis, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedSiswaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedSiswaTable,
          CachedSiswaData,
          $$CachedSiswaTableFilterComposer,
          $$CachedSiswaTableOrderingComposer,
          $$CachedSiswaTableAnnotationComposer,
          $$CachedSiswaTableCreateCompanionBuilder,
          $$CachedSiswaTableUpdateCompanionBuilder,
          (
            CachedSiswaData,
            BaseReferences<_$AppDatabase, $CachedSiswaTable, CachedSiswaData>,
          ),
          CachedSiswaData,
          PrefetchHooks Function()
        > {
  $$CachedSiswaTableTableManager(_$AppDatabase db, $CachedSiswaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSiswaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSiswaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSiswaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> nis = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSiswaCompanion(
                id: id,
                nama: nama,
                email: email,
                nis: nis,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                required String email,
                required String nis,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSiswaCompanion.insert(
                id: id,
                nama: nama,
                email: email,
                nis: nis,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSiswaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedSiswaTable,
      CachedSiswaData,
      $$CachedSiswaTableFilterComposer,
      $$CachedSiswaTableOrderingComposer,
      $$CachedSiswaTableAnnotationComposer,
      $$CachedSiswaTableCreateCompanionBuilder,
      $$CachedSiswaTableUpdateCompanionBuilder,
      (
        CachedSiswaData,
        BaseReferences<_$AppDatabase, $CachedSiswaTable, CachedSiswaData>,
      ),
      CachedSiswaData,
      PrefetchHooks Function()
    >;
typedef $$CachedSiswaKelasTableCreateCompanionBuilder =
    CachedSiswaKelasCompanion Function({
      required String id,
      required String siswaId,
      required String kelasId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedSiswaKelasTableUpdateCompanionBuilder =
    CachedSiswaKelasCompanion Function({
      Value<String> id,
      Value<String> siswaId,
      Value<String> kelasId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedSiswaKelasTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSiswaKelasTable> {
  $$CachedSiswaKelasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siswaId => $composableBuilder(
    column: $table.siswaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kelasId => $composableBuilder(
    column: $table.kelasId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSiswaKelasTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSiswaKelasTable> {
  $$CachedSiswaKelasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siswaId => $composableBuilder(
    column: $table.siswaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kelasId => $composableBuilder(
    column: $table.kelasId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSiswaKelasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSiswaKelasTable> {
  $$CachedSiswaKelasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get siswaId =>
      $composableBuilder(column: $table.siswaId, builder: (column) => column);

  GeneratedColumn<String> get kelasId =>
      $composableBuilder(column: $table.kelasId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedSiswaKelasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedSiswaKelasTable,
          CachedSiswaKela,
          $$CachedSiswaKelasTableFilterComposer,
          $$CachedSiswaKelasTableOrderingComposer,
          $$CachedSiswaKelasTableAnnotationComposer,
          $$CachedSiswaKelasTableCreateCompanionBuilder,
          $$CachedSiswaKelasTableUpdateCompanionBuilder,
          (
            CachedSiswaKela,
            BaseReferences<
              _$AppDatabase,
              $CachedSiswaKelasTable,
              CachedSiswaKela
            >,
          ),
          CachedSiswaKela,
          PrefetchHooks Function()
        > {
  $$CachedSiswaKelasTableTableManager(
    _$AppDatabase db,
    $CachedSiswaKelasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSiswaKelasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSiswaKelasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSiswaKelasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> siswaId = const Value.absent(),
                Value<String> kelasId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSiswaKelasCompanion(
                id: id,
                siswaId: siswaId,
                kelasId: kelasId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String siswaId,
                required String kelasId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSiswaKelasCompanion.insert(
                id: id,
                siswaId: siswaId,
                kelasId: kelasId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSiswaKelasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedSiswaKelasTable,
      CachedSiswaKela,
      $$CachedSiswaKelasTableFilterComposer,
      $$CachedSiswaKelasTableOrderingComposer,
      $$CachedSiswaKelasTableAnnotationComposer,
      $$CachedSiswaKelasTableCreateCompanionBuilder,
      $$CachedSiswaKelasTableUpdateCompanionBuilder,
      (
        CachedSiswaKela,
        BaseReferences<_$AppDatabase, $CachedSiswaKelasTable, CachedSiswaKela>,
      ),
      CachedSiswaKela,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String tableName,
      required String recordId,
      required String operation,
      Value<String?> data,
      Value<DateTime> createdAt,
      Value<bool> synced,
      Value<DateTime?> syncedAt,
      Value<String?> errorMessage,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> tableName,
      Value<String> recordId,
      Value<String> operation,
      Value<String?> data,
      Value<DateTime> createdAt,
      Value<bool> synced,
      Value<DateTime?> syncedAt,
      Value<String?> errorMessage,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableName => $composableBuilder(
    column: $table.tableName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableName => $composableBuilder(
    column: $table.tableName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tableName =>
      $composableBuilder(column: $table.tableName, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tableName = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                tableName: tableName,
                recordId: recordId,
                operation: operation,
                data: data,
                createdAt: createdAt,
                synced: synced,
                syncedAt: syncedAt,
                errorMessage: errorMessage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tableName,
                required String recordId,
                required String operation,
                Value<String?> data = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                tableName: tableName,
                recordId: recordId,
                operation: operation,
                data: data,
                createdAt: createdAt,
                synced: synced,
                syncedAt: syncedAt,
                errorMessage: errorMessage,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedKelasTableTableManager get cachedKelas =>
      $$CachedKelasTableTableManager(_db, _db.cachedKelas);
  $$CachedMapelTableTableManager get cachedMapel =>
      $$CachedMapelTableTableManager(_db, _db.cachedMapel);
  $$CachedKelasNgajarTableTableManager get cachedKelasNgajar =>
      $$CachedKelasNgajarTableTableManager(_db, _db.cachedKelasNgajar);
  $$CachedPengumumanTableTableManager get cachedPengumuman =>
      $$CachedPengumumanTableTableManager(_db, _db.cachedPengumuman);
  $$CachedGuruTableTableManager get cachedGuru =>
      $$CachedGuruTableTableManager(_db, _db.cachedGuru);
  $$CachedSiswaTableTableManager get cachedSiswa =>
      $$CachedSiswaTableTableManager(_db, _db.cachedSiswa);
  $$CachedSiswaKelasTableTableManager get cachedSiswaKelas =>
      $$CachedSiswaKelasTableTableManager(_db, _db.cachedSiswaKelas);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
