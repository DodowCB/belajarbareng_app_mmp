# 📱 Database Offline - Panduan Penggunaan

Database offline menggunakan **Drift** (SQLite) untuk menyimpan data lokal dan mendukung sinkronisasi dengan Firestore.

## 📦 Struktur Database

### Tables yang Tersedia:
1. **CachedKelas** - Data kelas
2. **CachedMapel** - Data mata pelajaran
3. **CachedKelasNgajar** - Data jadwal mengajar
4. **CachedPengumuman** - Data pengumuman
5. **CachedGuru** - Data guru
6. **CachedSiswa** - Data siswa
7. **CachedSiswaKelas** - Relasi siswa-kelas
8. **SyncQueue** - Antrian sinkronisasi

## 🚀 Cara Penggunaan

### 1. Import Provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/database_provider.dart';
```

### 2. Akses Database di Widget

```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(appDatabaseProvider);
    
    // Sekarang bisa gunakan database
    return FutureBuilder(
      future: database.getAllKelas(),
      builder: (context, snapshot) {
        // ... handle data
      },
    );
  }
}
```

### 3. CRUD Operations

#### **Kelas**

```dart
// Read
final allKelas = await database.getAllKelas();
final activeKelas = await database.getActiveKelas();
final kelas = await database.getKelasById('1');

// Create/Update
await database.upsertKelas(
  CachedKelasCompanion(
    id: Value('1'),
    namaKelas: Value('Kelas 10 IPA 1'),
    guruId: Value('guru_123'),
    status: Value(true),
    createdAt: Value(DateTime.now()),
    updatedAt: Value(DateTime.now()),
  ),
);

// Delete
await database.deleteKelas('1');
```

#### **Mapel**

```dart
// Read
final allMapel = await database.getAllMapel();
final mapel = await database.getMapelById('1');

// Create/Update
await database.upsertMapel(
  CachedMapelCompanion(
    id: Value('1'),
    namaMapel: Value('Matematika'),
    createdAt: Value(DateTime.now()),
    updatedAt: Value(DateTime.now()),
  ),
);

// Delete
await database.deleteMapel('1');
```

#### **Pengumuman**

```dart
// Read
final allPengumuman = await database.getAllPengumuman();
final pengumumanGuru = await database.getPengumumanByType('guru');

// Create/Update
await database.upsertPengumuman(
  CachedPengumumanCompanion(
    id: Value('1'),
    judul: Value('Libur Semester'),
    isi: Value('Libur semester akan dimulai...'),
    tipe: Value('umum'),
    tanggalDibuat: Value(DateTime.now()),
    createdAt: Value(DateTime.now()),
    updatedAt: Value(DateTime.now()),
  ),
);

// Delete
await database.deletePengumuman('1');
```

## 🔄 Sinkronisasi dengan Firestore

### Setup Sync Service

```dart
import '../core/services/database_sync_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final database = ref.watch(appDatabaseProvider);
final firestore = FirebaseFirestore.instance;
final syncService = DatabaseSyncService(database, firestore);
```

### Sync dari Firestore ke Local

```dart
// Sync semua data
await syncService.syncAllFromFirestore();

// Atau sync per collection
await syncService.syncKelasFromFirestore();
await syncService.syncMapelFromFirestore();
await syncService.syncPengumumanFromFirestore();
```

### Sync dari Local ke Firestore

```dart
// Process pending sync queue
await syncService.processSyncQueue();
```

### Menambahkan ke Sync Queue

```dart
// Ketika create/update/delete offline
await database.addToSyncQueue(
  tableName: 'kelas',
  recordId: '1',
  operation: 'insert', // atau 'update', 'delete'
  data: jsonEncode({...}), // optional
);
```

## 📊 Database Stats

```dart
final stats = await database.getDatabaseStats();
print('Jumlah kelas: ${stats['kelas']}');
print('Jumlah mapel: ${stats['mapel']}');
print('Pending sync: ${stats['sync_queue']}');
```

## 🧹 Clear Data

```dart
// Clear semua data (saat logout)
await database.clearAllData();

// Clear completed sync items
await syncService.clearOldSyncItems();
```

## 💡 Best Practices

### 1. **Gunakan di BLoC/Provider**

```dart
class KelasBloc extends Bloc<KelasEvent, KelasState> {
  final AppDatabase database;
  final DatabaseSyncService syncService;
  
  KelasBloc(this.database, this.syncService) : super(KelasInitial());
  
  Future<void> loadKelas() async {
    try {
      // Try load from local first
      final localData = await database.getAllKelas();
      
      if (localData.isNotEmpty) {
        emit(KelasLoaded(localData));
      }
      
      // Then sync from Firestore in background
      await syncService.syncKelasFromFirestore();
      final updatedData = await database.getAllKelas();
      emit(KelasLoaded(updatedData));
    } catch (e) {
      emit(KelasError(e.toString()));
    }
  }
}
```

### 2. **Auto Sync on App Start**

```dart
// Di main.dart atau splash screen
Future<void> initializeApp() async {
  final database = ref.read(appDatabaseProvider);
  final firestore = FirebaseFirestore.instance;
  final syncService = DatabaseSyncService(database, firestore);
  
  try {
    await syncService.syncAllFromFirestore();
    print('✅ Data synced successfully');
  } catch (e) {
    print('⚠️ Sync failed: $e');
    // App tetap bisa jalan dengan data lokal
  }
}
```

### 3. **Periodic Sync**

```dart
// Setup periodic sync setiap 5 menit
Timer.periodic(Duration(minutes: 5), (timer) async {
  try {
    await syncService.processSyncQueue();
    await syncService.syncAllFromFirestore();
  } catch (e) {
    print('⚠️ Periodic sync failed: $e');
  }
});
```

### 4. **Offline-First Pattern**

```dart
Future<void> createKelas(String nama, String guruId) async {
  // 1. Save to local database immediately
  final newId = DateTime.now().millisecondsSinceEpoch.toString();
  await database.upsertKelas(
    CachedKelasCompanion(
      id: Value(newId),
      namaKelas: Value(nama),
      guruId: Value(guruId),
      status: Value(true),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ),
  );
  
  // 2. Add to sync queue
  await database.addToSyncQueue(
    tableName: 'kelas',
    recordId: newId,
    operation: 'insert',
  );
  
  // 3. Try sync immediately (if online)
  try {
    final kelas = await database.getKelasById(newId);
    if (kelas != null) {
      await syncService.syncKelasToFirestore(kelas);
    }
  } catch (e) {
    // Will be synced later via processSyncQueue
    print('⚠️ Offline - will sync later');
  }
}
```

## 🔧 Troubleshooting

### Error: "Table doesn't exist"
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Clear database (for testing)
```dart
await database.clearAllData();
```

### Check database file location
```dart
import 'package:path_provider/path_provider.dart';
final dir = await getApplicationDocumentsDirectory();
print('Database location: ${dir.path}/belajarbareng_app.sqlite');
```

## 📝 Notes

- Database menggunakan **SQLite** via Drift
- Semua timestamp menggunakan `DateTime` Dart
- ID menggunakan `String` untuk konsistensi dengan Firestore
- `syncedAt` menandakan kapan terakhir data disync dengan Firestore
- `SyncQueue` otomatis menangani retry jika sync gagal
