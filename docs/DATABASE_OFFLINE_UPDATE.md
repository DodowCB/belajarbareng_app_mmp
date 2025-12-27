# Database Offline Update - Admin Features

## 📊 Overview
Updated local database (Drift/SQLite) to support new admin features including absensi, tugas, materi, quiz, pengumpulan, and settings management.

## 🆕 New Tables Added

### 1. **CachedAbsensi** - Attendance Records
```dart
- id (String, PK)
- siswa_id (String)
- kelas_id (String)
- status (String) // 'hadir', 'sakit', 'izin', 'alpha'
- tipe_absen (String) // 'guru_kelas', 'wali_kelas'
- diabsen_oleh (String)
- tanggal (DateTime)
- created_at (DateTime)
- updated_at (DateTime)
- synced_at (DateTime, nullable)
```

**Methods:**
- `getAllAbsensi()` - Get all attendance records
- `getAbsensiByKelasId(kelasId)` - Get by class
- `getAbsensiBySiswaId(siswaId)` - Get by student
- `upsertAbsensi(absensi)` - Insert/update
- `deleteAbsensi(id)` - Delete record

---

### 2. **CachedTugas** - Assignments
```dart
- id (String, PK)
- id_kelas (String)
- id_mapel (String)
- id_guru (String)
- judul (String)
- deskripsi (String)
- deadline (DateTime)
- created_at (DateTime)
- updated_at (DateTime)
- synced_at (DateTime, nullable)
```

**Methods:**
- `getAllTugas()` - Get all assignments
- `getTugasByKelasId(kelasId)` - Get by class
- `getTugasById(id)` - Get single assignment
- `upsertTugas(tugas)` - Insert/update
- `deleteTugas(id)` - Delete assignment

---

### 3. **CachedPengumpulan** - Assignment Submissions
```dart
- id (String, PK)
- tugas_id (String)
- siswa_id (String)
- status (String, default: 'Terkumpul')
- created_at (DateTime)
- updated_at (DateTime)
- synced_at (DateTime, nullable)
```

**Methods:**
- `getAllPengumpulan()` - Get all submissions
- `getPengumpulanByTugasId(tugasId)` - Get by assignment
- `getPengumpulanBySiswaId(siswaId)` - Get by student
- `upsertPengumpulan(pengumpulan)` - Insert/update
- `deletePengumpulan(id)` - Delete submission

---

### 4. **CachedMateri** - Learning Materials
```dart
- id (String, PK)
- id_kelas (String)
- id_mapel (String)
- id_guru (String)
- judul (String)
- deskripsi (String, nullable)
- tipe_materi (String) // 'file', 'youtube'
- youtube_url (String, nullable)
- uploaded_at (DateTime)
- created_at (DateTime)
- updated_at (DateTime)
- synced_at (DateTime, nullable)
```

**Methods:**
- `getAllMateri()` - Get all materials
- `getMateriByKelasId(kelasId)` - Get by class
- `getMateriById(id)` - Get single material
- `upsertMateri(materi)` - Insert/update
- `deleteMateri(id)` - Delete material

---

### 5. **CachedQuiz** - Quizzes
```dart
- id (String, PK)
- id_kelas (String)
- id_mapel (String)
- id_guru (String)
- judul (String)
- waktu (int) // minutes
- deadline (DateTime)
- created_at (DateTime)
- updated_at (DateTime)
- synced_at (DateTime, nullable)
```

**Methods:**
- `getAllQuiz()` - Get all quizzes
- `getQuizByKelasId(kelasId)` - Get by class
- `getQuizById(id)` - Get single quiz
- `upsertQuiz(quiz)` - Insert/update
- `deleteQuiz(id)` - Delete quiz

---

### 6. **CachedQuizSoal** - Quiz Questions
```dart
- id (String, PK)
- quiz_id (String)
- soal (String)
- tipe_jawaban (String) // 'single', 'multiple'
- poin (int)
- created_at (DateTime)
- updated_at (DateTime)
- synced_at (DateTime, nullable)
```

**Methods:**
- `getAllQuizSoal()` - Get all questions
- `getQuizSoalByQuizId(quizId)` - Get by quiz
- `upsertQuizSoal(quizSoal)` - Insert/update
- `deleteQuizSoal(id)` - Delete question

---

### 7. **CachedSettings** - Application Settings
```dart
- key (String, PK)
- value (String)
- updated_at (DateTime)
- synced_at (DateTime, nullable)
```

**Methods:**
- `getSetting(key)` - Get single setting
- `getAllSettings()` - Get all settings
- `upsertSetting(setting)` - Insert/update
- `deleteSetting(key)` - Delete setting

---

## 🔄 Database Migration

**Schema Version:** Updated from `1` to `2`

**Migration Strategy:**
```dart
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
}
```

---

## 📦 Existing Tables (Unchanged)
1. CachedKelas - Class information
2. CachedMapel - Subject information
3. CachedKelasNgajar - Teaching schedule
4. CachedPengumuman - Announcements
5. CachedGuru - Teacher data
6. CachedSiswa - Student data
7. CachedSiswaKelas - Student-class relationships
8. SyncQueue - Sync tracking

---

## 🔧 Updated Methods

### Bulk Operations

**clearAllData()** - Updated to include new tables:
```dart
await delete(cachedAbsensi).go();
await delete(cachedTugas).go();
await delete(cachedPengumpulan).go();
await delete(cachedMateri).go();
await delete(cachedQuiz).go();
await delete(cachedQuizSoal).go();
await delete(cachedSettings).go();
```

**getDatabaseStats()** - Updated to include new table counts:
```dart
stats['absensi'] = ...
stats['tugas'] = ...
stats['pengumpulan'] = ...
stats['materi'] = ...
stats['quiz'] = ...
stats['quiz_soal'] = ...
stats['settings'] = ...
```

---

## 🚀 Usage Examples

### 1. Caching Absensi
```dart
final database = ref.watch(appDatabaseProvider);

// Insert/Update absensi
await database.upsertAbsensi(
  CachedAbsensiCompanion(
    id: Value('absen-123'),
    siswaId: Value('siswa-1'),
    kelasId: Value('kelas-1'),
    status: Value('hadir'),
    tipeAbsen: Value('guru_kelas'),
    diabsenOleh: Value('guru-1'),
    tanggal: Value(DateTime.now()),
    createdAt: Value(DateTime.now()),
    updatedAt: Value(DateTime.now()),
  ),
);

// Get all absensi for a class
final absensiList = await database.getAbsensiByKelasId('kelas-1');
```

### 2. Caching Tugas
```dart
// Insert tugas
await database.upsertTugas(
  CachedTugasCompanion(
    id: Value('tugas-1'),
    idKelas: Value('kelas-1'),
    idMapel: Value('mapel-1'),
    idGuru: Value('guru-1'),
    judul: Value('Tugas Matematika'),
    deskripsi: Value('Kerjakan soal latihan'),
    deadline: Value(DateTime.now().add(Duration(days: 7))),
    createdAt: Value(DateTime.now()),
    updatedAt: Value(DateTime.now()),
  ),
);

// Get tugas by kelas
final tugasList = await database.getTugasByKelasId('kelas-1');
```

### 3. Caching Settings
```dart
// Save Gemini API key
await database.upsertSetting(
  CachedSettingsCompanion(
    key: Value('gemini_api_key'),
    value: Value('AIzaSy...'),
    updatedAt: Value(DateTime.now()),
  ),
);

// Get API key
final setting = await database.getSetting('gemini_api_key');
if (setting != null) {
  final apiKey = setting.value;
}
```

---

## 📊 Database Statistics

Total Tables: **15**
- Original: 8 tables
- New: 7 tables

Total Methods: **80+**
- CRUD operations for each table
- Bulk operations
- Statistics tracking

---

## ✅ Testing Checklist

- [x] All new tables created successfully
- [x] Migration from schema v1 to v2 works
- [x] All CRUD methods implemented
- [x] Bulk operations updated
- [x] Database stats updated
- [x] Generated code with build_runner
- [x] No compilation errors
- [x] Ready for offline sync implementation

---

## 🔜 Next Steps

1. **Implement Sync Logic**
   - Create sync service for new tables
   - Handle bidirectional sync with Firestore
   - Implement conflict resolution

2. **Add Offline UI Indicators**
   - Show cached data badges
   - Display sync status
   - Show last sync timestamp

3. **Add Background Sync**
   - Schedule periodic sync
   - Sync on connectivity change
   - Handle failed syncs with retry

4. **Testing**
   - Test offline mode
   - Test sync functionality
   - Test data integrity

---

## 📝 Notes

- All new tables follow the same pattern as existing tables
- Each table has `synced_at` field for tracking sync status
- Primary keys use string IDs matching Firestore document IDs
- Timestamps stored as DateTime for easy querying
- Settings table uses key-value pattern for flexibility

---

Last Updated: December 28, 2025
Schema Version: 2
