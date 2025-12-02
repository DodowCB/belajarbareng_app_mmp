import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ============================================================================
// TABLES DEFINITION
// ============================================================================

/// Table untuk cache data Kelas
class CachedKelas extends Table {
  TextColumn get id => text()();
  TextColumn get namaKelas => text().named('nama_kelas')();
  TextColumn get guruId => text().named('guru_id')();
  BoolColumn get status => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Mata Pelajaran
class CachedMapel extends Table {
  TextColumn get id => text()();
  TextColumn get namaMapel => text().named('nama_mapel')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Kelas Ngajar (Jadwal Mengajar)
class CachedKelasNgajar extends Table {
  TextColumn get id => text()();
  TextColumn get idGuru => text().named('id_guru')();
  TextColumn get idKelas => text().named('id_kelas')();
  TextColumn get idMapel => text().named('id_mapel')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Pengumuman
class CachedPengumuman extends Table {
  TextColumn get id => text()();
  TextColumn get judul => text()();
  TextColumn get isi => text()();
  TextColumn get tipe => text()(); // 'umum', 'guru', 'siswa'
  DateTimeColumn get tanggalDibuat => dateTime().named('tanggal_dibuat')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Guru
class CachedGuru extends Table {
  TextColumn get id => text()();
  TextColumn get namaLengkap => text().named('nama_lengkap')();
  TextColumn get email => text()();
  IntColumn get nig => integer()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Siswa
class CachedSiswa extends Table {
  TextColumn get id => text()();
  TextColumn get nama => text()();
  TextColumn get email => text()();
  TextColumn get nis => text()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Siswa Kelas (Relasi)
class CachedSiswaKelas extends Table {
  TextColumn get id => text()();
  TextColumn get siswaId => text().named('siswa_id')();
  TextColumn get kelasId => text().named('kelas_id')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk tracking sync status
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableName => text()();
  TextColumn get recordId => text()();
  TextColumn get operation => text()(); // 'insert', 'update', 'delete'
  TextColumn get data => text().nullable()(); // JSON data for insert/update
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();
}

// ============================================================================
// DATABASE CLASS
// ============================================================================

@DriftDatabase(
  tables: [
    CachedKelas,
    CachedMapel,
    CachedKelasNgajar,
    CachedPengumuman,
    CachedGuru,
    CachedSiswa,
    CachedSiswaKelas,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle future migrations here
    },
  );

  // ============================================================================
  // KELAS METHODS
  // ============================================================================

  /// Get all kelas from cache
  Future<List<CachedKelasData>> getAllKelas() async {
    return await select(cachedKelas).get();
  }

  /// Get kelas by ID
  Future<CachedKelasData?> getKelasById(String id) async {
    return await (select(
      cachedKelas,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update kelas
  Future<void> upsertKelas(CachedKelasCompanion kelas) async {
    await into(cachedKelas).insertOnConflictUpdate(kelas);
  }

  /// Delete kelas
  Future<void> deleteKelas(String id) async {
    await (delete(cachedKelas)..where((t) => t.id.equals(id))).go();
  }

  /// Get active kelas only
  Future<List<CachedKelasData>> getActiveKelas() async {
    return await (select(
      cachedKelas,
    )..where((t) => t.status.equals(true))).get();
  }

  // ============================================================================
  // MAPEL METHODS
  // ============================================================================

  /// Get all mapel from cache
  Future<List<CachedMapelData>> getAllMapel() async {
    return await select(cachedMapel).get();
  }

  /// Get mapel by ID
  Future<CachedMapelData?> getMapelById(String id) async {
    return await (select(
      cachedMapel,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update mapel
  Future<void> upsertMapel(CachedMapelCompanion mapel) async {
    await into(cachedMapel).insertOnConflictUpdate(mapel);
  }

  /// Delete mapel
  Future<void> deleteMapel(String id) async {
    await (delete(cachedMapel)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // KELAS NGAJAR METHODS
  // ============================================================================

  /// Get all kelas ngajar from cache
  Future<List<CachedKelasNgajarData>> getAllKelasNgajar() async {
    return await select(cachedKelasNgajar).get();
  }

  /// Get kelas ngajar by guru ID
  Future<List<CachedKelasNgajarData>> getKelasNgajarByGuruId(
    String guruId,
  ) async {
    return await (select(
      cachedKelasNgajar,
    )..where((t) => t.idGuru.equals(guruId))).get();
  }

  /// Insert or update kelas ngajar
  Future<void> upsertKelasNgajar(CachedKelasNgajarCompanion kelasNgajar) async {
    await into(cachedKelasNgajar).insertOnConflictUpdate(kelasNgajar);
  }

  /// Delete kelas ngajar
  Future<void> deleteKelasNgajar(String id) async {
    await (delete(cachedKelasNgajar)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // PENGUMUMAN METHODS
  // ============================================================================

  /// Get all pengumuman from cache
  Future<List<CachedPengumumanData>> getAllPengumuman() async {
    return await (select(
      cachedPengumuman,
    )..orderBy([(t) => OrderingTerm.desc(t.tanggalDibuat)])).get();
  }

  /// Get pengumuman by type
  Future<List<CachedPengumumanData>> getPengumumanByType(String tipe) async {
    return await (select(cachedPengumuman)
          ..where((t) => t.tipe.equals(tipe))
          ..orderBy([(t) => OrderingTerm.desc(t.tanggalDibuat)]))
        .get();
  }

  /// Insert or update pengumuman
  Future<void> upsertPengumuman(CachedPengumumanCompanion pengumuman) async {
    await into(cachedPengumuman).insertOnConflictUpdate(pengumuman);
  }

  /// Delete pengumuman
  Future<void> deletePengumuman(String id) async {
    await (delete(cachedPengumuman)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // GURU METHODS
  // ============================================================================

  /// Get all guru from cache
  Future<List<CachedGuruData>> getAllGuru() async {
    return await select(cachedGuru).get();
  }

  /// Get guru by ID
  Future<CachedGuruData?> getGuruById(String id) async {
    return await (select(
      cachedGuru,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update guru
  Future<void> upsertGuru(CachedGuruCompanion guru) async {
    await into(cachedGuru).insertOnConflictUpdate(guru);
  }

  /// Delete guru
  Future<void> deleteGuru(String id) async {
    await (delete(cachedGuru)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // SISWA METHODS
  // ============================================================================

  /// Get all siswa from cache
  Future<List<CachedSiswaData>> getAllSiswa() async {
    return await select(cachedSiswa).get();
  }

  /// Get siswa by ID
  Future<CachedSiswaData?> getSiswaById(String id) async {
    return await (select(
      cachedSiswa,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update siswa
  Future<void> upsertSiswa(CachedSiswaCompanion siswa) async {
    await into(cachedSiswa).insertOnConflictUpdate(siswa);
  }

  /// Delete siswa
  Future<void> deleteSiswa(String id) async {
    await (delete(cachedSiswa)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // SISWA KELAS METHODS
  // ============================================================================

  /// Get all siswa kelas from cache
  Future<List<CachedSiswaKelasData>> getAllSiswaKelas() async {
    return await select(cachedSiswaKelas).get();
  }

  /// Get siswa kelas by kelas ID
  Future<List<CachedSiswaKelasData>> getSiswaKelasByKelasId(
    String kelasId,
  ) async {
    return await (select(
      cachedSiswaKelas,
    )..where((t) => t.kelasId.equals(kelasId))).get();
  }

  /// Insert or update siswa kelas
  Future<void> upsertSiswaKelas(CachedSiswaKelasCompanion siswaKelas) async {
    await into(cachedSiswaKelas).insertOnConflictUpdate(siswaKelas);
  }

  /// Delete siswa kelas
  Future<void> deleteSiswaKelas(String id) async {
    await (delete(cachedSiswaKelas)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // SYNC QUEUE METHODS
  // ============================================================================

  /// Add item to sync queue
  Future<int> addToSyncQueue({
    required String tableName,
    required String recordId,
    required String operation,
    String? data,
  }) async {
    return await into(syncQueue).insert(
      SyncQueueCompanion.insert(
        tableName: tableName,
        recordId: recordId,
        operation: operation,
        data: Value(data),
      ),
    );
  }

  /// Get pending sync items
  Future<List<SyncQueueData>> getPendingSyncItems() async {
    return await (select(syncQueue)
          ..where((t) => t.synced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Mark sync item as completed
  Future<void> markSyncCompleted(int id) async {
    await (update(syncQueue)..where((t) => t.id.equals(id))).write(
      SyncQueueCompanion(
        synced: const Value(true),
        syncedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark sync item as failed
  Future<void> markSyncFailed(int id, String errorMessage) async {
    await (update(syncQueue)..where((t) => t.id.equals(id))).write(
      SyncQueueCompanion(errorMessage: Value(errorMessage)),
    );
  }

  /// Clear completed sync items
  Future<void> clearCompletedSyncItems() async {
    await (delete(syncQueue)..where((t) => t.synced.equals(true))).go();
  }

  // ============================================================================
  // BULK OPERATIONS
  // ============================================================================

  /// Clear all data (for logout or reset)
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(cachedKelas).go();
      await delete(cachedMapel).go();
      await delete(cachedKelasNgajar).go();
      await delete(cachedPengumuman).go();
      await delete(cachedGuru).go();
      await delete(cachedSiswa).go();
      await delete(cachedSiswaKelas).go();
      await delete(syncQueue).go();
    });
  }

  /// Get database size info
  Future<Map<String, int>> getDatabaseStats() async {
    final stats = <String, int>{};
    stats['kelas'] = await (select(cachedKelas)).get().then((l) => l.length);
    stats['mapel'] = await (select(cachedMapel)).get().then((l) => l.length);
    stats['kelas_ngajar'] = await (select(
      cachedKelasNgajar,
    )).get().then((l) => l.length);
    stats['pengumuman'] = await (select(
      cachedPengumuman,
    )).get().then((l) => l.length);
    stats['guru'] = await (select(cachedGuru)).get().then((l) => l.length);
    stats['siswa'] = await (select(cachedSiswa)).get().then((l) => l.length);
    stats['siswa_kelas'] = await (select(
      cachedSiswaKelas,
    )).get().then((l) => l.length);
    stats['sync_queue'] = await (select(syncQueue)).get().then((l) => l.length);
    return stats;
  }
}

// ============================================================================
// DATABASE CONNECTION
// ============================================================================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'belajarbareng_app.sqlite'));
    return NativeDatabase(file);
  });
}
