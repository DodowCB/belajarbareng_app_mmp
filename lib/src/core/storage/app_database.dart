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
@DataClassName('CachedKelasData')
class CachedKelas extends Table {
  TextColumn get id => text()();
  TextColumn get namaKelas => text().named('nama_kelas')();
  TextColumn get guruId => text().named('guru_id')();
  TextColumn get namaGuru => text().named('nama_guru')();
  TextColumn get jenjangKelas => text().named('jenjang_kelas')();
  TextColumn get nomorKelas => text().named('nomor_kelas')();
  TextColumn get tahunAjaran => text().named('tahun_ajaran')();
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
@DataClassName('CachedKelasNgajarData')
class CachedKelasNgajar extends Table {
  TextColumn get id => text()();
  TextColumn get idGuru => text().named('id_guru')();
  TextColumn get idKelas => text().named('id_kelas')();
  TextColumn get idMapel => text().named('id_mapel')();
  TextColumn get hari => text()();
  TextColumn get jam => text()();
  DateTimeColumn get tanggal => dateTime()();
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
@DataClassName('CachedGuruData')
class CachedGuru extends Table {
  TextColumn get id => text()();
  TextColumn get namaLengkap => text().named('nama_lengkap')();
  TextColumn get email => text()();
  IntColumn get nig => integer()();
  TextColumn get jenisKelamin => text().named('jenis_kelamin')();
  TextColumn get mataPelajaran => text().named('mata_pelajaran')();
  TextColumn get password => text()();
  TextColumn get photoUrl => text().named('photo_url')();
  TextColumn get sekolah => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();
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
@DataClassName('CachedSiswaKelasData')
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

/// Table untuk cache data Files (Google Drive)
@DataClassName('CachedFilesData')
class CachedFiles extends Table {
  TextColumn get id => text()();
  TextColumn get driveFileId => text().named('drive_file_id')();
  TextColumn get mimeType => text().named('mime_type')();
  TextColumn get name => text()();
  IntColumn get size => integer()();
  TextColumn get status => text()();
  DateTimeColumn get uploadedAt => dateTime().named('uploaded_at')();
  TextColumn get uploadedBy => text().named('uploaded_by')();
  TextColumn get webViewLink => text().named('web_view_link').nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Absensi
@DataClassName('CachedAbsensiData')
class CachedAbsensi extends Table {
  TextColumn get id => text()();
  TextColumn get siswaId => text().named('siswa_id')();
  TextColumn get kelasId => text().named('kelas_id')();
  TextColumn get jadwalId => text().named('jadwal_id').nullable()();
  TextColumn get status => text()(); // 'hadir', 'sakit', 'izin', 'alpha'
  TextColumn get tipeAbsen =>
      text().named('tipe_absen')(); // 'guru_kelas', 'wali_kelas'
  TextColumn get diabsenOleh => text().named('diabsen_oleh')();
  DateTimeColumn get tanggal => dateTime()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Tugas
@DataClassName('CachedTugasData')
class CachedTugas extends Table {
  TextColumn get id => text()();
  TextColumn get idKelas => text().named('id_kelas')();
  TextColumn get idMapel => text().named('id_mapel')();
  TextColumn get idGuru => text().named('id_guru')();
  TextColumn get judul => text()();
  TextColumn get deskripsi => text()();
  TextColumn get status => text().withDefault(const Constant('Aktif'))(); // 'Aktif', 'Selesai'
  DateTimeColumn get deadline => dateTime()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Pengumpulan Tugas
@DataClassName('CachedPengumpulanData')
class CachedPengumpulan extends Table {
  TextColumn get id => text()();
  TextColumn get tugasId => text().named('tugas_id')();
  TextColumn get siswaId => text().named('siswa_id')();
  TextColumn get status => text().withDefault(const Constant('Terkumpul'))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Materi
@DataClassName('CachedMateriData')
class CachedMateri extends Table {
  TextColumn get id => text()();
  TextColumn get idKelas => text().named('id_kelas')();
  TextColumn get idMapel => text().named('id_mapel')();
  TextColumn get idGuru => text().named('id_guru')();
  TextColumn get judul => text()();
  TextColumn get deskripsi => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache relasi Materi-Files (Many-to-Many)
@DataClassName('CachedMateriFilesData')
class CachedMateriFiles extends Table {
  TextColumn get id => text()();
  IntColumn get idMateri => integer().named('id_materi')();
  IntColumn get idFiles => integer().named('id_files')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Quiz
@DataClassName('CachedQuizData')
class CachedQuiz extends Table {
  TextColumn get id => text()();
  TextColumn get idKelas => text().named('id_kelas')();
  TextColumn get idMapel => text().named('id_mapel')();
  TextColumn get idGuru => text().named('id_guru')();
  TextColumn get judul => text()();
  IntColumn get waktu => integer()(); // dalam menit
  DateTimeColumn get deadline => dateTime()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache data Quiz Soal
@DataClassName('CachedQuizSoalData')
class CachedQuizSoal extends Table {
  TextColumn get id => text()();
  TextColumn get quizId => text().named('quiz_id')();
  TextColumn get soal => text()();
  TextColumn get tipeJawaban =>
      text().named('tipe_jawaban')(); // 'single', 'multiple'
  IntColumn get poin => integer()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table untuk cache Settings
@DataClassName('CachedSettingsData')
class CachedSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Table untuk tracking sync status
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get syncTableName => text().named('table_name')();
  TextColumn get recordId => text().named('record_id')();
  TextColumn get operation => text()(); // 'insert', 'update', 'delete'
  TextColumn get data => text().nullable()(); // JSON data for insert/update
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();
  TextColumn get errorMessage => text().named('error_message').nullable()();
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
    CachedFiles,
    CachedAbsensi,
    CachedTugas,
    CachedPengumpulan,
    CachedMateri,
    CachedMateriFiles,
    CachedQuiz,
    CachedQuizSoal,
    CachedSettings,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Add new tables for version 2
        await m.createTable(cachedAbsensi);
        await m.createTable(cachedTugas);
        await m.createTable(cachedPengumpulan);
        await m.createTable(cachedMateri);
        await m.createTable(cachedQuiz);
        await m.createTable(cachedQuizSoal);
        await m.createTable(cachedSettings);
      }
      if (from < 3) {
        // Add new table and update existing tables for version 3
        await m.createTable(cachedFiles);

        // Add new columns to existing tables
        await m.addColumn(cachedKelas, cachedKelas.namaGuru);
        await m.addColumn(cachedKelas, cachedKelas.jenjangKelas);
        await m.addColumn(cachedKelas, cachedKelas.nomorKelas);
        await m.addColumn(cachedKelas, cachedKelas.tahunAjaran);

        await m.addColumn(cachedGuru, cachedGuru.jenisKelamin);
        await m.addColumn(cachedGuru, cachedGuru.mataPelajaran);
        await m.addColumn(cachedGuru, cachedGuru.password);
        await m.addColumn(cachedGuru, cachedGuru.photoUrl);
        await m.addColumn(cachedGuru, cachedGuru.sekolah);
        await m.addColumn(cachedGuru, cachedGuru.status);

        await m.addColumn(cachedKelasNgajar, cachedKelasNgajar.hari);
        await m.addColumn(cachedKelasNgajar, cachedKelasNgajar.jam);
        await m.addColumn(cachedKelasNgajar, cachedKelasNgajar.tanggal);

        await m.addColumn(cachedAbsensi, cachedAbsensi.jadwalId);
      }
      if (from < 4) {
        // Add materi_files junction table and update tugas status field
        await m.createTable(cachedMateriFiles);
        await m.addColumn(cachedTugas, cachedTugas.status);
      }
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
  // FILES METHODS
  // ============================================================================

  /// Get all files from cache
  Future<List<CachedFilesData>> getAllFiles() async {
    return await select(cachedFiles).get();
  }

  /// Get file by ID
  Future<CachedFilesData?> getFileById(String id) async {
    return await (select(
      cachedFiles,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get file by drive file ID
  Future<CachedFilesData?> getFileByDriveId(String driveFileId) async {
    return await (select(
      cachedFiles,
    )..where((t) => t.driveFileId.equals(driveFileId))).getSingleOrNull();
  }

  /// Insert or update file
  Future<void> upsertFile(CachedFilesCompanion file) async {
    await into(cachedFiles).insertOnConflictUpdate(file);
  }

  /// Delete file
  Future<void> deleteFile(String id) async {
    await (delete(cachedFiles)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // ABSENSI METHODS
  // ============================================================================

  /// Get all absensi from cache
  Future<List<CachedAbsensiData>> getAllAbsensi() async {
    return await select(cachedAbsensi).get();
  }

  /// Get absensi by kelas ID
  Future<List<CachedAbsensiData>> getAbsensiByKelasId(String kelasId) async {
    return await (select(
      cachedAbsensi,
    )..where((t) => t.kelasId.equals(kelasId))).get();
  }

  /// Get absensi by siswa ID
  Future<List<CachedAbsensiData>> getAbsensiBySiswaId(String siswaId) async {
    return await (select(
      cachedAbsensi,
    )..where((t) => t.siswaId.equals(siswaId))).get();
  }

  /// Insert or update absensi
  Future<void> upsertAbsensi(CachedAbsensiCompanion absensi) async {
    await into(cachedAbsensi).insertOnConflictUpdate(absensi);
  }

  /// Delete absensi
  Future<void> deleteAbsensi(String id) async {
    await (delete(cachedAbsensi)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // TUGAS METHODS
  // ============================================================================

  /// Get all tugas from cache
  Future<List<CachedTugasData>> getAllTugas() async {
    return await select(cachedTugas).get();
  }

  /// Get tugas by kelas ID
  Future<List<CachedTugasData>> getTugasByKelasId(String kelasId) async {
    return await (select(
      cachedTugas,
    )..where((t) => t.idKelas.equals(kelasId))).get();
  }

  /// Get tugas by ID
  Future<CachedTugasData?> getTugasById(String id) async {
    return await (select(
      cachedTugas,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update tugas
  Future<void> upsertTugas(CachedTugasCompanion tugas) async {
    await into(cachedTugas).insertOnConflictUpdate(tugas);
  }

  /// Delete tugas
  Future<void> deleteTugas(String id) async {
    await (delete(cachedTugas)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // PENGUMPULAN METHODS
  // ============================================================================

  /// Get all pengumpulan from cache
  Future<List<CachedPengumpulanData>> getAllPengumpulan() async {
    return await select(cachedPengumpulan).get();
  }

  /// Get pengumpulan by tugas ID
  Future<List<CachedPengumpulanData>> getPengumpulanByTugasId(
    String tugasId,
  ) async {
    return await (select(
      cachedPengumpulan,
    )..where((t) => t.tugasId.equals(tugasId))).get();
  }

  /// Get pengumpulan by siswa ID
  Future<List<CachedPengumpulanData>> getPengumpulanBySiswaId(
    String siswaId,
  ) async {
    return await (select(
      cachedPengumpulan,
    )..where((t) => t.siswaId.equals(siswaId))).get();
  }

  /// Insert or update pengumpulan
  Future<void> upsertPengumpulan(CachedPengumpulanCompanion pengumpulan) async {
    await into(cachedPengumpulan).insertOnConflictUpdate(pengumpulan);
  }

  /// Delete pengumpulan
  Future<void> deletePengumpulan(String id) async {
    await (delete(cachedPengumpulan)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // MATERI METHODS
  // ============================================================================

  /// Get all materi from cache
  Future<List<CachedMateriData>> getAllMateri() async {
    return await select(cachedMateri).get();
  }

  /// Get materi by kelas ID
  Future<List<CachedMateriData>> getMateriByKelasId(String kelasId) async {
    return await (select(
      cachedMateri,
    )..where((t) => t.idKelas.equals(kelasId))).get();
  }

  /// Get materi by ID
  Future<CachedMateriData?> getMateriById(String id) async {
    return await (select(
      cachedMateri,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update materi
  Future<void> upsertMateri(CachedMateriCompanion materi) async {
    await into(cachedMateri).insertOnConflictUpdate(materi);
  }

  /// Delete materi
  Future<void> deleteMateri(String id) async {
    await (delete(cachedMateri)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // MATERI FILES METHODS (Junction Table)
  // ============================================================================

  /// Get all materi files relations
  Future<List<CachedMateriFilesData>> getAllMateriFiles() async {
    return await select(cachedMateriFiles).get();
  }

  /// Get files by materi ID
  Future<List<CachedMateriFilesData>> getFilesByMateriId(int materiId) async {
    return await (select(
      cachedMateriFiles,
    )..where((t) => t.idMateri.equals(materiId))).get();
  }

  /// Get materi by file ID
  Future<List<CachedMateriFilesData>> getMateriByFileId(int fileId) async {
    return await (select(
      cachedMateriFiles,
    )..where((t) => t.idFiles.equals(fileId))).get();
  }

  /// Insert or update materi-file relation
  Future<void> upsertMateriFile(CachedMateriFilesCompanion materiFile) async {
    await into(cachedMateriFiles).insertOnConflictUpdate(materiFile);
  }

  /// Delete materi-file relation
  Future<void> deleteMateriFile(String id) async {
    await (delete(cachedMateriFiles)..where((t) => t.id.equals(id))).go();
  }

  /// Delete all files relations for a materi
  Future<void> deleteMateriFilesByMateriId(int materiId) async {
    await (delete(
      cachedMateriFiles,
    )..where((t) => t.idMateri.equals(materiId))).go();
  }

  // ============================================================================
  // QUIZ METHODS
  // ============================================================================

  /// Get all quiz from cache
  Future<List<CachedQuizData>> getAllQuiz() async {
    return await select(cachedQuiz).get();
  }

  /// Get quiz by kelas ID
  Future<List<CachedQuizData>> getQuizByKelasId(String kelasId) async {
    return await (select(
      cachedQuiz,
    )..where((t) => t.idKelas.equals(kelasId))).get();
  }

  /// Get quiz by ID
  Future<CachedQuizData?> getQuizById(String id) async {
    return await (select(
      cachedQuiz,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update quiz
  Future<void> upsertQuiz(CachedQuizCompanion quiz) async {
    await into(cachedQuiz).insertOnConflictUpdate(quiz);
  }

  /// Delete quiz
  Future<void> deleteQuiz(String id) async {
    await (delete(cachedQuiz)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // QUIZ SOAL METHODS
  // ============================================================================

  /// Get all quiz soal from cache
  Future<List<CachedQuizSoalData>> getAllQuizSoal() async {
    return await select(cachedQuizSoal).get();
  }

  /// Get quiz soal by quiz ID
  Future<List<CachedQuizSoalData>> getQuizSoalByQuizId(String quizId) async {
    return await (select(
      cachedQuizSoal,
    )..where((t) => t.quizId.equals(quizId))).get();
  }

  /// Insert or update quiz soal
  Future<void> upsertQuizSoal(CachedQuizSoalCompanion quizSoal) async {
    await into(cachedQuizSoal).insertOnConflictUpdate(quizSoal);
  }

  /// Delete quiz soal
  Future<void> deleteQuizSoal(String id) async {
    await (delete(cachedQuizSoal)..where((t) => t.id.equals(id))).go();
  }

  // ============================================================================
  // SETTINGS METHODS
  // ============================================================================

  /// Get setting by key
  Future<CachedSettingsData?> getSetting(String key) async {
    return await (select(
      cachedSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
  }

  /// Get all settings
  Future<List<CachedSettingsData>> getAllSettings() async {
    return await select(cachedSettings).get();
  }

  /// Insert or update setting
  Future<void> upsertSetting(CachedSettingsCompanion setting) async {
    await into(cachedSettings).insertOnConflictUpdate(setting);
  }

  /// Delete setting
  Future<void> deleteSetting(String key) async {
    await (delete(cachedSettings)..where((t) => t.key.equals(key))).go();
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
        syncTableName: tableName,
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
      await delete(cachedFiles).go();
      await delete(cachedAbsensi).go();
      await delete(cachedTugas).go();
      await delete(cachedPengumpulan).go();
      await delete(cachedMateri).go();
      await delete(cachedMateriFiles).go();
      await delete(cachedQuiz).go();
      await delete(cachedQuizSoal).go();
      await delete(cachedSettings).go();
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
    stats['files'] = await (select(cachedFiles)).get().then((l) => l.length);
    stats['absensi'] = await (select(
      cachedAbsensi,
    )).get().then((l) => l.length);
    stats['tugas'] = await (select(cachedTugas)).get().then((l) => l.length);
    stats['pengumpulan'] = await (select(
      cachedPengumpulan,
    )).get().then((l) => l.length);
    stats['materi'] = await (select(cachedMateri)).get().then((l) => l.length);
    stats['materi_files'] = await (select(
      cachedMateriFiles,
    )).get().then((l) => l.length);
    stats['quiz'] = await (select(cachedQuiz)).get().then((l) => l.length);
    stats['quiz_soal'] = await (select(
      cachedQuizSoal,
    )).get().then((l) => l.length);
    stats['settings'] = await (select(
      cachedSettings,
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
