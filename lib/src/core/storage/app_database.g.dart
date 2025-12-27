// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedKelasTable extends CachedKelas
    with TableInfo<$CachedKelasTable, CachedKelasData> {
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
  static const VerificationMeta _namaGuruMeta = const VerificationMeta(
    'namaGuru',
  );
  @override
  late final GeneratedColumn<String> namaGuru = GeneratedColumn<String>(
    'nama_guru',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jenjangKelasMeta = const VerificationMeta(
    'jenjangKelas',
  );
  @override
  late final GeneratedColumn<String> jenjangKelas = GeneratedColumn<String>(
    'jenjang_kelas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomorKelasMeta = const VerificationMeta(
    'nomorKelas',
  );
  @override
  late final GeneratedColumn<String> nomorKelas = GeneratedColumn<String>(
    'nomor_kelas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tahunAjaranMeta = const VerificationMeta(
    'tahunAjaran',
  );
  @override
  late final GeneratedColumn<String> tahunAjaran = GeneratedColumn<String>(
    'tahun_ajaran',
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
    namaGuru,
    jenjangKelas,
    nomorKelas,
    tahunAjaran,
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
    Insertable<CachedKelasData> instance, {
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
    if (data.containsKey('nama_guru')) {
      context.handle(
        _namaGuruMeta,
        namaGuru.isAcceptableOrUnknown(data['nama_guru']!, _namaGuruMeta),
      );
    } else if (isInserting) {
      context.missing(_namaGuruMeta);
    }
    if (data.containsKey('jenjang_kelas')) {
      context.handle(
        _jenjangKelasMeta,
        jenjangKelas.isAcceptableOrUnknown(
          data['jenjang_kelas']!,
          _jenjangKelasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jenjangKelasMeta);
    }
    if (data.containsKey('nomor_kelas')) {
      context.handle(
        _nomorKelasMeta,
        nomorKelas.isAcceptableOrUnknown(data['nomor_kelas']!, _nomorKelasMeta),
      );
    } else if (isInserting) {
      context.missing(_nomorKelasMeta);
    }
    if (data.containsKey('tahun_ajaran')) {
      context.handle(
        _tahunAjaranMeta,
        tahunAjaran.isAcceptableOrUnknown(
          data['tahun_ajaran']!,
          _tahunAjaranMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tahunAjaranMeta);
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
  CachedKelasData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedKelasData(
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
      namaGuru: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_guru'],
      )!,
      jenjangKelas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jenjang_kelas'],
      )!,
      nomorKelas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nomor_kelas'],
      )!,
      tahunAjaran: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tahun_ajaran'],
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

class CachedKelasData extends DataClass implements Insertable<CachedKelasData> {
  final String id;
  final String namaKelas;
  final String guruId;
  final String namaGuru;
  final String jenjangKelas;
  final String nomorKelas;
  final String tahunAjaran;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedKelasData({
    required this.id,
    required this.namaKelas,
    required this.guruId,
    required this.namaGuru,
    required this.jenjangKelas,
    required this.nomorKelas,
    required this.tahunAjaran,
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
    map['nama_guru'] = Variable<String>(namaGuru);
    map['jenjang_kelas'] = Variable<String>(jenjangKelas);
    map['nomor_kelas'] = Variable<String>(nomorKelas);
    map['tahun_ajaran'] = Variable<String>(tahunAjaran);
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
      namaGuru: Value(namaGuru),
      jenjangKelas: Value(jenjangKelas),
      nomorKelas: Value(nomorKelas),
      tahunAjaran: Value(tahunAjaran),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedKelasData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedKelasData(
      id: serializer.fromJson<String>(json['id']),
      namaKelas: serializer.fromJson<String>(json['namaKelas']),
      guruId: serializer.fromJson<String>(json['guruId']),
      namaGuru: serializer.fromJson<String>(json['namaGuru']),
      jenjangKelas: serializer.fromJson<String>(json['jenjangKelas']),
      nomorKelas: serializer.fromJson<String>(json['nomorKelas']),
      tahunAjaran: serializer.fromJson<String>(json['tahunAjaran']),
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
      'namaGuru': serializer.toJson<String>(namaGuru),
      'jenjangKelas': serializer.toJson<String>(jenjangKelas),
      'nomorKelas': serializer.toJson<String>(nomorKelas),
      'tahunAjaran': serializer.toJson<String>(tahunAjaran),
      'status': serializer.toJson<bool>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedKelasData copyWith({
    String? id,
    String? namaKelas,
    String? guruId,
    String? namaGuru,
    String? jenjangKelas,
    String? nomorKelas,
    String? tahunAjaran,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedKelasData(
    id: id ?? this.id,
    namaKelas: namaKelas ?? this.namaKelas,
    guruId: guruId ?? this.guruId,
    namaGuru: namaGuru ?? this.namaGuru,
    jenjangKelas: jenjangKelas ?? this.jenjangKelas,
    nomorKelas: nomorKelas ?? this.nomorKelas,
    tahunAjaran: tahunAjaran ?? this.tahunAjaran,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedKelasData copyWithCompanion(CachedKelasCompanion data) {
    return CachedKelasData(
      id: data.id.present ? data.id.value : this.id,
      namaKelas: data.namaKelas.present ? data.namaKelas.value : this.namaKelas,
      guruId: data.guruId.present ? data.guruId.value : this.guruId,
      namaGuru: data.namaGuru.present ? data.namaGuru.value : this.namaGuru,
      jenjangKelas: data.jenjangKelas.present
          ? data.jenjangKelas.value
          : this.jenjangKelas,
      nomorKelas: data.nomorKelas.present
          ? data.nomorKelas.value
          : this.nomorKelas,
      tahunAjaran: data.tahunAjaran.present
          ? data.tahunAjaran.value
          : this.tahunAjaran,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedKelasData(')
          ..write('id: $id, ')
          ..write('namaKelas: $namaKelas, ')
          ..write('guruId: $guruId, ')
          ..write('namaGuru: $namaGuru, ')
          ..write('jenjangKelas: $jenjangKelas, ')
          ..write('nomorKelas: $nomorKelas, ')
          ..write('tahunAjaran: $tahunAjaran, ')
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
    namaGuru,
    jenjangKelas,
    nomorKelas,
    tahunAjaran,
    status,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedKelasData &&
          other.id == this.id &&
          other.namaKelas == this.namaKelas &&
          other.guruId == this.guruId &&
          other.namaGuru == this.namaGuru &&
          other.jenjangKelas == this.jenjangKelas &&
          other.nomorKelas == this.nomorKelas &&
          other.tahunAjaran == this.tahunAjaran &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedKelasCompanion extends UpdateCompanion<CachedKelasData> {
  final Value<String> id;
  final Value<String> namaKelas;
  final Value<String> guruId;
  final Value<String> namaGuru;
  final Value<String> jenjangKelas;
  final Value<String> nomorKelas;
  final Value<String> tahunAjaran;
  final Value<bool> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedKelasCompanion({
    this.id = const Value.absent(),
    this.namaKelas = const Value.absent(),
    this.guruId = const Value.absent(),
    this.namaGuru = const Value.absent(),
    this.jenjangKelas = const Value.absent(),
    this.nomorKelas = const Value.absent(),
    this.tahunAjaran = const Value.absent(),
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
    required String namaGuru,
    required String jenjangKelas,
    required String nomorKelas,
    required String tahunAjaran,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       namaKelas = Value(namaKelas),
       guruId = Value(guruId),
       namaGuru = Value(namaGuru),
       jenjangKelas = Value(jenjangKelas),
       nomorKelas = Value(nomorKelas),
       tahunAjaran = Value(tahunAjaran),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedKelasData> custom({
    Expression<String>? id,
    Expression<String>? namaKelas,
    Expression<String>? guruId,
    Expression<String>? namaGuru,
    Expression<String>? jenjangKelas,
    Expression<String>? nomorKelas,
    Expression<String>? tahunAjaran,
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
      if (namaGuru != null) 'nama_guru': namaGuru,
      if (jenjangKelas != null) 'jenjang_kelas': jenjangKelas,
      if (nomorKelas != null) 'nomor_kelas': nomorKelas,
      if (tahunAjaran != null) 'tahun_ajaran': tahunAjaran,
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
    Value<String>? namaGuru,
    Value<String>? jenjangKelas,
    Value<String>? nomorKelas,
    Value<String>? tahunAjaran,
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
      namaGuru: namaGuru ?? this.namaGuru,
      jenjangKelas: jenjangKelas ?? this.jenjangKelas,
      nomorKelas: nomorKelas ?? this.nomorKelas,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
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
    if (namaGuru.present) {
      map['nama_guru'] = Variable<String>(namaGuru.value);
    }
    if (jenjangKelas.present) {
      map['jenjang_kelas'] = Variable<String>(jenjangKelas.value);
    }
    if (nomorKelas.present) {
      map['nomor_kelas'] = Variable<String>(nomorKelas.value);
    }
    if (tahunAjaran.present) {
      map['tahun_ajaran'] = Variable<String>(tahunAjaran.value);
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
          ..write('namaGuru: $namaGuru, ')
          ..write('jenjangKelas: $jenjangKelas, ')
          ..write('nomorKelas: $nomorKelas, ')
          ..write('tahunAjaran: $tahunAjaran, ')
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
  static const VerificationMeta _hariMeta = const VerificationMeta('hari');
  @override
  late final GeneratedColumn<String> hari = GeneratedColumn<String>(
    'hari',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jamMeta = const VerificationMeta('jam');
  @override
  late final GeneratedColumn<String> jam = GeneratedColumn<String>(
    'jam',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
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
    idGuru,
    idKelas,
    idMapel,
    hari,
    jam,
    tanggal,
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
    if (data.containsKey('hari')) {
      context.handle(
        _hariMeta,
        hari.isAcceptableOrUnknown(data['hari']!, _hariMeta),
      );
    } else if (isInserting) {
      context.missing(_hariMeta);
    }
    if (data.containsKey('jam')) {
      context.handle(
        _jamMeta,
        jam.isAcceptableOrUnknown(data['jam']!, _jamMeta),
      );
    } else if (isInserting) {
      context.missing(_jamMeta);
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
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
      hari: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hari'],
      )!,
      jam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jam'],
      )!,
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
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
  final String hari;
  final String jam;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedKelasNgajarData({
    required this.id,
    required this.idGuru,
    required this.idKelas,
    required this.idMapel,
    required this.hari,
    required this.jam,
    required this.tanggal,
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
    map['hari'] = Variable<String>(hari);
    map['jam'] = Variable<String>(jam);
    map['tanggal'] = Variable<DateTime>(tanggal);
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
      hari: Value(hari),
      jam: Value(jam),
      tanggal: Value(tanggal),
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
      hari: serializer.fromJson<String>(json['hari']),
      jam: serializer.fromJson<String>(json['jam']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
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
      'hari': serializer.toJson<String>(hari),
      'jam': serializer.toJson<String>(jam),
      'tanggal': serializer.toJson<DateTime>(tanggal),
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
    String? hari,
    String? jam,
    DateTime? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedKelasNgajarData(
    id: id ?? this.id,
    idGuru: idGuru ?? this.idGuru,
    idKelas: idKelas ?? this.idKelas,
    idMapel: idMapel ?? this.idMapel,
    hari: hari ?? this.hari,
    jam: jam ?? this.jam,
    tanggal: tanggal ?? this.tanggal,
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
      hari: data.hari.present ? data.hari.value : this.hari,
      jam: data.jam.present ? data.jam.value : this.jam,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
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
          ..write('hari: $hari, ')
          ..write('jam: $jam, ')
          ..write('tanggal: $tanggal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idGuru,
    idKelas,
    idMapel,
    hari,
    jam,
    tanggal,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedKelasNgajarData &&
          other.id == this.id &&
          other.idGuru == this.idGuru &&
          other.idKelas == this.idKelas &&
          other.idMapel == this.idMapel &&
          other.hari == this.hari &&
          other.jam == this.jam &&
          other.tanggal == this.tanggal &&
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
  final Value<String> hari;
  final Value<String> jam;
  final Value<DateTime> tanggal;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedKelasNgajarCompanion({
    this.id = const Value.absent(),
    this.idGuru = const Value.absent(),
    this.idKelas = const Value.absent(),
    this.idMapel = const Value.absent(),
    this.hari = const Value.absent(),
    this.jam = const Value.absent(),
    this.tanggal = const Value.absent(),
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
    required String hari,
    required String jam,
    required DateTime tanggal,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idGuru = Value(idGuru),
       idKelas = Value(idKelas),
       idMapel = Value(idMapel),
       hari = Value(hari),
       jam = Value(jam),
       tanggal = Value(tanggal),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedKelasNgajarData> custom({
    Expression<String>? id,
    Expression<String>? idGuru,
    Expression<String>? idKelas,
    Expression<String>? idMapel,
    Expression<String>? hari,
    Expression<String>? jam,
    Expression<DateTime>? tanggal,
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
      if (hari != null) 'hari': hari,
      if (jam != null) 'jam': jam,
      if (tanggal != null) 'tanggal': tanggal,
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
    Value<String>? hari,
    Value<String>? jam,
    Value<DateTime>? tanggal,
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
      hari: hari ?? this.hari,
      jam: jam ?? this.jam,
      tanggal: tanggal ?? this.tanggal,
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
    if (hari.present) {
      map['hari'] = Variable<String>(hari.value);
    }
    if (jam.present) {
      map['jam'] = Variable<String>(jam.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
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
          ..write('hari: $hari, ')
          ..write('jam: $jam, ')
          ..write('tanggal: $tanggal, ')
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
  static const VerificationMeta _jenisKelaminMeta = const VerificationMeta(
    'jenisKelamin',
  );
  @override
  late final GeneratedColumn<String> jenisKelamin = GeneratedColumn<String>(
    'jenis_kelamin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mataPelajaranMeta = const VerificationMeta(
    'mataPelajaran',
  );
  @override
  late final GeneratedColumn<String> mataPelajaran = GeneratedColumn<String>(
    'mata_pelajaran',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sekolahMeta = const VerificationMeta(
    'sekolah',
  );
  @override
  late final GeneratedColumn<String> sekolah = GeneratedColumn<String>(
    'sekolah',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    jenisKelamin,
    mataPelajaran,
    password,
    photoUrl,
    sekolah,
    status,
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
    if (data.containsKey('jenis_kelamin')) {
      context.handle(
        _jenisKelaminMeta,
        jenisKelamin.isAcceptableOrUnknown(
          data['jenis_kelamin']!,
          _jenisKelaminMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jenisKelaminMeta);
    }
    if (data.containsKey('mata_pelajaran')) {
      context.handle(
        _mataPelajaranMeta,
        mataPelajaran.isAcceptableOrUnknown(
          data['mata_pelajaran']!,
          _mataPelajaranMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mataPelajaranMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_photoUrlMeta);
    }
    if (data.containsKey('sekolah')) {
      context.handle(
        _sekolahMeta,
        sekolah.isAcceptableOrUnknown(data['sekolah']!, _sekolahMeta),
      );
    } else if (isInserting) {
      context.missing(_sekolahMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
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
      jenisKelamin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jenis_kelamin'],
      )!,
      mataPelajaran: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mata_pelajaran'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      )!,
      sekolah: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sekolah'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
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
  final String jenisKelamin;
  final String mataPelajaran;
  final String password;
  final String photoUrl;
  final String sekolah;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  const CachedGuruData({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.nig,
    required this.jenisKelamin,
    required this.mataPelajaran,
    required this.password,
    required this.photoUrl,
    required this.sekolah,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama_lengkap'] = Variable<String>(namaLengkap);
    map['email'] = Variable<String>(email);
    map['nig'] = Variable<int>(nig);
    map['jenis_kelamin'] = Variable<String>(jenisKelamin);
    map['mata_pelajaran'] = Variable<String>(mataPelajaran);
    map['password'] = Variable<String>(password);
    map['photo_url'] = Variable<String>(photoUrl);
    map['sekolah'] = Variable<String>(sekolah);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
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
      jenisKelamin: Value(jenisKelamin),
      mataPelajaran: Value(mataPelajaran),
      password: Value(password),
      photoUrl: Value(photoUrl),
      sekolah: Value(sekolah),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
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
      jenisKelamin: serializer.fromJson<String>(json['jenisKelamin']),
      mataPelajaran: serializer.fromJson<String>(json['mataPelajaran']),
      password: serializer.fromJson<String>(json['password']),
      photoUrl: serializer.fromJson<String>(json['photoUrl']),
      sekolah: serializer.fromJson<String>(json['sekolah']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
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
      'jenisKelamin': serializer.toJson<String>(jenisKelamin),
      'mataPelajaran': serializer.toJson<String>(mataPelajaran),
      'password': serializer.toJson<String>(password),
      'photoUrl': serializer.toJson<String>(photoUrl),
      'sekolah': serializer.toJson<String>(sekolah),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedGuruData copyWith({
    String? id,
    String? namaLengkap,
    String? email,
    int? nig,
    String? jenisKelamin,
    String? mataPelajaran,
    String? password,
    String? photoUrl,
    String? sekolah,
    String? status,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedGuruData(
    id: id ?? this.id,
    namaLengkap: namaLengkap ?? this.namaLengkap,
    email: email ?? this.email,
    nig: nig ?? this.nig,
    jenisKelamin: jenisKelamin ?? this.jenisKelamin,
    mataPelajaran: mataPelajaran ?? this.mataPelajaran,
    password: password ?? this.password,
    photoUrl: photoUrl ?? this.photoUrl,
    sekolah: sekolah ?? this.sekolah,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
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
      jenisKelamin: data.jenisKelamin.present
          ? data.jenisKelamin.value
          : this.jenisKelamin,
      mataPelajaran: data.mataPelajaran.present
          ? data.mataPelajaran.value
          : this.mataPelajaran,
      password: data.password.present ? data.password.value : this.password,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      sekolah: data.sekolah.present ? data.sekolah.value : this.sekolah,
      status: data.status.present ? data.status.value : this.status,
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
          ..write('jenisKelamin: $jenisKelamin, ')
          ..write('mataPelajaran: $mataPelajaran, ')
          ..write('password: $password, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('sekolah: $sekolah, ')
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
    namaLengkap,
    email,
    nig,
    jenisKelamin,
    mataPelajaran,
    password,
    photoUrl,
    sekolah,
    status,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedGuruData &&
          other.id == this.id &&
          other.namaLengkap == this.namaLengkap &&
          other.email == this.email &&
          other.nig == this.nig &&
          other.jenisKelamin == this.jenisKelamin &&
          other.mataPelajaran == this.mataPelajaran &&
          other.password == this.password &&
          other.photoUrl == this.photoUrl &&
          other.sekolah == this.sekolah &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedGuruCompanion extends UpdateCompanion<CachedGuruData> {
  final Value<String> id;
  final Value<String> namaLengkap;
  final Value<String> email;
  final Value<int> nig;
  final Value<String> jenisKelamin;
  final Value<String> mataPelajaran;
  final Value<String> password;
  final Value<String> photoUrl;
  final Value<String> sekolah;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedGuruCompanion({
    this.id = const Value.absent(),
    this.namaLengkap = const Value.absent(),
    this.email = const Value.absent(),
    this.nig = const Value.absent(),
    this.jenisKelamin = const Value.absent(),
    this.mataPelajaran = const Value.absent(),
    this.password = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.sekolah = const Value.absent(),
    this.status = const Value.absent(),
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
    required String jenisKelamin,
    required String mataPelajaran,
    required String password,
    required String photoUrl,
    required String sekolah,
    required String status,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       namaLengkap = Value(namaLengkap),
       email = Value(email),
       nig = Value(nig),
       jenisKelamin = Value(jenisKelamin),
       mataPelajaran = Value(mataPelajaran),
       password = Value(password),
       photoUrl = Value(photoUrl),
       sekolah = Value(sekolah),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<CachedGuruData> custom({
    Expression<String>? id,
    Expression<String>? namaLengkap,
    Expression<String>? email,
    Expression<int>? nig,
    Expression<String>? jenisKelamin,
    Expression<String>? mataPelajaran,
    Expression<String>? password,
    Expression<String>? photoUrl,
    Expression<String>? sekolah,
    Expression<String>? status,
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
      if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
      if (mataPelajaran != null) 'mata_pelajaran': mataPelajaran,
      if (password != null) 'password': password,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (sekolah != null) 'sekolah': sekolah,
      if (status != null) 'status': status,
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
    Value<String>? jenisKelamin,
    Value<String>? mataPelajaran,
    Value<String>? password,
    Value<String>? photoUrl,
    Value<String>? sekolah,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedGuruCompanion(
      id: id ?? this.id,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      email: email ?? this.email,
      nig: nig ?? this.nig,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      mataPelajaran: mataPelajaran ?? this.mataPelajaran,
      password: password ?? this.password,
      photoUrl: photoUrl ?? this.photoUrl,
      sekolah: sekolah ?? this.sekolah,
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
    if (namaLengkap.present) {
      map['nama_lengkap'] = Variable<String>(namaLengkap.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (nig.present) {
      map['nig'] = Variable<int>(nig.value);
    }
    if (jenisKelamin.present) {
      map['jenis_kelamin'] = Variable<String>(jenisKelamin.value);
    }
    if (mataPelajaran.present) {
      map['mata_pelajaran'] = Variable<String>(mataPelajaran.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (sekolah.present) {
      map['sekolah'] = Variable<String>(sekolah.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
          ..write('jenisKelamin: $jenisKelamin, ')
          ..write('mataPelajaran: $mataPelajaran, ')
          ..write('password: $password, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('sekolah: $sekolah, ')
          ..write('status: $status, ')
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
    with TableInfo<$CachedSiswaKelasTable, CachedSiswaKelasData> {
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
    Insertable<CachedSiswaKelasData> instance, {
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
  CachedSiswaKelasData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSiswaKelasData(
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

class CachedSiswaKelasData extends DataClass
    implements Insertable<CachedSiswaKelasData> {
  final String id;
  final String siswaId;
  final String kelasId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedSiswaKelasData({
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

  factory CachedSiswaKelasData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSiswaKelasData(
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

  CachedSiswaKelasData copyWith({
    String? id,
    String? siswaId,
    String? kelasId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedSiswaKelasData(
    id: id ?? this.id,
    siswaId: siswaId ?? this.siswaId,
    kelasId: kelasId ?? this.kelasId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedSiswaKelasData copyWithCompanion(CachedSiswaKelasCompanion data) {
    return CachedSiswaKelasData(
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
    return (StringBuffer('CachedSiswaKelasData(')
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
      (other is CachedSiswaKelasData &&
          other.id == this.id &&
          other.siswaId == this.siswaId &&
          other.kelasId == this.kelasId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedSiswaKelasCompanion extends UpdateCompanion<CachedSiswaKelasData> {
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
  static Insertable<CachedSiswaKelasData> custom({
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

class $CachedFilesTable extends CachedFiles
    with TableInfo<$CachedFilesTable, CachedFilesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _driveFileIdMeta = const VerificationMeta(
    'driveFileId',
  );
  @override
  late final GeneratedColumn<String> driveFileId = GeneratedColumn<String>(
    'drive_file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
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
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedByMeta = const VerificationMeta(
    'uploadedBy',
  );
  @override
  late final GeneratedColumn<String> uploadedBy = GeneratedColumn<String>(
    'uploaded_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _webViewLinkMeta = const VerificationMeta(
    'webViewLink',
  );
  @override
  late final GeneratedColumn<String> webViewLink = GeneratedColumn<String>(
    'web_view_link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    driveFileId,
    mimeType,
    name,
    size,
    status,
    uploadedAt,
    uploadedBy,
    webViewLink,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedFilesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('drive_file_id')) {
      context.handle(
        _driveFileIdMeta,
        driveFileId.isAcceptableOrUnknown(
          data['drive_file_id']!,
          _driveFileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_driveFileIdMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_uploadedAtMeta);
    }
    if (data.containsKey('uploaded_by')) {
      context.handle(
        _uploadedByMeta,
        uploadedBy.isAcceptableOrUnknown(data['uploaded_by']!, _uploadedByMeta),
      );
    } else if (isInserting) {
      context.missing(_uploadedByMeta);
    }
    if (data.containsKey('web_view_link')) {
      context.handle(
        _webViewLinkMeta,
        webViewLink.isAcceptableOrUnknown(
          data['web_view_link']!,
          _webViewLinkMeta,
        ),
      );
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
  CachedFilesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedFilesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      driveFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drive_file_id'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
      )!,
      uploadedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uploaded_by'],
      )!,
      webViewLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}web_view_link'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CachedFilesTable createAlias(String alias) {
    return $CachedFilesTable(attachedDatabase, alias);
  }
}

class CachedFilesData extends DataClass implements Insertable<CachedFilesData> {
  final String id;
  final String driveFileId;
  final String mimeType;
  final String name;
  final int size;
  final String status;
  final DateTime uploadedAt;
  final String uploadedBy;
  final String? webViewLink;
  final DateTime? syncedAt;
  const CachedFilesData({
    required this.id,
    required this.driveFileId,
    required this.mimeType,
    required this.name,
    required this.size,
    required this.status,
    required this.uploadedAt,
    required this.uploadedBy,
    this.webViewLink,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['drive_file_id'] = Variable<String>(driveFileId);
    map['mime_type'] = Variable<String>(mimeType);
    map['name'] = Variable<String>(name);
    map['size'] = Variable<int>(size);
    map['status'] = Variable<String>(status);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    map['uploaded_by'] = Variable<String>(uploadedBy);
    if (!nullToAbsent || webViewLink != null) {
      map['web_view_link'] = Variable<String>(webViewLink);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedFilesCompanion toCompanion(bool nullToAbsent) {
    return CachedFilesCompanion(
      id: Value(id),
      driveFileId: Value(driveFileId),
      mimeType: Value(mimeType),
      name: Value(name),
      size: Value(size),
      status: Value(status),
      uploadedAt: Value(uploadedAt),
      uploadedBy: Value(uploadedBy),
      webViewLink: webViewLink == null && nullToAbsent
          ? const Value.absent()
          : Value(webViewLink),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedFilesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedFilesData(
      id: serializer.fromJson<String>(json['id']),
      driveFileId: serializer.fromJson<String>(json['driveFileId']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      name: serializer.fromJson<String>(json['name']),
      size: serializer.fromJson<int>(json['size']),
      status: serializer.fromJson<String>(json['status']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
      uploadedBy: serializer.fromJson<String>(json['uploadedBy']),
      webViewLink: serializer.fromJson<String?>(json['webViewLink']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'driveFileId': serializer.toJson<String>(driveFileId),
      'mimeType': serializer.toJson<String>(mimeType),
      'name': serializer.toJson<String>(name),
      'size': serializer.toJson<int>(size),
      'status': serializer.toJson<String>(status),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
      'uploadedBy': serializer.toJson<String>(uploadedBy),
      'webViewLink': serializer.toJson<String?>(webViewLink),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedFilesData copyWith({
    String? id,
    String? driveFileId,
    String? mimeType,
    String? name,
    int? size,
    String? status,
    DateTime? uploadedAt,
    String? uploadedBy,
    Value<String?> webViewLink = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedFilesData(
    id: id ?? this.id,
    driveFileId: driveFileId ?? this.driveFileId,
    mimeType: mimeType ?? this.mimeType,
    name: name ?? this.name,
    size: size ?? this.size,
    status: status ?? this.status,
    uploadedAt: uploadedAt ?? this.uploadedAt,
    uploadedBy: uploadedBy ?? this.uploadedBy,
    webViewLink: webViewLink.present ? webViewLink.value : this.webViewLink,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedFilesData copyWithCompanion(CachedFilesCompanion data) {
    return CachedFilesData(
      id: data.id.present ? data.id.value : this.id,
      driveFileId: data.driveFileId.present
          ? data.driveFileId.value
          : this.driveFileId,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      name: data.name.present ? data.name.value : this.name,
      size: data.size.present ? data.size.value : this.size,
      status: data.status.present ? data.status.value : this.status,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
      uploadedBy: data.uploadedBy.present
          ? data.uploadedBy.value
          : this.uploadedBy,
      webViewLink: data.webViewLink.present
          ? data.webViewLink.value
          : this.webViewLink,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedFilesData(')
          ..write('id: $id, ')
          ..write('driveFileId: $driveFileId, ')
          ..write('mimeType: $mimeType, ')
          ..write('name: $name, ')
          ..write('size: $size, ')
          ..write('status: $status, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('webViewLink: $webViewLink, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    driveFileId,
    mimeType,
    name,
    size,
    status,
    uploadedAt,
    uploadedBy,
    webViewLink,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedFilesData &&
          other.id == this.id &&
          other.driveFileId == this.driveFileId &&
          other.mimeType == this.mimeType &&
          other.name == this.name &&
          other.size == this.size &&
          other.status == this.status &&
          other.uploadedAt == this.uploadedAt &&
          other.uploadedBy == this.uploadedBy &&
          other.webViewLink == this.webViewLink &&
          other.syncedAt == this.syncedAt);
}

class CachedFilesCompanion extends UpdateCompanion<CachedFilesData> {
  final Value<String> id;
  final Value<String> driveFileId;
  final Value<String> mimeType;
  final Value<String> name;
  final Value<int> size;
  final Value<String> status;
  final Value<DateTime> uploadedAt;
  final Value<String> uploadedBy;
  final Value<String?> webViewLink;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedFilesCompanion({
    this.id = const Value.absent(),
    this.driveFileId = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.name = const Value.absent(),
    this.size = const Value.absent(),
    this.status = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    this.webViewLink = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedFilesCompanion.insert({
    required String id,
    required String driveFileId,
    required String mimeType,
    required String name,
    required int size,
    required String status,
    required DateTime uploadedAt,
    required String uploadedBy,
    this.webViewLink = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       driveFileId = Value(driveFileId),
       mimeType = Value(mimeType),
       name = Value(name),
       size = Value(size),
       status = Value(status),
       uploadedAt = Value(uploadedAt),
       uploadedBy = Value(uploadedBy);
  static Insertable<CachedFilesData> custom({
    Expression<String>? id,
    Expression<String>? driveFileId,
    Expression<String>? mimeType,
    Expression<String>? name,
    Expression<int>? size,
    Expression<String>? status,
    Expression<DateTime>? uploadedAt,
    Expression<String>? uploadedBy,
    Expression<String>? webViewLink,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (driveFileId != null) 'drive_file_id': driveFileId,
      if (mimeType != null) 'mime_type': mimeType,
      if (name != null) 'name': name,
      if (size != null) 'size': size,
      if (status != null) 'status': status,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (uploadedBy != null) 'uploaded_by': uploadedBy,
      if (webViewLink != null) 'web_view_link': webViewLink,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedFilesCompanion copyWith({
    Value<String>? id,
    Value<String>? driveFileId,
    Value<String>? mimeType,
    Value<String>? name,
    Value<int>? size,
    Value<String>? status,
    Value<DateTime>? uploadedAt,
    Value<String>? uploadedBy,
    Value<String?>? webViewLink,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedFilesCompanion(
      id: id ?? this.id,
      driveFileId: driveFileId ?? this.driveFileId,
      mimeType: mimeType ?? this.mimeType,
      name: name ?? this.name,
      size: size ?? this.size,
      status: status ?? this.status,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      webViewLink: webViewLink ?? this.webViewLink,
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
    if (driveFileId.present) {
      map['drive_file_id'] = Variable<String>(driveFileId.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    if (uploadedBy.present) {
      map['uploaded_by'] = Variable<String>(uploadedBy.value);
    }
    if (webViewLink.present) {
      map['web_view_link'] = Variable<String>(webViewLink.value);
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
    return (StringBuffer('CachedFilesCompanion(')
          ..write('id: $id, ')
          ..write('driveFileId: $driveFileId, ')
          ..write('mimeType: $mimeType, ')
          ..write('name: $name, ')
          ..write('size: $size, ')
          ..write('status: $status, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('uploadedBy: $uploadedBy, ')
          ..write('webViewLink: $webViewLink, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedAbsensiTable extends CachedAbsensi
    with TableInfo<$CachedAbsensiTable, CachedAbsensiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAbsensiTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _jadwalIdMeta = const VerificationMeta(
    'jadwalId',
  );
  @override
  late final GeneratedColumn<String> jadwalId = GeneratedColumn<String>(
    'jadwal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _tipeAbsenMeta = const VerificationMeta(
    'tipeAbsen',
  );
  @override
  late final GeneratedColumn<String> tipeAbsen = GeneratedColumn<String>(
    'tipe_absen',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diabsenOlehMeta = const VerificationMeta(
    'diabsenOleh',
  );
  @override
  late final GeneratedColumn<String> diabsenOleh = GeneratedColumn<String>(
    'diabsen_oleh',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
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
    siswaId,
    kelasId,
    jadwalId,
    status,
    tipeAbsen,
    diabsenOleh,
    tanggal,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_absensi';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAbsensiData> instance, {
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
    if (data.containsKey('jadwal_id')) {
      context.handle(
        _jadwalIdMeta,
        jadwalId.isAcceptableOrUnknown(data['jadwal_id']!, _jadwalIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('tipe_absen')) {
      context.handle(
        _tipeAbsenMeta,
        tipeAbsen.isAcceptableOrUnknown(data['tipe_absen']!, _tipeAbsenMeta),
      );
    } else if (isInserting) {
      context.missing(_tipeAbsenMeta);
    }
    if (data.containsKey('diabsen_oleh')) {
      context.handle(
        _diabsenOlehMeta,
        diabsenOleh.isAcceptableOrUnknown(
          data['diabsen_oleh']!,
          _diabsenOlehMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diabsenOlehMeta);
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
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
  CachedAbsensiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAbsensiData(
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
      jadwalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jadwal_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      tipeAbsen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipe_absen'],
      )!,
      diabsenOleh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diabsen_oleh'],
      )!,
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
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
  $CachedAbsensiTable createAlias(String alias) {
    return $CachedAbsensiTable(attachedDatabase, alias);
  }
}

class CachedAbsensiData extends DataClass
    implements Insertable<CachedAbsensiData> {
  final String id;
  final String siswaId;
  final String kelasId;
  final String? jadwalId;
  final String status;
  final String tipeAbsen;
  final String diabsenOleh;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedAbsensiData({
    required this.id,
    required this.siswaId,
    required this.kelasId,
    this.jadwalId,
    required this.status,
    required this.tipeAbsen,
    required this.diabsenOleh,
    required this.tanggal,
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
    if (!nullToAbsent || jadwalId != null) {
      map['jadwal_id'] = Variable<String>(jadwalId);
    }
    map['status'] = Variable<String>(status);
    map['tipe_absen'] = Variable<String>(tipeAbsen);
    map['diabsen_oleh'] = Variable<String>(diabsenOleh);
    map['tanggal'] = Variable<DateTime>(tanggal);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedAbsensiCompanion toCompanion(bool nullToAbsent) {
    return CachedAbsensiCompanion(
      id: Value(id),
      siswaId: Value(siswaId),
      kelasId: Value(kelasId),
      jadwalId: jadwalId == null && nullToAbsent
          ? const Value.absent()
          : Value(jadwalId),
      status: Value(status),
      tipeAbsen: Value(tipeAbsen),
      diabsenOleh: Value(diabsenOleh),
      tanggal: Value(tanggal),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedAbsensiData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAbsensiData(
      id: serializer.fromJson<String>(json['id']),
      siswaId: serializer.fromJson<String>(json['siswaId']),
      kelasId: serializer.fromJson<String>(json['kelasId']),
      jadwalId: serializer.fromJson<String?>(json['jadwalId']),
      status: serializer.fromJson<String>(json['status']),
      tipeAbsen: serializer.fromJson<String>(json['tipeAbsen']),
      diabsenOleh: serializer.fromJson<String>(json['diabsenOleh']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
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
      'jadwalId': serializer.toJson<String?>(jadwalId),
      'status': serializer.toJson<String>(status),
      'tipeAbsen': serializer.toJson<String>(tipeAbsen),
      'diabsenOleh': serializer.toJson<String>(diabsenOleh),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedAbsensiData copyWith({
    String? id,
    String? siswaId,
    String? kelasId,
    Value<String?> jadwalId = const Value.absent(),
    String? status,
    String? tipeAbsen,
    String? diabsenOleh,
    DateTime? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedAbsensiData(
    id: id ?? this.id,
    siswaId: siswaId ?? this.siswaId,
    kelasId: kelasId ?? this.kelasId,
    jadwalId: jadwalId.present ? jadwalId.value : this.jadwalId,
    status: status ?? this.status,
    tipeAbsen: tipeAbsen ?? this.tipeAbsen,
    diabsenOleh: diabsenOleh ?? this.diabsenOleh,
    tanggal: tanggal ?? this.tanggal,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedAbsensiData copyWithCompanion(CachedAbsensiCompanion data) {
    return CachedAbsensiData(
      id: data.id.present ? data.id.value : this.id,
      siswaId: data.siswaId.present ? data.siswaId.value : this.siswaId,
      kelasId: data.kelasId.present ? data.kelasId.value : this.kelasId,
      jadwalId: data.jadwalId.present ? data.jadwalId.value : this.jadwalId,
      status: data.status.present ? data.status.value : this.status,
      tipeAbsen: data.tipeAbsen.present ? data.tipeAbsen.value : this.tipeAbsen,
      diabsenOleh: data.diabsenOleh.present
          ? data.diabsenOleh.value
          : this.diabsenOleh,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAbsensiData(')
          ..write('id: $id, ')
          ..write('siswaId: $siswaId, ')
          ..write('kelasId: $kelasId, ')
          ..write('jadwalId: $jadwalId, ')
          ..write('status: $status, ')
          ..write('tipeAbsen: $tipeAbsen, ')
          ..write('diabsenOleh: $diabsenOleh, ')
          ..write('tanggal: $tanggal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    siswaId,
    kelasId,
    jadwalId,
    status,
    tipeAbsen,
    diabsenOleh,
    tanggal,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAbsensiData &&
          other.id == this.id &&
          other.siswaId == this.siswaId &&
          other.kelasId == this.kelasId &&
          other.jadwalId == this.jadwalId &&
          other.status == this.status &&
          other.tipeAbsen == this.tipeAbsen &&
          other.diabsenOleh == this.diabsenOleh &&
          other.tanggal == this.tanggal &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedAbsensiCompanion extends UpdateCompanion<CachedAbsensiData> {
  final Value<String> id;
  final Value<String> siswaId;
  final Value<String> kelasId;
  final Value<String?> jadwalId;
  final Value<String> status;
  final Value<String> tipeAbsen;
  final Value<String> diabsenOleh;
  final Value<DateTime> tanggal;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedAbsensiCompanion({
    this.id = const Value.absent(),
    this.siswaId = const Value.absent(),
    this.kelasId = const Value.absent(),
    this.jadwalId = const Value.absent(),
    this.status = const Value.absent(),
    this.tipeAbsen = const Value.absent(),
    this.diabsenOleh = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAbsensiCompanion.insert({
    required String id,
    required String siswaId,
    required String kelasId,
    this.jadwalId = const Value.absent(),
    required String status,
    required String tipeAbsen,
    required String diabsenOleh,
    required DateTime tanggal,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       siswaId = Value(siswaId),
       kelasId = Value(kelasId),
       status = Value(status),
       tipeAbsen = Value(tipeAbsen),
       diabsenOleh = Value(diabsenOleh),
       tanggal = Value(tanggal),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedAbsensiData> custom({
    Expression<String>? id,
    Expression<String>? siswaId,
    Expression<String>? kelasId,
    Expression<String>? jadwalId,
    Expression<String>? status,
    Expression<String>? tipeAbsen,
    Expression<String>? diabsenOleh,
    Expression<DateTime>? tanggal,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siswaId != null) 'siswa_id': siswaId,
      if (kelasId != null) 'kelas_id': kelasId,
      if (jadwalId != null) 'jadwal_id': jadwalId,
      if (status != null) 'status': status,
      if (tipeAbsen != null) 'tipe_absen': tipeAbsen,
      if (diabsenOleh != null) 'diabsen_oleh': diabsenOleh,
      if (tanggal != null) 'tanggal': tanggal,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAbsensiCompanion copyWith({
    Value<String>? id,
    Value<String>? siswaId,
    Value<String>? kelasId,
    Value<String?>? jadwalId,
    Value<String>? status,
    Value<String>? tipeAbsen,
    Value<String>? diabsenOleh,
    Value<DateTime>? tanggal,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedAbsensiCompanion(
      id: id ?? this.id,
      siswaId: siswaId ?? this.siswaId,
      kelasId: kelasId ?? this.kelasId,
      jadwalId: jadwalId ?? this.jadwalId,
      status: status ?? this.status,
      tipeAbsen: tipeAbsen ?? this.tipeAbsen,
      diabsenOleh: diabsenOleh ?? this.diabsenOleh,
      tanggal: tanggal ?? this.tanggal,
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
    if (jadwalId.present) {
      map['jadwal_id'] = Variable<String>(jadwalId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (tipeAbsen.present) {
      map['tipe_absen'] = Variable<String>(tipeAbsen.value);
    }
    if (diabsenOleh.present) {
      map['diabsen_oleh'] = Variable<String>(diabsenOleh.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
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
    return (StringBuffer('CachedAbsensiCompanion(')
          ..write('id: $id, ')
          ..write('siswaId: $siswaId, ')
          ..write('kelasId: $kelasId, ')
          ..write('jadwalId: $jadwalId, ')
          ..write('status: $status, ')
          ..write('tipeAbsen: $tipeAbsen, ')
          ..write('diabsenOleh: $diabsenOleh, ')
          ..write('tanggal: $tanggal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedTugasTable extends CachedTugas
    with TableInfo<$CachedTugasTable, CachedTugasData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedTugasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _idGuruMeta = const VerificationMeta('idGuru');
  @override
  late final GeneratedColumn<String> idGuru = GeneratedColumn<String>(
    'id_guru',
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
  static const VerificationMeta _deskripsiMeta = const VerificationMeta(
    'deskripsi',
  );
  @override
  late final GeneratedColumn<String> deskripsi = GeneratedColumn<String>(
    'deskripsi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Aktif'),
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
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
    idKelas,
    idMapel,
    idGuru,
    judul,
    deskripsi,
    status,
    deadline,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_tugas';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedTugasData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('id_guru')) {
      context.handle(
        _idGuruMeta,
        idGuru.isAcceptableOrUnknown(data['id_guru']!, _idGuruMeta),
      );
    } else if (isInserting) {
      context.missing(_idGuruMeta);
    }
    if (data.containsKey('judul')) {
      context.handle(
        _judulMeta,
        judul.isAcceptableOrUnknown(data['judul']!, _judulMeta),
      );
    } else if (isInserting) {
      context.missing(_judulMeta);
    }
    if (data.containsKey('deskripsi')) {
      context.handle(
        _deskripsiMeta,
        deskripsi.isAcceptableOrUnknown(data['deskripsi']!, _deskripsiMeta),
      );
    } else if (isInserting) {
      context.missing(_deskripsiMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    } else if (isInserting) {
      context.missing(_deadlineMeta);
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
  CachedTugasData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedTugasData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idKelas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_kelas'],
      )!,
      idMapel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_mapel'],
      )!,
      idGuru: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_guru'],
      )!,
      judul: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}judul'],
      )!,
      deskripsi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deskripsi'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
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
  $CachedTugasTable createAlias(String alias) {
    return $CachedTugasTable(attachedDatabase, alias);
  }
}

class CachedTugasData extends DataClass implements Insertable<CachedTugasData> {
  final String id;
  final String idKelas;
  final String idMapel;
  final String idGuru;
  final String judul;
  final String deskripsi;
  final String status;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedTugasData({
    required this.id,
    required this.idKelas,
    required this.idMapel,
    required this.idGuru,
    required this.judul,
    required this.deskripsi,
    required this.status,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_kelas'] = Variable<String>(idKelas);
    map['id_mapel'] = Variable<String>(idMapel);
    map['id_guru'] = Variable<String>(idGuru);
    map['judul'] = Variable<String>(judul);
    map['deskripsi'] = Variable<String>(deskripsi);
    map['status'] = Variable<String>(status);
    map['deadline'] = Variable<DateTime>(deadline);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedTugasCompanion toCompanion(bool nullToAbsent) {
    return CachedTugasCompanion(
      id: Value(id),
      idKelas: Value(idKelas),
      idMapel: Value(idMapel),
      idGuru: Value(idGuru),
      judul: Value(judul),
      deskripsi: Value(deskripsi),
      status: Value(status),
      deadline: Value(deadline),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedTugasData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedTugasData(
      id: serializer.fromJson<String>(json['id']),
      idKelas: serializer.fromJson<String>(json['idKelas']),
      idMapel: serializer.fromJson<String>(json['idMapel']),
      idGuru: serializer.fromJson<String>(json['idGuru']),
      judul: serializer.fromJson<String>(json['judul']),
      deskripsi: serializer.fromJson<String>(json['deskripsi']),
      status: serializer.fromJson<String>(json['status']),
      deadline: serializer.fromJson<DateTime>(json['deadline']),
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
      'idKelas': serializer.toJson<String>(idKelas),
      'idMapel': serializer.toJson<String>(idMapel),
      'idGuru': serializer.toJson<String>(idGuru),
      'judul': serializer.toJson<String>(judul),
      'deskripsi': serializer.toJson<String>(deskripsi),
      'status': serializer.toJson<String>(status),
      'deadline': serializer.toJson<DateTime>(deadline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedTugasData copyWith({
    String? id,
    String? idKelas,
    String? idMapel,
    String? idGuru,
    String? judul,
    String? deskripsi,
    String? status,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedTugasData(
    id: id ?? this.id,
    idKelas: idKelas ?? this.idKelas,
    idMapel: idMapel ?? this.idMapel,
    idGuru: idGuru ?? this.idGuru,
    judul: judul ?? this.judul,
    deskripsi: deskripsi ?? this.deskripsi,
    status: status ?? this.status,
    deadline: deadline ?? this.deadline,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedTugasData copyWithCompanion(CachedTugasCompanion data) {
    return CachedTugasData(
      id: data.id.present ? data.id.value : this.id,
      idKelas: data.idKelas.present ? data.idKelas.value : this.idKelas,
      idMapel: data.idMapel.present ? data.idMapel.value : this.idMapel,
      idGuru: data.idGuru.present ? data.idGuru.value : this.idGuru,
      judul: data.judul.present ? data.judul.value : this.judul,
      deskripsi: data.deskripsi.present ? data.deskripsi.value : this.deskripsi,
      status: data.status.present ? data.status.value : this.status,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedTugasData(')
          ..write('id: $id, ')
          ..write('idKelas: $idKelas, ')
          ..write('idMapel: $idMapel, ')
          ..write('idGuru: $idGuru, ')
          ..write('judul: $judul, ')
          ..write('deskripsi: $deskripsi, ')
          ..write('status: $status, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idKelas,
    idMapel,
    idGuru,
    judul,
    deskripsi,
    status,
    deadline,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedTugasData &&
          other.id == this.id &&
          other.idKelas == this.idKelas &&
          other.idMapel == this.idMapel &&
          other.idGuru == this.idGuru &&
          other.judul == this.judul &&
          other.deskripsi == this.deskripsi &&
          other.status == this.status &&
          other.deadline == this.deadline &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedTugasCompanion extends UpdateCompanion<CachedTugasData> {
  final Value<String> id;
  final Value<String> idKelas;
  final Value<String> idMapel;
  final Value<String> idGuru;
  final Value<String> judul;
  final Value<String> deskripsi;
  final Value<String> status;
  final Value<DateTime> deadline;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedTugasCompanion({
    this.id = const Value.absent(),
    this.idKelas = const Value.absent(),
    this.idMapel = const Value.absent(),
    this.idGuru = const Value.absent(),
    this.judul = const Value.absent(),
    this.deskripsi = const Value.absent(),
    this.status = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedTugasCompanion.insert({
    required String id,
    required String idKelas,
    required String idMapel,
    required String idGuru,
    required String judul,
    required String deskripsi,
    this.status = const Value.absent(),
    required DateTime deadline,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idKelas = Value(idKelas),
       idMapel = Value(idMapel),
       idGuru = Value(idGuru),
       judul = Value(judul),
       deskripsi = Value(deskripsi),
       deadline = Value(deadline),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedTugasData> custom({
    Expression<String>? id,
    Expression<String>? idKelas,
    Expression<String>? idMapel,
    Expression<String>? idGuru,
    Expression<String>? judul,
    Expression<String>? deskripsi,
    Expression<String>? status,
    Expression<DateTime>? deadline,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idKelas != null) 'id_kelas': idKelas,
      if (idMapel != null) 'id_mapel': idMapel,
      if (idGuru != null) 'id_guru': idGuru,
      if (judul != null) 'judul': judul,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (status != null) 'status': status,
      if (deadline != null) 'deadline': deadline,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedTugasCompanion copyWith({
    Value<String>? id,
    Value<String>? idKelas,
    Value<String>? idMapel,
    Value<String>? idGuru,
    Value<String>? judul,
    Value<String>? deskripsi,
    Value<String>? status,
    Value<DateTime>? deadline,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedTugasCompanion(
      id: id ?? this.id,
      idKelas: idKelas ?? this.idKelas,
      idMapel: idMapel ?? this.idMapel,
      idGuru: idGuru ?? this.idGuru,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
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
    if (idKelas.present) {
      map['id_kelas'] = Variable<String>(idKelas.value);
    }
    if (idMapel.present) {
      map['id_mapel'] = Variable<String>(idMapel.value);
    }
    if (idGuru.present) {
      map['id_guru'] = Variable<String>(idGuru.value);
    }
    if (judul.present) {
      map['judul'] = Variable<String>(judul.value);
    }
    if (deskripsi.present) {
      map['deskripsi'] = Variable<String>(deskripsi.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
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
    return (StringBuffer('CachedTugasCompanion(')
          ..write('id: $id, ')
          ..write('idKelas: $idKelas, ')
          ..write('idMapel: $idMapel, ')
          ..write('idGuru: $idGuru, ')
          ..write('judul: $judul, ')
          ..write('deskripsi: $deskripsi, ')
          ..write('status: $status, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPengumpulanTable extends CachedPengumpulan
    with TableInfo<$CachedPengumpulanTable, CachedPengumpulanData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPengumpulanTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tugasIdMeta = const VerificationMeta(
    'tugasId',
  );
  @override
  late final GeneratedColumn<String> tugasId = GeneratedColumn<String>(
    'tugas_id',
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Terkumpul'),
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
    tugasId,
    siswaId,
    status,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_pengumpulan';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPengumpulanData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tugas_id')) {
      context.handle(
        _tugasIdMeta,
        tugasId.isAcceptableOrUnknown(data['tugas_id']!, _tugasIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tugasIdMeta);
    }
    if (data.containsKey('siswa_id')) {
      context.handle(
        _siswaIdMeta,
        siswaId.isAcceptableOrUnknown(data['siswa_id']!, _siswaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siswaIdMeta);
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
  CachedPengumpulanData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPengumpulanData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tugasId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tugas_id'],
      )!,
      siswaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}siswa_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
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
  $CachedPengumpulanTable createAlias(String alias) {
    return $CachedPengumpulanTable(attachedDatabase, alias);
  }
}

class CachedPengumpulanData extends DataClass
    implements Insertable<CachedPengumpulanData> {
  final String id;
  final String tugasId;
  final String siswaId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedPengumpulanData({
    required this.id,
    required this.tugasId,
    required this.siswaId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tugas_id'] = Variable<String>(tugasId);
    map['siswa_id'] = Variable<String>(siswaId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedPengumpulanCompanion toCompanion(bool nullToAbsent) {
    return CachedPengumpulanCompanion(
      id: Value(id),
      tugasId: Value(tugasId),
      siswaId: Value(siswaId),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedPengumpulanData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPengumpulanData(
      id: serializer.fromJson<String>(json['id']),
      tugasId: serializer.fromJson<String>(json['tugasId']),
      siswaId: serializer.fromJson<String>(json['siswaId']),
      status: serializer.fromJson<String>(json['status']),
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
      'tugasId': serializer.toJson<String>(tugasId),
      'siswaId': serializer.toJson<String>(siswaId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedPengumpulanData copyWith({
    String? id,
    String? tugasId,
    String? siswaId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedPengumpulanData(
    id: id ?? this.id,
    tugasId: tugasId ?? this.tugasId,
    siswaId: siswaId ?? this.siswaId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedPengumpulanData copyWithCompanion(CachedPengumpulanCompanion data) {
    return CachedPengumpulanData(
      id: data.id.present ? data.id.value : this.id,
      tugasId: data.tugasId.present ? data.tugasId.value : this.tugasId,
      siswaId: data.siswaId.present ? data.siswaId.value : this.siswaId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPengumpulanData(')
          ..write('id: $id, ')
          ..write('tugasId: $tugasId, ')
          ..write('siswaId: $siswaId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tugasId, siswaId, status, createdAt, updatedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPengumpulanData &&
          other.id == this.id &&
          other.tugasId == this.tugasId &&
          other.siswaId == this.siswaId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedPengumpulanCompanion
    extends UpdateCompanion<CachedPengumpulanData> {
  final Value<String> id;
  final Value<String> tugasId;
  final Value<String> siswaId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedPengumpulanCompanion({
    this.id = const Value.absent(),
    this.tugasId = const Value.absent(),
    this.siswaId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPengumpulanCompanion.insert({
    required String id,
    required String tugasId,
    required String siswaId,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tugasId = Value(tugasId),
       siswaId = Value(siswaId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedPengumpulanData> custom({
    Expression<String>? id,
    Expression<String>? tugasId,
    Expression<String>? siswaId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tugasId != null) 'tugas_id': tugasId,
      if (siswaId != null) 'siswa_id': siswaId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPengumpulanCompanion copyWith({
    Value<String>? id,
    Value<String>? tugasId,
    Value<String>? siswaId,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedPengumpulanCompanion(
      id: id ?? this.id,
      tugasId: tugasId ?? this.tugasId,
      siswaId: siswaId ?? this.siswaId,
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
    if (tugasId.present) {
      map['tugas_id'] = Variable<String>(tugasId.value);
    }
    if (siswaId.present) {
      map['siswa_id'] = Variable<String>(siswaId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
    return (StringBuffer('CachedPengumpulanCompanion(')
          ..write('id: $id, ')
          ..write('tugasId: $tugasId, ')
          ..write('siswaId: $siswaId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedMateriTable extends CachedMateri
    with TableInfo<$CachedMateriTable, CachedMateriData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedMateriTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _idGuruMeta = const VerificationMeta('idGuru');
  @override
  late final GeneratedColumn<String> idGuru = GeneratedColumn<String>(
    'id_guru',
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
  static const VerificationMeta _deskripsiMeta = const VerificationMeta(
    'deskripsi',
  );
  @override
  late final GeneratedColumn<String> deskripsi = GeneratedColumn<String>(
    'deskripsi',
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
    idKelas,
    idMapel,
    idGuru,
    judul,
    deskripsi,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_materi';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMateriData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('id_guru')) {
      context.handle(
        _idGuruMeta,
        idGuru.isAcceptableOrUnknown(data['id_guru']!, _idGuruMeta),
      );
    } else if (isInserting) {
      context.missing(_idGuruMeta);
    }
    if (data.containsKey('judul')) {
      context.handle(
        _judulMeta,
        judul.isAcceptableOrUnknown(data['judul']!, _judulMeta),
      );
    } else if (isInserting) {
      context.missing(_judulMeta);
    }
    if (data.containsKey('deskripsi')) {
      context.handle(
        _deskripsiMeta,
        deskripsi.isAcceptableOrUnknown(data['deskripsi']!, _deskripsiMeta),
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
  CachedMateriData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMateriData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idKelas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_kelas'],
      )!,
      idMapel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_mapel'],
      )!,
      idGuru: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_guru'],
      )!,
      judul: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}judul'],
      )!,
      deskripsi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deskripsi'],
      ),
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
  $CachedMateriTable createAlias(String alias) {
    return $CachedMateriTable(attachedDatabase, alias);
  }
}

class CachedMateriData extends DataClass
    implements Insertable<CachedMateriData> {
  final String id;
  final String idKelas;
  final String idMapel;
  final String idGuru;
  final String judul;
  final String? deskripsi;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedMateriData({
    required this.id,
    required this.idKelas,
    required this.idMapel,
    required this.idGuru,
    required this.judul,
    this.deskripsi,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_kelas'] = Variable<String>(idKelas);
    map['id_mapel'] = Variable<String>(idMapel);
    map['id_guru'] = Variable<String>(idGuru);
    map['judul'] = Variable<String>(judul);
    if (!nullToAbsent || deskripsi != null) {
      map['deskripsi'] = Variable<String>(deskripsi);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedMateriCompanion toCompanion(bool nullToAbsent) {
    return CachedMateriCompanion(
      id: Value(id),
      idKelas: Value(idKelas),
      idMapel: Value(idMapel),
      idGuru: Value(idGuru),
      judul: Value(judul),
      deskripsi: deskripsi == null && nullToAbsent
          ? const Value.absent()
          : Value(deskripsi),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedMateriData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMateriData(
      id: serializer.fromJson<String>(json['id']),
      idKelas: serializer.fromJson<String>(json['idKelas']),
      idMapel: serializer.fromJson<String>(json['idMapel']),
      idGuru: serializer.fromJson<String>(json['idGuru']),
      judul: serializer.fromJson<String>(json['judul']),
      deskripsi: serializer.fromJson<String?>(json['deskripsi']),
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
      'idKelas': serializer.toJson<String>(idKelas),
      'idMapel': serializer.toJson<String>(idMapel),
      'idGuru': serializer.toJson<String>(idGuru),
      'judul': serializer.toJson<String>(judul),
      'deskripsi': serializer.toJson<String?>(deskripsi),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedMateriData copyWith({
    String? id,
    String? idKelas,
    String? idMapel,
    String? idGuru,
    String? judul,
    Value<String?> deskripsi = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedMateriData(
    id: id ?? this.id,
    idKelas: idKelas ?? this.idKelas,
    idMapel: idMapel ?? this.idMapel,
    idGuru: idGuru ?? this.idGuru,
    judul: judul ?? this.judul,
    deskripsi: deskripsi.present ? deskripsi.value : this.deskripsi,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedMateriData copyWithCompanion(CachedMateriCompanion data) {
    return CachedMateriData(
      id: data.id.present ? data.id.value : this.id,
      idKelas: data.idKelas.present ? data.idKelas.value : this.idKelas,
      idMapel: data.idMapel.present ? data.idMapel.value : this.idMapel,
      idGuru: data.idGuru.present ? data.idGuru.value : this.idGuru,
      judul: data.judul.present ? data.judul.value : this.judul,
      deskripsi: data.deskripsi.present ? data.deskripsi.value : this.deskripsi,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMateriData(')
          ..write('id: $id, ')
          ..write('idKelas: $idKelas, ')
          ..write('idMapel: $idMapel, ')
          ..write('idGuru: $idGuru, ')
          ..write('judul: $judul, ')
          ..write('deskripsi: $deskripsi, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idKelas,
    idMapel,
    idGuru,
    judul,
    deskripsi,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMateriData &&
          other.id == this.id &&
          other.idKelas == this.idKelas &&
          other.idMapel == this.idMapel &&
          other.idGuru == this.idGuru &&
          other.judul == this.judul &&
          other.deskripsi == this.deskripsi &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedMateriCompanion extends UpdateCompanion<CachedMateriData> {
  final Value<String> id;
  final Value<String> idKelas;
  final Value<String> idMapel;
  final Value<String> idGuru;
  final Value<String> judul;
  final Value<String?> deskripsi;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedMateriCompanion({
    this.id = const Value.absent(),
    this.idKelas = const Value.absent(),
    this.idMapel = const Value.absent(),
    this.idGuru = const Value.absent(),
    this.judul = const Value.absent(),
    this.deskripsi = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedMateriCompanion.insert({
    required String id,
    required String idKelas,
    required String idMapel,
    required String idGuru,
    required String judul,
    this.deskripsi = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idKelas = Value(idKelas),
       idMapel = Value(idMapel),
       idGuru = Value(idGuru),
       judul = Value(judul),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedMateriData> custom({
    Expression<String>? id,
    Expression<String>? idKelas,
    Expression<String>? idMapel,
    Expression<String>? idGuru,
    Expression<String>? judul,
    Expression<String>? deskripsi,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idKelas != null) 'id_kelas': idKelas,
      if (idMapel != null) 'id_mapel': idMapel,
      if (idGuru != null) 'id_guru': idGuru,
      if (judul != null) 'judul': judul,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedMateriCompanion copyWith({
    Value<String>? id,
    Value<String>? idKelas,
    Value<String>? idMapel,
    Value<String>? idGuru,
    Value<String>? judul,
    Value<String?>? deskripsi,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedMateriCompanion(
      id: id ?? this.id,
      idKelas: idKelas ?? this.idKelas,
      idMapel: idMapel ?? this.idMapel,
      idGuru: idGuru ?? this.idGuru,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
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
    if (idKelas.present) {
      map['id_kelas'] = Variable<String>(idKelas.value);
    }
    if (idMapel.present) {
      map['id_mapel'] = Variable<String>(idMapel.value);
    }
    if (idGuru.present) {
      map['id_guru'] = Variable<String>(idGuru.value);
    }
    if (judul.present) {
      map['judul'] = Variable<String>(judul.value);
    }
    if (deskripsi.present) {
      map['deskripsi'] = Variable<String>(deskripsi.value);
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
    return (StringBuffer('CachedMateriCompanion(')
          ..write('id: $id, ')
          ..write('idKelas: $idKelas, ')
          ..write('idMapel: $idMapel, ')
          ..write('idGuru: $idGuru, ')
          ..write('judul: $judul, ')
          ..write('deskripsi: $deskripsi, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedMateriFilesTable extends CachedMateriFiles
    with TableInfo<$CachedMateriFilesTable, CachedMateriFilesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedMateriFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idMateriMeta = const VerificationMeta(
    'idMateri',
  );
  @override
  late final GeneratedColumn<int> idMateri = GeneratedColumn<int>(
    'id_materi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idFilesMeta = const VerificationMeta(
    'idFiles',
  );
  @override
  late final GeneratedColumn<int> idFiles = GeneratedColumn<int>(
    'id_files',
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
    idMateri,
    idFiles,
    createdAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_materi_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMateriFilesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_materi')) {
      context.handle(
        _idMateriMeta,
        idMateri.isAcceptableOrUnknown(data['id_materi']!, _idMateriMeta),
      );
    } else if (isInserting) {
      context.missing(_idMateriMeta);
    }
    if (data.containsKey('id_files')) {
      context.handle(
        _idFilesMeta,
        idFiles.isAcceptableOrUnknown(data['id_files']!, _idFilesMeta),
      );
    } else if (isInserting) {
      context.missing(_idFilesMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  CachedMateriFilesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMateriFilesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idMateri: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_materi'],
      )!,
      idFiles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_files'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CachedMateriFilesTable createAlias(String alias) {
    return $CachedMateriFilesTable(attachedDatabase, alias);
  }
}

class CachedMateriFilesData extends DataClass
    implements Insertable<CachedMateriFilesData> {
  final String id;
  final int idMateri;
  final int idFiles;
  final DateTime createdAt;
  final DateTime? syncedAt;
  const CachedMateriFilesData({
    required this.id,
    required this.idMateri,
    required this.idFiles,
    required this.createdAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_materi'] = Variable<int>(idMateri);
    map['id_files'] = Variable<int>(idFiles);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedMateriFilesCompanion toCompanion(bool nullToAbsent) {
    return CachedMateriFilesCompanion(
      id: Value(id),
      idMateri: Value(idMateri),
      idFiles: Value(idFiles),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedMateriFilesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMateriFilesData(
      id: serializer.fromJson<String>(json['id']),
      idMateri: serializer.fromJson<int>(json['idMateri']),
      idFiles: serializer.fromJson<int>(json['idFiles']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idMateri': serializer.toJson<int>(idMateri),
      'idFiles': serializer.toJson<int>(idFiles),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedMateriFilesData copyWith({
    String? id,
    int? idMateri,
    int? idFiles,
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedMateriFilesData(
    id: id ?? this.id,
    idMateri: idMateri ?? this.idMateri,
    idFiles: idFiles ?? this.idFiles,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedMateriFilesData copyWithCompanion(CachedMateriFilesCompanion data) {
    return CachedMateriFilesData(
      id: data.id.present ? data.id.value : this.id,
      idMateri: data.idMateri.present ? data.idMateri.value : this.idMateri,
      idFiles: data.idFiles.present ? data.idFiles.value : this.idFiles,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMateriFilesData(')
          ..write('id: $id, ')
          ..write('idMateri: $idMateri, ')
          ..write('idFiles: $idFiles, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idMateri, idFiles, createdAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMateriFilesData &&
          other.id == this.id &&
          other.idMateri == this.idMateri &&
          other.idFiles == this.idFiles &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class CachedMateriFilesCompanion
    extends UpdateCompanion<CachedMateriFilesData> {
  final Value<String> id;
  final Value<int> idMateri;
  final Value<int> idFiles;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedMateriFilesCompanion({
    this.id = const Value.absent(),
    this.idMateri = const Value.absent(),
    this.idFiles = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedMateriFilesCompanion.insert({
    required String id,
    required int idMateri,
    required int idFiles,
    required DateTime createdAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idMateri = Value(idMateri),
       idFiles = Value(idFiles),
       createdAt = Value(createdAt);
  static Insertable<CachedMateriFilesData> custom({
    Expression<String>? id,
    Expression<int>? idMateri,
    Expression<int>? idFiles,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idMateri != null) 'id_materi': idMateri,
      if (idFiles != null) 'id_files': idFiles,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedMateriFilesCompanion copyWith({
    Value<String>? id,
    Value<int>? idMateri,
    Value<int>? idFiles,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedMateriFilesCompanion(
      id: id ?? this.id,
      idMateri: idMateri ?? this.idMateri,
      idFiles: idFiles ?? this.idFiles,
      createdAt: createdAt ?? this.createdAt,
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
    if (idMateri.present) {
      map['id_materi'] = Variable<int>(idMateri.value);
    }
    if (idFiles.present) {
      map['id_files'] = Variable<int>(idFiles.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('CachedMateriFilesCompanion(')
          ..write('id: $id, ')
          ..write('idMateri: $idMateri, ')
          ..write('idFiles: $idFiles, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedQuizTable extends CachedQuiz
    with TableInfo<$CachedQuizTable, CachedQuizData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedQuizTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _idGuruMeta = const VerificationMeta('idGuru');
  @override
  late final GeneratedColumn<String> idGuru = GeneratedColumn<String>(
    'id_guru',
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
  static const VerificationMeta _waktuMeta = const VerificationMeta('waktu');
  @override
  late final GeneratedColumn<int> waktu = GeneratedColumn<int>(
    'waktu',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
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
    idKelas,
    idMapel,
    idGuru,
    judul,
    waktu,
    deadline,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_quiz';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedQuizData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('id_guru')) {
      context.handle(
        _idGuruMeta,
        idGuru.isAcceptableOrUnknown(data['id_guru']!, _idGuruMeta),
      );
    } else if (isInserting) {
      context.missing(_idGuruMeta);
    }
    if (data.containsKey('judul')) {
      context.handle(
        _judulMeta,
        judul.isAcceptableOrUnknown(data['judul']!, _judulMeta),
      );
    } else if (isInserting) {
      context.missing(_judulMeta);
    }
    if (data.containsKey('waktu')) {
      context.handle(
        _waktuMeta,
        waktu.isAcceptableOrUnknown(data['waktu']!, _waktuMeta),
      );
    } else if (isInserting) {
      context.missing(_waktuMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    } else if (isInserting) {
      context.missing(_deadlineMeta);
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
  CachedQuizData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedQuizData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idKelas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_kelas'],
      )!,
      idMapel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_mapel'],
      )!,
      idGuru: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_guru'],
      )!,
      judul: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}judul'],
      )!,
      waktu: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}waktu'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
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
  $CachedQuizTable createAlias(String alias) {
    return $CachedQuizTable(attachedDatabase, alias);
  }
}

class CachedQuizData extends DataClass implements Insertable<CachedQuizData> {
  final String id;
  final String idKelas;
  final String idMapel;
  final String idGuru;
  final String judul;
  final int waktu;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedQuizData({
    required this.id,
    required this.idKelas,
    required this.idMapel,
    required this.idGuru,
    required this.judul,
    required this.waktu,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_kelas'] = Variable<String>(idKelas);
    map['id_mapel'] = Variable<String>(idMapel);
    map['id_guru'] = Variable<String>(idGuru);
    map['judul'] = Variable<String>(judul);
    map['waktu'] = Variable<int>(waktu);
    map['deadline'] = Variable<DateTime>(deadline);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedQuizCompanion toCompanion(bool nullToAbsent) {
    return CachedQuizCompanion(
      id: Value(id),
      idKelas: Value(idKelas),
      idMapel: Value(idMapel),
      idGuru: Value(idGuru),
      judul: Value(judul),
      waktu: Value(waktu),
      deadline: Value(deadline),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedQuizData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedQuizData(
      id: serializer.fromJson<String>(json['id']),
      idKelas: serializer.fromJson<String>(json['idKelas']),
      idMapel: serializer.fromJson<String>(json['idMapel']),
      idGuru: serializer.fromJson<String>(json['idGuru']),
      judul: serializer.fromJson<String>(json['judul']),
      waktu: serializer.fromJson<int>(json['waktu']),
      deadline: serializer.fromJson<DateTime>(json['deadline']),
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
      'idKelas': serializer.toJson<String>(idKelas),
      'idMapel': serializer.toJson<String>(idMapel),
      'idGuru': serializer.toJson<String>(idGuru),
      'judul': serializer.toJson<String>(judul),
      'waktu': serializer.toJson<int>(waktu),
      'deadline': serializer.toJson<DateTime>(deadline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedQuizData copyWith({
    String? id,
    String? idKelas,
    String? idMapel,
    String? idGuru,
    String? judul,
    int? waktu,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedQuizData(
    id: id ?? this.id,
    idKelas: idKelas ?? this.idKelas,
    idMapel: idMapel ?? this.idMapel,
    idGuru: idGuru ?? this.idGuru,
    judul: judul ?? this.judul,
    waktu: waktu ?? this.waktu,
    deadline: deadline ?? this.deadline,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedQuizData copyWithCompanion(CachedQuizCompanion data) {
    return CachedQuizData(
      id: data.id.present ? data.id.value : this.id,
      idKelas: data.idKelas.present ? data.idKelas.value : this.idKelas,
      idMapel: data.idMapel.present ? data.idMapel.value : this.idMapel,
      idGuru: data.idGuru.present ? data.idGuru.value : this.idGuru,
      judul: data.judul.present ? data.judul.value : this.judul,
      waktu: data.waktu.present ? data.waktu.value : this.waktu,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedQuizData(')
          ..write('id: $id, ')
          ..write('idKelas: $idKelas, ')
          ..write('idMapel: $idMapel, ')
          ..write('idGuru: $idGuru, ')
          ..write('judul: $judul, ')
          ..write('waktu: $waktu, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idKelas,
    idMapel,
    idGuru,
    judul,
    waktu,
    deadline,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedQuizData &&
          other.id == this.id &&
          other.idKelas == this.idKelas &&
          other.idMapel == this.idMapel &&
          other.idGuru == this.idGuru &&
          other.judul == this.judul &&
          other.waktu == this.waktu &&
          other.deadline == this.deadline &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedQuizCompanion extends UpdateCompanion<CachedQuizData> {
  final Value<String> id;
  final Value<String> idKelas;
  final Value<String> idMapel;
  final Value<String> idGuru;
  final Value<String> judul;
  final Value<int> waktu;
  final Value<DateTime> deadline;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedQuizCompanion({
    this.id = const Value.absent(),
    this.idKelas = const Value.absent(),
    this.idMapel = const Value.absent(),
    this.idGuru = const Value.absent(),
    this.judul = const Value.absent(),
    this.waktu = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedQuizCompanion.insert({
    required String id,
    required String idKelas,
    required String idMapel,
    required String idGuru,
    required String judul,
    required int waktu,
    required DateTime deadline,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idKelas = Value(idKelas),
       idMapel = Value(idMapel),
       idGuru = Value(idGuru),
       judul = Value(judul),
       waktu = Value(waktu),
       deadline = Value(deadline),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedQuizData> custom({
    Expression<String>? id,
    Expression<String>? idKelas,
    Expression<String>? idMapel,
    Expression<String>? idGuru,
    Expression<String>? judul,
    Expression<int>? waktu,
    Expression<DateTime>? deadline,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idKelas != null) 'id_kelas': idKelas,
      if (idMapel != null) 'id_mapel': idMapel,
      if (idGuru != null) 'id_guru': idGuru,
      if (judul != null) 'judul': judul,
      if (waktu != null) 'waktu': waktu,
      if (deadline != null) 'deadline': deadline,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedQuizCompanion copyWith({
    Value<String>? id,
    Value<String>? idKelas,
    Value<String>? idMapel,
    Value<String>? idGuru,
    Value<String>? judul,
    Value<int>? waktu,
    Value<DateTime>? deadline,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedQuizCompanion(
      id: id ?? this.id,
      idKelas: idKelas ?? this.idKelas,
      idMapel: idMapel ?? this.idMapel,
      idGuru: idGuru ?? this.idGuru,
      judul: judul ?? this.judul,
      waktu: waktu ?? this.waktu,
      deadline: deadline ?? this.deadline,
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
    if (idKelas.present) {
      map['id_kelas'] = Variable<String>(idKelas.value);
    }
    if (idMapel.present) {
      map['id_mapel'] = Variable<String>(idMapel.value);
    }
    if (idGuru.present) {
      map['id_guru'] = Variable<String>(idGuru.value);
    }
    if (judul.present) {
      map['judul'] = Variable<String>(judul.value);
    }
    if (waktu.present) {
      map['waktu'] = Variable<int>(waktu.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
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
    return (StringBuffer('CachedQuizCompanion(')
          ..write('id: $id, ')
          ..write('idKelas: $idKelas, ')
          ..write('idMapel: $idMapel, ')
          ..write('idGuru: $idGuru, ')
          ..write('judul: $judul, ')
          ..write('waktu: $waktu, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedQuizSoalTable extends CachedQuizSoal
    with TableInfo<$CachedQuizSoalTable, CachedQuizSoalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedQuizSoalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
    'quiz_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soalMeta = const VerificationMeta('soal');
  @override
  late final GeneratedColumn<String> soal = GeneratedColumn<String>(
    'soal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipeJawabanMeta = const VerificationMeta(
    'tipeJawaban',
  );
  @override
  late final GeneratedColumn<String> tipeJawaban = GeneratedColumn<String>(
    'tipe_jawaban',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poinMeta = const VerificationMeta('poin');
  @override
  late final GeneratedColumn<int> poin = GeneratedColumn<int>(
    'poin',
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
    quizId,
    soal,
    tipeJawaban,
    poin,
    createdAt,
    updatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_quiz_soal';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedQuizSoalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quiz_id')) {
      context.handle(
        _quizIdMeta,
        quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('soal')) {
      context.handle(
        _soalMeta,
        soal.isAcceptableOrUnknown(data['soal']!, _soalMeta),
      );
    } else if (isInserting) {
      context.missing(_soalMeta);
    }
    if (data.containsKey('tipe_jawaban')) {
      context.handle(
        _tipeJawabanMeta,
        tipeJawaban.isAcceptableOrUnknown(
          data['tipe_jawaban']!,
          _tipeJawabanMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipeJawabanMeta);
    }
    if (data.containsKey('poin')) {
      context.handle(
        _poinMeta,
        poin.isAcceptableOrUnknown(data['poin']!, _poinMeta),
      );
    } else if (isInserting) {
      context.missing(_poinMeta);
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
  CachedQuizSoalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedQuizSoalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quizId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_id'],
      )!,
      soal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}soal'],
      )!,
      tipeJawaban: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipe_jawaban'],
      )!,
      poin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}poin'],
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
  $CachedQuizSoalTable createAlias(String alias) {
    return $CachedQuizSoalTable(attachedDatabase, alias);
  }
}

class CachedQuizSoalData extends DataClass
    implements Insertable<CachedQuizSoalData> {
  final String id;
  final String quizId;
  final String soal;
  final String tipeJawaban;
  final int poin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedQuizSoalData({
    required this.id,
    required this.quizId,
    required this.soal,
    required this.tipeJawaban,
    required this.poin,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quiz_id'] = Variable<String>(quizId);
    map['soal'] = Variable<String>(soal);
    map['tipe_jawaban'] = Variable<String>(tipeJawaban);
    map['poin'] = Variable<int>(poin);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedQuizSoalCompanion toCompanion(bool nullToAbsent) {
    return CachedQuizSoalCompanion(
      id: Value(id),
      quizId: Value(quizId),
      soal: Value(soal),
      tipeJawaban: Value(tipeJawaban),
      poin: Value(poin),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedQuizSoalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedQuizSoalData(
      id: serializer.fromJson<String>(json['id']),
      quizId: serializer.fromJson<String>(json['quizId']),
      soal: serializer.fromJson<String>(json['soal']),
      tipeJawaban: serializer.fromJson<String>(json['tipeJawaban']),
      poin: serializer.fromJson<int>(json['poin']),
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
      'quizId': serializer.toJson<String>(quizId),
      'soal': serializer.toJson<String>(soal),
      'tipeJawaban': serializer.toJson<String>(tipeJawaban),
      'poin': serializer.toJson<int>(poin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedQuizSoalData copyWith({
    String? id,
    String? quizId,
    String? soal,
    String? tipeJawaban,
    int? poin,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedQuizSoalData(
    id: id ?? this.id,
    quizId: quizId ?? this.quizId,
    soal: soal ?? this.soal,
    tipeJawaban: tipeJawaban ?? this.tipeJawaban,
    poin: poin ?? this.poin,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedQuizSoalData copyWithCompanion(CachedQuizSoalCompanion data) {
    return CachedQuizSoalData(
      id: data.id.present ? data.id.value : this.id,
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      soal: data.soal.present ? data.soal.value : this.soal,
      tipeJawaban: data.tipeJawaban.present
          ? data.tipeJawaban.value
          : this.tipeJawaban,
      poin: data.poin.present ? data.poin.value : this.poin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedQuizSoalData(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('soal: $soal, ')
          ..write('tipeJawaban: $tipeJawaban, ')
          ..write('poin: $poin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quizId,
    soal,
    tipeJawaban,
    poin,
    createdAt,
    updatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedQuizSoalData &&
          other.id == this.id &&
          other.quizId == this.quizId &&
          other.soal == this.soal &&
          other.tipeJawaban == this.tipeJawaban &&
          other.poin == this.poin &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedQuizSoalCompanion extends UpdateCompanion<CachedQuizSoalData> {
  final Value<String> id;
  final Value<String> quizId;
  final Value<String> soal;
  final Value<String> tipeJawaban;
  final Value<int> poin;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedQuizSoalCompanion({
    this.id = const Value.absent(),
    this.quizId = const Value.absent(),
    this.soal = const Value.absent(),
    this.tipeJawaban = const Value.absent(),
    this.poin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedQuizSoalCompanion.insert({
    required String id,
    required String quizId,
    required String soal,
    required String tipeJawaban,
    required int poin,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quizId = Value(quizId),
       soal = Value(soal),
       tipeJawaban = Value(tipeJawaban),
       poin = Value(poin),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedQuizSoalData> custom({
    Expression<String>? id,
    Expression<String>? quizId,
    Expression<String>? soal,
    Expression<String>? tipeJawaban,
    Expression<int>? poin,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quizId != null) 'quiz_id': quizId,
      if (soal != null) 'soal': soal,
      if (tipeJawaban != null) 'tipe_jawaban': tipeJawaban,
      if (poin != null) 'poin': poin,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedQuizSoalCompanion copyWith({
    Value<String>? id,
    Value<String>? quizId,
    Value<String>? soal,
    Value<String>? tipeJawaban,
    Value<int>? poin,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedQuizSoalCompanion(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      soal: soal ?? this.soal,
      tipeJawaban: tipeJawaban ?? this.tipeJawaban,
      poin: poin ?? this.poin,
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
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (soal.present) {
      map['soal'] = Variable<String>(soal.value);
    }
    if (tipeJawaban.present) {
      map['tipe_jawaban'] = Variable<String>(tipeJawaban.value);
    }
    if (poin.present) {
      map['poin'] = Variable<int>(poin.value);
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
    return (StringBuffer('CachedQuizSoalCompanion(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('soal: $soal, ')
          ..write('tipeJawaban: $tipeJawaban, ')
          ..write('poin: $poin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedSettingsTable extends CachedSettings
    with TableInfo<$CachedSettingsTable, CachedSettingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
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
  List<GeneratedColumn> get $columns => [key, value, updatedAt, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSettingsData> instance, {
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
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CachedSettingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSettingsData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
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
  $CachedSettingsTable createAlias(String alias) {
    return $CachedSettingsTable(attachedDatabase, alias);
  }
}

class CachedSettingsData extends DataClass
    implements Insertable<CachedSettingsData> {
  final String key;
  final String value;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const CachedSettingsData({
    required this.key,
    required this.value,
    required this.updatedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CachedSettingsCompanion toCompanion(bool nullToAbsent) {
    return CachedSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CachedSettingsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSettingsData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CachedSettingsData copyWith({
    String? key,
    String? value,
    DateTime? updatedAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => CachedSettingsData(
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  CachedSettingsData copyWithCompanion(CachedSettingsCompanion data) {
    return CachedSettingsData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSettingsData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSettingsData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class CachedSettingsCompanion extends UpdateCompanion<CachedSettingsData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CachedSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSettingsCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<CachedSettingsData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return CachedSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
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
    return (StringBuffer('CachedSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
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
  static const VerificationMeta _syncTableNameMeta = const VerificationMeta(
    'syncTableName',
  );
  @override
  late final GeneratedColumn<String> syncTableName = GeneratedColumn<String>(
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
    syncTableName,
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
        _syncTableNameMeta,
        syncTableName.isAcceptableOrUnknown(
          data['table_name']!,
          _syncTableNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncTableNameMeta);
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
      syncTableName: attachedDatabase.typeMapping.read(
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
  final String syncTableName;
  final String recordId;
  final String operation;
  final String? data;
  final DateTime createdAt;
  final bool synced;
  final DateTime? syncedAt;
  final String? errorMessage;
  const SyncQueueData({
    required this.id,
    required this.syncTableName,
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
    map['table_name'] = Variable<String>(syncTableName);
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
      syncTableName: Value(syncTableName),
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
      syncTableName: serializer.fromJson<String>(json['syncTableName']),
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
      'syncTableName': serializer.toJson<String>(syncTableName),
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
    String? syncTableName,
    String? recordId,
    String? operation,
    Value<String?> data = const Value.absent(),
    DateTime? createdAt,
    bool? synced,
    Value<DateTime?> syncedAt = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    syncTableName: syncTableName ?? this.syncTableName,
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
      syncTableName: data.syncTableName.present
          ? data.syncTableName.value
          : this.syncTableName,
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
          ..write('syncTableName: $syncTableName, ')
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
    syncTableName,
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
          other.syncTableName == this.syncTableName &&
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
  final Value<String> syncTableName;
  final Value<String> recordId;
  final Value<String> operation;
  final Value<String?> data;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  final Value<DateTime?> syncedAt;
  final Value<String?> errorMessage;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.syncTableName = const Value.absent(),
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
    required String syncTableName,
    required String recordId,
    required String operation,
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
  }) : syncTableName = Value(syncTableName),
       recordId = Value(recordId),
       operation = Value(operation);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? syncTableName,
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
      if (syncTableName != null) 'table_name': syncTableName,
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
    Value<String>? syncTableName,
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
      syncTableName: syncTableName ?? this.syncTableName,
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
    if (syncTableName.present) {
      map['table_name'] = Variable<String>(syncTableName.value);
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
          ..write('syncTableName: $syncTableName, ')
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
  late final $CachedFilesTable cachedFiles = $CachedFilesTable(this);
  late final $CachedAbsensiTable cachedAbsensi = $CachedAbsensiTable(this);
  late final $CachedTugasTable cachedTugas = $CachedTugasTable(this);
  late final $CachedPengumpulanTable cachedPengumpulan =
      $CachedPengumpulanTable(this);
  late final $CachedMateriTable cachedMateri = $CachedMateriTable(this);
  late final $CachedMateriFilesTable cachedMateriFiles =
      $CachedMateriFilesTable(this);
  late final $CachedQuizTable cachedQuiz = $CachedQuizTable(this);
  late final $CachedQuizSoalTable cachedQuizSoal = $CachedQuizSoalTable(this);
  late final $CachedSettingsTable cachedSettings = $CachedSettingsTable(this);
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
    cachedFiles,
    cachedAbsensi,
    cachedTugas,
    cachedPengumpulan,
    cachedMateri,
    cachedMateriFiles,
    cachedQuiz,
    cachedQuizSoal,
    cachedSettings,
    syncQueue,
  ];
}

typedef $$CachedKelasTableCreateCompanionBuilder =
    CachedKelasCompanion Function({
      required String id,
      required String namaKelas,
      required String guruId,
      required String namaGuru,
      required String jenjangKelas,
      required String nomorKelas,
      required String tahunAjaran,
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
      Value<String> namaGuru,
      Value<String> jenjangKelas,
      Value<String> nomorKelas,
      Value<String> tahunAjaran,
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

  ColumnFilters<String> get namaGuru => $composableBuilder(
    column: $table.namaGuru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jenjangKelas => $composableBuilder(
    column: $table.jenjangKelas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomorKelas => $composableBuilder(
    column: $table.nomorKelas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tahunAjaran => $composableBuilder(
    column: $table.tahunAjaran,
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

  ColumnOrderings<String> get namaGuru => $composableBuilder(
    column: $table.namaGuru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jenjangKelas => $composableBuilder(
    column: $table.jenjangKelas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomorKelas => $composableBuilder(
    column: $table.nomorKelas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tahunAjaran => $composableBuilder(
    column: $table.tahunAjaran,
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

  GeneratedColumn<String> get namaGuru =>
      $composableBuilder(column: $table.namaGuru, builder: (column) => column);

  GeneratedColumn<String> get jenjangKelas => $composableBuilder(
    column: $table.jenjangKelas,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nomorKelas => $composableBuilder(
    column: $table.nomorKelas,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tahunAjaran => $composableBuilder(
    column: $table.tahunAjaran,
    builder: (column) => column,
  );

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
          CachedKelasData,
          $$CachedKelasTableFilterComposer,
          $$CachedKelasTableOrderingComposer,
          $$CachedKelasTableAnnotationComposer,
          $$CachedKelasTableCreateCompanionBuilder,
          $$CachedKelasTableUpdateCompanionBuilder,
          (
            CachedKelasData,
            BaseReferences<_$AppDatabase, $CachedKelasTable, CachedKelasData>,
          ),
          CachedKelasData,
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
                Value<String> namaGuru = const Value.absent(),
                Value<String> jenjangKelas = const Value.absent(),
                Value<String> nomorKelas = const Value.absent(),
                Value<String> tahunAjaran = const Value.absent(),
                Value<bool> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedKelasCompanion(
                id: id,
                namaKelas: namaKelas,
                guruId: guruId,
                namaGuru: namaGuru,
                jenjangKelas: jenjangKelas,
                nomorKelas: nomorKelas,
                tahunAjaran: tahunAjaran,
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
                required String namaGuru,
                required String jenjangKelas,
                required String nomorKelas,
                required String tahunAjaran,
                Value<bool> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedKelasCompanion.insert(
                id: id,
                namaKelas: namaKelas,
                guruId: guruId,
                namaGuru: namaGuru,
                jenjangKelas: jenjangKelas,
                nomorKelas: nomorKelas,
                tahunAjaran: tahunAjaran,
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
      CachedKelasData,
      $$CachedKelasTableFilterComposer,
      $$CachedKelasTableOrderingComposer,
      $$CachedKelasTableAnnotationComposer,
      $$CachedKelasTableCreateCompanionBuilder,
      $$CachedKelasTableUpdateCompanionBuilder,
      (
        CachedKelasData,
        BaseReferences<_$AppDatabase, $CachedKelasTable, CachedKelasData>,
      ),
      CachedKelasData,
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
      required String hari,
      required String jam,
      required DateTime tanggal,
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
      Value<String> hari,
      Value<String> jam,
      Value<DateTime> tanggal,
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

  ColumnFilters<String> get hari => $composableBuilder(
    column: $table.hari,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jam => $composableBuilder(
    column: $table.jam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
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

  ColumnOrderings<String> get hari => $composableBuilder(
    column: $table.hari,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jam => $composableBuilder(
    column: $table.jam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
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

  GeneratedColumn<String> get hari =>
      $composableBuilder(column: $table.hari, builder: (column) => column);

  GeneratedColumn<String> get jam =>
      $composableBuilder(column: $table.jam, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

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
                Value<String> hari = const Value.absent(),
                Value<String> jam = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedKelasNgajarCompanion(
                id: id,
                idGuru: idGuru,
                idKelas: idKelas,
                idMapel: idMapel,
                hari: hari,
                jam: jam,
                tanggal: tanggal,
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
                required String hari,
                required String jam,
                required DateTime tanggal,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedKelasNgajarCompanion.insert(
                id: id,
                idGuru: idGuru,
                idKelas: idKelas,
                idMapel: idMapel,
                hari: hari,
                jam: jam,
                tanggal: tanggal,
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
      required String jenisKelamin,
      required String mataPelajaran,
      required String password,
      required String photoUrl,
      required String sekolah,
      required String status,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedGuruTableUpdateCompanionBuilder =
    CachedGuruCompanion Function({
      Value<String> id,
      Value<String> namaLengkap,
      Value<String> email,
      Value<int> nig,
      Value<String> jenisKelamin,
      Value<String> mataPelajaran,
      Value<String> password,
      Value<String> photoUrl,
      Value<String> sekolah,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
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

  ColumnFilters<String> get jenisKelamin => $composableBuilder(
    column: $table.jenisKelamin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mataPelajaran => $composableBuilder(
    column: $table.mataPelajaran,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sekolah => $composableBuilder(
    column: $table.sekolah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
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

  ColumnOrderings<String> get jenisKelamin => $composableBuilder(
    column: $table.jenisKelamin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mataPelajaran => $composableBuilder(
    column: $table.mataPelajaran,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sekolah => $composableBuilder(
    column: $table.sekolah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
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

  GeneratedColumn<String> get jenisKelamin => $composableBuilder(
    column: $table.jenisKelamin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mataPelajaran => $composableBuilder(
    column: $table.mataPelajaran,
    builder: (column) => column,
  );

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get sekolah =>
      $composableBuilder(column: $table.sekolah, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

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
                Value<String> jenisKelamin = const Value.absent(),
                Value<String> mataPelajaran = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> photoUrl = const Value.absent(),
                Value<String> sekolah = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedGuruCompanion(
                id: id,
                namaLengkap: namaLengkap,
                email: email,
                nig: nig,
                jenisKelamin: jenisKelamin,
                mataPelajaran: mataPelajaran,
                password: password,
                photoUrl: photoUrl,
                sekolah: sekolah,
                status: status,
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
                required String jenisKelamin,
                required String mataPelajaran,
                required String password,
                required String photoUrl,
                required String sekolah,
                required String status,
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedGuruCompanion.insert(
                id: id,
                namaLengkap: namaLengkap,
                email: email,
                nig: nig,
                jenisKelamin: jenisKelamin,
                mataPelajaran: mataPelajaran,
                password: password,
                photoUrl: photoUrl,
                sekolah: sekolah,
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
          CachedSiswaKelasData,
          $$CachedSiswaKelasTableFilterComposer,
          $$CachedSiswaKelasTableOrderingComposer,
          $$CachedSiswaKelasTableAnnotationComposer,
          $$CachedSiswaKelasTableCreateCompanionBuilder,
          $$CachedSiswaKelasTableUpdateCompanionBuilder,
          (
            CachedSiswaKelasData,
            BaseReferences<
              _$AppDatabase,
              $CachedSiswaKelasTable,
              CachedSiswaKelasData
            >,
          ),
          CachedSiswaKelasData,
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
      CachedSiswaKelasData,
      $$CachedSiswaKelasTableFilterComposer,
      $$CachedSiswaKelasTableOrderingComposer,
      $$CachedSiswaKelasTableAnnotationComposer,
      $$CachedSiswaKelasTableCreateCompanionBuilder,
      $$CachedSiswaKelasTableUpdateCompanionBuilder,
      (
        CachedSiswaKelasData,
        BaseReferences<
          _$AppDatabase,
          $CachedSiswaKelasTable,
          CachedSiswaKelasData
        >,
      ),
      CachedSiswaKelasData,
      PrefetchHooks Function()
    >;
typedef $$CachedFilesTableCreateCompanionBuilder =
    CachedFilesCompanion Function({
      required String id,
      required String driveFileId,
      required String mimeType,
      required String name,
      required int size,
      required String status,
      required DateTime uploadedAt,
      required String uploadedBy,
      Value<String?> webViewLink,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedFilesTableUpdateCompanionBuilder =
    CachedFilesCompanion Function({
      Value<String> id,
      Value<String> driveFileId,
      Value<String> mimeType,
      Value<String> name,
      Value<int> size,
      Value<String> status,
      Value<DateTime> uploadedAt,
      Value<String> uploadedBy,
      Value<String?> webViewLink,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedFilesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedFilesTable> {
  $$CachedFilesTableFilterComposer({
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

  ColumnFilters<String> get driveFileId => $composableBuilder(
    column: $table.driveFileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadedBy => $composableBuilder(
    column: $table.uploadedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get webViewLink => $composableBuilder(
    column: $table.webViewLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedFilesTable> {
  $$CachedFilesTableOrderingComposer({
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

  ColumnOrderings<String> get driveFileId => $composableBuilder(
    column: $table.driveFileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadedBy => $composableBuilder(
    column: $table.uploadedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get webViewLink => $composableBuilder(
    column: $table.webViewLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedFilesTable> {
  $$CachedFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get driveFileId => $composableBuilder(
    column: $table.driveFileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadedBy => $composableBuilder(
    column: $table.uploadedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get webViewLink => $composableBuilder(
    column: $table.webViewLink,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedFilesTable,
          CachedFilesData,
          $$CachedFilesTableFilterComposer,
          $$CachedFilesTableOrderingComposer,
          $$CachedFilesTableAnnotationComposer,
          $$CachedFilesTableCreateCompanionBuilder,
          $$CachedFilesTableUpdateCompanionBuilder,
          (
            CachedFilesData,
            BaseReferences<_$AppDatabase, $CachedFilesTable, CachedFilesData>,
          ),
          CachedFilesData,
          PrefetchHooks Function()
        > {
  $$CachedFilesTableTableManager(_$AppDatabase db, $CachedFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> driveFileId = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
                Value<String> uploadedBy = const Value.absent(),
                Value<String?> webViewLink = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedFilesCompanion(
                id: id,
                driveFileId: driveFileId,
                mimeType: mimeType,
                name: name,
                size: size,
                status: status,
                uploadedAt: uploadedAt,
                uploadedBy: uploadedBy,
                webViewLink: webViewLink,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String driveFileId,
                required String mimeType,
                required String name,
                required int size,
                required String status,
                required DateTime uploadedAt,
                required String uploadedBy,
                Value<String?> webViewLink = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedFilesCompanion.insert(
                id: id,
                driveFileId: driveFileId,
                mimeType: mimeType,
                name: name,
                size: size,
                status: status,
                uploadedAt: uploadedAt,
                uploadedBy: uploadedBy,
                webViewLink: webViewLink,
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

typedef $$CachedFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedFilesTable,
      CachedFilesData,
      $$CachedFilesTableFilterComposer,
      $$CachedFilesTableOrderingComposer,
      $$CachedFilesTableAnnotationComposer,
      $$CachedFilesTableCreateCompanionBuilder,
      $$CachedFilesTableUpdateCompanionBuilder,
      (
        CachedFilesData,
        BaseReferences<_$AppDatabase, $CachedFilesTable, CachedFilesData>,
      ),
      CachedFilesData,
      PrefetchHooks Function()
    >;
typedef $$CachedAbsensiTableCreateCompanionBuilder =
    CachedAbsensiCompanion Function({
      required String id,
      required String siswaId,
      required String kelasId,
      Value<String?> jadwalId,
      required String status,
      required String tipeAbsen,
      required String diabsenOleh,
      required DateTime tanggal,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedAbsensiTableUpdateCompanionBuilder =
    CachedAbsensiCompanion Function({
      Value<String> id,
      Value<String> siswaId,
      Value<String> kelasId,
      Value<String?> jadwalId,
      Value<String> status,
      Value<String> tipeAbsen,
      Value<String> diabsenOleh,
      Value<DateTime> tanggal,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedAbsensiTableFilterComposer
    extends Composer<_$AppDatabase, $CachedAbsensiTable> {
  $$CachedAbsensiTableFilterComposer({
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

  ColumnFilters<String> get jadwalId => $composableBuilder(
    column: $table.jadwalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipeAbsen => $composableBuilder(
    column: $table.tipeAbsen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diabsenOleh => $composableBuilder(
    column: $table.diabsenOleh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
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

class $$CachedAbsensiTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedAbsensiTable> {
  $$CachedAbsensiTableOrderingComposer({
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

  ColumnOrderings<String> get jadwalId => $composableBuilder(
    column: $table.jadwalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipeAbsen => $composableBuilder(
    column: $table.tipeAbsen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diabsenOleh => $composableBuilder(
    column: $table.diabsenOleh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
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

class $$CachedAbsensiTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedAbsensiTable> {
  $$CachedAbsensiTableAnnotationComposer({
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

  GeneratedColumn<String> get jadwalId =>
      $composableBuilder(column: $table.jadwalId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get tipeAbsen =>
      $composableBuilder(column: $table.tipeAbsen, builder: (column) => column);

  GeneratedColumn<String> get diabsenOleh => $composableBuilder(
    column: $table.diabsenOleh,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedAbsensiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedAbsensiTable,
          CachedAbsensiData,
          $$CachedAbsensiTableFilterComposer,
          $$CachedAbsensiTableOrderingComposer,
          $$CachedAbsensiTableAnnotationComposer,
          $$CachedAbsensiTableCreateCompanionBuilder,
          $$CachedAbsensiTableUpdateCompanionBuilder,
          (
            CachedAbsensiData,
            BaseReferences<
              _$AppDatabase,
              $CachedAbsensiTable,
              CachedAbsensiData
            >,
          ),
          CachedAbsensiData,
          PrefetchHooks Function()
        > {
  $$CachedAbsensiTableTableManager(_$AppDatabase db, $CachedAbsensiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAbsensiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedAbsensiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedAbsensiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> siswaId = const Value.absent(),
                Value<String> kelasId = const Value.absent(),
                Value<String?> jadwalId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> tipeAbsen = const Value.absent(),
                Value<String> diabsenOleh = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAbsensiCompanion(
                id: id,
                siswaId: siswaId,
                kelasId: kelasId,
                jadwalId: jadwalId,
                status: status,
                tipeAbsen: tipeAbsen,
                diabsenOleh: diabsenOleh,
                tanggal: tanggal,
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
                Value<String?> jadwalId = const Value.absent(),
                required String status,
                required String tipeAbsen,
                required String diabsenOleh,
                required DateTime tanggal,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAbsensiCompanion.insert(
                id: id,
                siswaId: siswaId,
                kelasId: kelasId,
                jadwalId: jadwalId,
                status: status,
                tipeAbsen: tipeAbsen,
                diabsenOleh: diabsenOleh,
                tanggal: tanggal,
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

typedef $$CachedAbsensiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedAbsensiTable,
      CachedAbsensiData,
      $$CachedAbsensiTableFilterComposer,
      $$CachedAbsensiTableOrderingComposer,
      $$CachedAbsensiTableAnnotationComposer,
      $$CachedAbsensiTableCreateCompanionBuilder,
      $$CachedAbsensiTableUpdateCompanionBuilder,
      (
        CachedAbsensiData,
        BaseReferences<_$AppDatabase, $CachedAbsensiTable, CachedAbsensiData>,
      ),
      CachedAbsensiData,
      PrefetchHooks Function()
    >;
typedef $$CachedTugasTableCreateCompanionBuilder =
    CachedTugasCompanion Function({
      required String id,
      required String idKelas,
      required String idMapel,
      required String idGuru,
      required String judul,
      required String deskripsi,
      Value<String> status,
      required DateTime deadline,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedTugasTableUpdateCompanionBuilder =
    CachedTugasCompanion Function({
      Value<String> id,
      Value<String> idKelas,
      Value<String> idMapel,
      Value<String> idGuru,
      Value<String> judul,
      Value<String> deskripsi,
      Value<String> status,
      Value<DateTime> deadline,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedTugasTableFilterComposer
    extends Composer<_$AppDatabase, $CachedTugasTable> {
  $$CachedTugasTableFilterComposer({
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

  ColumnFilters<String> get idKelas => $composableBuilder(
    column: $table.idKelas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idMapel => $composableBuilder(
    column: $table.idMapel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idGuru => $composableBuilder(
    column: $table.idGuru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deskripsi => $composableBuilder(
    column: $table.deskripsi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
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

class $$CachedTugasTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedTugasTable> {
  $$CachedTugasTableOrderingComposer({
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

  ColumnOrderings<String> get idKelas => $composableBuilder(
    column: $table.idKelas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idMapel => $composableBuilder(
    column: $table.idMapel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idGuru => $composableBuilder(
    column: $table.idGuru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deskripsi => $composableBuilder(
    column: $table.deskripsi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
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

class $$CachedTugasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedTugasTable> {
  $$CachedTugasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idKelas =>
      $composableBuilder(column: $table.idKelas, builder: (column) => column);

  GeneratedColumn<String> get idMapel =>
      $composableBuilder(column: $table.idMapel, builder: (column) => column);

  GeneratedColumn<String> get idGuru =>
      $composableBuilder(column: $table.idGuru, builder: (column) => column);

  GeneratedColumn<String> get judul =>
      $composableBuilder(column: $table.judul, builder: (column) => column);

  GeneratedColumn<String> get deskripsi =>
      $composableBuilder(column: $table.deskripsi, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedTugasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedTugasTable,
          CachedTugasData,
          $$CachedTugasTableFilterComposer,
          $$CachedTugasTableOrderingComposer,
          $$CachedTugasTableAnnotationComposer,
          $$CachedTugasTableCreateCompanionBuilder,
          $$CachedTugasTableUpdateCompanionBuilder,
          (
            CachedTugasData,
            BaseReferences<_$AppDatabase, $CachedTugasTable, CachedTugasData>,
          ),
          CachedTugasData,
          PrefetchHooks Function()
        > {
  $$CachedTugasTableTableManager(_$AppDatabase db, $CachedTugasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedTugasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedTugasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedTugasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idKelas = const Value.absent(),
                Value<String> idMapel = const Value.absent(),
                Value<String> idGuru = const Value.absent(),
                Value<String> judul = const Value.absent(),
                Value<String> deskripsi = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> deadline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTugasCompanion(
                id: id,
                idKelas: idKelas,
                idMapel: idMapel,
                idGuru: idGuru,
                judul: judul,
                deskripsi: deskripsi,
                status: status,
                deadline: deadline,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idKelas,
                required String idMapel,
                required String idGuru,
                required String judul,
                required String deskripsi,
                Value<String> status = const Value.absent(),
                required DateTime deadline,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTugasCompanion.insert(
                id: id,
                idKelas: idKelas,
                idMapel: idMapel,
                idGuru: idGuru,
                judul: judul,
                deskripsi: deskripsi,
                status: status,
                deadline: deadline,
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

typedef $$CachedTugasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedTugasTable,
      CachedTugasData,
      $$CachedTugasTableFilterComposer,
      $$CachedTugasTableOrderingComposer,
      $$CachedTugasTableAnnotationComposer,
      $$CachedTugasTableCreateCompanionBuilder,
      $$CachedTugasTableUpdateCompanionBuilder,
      (
        CachedTugasData,
        BaseReferences<_$AppDatabase, $CachedTugasTable, CachedTugasData>,
      ),
      CachedTugasData,
      PrefetchHooks Function()
    >;
typedef $$CachedPengumpulanTableCreateCompanionBuilder =
    CachedPengumpulanCompanion Function({
      required String id,
      required String tugasId,
      required String siswaId,
      Value<String> status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedPengumpulanTableUpdateCompanionBuilder =
    CachedPengumpulanCompanion Function({
      Value<String> id,
      Value<String> tugasId,
      Value<String> siswaId,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedPengumpulanTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPengumpulanTable> {
  $$CachedPengumpulanTableFilterComposer({
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

  ColumnFilters<String> get tugasId => $composableBuilder(
    column: $table.tugasId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siswaId => $composableBuilder(
    column: $table.siswaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
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

class $$CachedPengumpulanTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPengumpulanTable> {
  $$CachedPengumpulanTableOrderingComposer({
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

  ColumnOrderings<String> get tugasId => $composableBuilder(
    column: $table.tugasId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siswaId => $composableBuilder(
    column: $table.siswaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
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

class $$CachedPengumpulanTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPengumpulanTable> {
  $$CachedPengumpulanTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tugasId =>
      $composableBuilder(column: $table.tugasId, builder: (column) => column);

  GeneratedColumn<String> get siswaId =>
      $composableBuilder(column: $table.siswaId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedPengumpulanTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedPengumpulanTable,
          CachedPengumpulanData,
          $$CachedPengumpulanTableFilterComposer,
          $$CachedPengumpulanTableOrderingComposer,
          $$CachedPengumpulanTableAnnotationComposer,
          $$CachedPengumpulanTableCreateCompanionBuilder,
          $$CachedPengumpulanTableUpdateCompanionBuilder,
          (
            CachedPengumpulanData,
            BaseReferences<
              _$AppDatabase,
              $CachedPengumpulanTable,
              CachedPengumpulanData
            >,
          ),
          CachedPengumpulanData,
          PrefetchHooks Function()
        > {
  $$CachedPengumpulanTableTableManager(
    _$AppDatabase db,
    $CachedPengumpulanTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPengumpulanTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedPengumpulanTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedPengumpulanTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tugasId = const Value.absent(),
                Value<String> siswaId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPengumpulanCompanion(
                id: id,
                tugasId: tugasId,
                siswaId: siswaId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tugasId,
                required String siswaId,
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPengumpulanCompanion.insert(
                id: id,
                tugasId: tugasId,
                siswaId: siswaId,
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

typedef $$CachedPengumpulanTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedPengumpulanTable,
      CachedPengumpulanData,
      $$CachedPengumpulanTableFilterComposer,
      $$CachedPengumpulanTableOrderingComposer,
      $$CachedPengumpulanTableAnnotationComposer,
      $$CachedPengumpulanTableCreateCompanionBuilder,
      $$CachedPengumpulanTableUpdateCompanionBuilder,
      (
        CachedPengumpulanData,
        BaseReferences<
          _$AppDatabase,
          $CachedPengumpulanTable,
          CachedPengumpulanData
        >,
      ),
      CachedPengumpulanData,
      PrefetchHooks Function()
    >;
typedef $$CachedMateriTableCreateCompanionBuilder =
    CachedMateriCompanion Function({
      required String id,
      required String idKelas,
      required String idMapel,
      required String idGuru,
      required String judul,
      Value<String?> deskripsi,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedMateriTableUpdateCompanionBuilder =
    CachedMateriCompanion Function({
      Value<String> id,
      Value<String> idKelas,
      Value<String> idMapel,
      Value<String> idGuru,
      Value<String> judul,
      Value<String?> deskripsi,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedMateriTableFilterComposer
    extends Composer<_$AppDatabase, $CachedMateriTable> {
  $$CachedMateriTableFilterComposer({
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

  ColumnFilters<String> get idKelas => $composableBuilder(
    column: $table.idKelas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idMapel => $composableBuilder(
    column: $table.idMapel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idGuru => $composableBuilder(
    column: $table.idGuru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deskripsi => $composableBuilder(
    column: $table.deskripsi,
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

class $$CachedMateriTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedMateriTable> {
  $$CachedMateriTableOrderingComposer({
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

  ColumnOrderings<String> get idKelas => $composableBuilder(
    column: $table.idKelas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idMapel => $composableBuilder(
    column: $table.idMapel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idGuru => $composableBuilder(
    column: $table.idGuru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deskripsi => $composableBuilder(
    column: $table.deskripsi,
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

class $$CachedMateriTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedMateriTable> {
  $$CachedMateriTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idKelas =>
      $composableBuilder(column: $table.idKelas, builder: (column) => column);

  GeneratedColumn<String> get idMapel =>
      $composableBuilder(column: $table.idMapel, builder: (column) => column);

  GeneratedColumn<String> get idGuru =>
      $composableBuilder(column: $table.idGuru, builder: (column) => column);

  GeneratedColumn<String> get judul =>
      $composableBuilder(column: $table.judul, builder: (column) => column);

  GeneratedColumn<String> get deskripsi =>
      $composableBuilder(column: $table.deskripsi, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedMateriTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedMateriTable,
          CachedMateriData,
          $$CachedMateriTableFilterComposer,
          $$CachedMateriTableOrderingComposer,
          $$CachedMateriTableAnnotationComposer,
          $$CachedMateriTableCreateCompanionBuilder,
          $$CachedMateriTableUpdateCompanionBuilder,
          (
            CachedMateriData,
            BaseReferences<_$AppDatabase, $CachedMateriTable, CachedMateriData>,
          ),
          CachedMateriData,
          PrefetchHooks Function()
        > {
  $$CachedMateriTableTableManager(_$AppDatabase db, $CachedMateriTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedMateriTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedMateriTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedMateriTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idKelas = const Value.absent(),
                Value<String> idMapel = const Value.absent(),
                Value<String> idGuru = const Value.absent(),
                Value<String> judul = const Value.absent(),
                Value<String?> deskripsi = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMateriCompanion(
                id: id,
                idKelas: idKelas,
                idMapel: idMapel,
                idGuru: idGuru,
                judul: judul,
                deskripsi: deskripsi,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idKelas,
                required String idMapel,
                required String idGuru,
                required String judul,
                Value<String?> deskripsi = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMateriCompanion.insert(
                id: id,
                idKelas: idKelas,
                idMapel: idMapel,
                idGuru: idGuru,
                judul: judul,
                deskripsi: deskripsi,
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

typedef $$CachedMateriTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedMateriTable,
      CachedMateriData,
      $$CachedMateriTableFilterComposer,
      $$CachedMateriTableOrderingComposer,
      $$CachedMateriTableAnnotationComposer,
      $$CachedMateriTableCreateCompanionBuilder,
      $$CachedMateriTableUpdateCompanionBuilder,
      (
        CachedMateriData,
        BaseReferences<_$AppDatabase, $CachedMateriTable, CachedMateriData>,
      ),
      CachedMateriData,
      PrefetchHooks Function()
    >;
typedef $$CachedMateriFilesTableCreateCompanionBuilder =
    CachedMateriFilesCompanion Function({
      required String id,
      required int idMateri,
      required int idFiles,
      required DateTime createdAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedMateriFilesTableUpdateCompanionBuilder =
    CachedMateriFilesCompanion Function({
      Value<String> id,
      Value<int> idMateri,
      Value<int> idFiles,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedMateriFilesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedMateriFilesTable> {
  $$CachedMateriFilesTableFilterComposer({
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

  ColumnFilters<int> get idMateri => $composableBuilder(
    column: $table.idMateri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idFiles => $composableBuilder(
    column: $table.idFiles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedMateriFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedMateriFilesTable> {
  $$CachedMateriFilesTableOrderingComposer({
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

  ColumnOrderings<int> get idMateri => $composableBuilder(
    column: $table.idMateri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idFiles => $composableBuilder(
    column: $table.idFiles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedMateriFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedMateriFilesTable> {
  $$CachedMateriFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get idMateri =>
      $composableBuilder(column: $table.idMateri, builder: (column) => column);

  GeneratedColumn<int> get idFiles =>
      $composableBuilder(column: $table.idFiles, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedMateriFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedMateriFilesTable,
          CachedMateriFilesData,
          $$CachedMateriFilesTableFilterComposer,
          $$CachedMateriFilesTableOrderingComposer,
          $$CachedMateriFilesTableAnnotationComposer,
          $$CachedMateriFilesTableCreateCompanionBuilder,
          $$CachedMateriFilesTableUpdateCompanionBuilder,
          (
            CachedMateriFilesData,
            BaseReferences<
              _$AppDatabase,
              $CachedMateriFilesTable,
              CachedMateriFilesData
            >,
          ),
          CachedMateriFilesData,
          PrefetchHooks Function()
        > {
  $$CachedMateriFilesTableTableManager(
    _$AppDatabase db,
    $CachedMateriFilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedMateriFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedMateriFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedMateriFilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> idMateri = const Value.absent(),
                Value<int> idFiles = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMateriFilesCompanion(
                id: id,
                idMateri: idMateri,
                idFiles: idFiles,
                createdAt: createdAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int idMateri,
                required int idFiles,
                required DateTime createdAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMateriFilesCompanion.insert(
                id: id,
                idMateri: idMateri,
                idFiles: idFiles,
                createdAt: createdAt,
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

typedef $$CachedMateriFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedMateriFilesTable,
      CachedMateriFilesData,
      $$CachedMateriFilesTableFilterComposer,
      $$CachedMateriFilesTableOrderingComposer,
      $$CachedMateriFilesTableAnnotationComposer,
      $$CachedMateriFilesTableCreateCompanionBuilder,
      $$CachedMateriFilesTableUpdateCompanionBuilder,
      (
        CachedMateriFilesData,
        BaseReferences<
          _$AppDatabase,
          $CachedMateriFilesTable,
          CachedMateriFilesData
        >,
      ),
      CachedMateriFilesData,
      PrefetchHooks Function()
    >;
typedef $$CachedQuizTableCreateCompanionBuilder =
    CachedQuizCompanion Function({
      required String id,
      required String idKelas,
      required String idMapel,
      required String idGuru,
      required String judul,
      required int waktu,
      required DateTime deadline,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedQuizTableUpdateCompanionBuilder =
    CachedQuizCompanion Function({
      Value<String> id,
      Value<String> idKelas,
      Value<String> idMapel,
      Value<String> idGuru,
      Value<String> judul,
      Value<int> waktu,
      Value<DateTime> deadline,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedQuizTableFilterComposer
    extends Composer<_$AppDatabase, $CachedQuizTable> {
  $$CachedQuizTableFilterComposer({
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

  ColumnFilters<String> get idKelas => $composableBuilder(
    column: $table.idKelas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idMapel => $composableBuilder(
    column: $table.idMapel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idGuru => $composableBuilder(
    column: $table.idGuru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waktu => $composableBuilder(
    column: $table.waktu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
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

class $$CachedQuizTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedQuizTable> {
  $$CachedQuizTableOrderingComposer({
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

  ColumnOrderings<String> get idKelas => $composableBuilder(
    column: $table.idKelas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idMapel => $composableBuilder(
    column: $table.idMapel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idGuru => $composableBuilder(
    column: $table.idGuru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waktu => $composableBuilder(
    column: $table.waktu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
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

class $$CachedQuizTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedQuizTable> {
  $$CachedQuizTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idKelas =>
      $composableBuilder(column: $table.idKelas, builder: (column) => column);

  GeneratedColumn<String> get idMapel =>
      $composableBuilder(column: $table.idMapel, builder: (column) => column);

  GeneratedColumn<String> get idGuru =>
      $composableBuilder(column: $table.idGuru, builder: (column) => column);

  GeneratedColumn<String> get judul =>
      $composableBuilder(column: $table.judul, builder: (column) => column);

  GeneratedColumn<int> get waktu =>
      $composableBuilder(column: $table.waktu, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedQuizTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedQuizTable,
          CachedQuizData,
          $$CachedQuizTableFilterComposer,
          $$CachedQuizTableOrderingComposer,
          $$CachedQuizTableAnnotationComposer,
          $$CachedQuizTableCreateCompanionBuilder,
          $$CachedQuizTableUpdateCompanionBuilder,
          (
            CachedQuizData,
            BaseReferences<_$AppDatabase, $CachedQuizTable, CachedQuizData>,
          ),
          CachedQuizData,
          PrefetchHooks Function()
        > {
  $$CachedQuizTableTableManager(_$AppDatabase db, $CachedQuizTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedQuizTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedQuizTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedQuizTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idKelas = const Value.absent(),
                Value<String> idMapel = const Value.absent(),
                Value<String> idGuru = const Value.absent(),
                Value<String> judul = const Value.absent(),
                Value<int> waktu = const Value.absent(),
                Value<DateTime> deadline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedQuizCompanion(
                id: id,
                idKelas: idKelas,
                idMapel: idMapel,
                idGuru: idGuru,
                judul: judul,
                waktu: waktu,
                deadline: deadline,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idKelas,
                required String idMapel,
                required String idGuru,
                required String judul,
                required int waktu,
                required DateTime deadline,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedQuizCompanion.insert(
                id: id,
                idKelas: idKelas,
                idMapel: idMapel,
                idGuru: idGuru,
                judul: judul,
                waktu: waktu,
                deadline: deadline,
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

typedef $$CachedQuizTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedQuizTable,
      CachedQuizData,
      $$CachedQuizTableFilterComposer,
      $$CachedQuizTableOrderingComposer,
      $$CachedQuizTableAnnotationComposer,
      $$CachedQuizTableCreateCompanionBuilder,
      $$CachedQuizTableUpdateCompanionBuilder,
      (
        CachedQuizData,
        BaseReferences<_$AppDatabase, $CachedQuizTable, CachedQuizData>,
      ),
      CachedQuizData,
      PrefetchHooks Function()
    >;
typedef $$CachedQuizSoalTableCreateCompanionBuilder =
    CachedQuizSoalCompanion Function({
      required String id,
      required String quizId,
      required String soal,
      required String tipeJawaban,
      required int poin,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedQuizSoalTableUpdateCompanionBuilder =
    CachedQuizSoalCompanion Function({
      Value<String> id,
      Value<String> quizId,
      Value<String> soal,
      Value<String> tipeJawaban,
      Value<int> poin,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedQuizSoalTableFilterComposer
    extends Composer<_$AppDatabase, $CachedQuizSoalTable> {
  $$CachedQuizSoalTableFilterComposer({
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

  ColumnFilters<String> get quizId => $composableBuilder(
    column: $table.quizId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get soal => $composableBuilder(
    column: $table.soal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipeJawaban => $composableBuilder(
    column: $table.tipeJawaban,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get poin => $composableBuilder(
    column: $table.poin,
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

class $$CachedQuizSoalTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedQuizSoalTable> {
  $$CachedQuizSoalTableOrderingComposer({
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

  ColumnOrderings<String> get quizId => $composableBuilder(
    column: $table.quizId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soal => $composableBuilder(
    column: $table.soal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipeJawaban => $composableBuilder(
    column: $table.tipeJawaban,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get poin => $composableBuilder(
    column: $table.poin,
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

class $$CachedQuizSoalTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedQuizSoalTable> {
  $$CachedQuizSoalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get quizId =>
      $composableBuilder(column: $table.quizId, builder: (column) => column);

  GeneratedColumn<String> get soal =>
      $composableBuilder(column: $table.soal, builder: (column) => column);

  GeneratedColumn<String> get tipeJawaban => $composableBuilder(
    column: $table.tipeJawaban,
    builder: (column) => column,
  );

  GeneratedColumn<int> get poin =>
      $composableBuilder(column: $table.poin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedQuizSoalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedQuizSoalTable,
          CachedQuizSoalData,
          $$CachedQuizSoalTableFilterComposer,
          $$CachedQuizSoalTableOrderingComposer,
          $$CachedQuizSoalTableAnnotationComposer,
          $$CachedQuizSoalTableCreateCompanionBuilder,
          $$CachedQuizSoalTableUpdateCompanionBuilder,
          (
            CachedQuizSoalData,
            BaseReferences<
              _$AppDatabase,
              $CachedQuizSoalTable,
              CachedQuizSoalData
            >,
          ),
          CachedQuizSoalData,
          PrefetchHooks Function()
        > {
  $$CachedQuizSoalTableTableManager(
    _$AppDatabase db,
    $CachedQuizSoalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedQuizSoalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedQuizSoalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedQuizSoalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quizId = const Value.absent(),
                Value<String> soal = const Value.absent(),
                Value<String> tipeJawaban = const Value.absent(),
                Value<int> poin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedQuizSoalCompanion(
                id: id,
                quizId: quizId,
                soal: soal,
                tipeJawaban: tipeJawaban,
                poin: poin,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quizId,
                required String soal,
                required String tipeJawaban,
                required int poin,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedQuizSoalCompanion.insert(
                id: id,
                quizId: quizId,
                soal: soal,
                tipeJawaban: tipeJawaban,
                poin: poin,
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

typedef $$CachedQuizSoalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedQuizSoalTable,
      CachedQuizSoalData,
      $$CachedQuizSoalTableFilterComposer,
      $$CachedQuizSoalTableOrderingComposer,
      $$CachedQuizSoalTableAnnotationComposer,
      $$CachedQuizSoalTableCreateCompanionBuilder,
      $$CachedQuizSoalTableUpdateCompanionBuilder,
      (
        CachedQuizSoalData,
        BaseReferences<_$AppDatabase, $CachedQuizSoalTable, CachedQuizSoalData>,
      ),
      CachedQuizSoalData,
      PrefetchHooks Function()
    >;
typedef $$CachedSettingsTableCreateCompanionBuilder =
    CachedSettingsCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$CachedSettingsTableUpdateCompanionBuilder =
    CachedSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$CachedSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSettingsTable> {
  $$CachedSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
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

class $$CachedSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSettingsTable> {
  $$CachedSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
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

class $$CachedSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSettingsTable> {
  $$CachedSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CachedSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedSettingsTable,
          CachedSettingsData,
          $$CachedSettingsTableFilterComposer,
          $$CachedSettingsTableOrderingComposer,
          $$CachedSettingsTableAnnotationComposer,
          $$CachedSettingsTableCreateCompanionBuilder,
          $$CachedSettingsTableUpdateCompanionBuilder,
          (
            CachedSettingsData,
            BaseReferences<
              _$AppDatabase,
              $CachedSettingsTable,
              CachedSettingsData
            >,
          ),
          CachedSettingsData,
          PrefetchHooks Function()
        > {
  $$CachedSettingsTableTableManager(
    _$AppDatabase db,
    $CachedSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSettingsCompanion.insert(
                key: key,
                value: value,
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

typedef $$CachedSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedSettingsTable,
      CachedSettingsData,
      $$CachedSettingsTableFilterComposer,
      $$CachedSettingsTableOrderingComposer,
      $$CachedSettingsTableAnnotationComposer,
      $$CachedSettingsTableCreateCompanionBuilder,
      $$CachedSettingsTableUpdateCompanionBuilder,
      (
        CachedSettingsData,
        BaseReferences<_$AppDatabase, $CachedSettingsTable, CachedSettingsData>,
      ),
      CachedSettingsData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String syncTableName,
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
      Value<String> syncTableName,
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

  ColumnFilters<String> get syncTableName => $composableBuilder(
    column: $table.syncTableName,
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

  ColumnOrderings<String> get syncTableName => $composableBuilder(
    column: $table.syncTableName,
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

  GeneratedColumn<String> get syncTableName => $composableBuilder(
    column: $table.syncTableName,
    builder: (column) => column,
  );

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
                Value<String> syncTableName = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> data = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                syncTableName: syncTableName,
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
                required String syncTableName,
                required String recordId,
                required String operation,
                Value<String?> data = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                syncTableName: syncTableName,
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
  $$CachedFilesTableTableManager get cachedFiles =>
      $$CachedFilesTableTableManager(_db, _db.cachedFiles);
  $$CachedAbsensiTableTableManager get cachedAbsensi =>
      $$CachedAbsensiTableTableManager(_db, _db.cachedAbsensi);
  $$CachedTugasTableTableManager get cachedTugas =>
      $$CachedTugasTableTableManager(_db, _db.cachedTugas);
  $$CachedPengumpulanTableTableManager get cachedPengumpulan =>
      $$CachedPengumpulanTableTableManager(_db, _db.cachedPengumpulan);
  $$CachedMateriTableTableManager get cachedMateri =>
      $$CachedMateriTableTableManager(_db, _db.cachedMateri);
  $$CachedMateriFilesTableTableManager get cachedMateriFiles =>
      $$CachedMateriFilesTableTableManager(_db, _db.cachedMateriFiles);
  $$CachedQuizTableTableManager get cachedQuiz =>
      $$CachedQuizTableTableManager(_db, _db.cachedQuiz);
  $$CachedQuizSoalTableTableManager get cachedQuizSoal =>
      $$CachedQuizSoalTableTableManager(_db, _db.cachedQuizSoal);
  $$CachedSettingsTableTableManager get cachedSettings =>
      $$CachedSettingsTableTableManager(_db, _db.cachedSettings);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
