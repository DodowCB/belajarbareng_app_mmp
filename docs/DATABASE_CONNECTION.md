# 🔌 DATABASE CONNECTION GUIDE

## 📋 Setup Firebase Firestore

### Step 1: Create Firebase Project

```bash
# 1. Go to Firebase Console
https://console.firebase.google.com/

# 2. Click "Add Project"
# 3. Enter project name: "belajarbareng-app"
# 4. Enable Google Analytics (optional)
# 5. Create project
```

---

### Step 2: Add Apps to Firebase Project

#### **Web App**

```bash
# In Firebase Console:
1. Click "Web" icon (</>)
2. App nickname: "BelajarBareng Web"
3. Check "Also set up Firebase Hosting"
4. Register app
5. Copy configuration
```

#### **Android App**

```bash
# In Firebase Console:
1. Click "Android" icon
2. Android package name: com.example.belajarbareng_app_mmp
3. Download google-services.json
4. Place in: android/app/google-services.json
```

#### **iOS App** (if needed)

```bash
# In Firebase Console:
1. Click "iOS" icon
2. iOS bundle ID: com.example.belajarbarengAppMmp
3. Download GoogleService-Info.plist
4. Place in: ios/Runner/GoogleService-Info.plist
```

---

### Step 3: Install FlutterFire CLI

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for Flutter project
flutterfire configure
```

**Output**: This will generate `lib/firebase_options.dart`

---

### Step 4: Enable Firestore Database

```bash
# In Firebase Console:
1. Go to "Firestore Database"
2. Click "Create database"
3. Select "Start in production mode" (for now)
4. Choose location: asia-southeast1 (Singapore) or asia-southeast2 (Jakarta)
5. Click "Enable"
```

---

### Step 5: Set Security Rules

Go to Firestore → Rules tab:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }

    // Users
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && isOwner(userId);
      allow update, delete: if isOwner(userId);
    }

    // Study Groups
    match /study_groups/{groupId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isSignedIn() &&
        (isOwner(resource.data.creatorId) ||
         request.auth.uid in resource.data.members);
      allow delete: if isOwner(resource.data.creatorId);
    }

    // Learning Materials
    match /learning_materials/{materialId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isOwner(resource.data.creatorId);
    }

    // User Progress
    match /user_progress/{progressId} {
      allow read: if isOwner(resource.data.userId);
      allow write: if isSignedIn() && isOwner(request.resource.data.userId);
    }

    // Default deny all
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

**Click "Publish"**

---

### Step 6: Enable Authentication

```bash
# In Firebase Console:
1. Go to "Authentication"
2. Click "Get started"
3. Enable sign-in methods:
   - Email/Password ✅
   - Google ✅
4. Add authorized domain for web:
   - localhost (already added)
   - Your deployment domain
```

---

## 💻 Code Implementation

### Initialize Firebase in Flutter

**File**: `lib/main.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: AppWidget()));
}
```

---

### Create Firestore Service Instance

**File**: `lib/src/api/firebase/firestore_service.dart` (already exists)

**Usage**:

```dart
// Initialize service
final firestoreService = FirestoreService();

// Create/Update user
await firestoreService.createOrUpdateUser(
  userId: 'user_123',
  userData: {
    'email': 'user@example.com',
    'displayName': 'John Doe',
    'createdAt': FieldValue.serverTimestamp(),
  },
);

// Get user data
final userData = await firestoreService.getUserData('user_123');

// Create study group
await firestoreService.createStudyGroup({
  'name': 'Flutter Developers',
  'description': 'Learning Flutter together',
  'category': 'Programming',
  'creatorId': 'user_123',
  'members': ['user_123'],
  'maxMembers': 50,
  'isPublic': true,
});

// Get learning materials
final materials = await firestoreService.getLearningMaterials(
  category: 'Programming',
  limit: 20,
);

// Update user progress
await firestoreService.updateUserProgress(
  userId: 'user_123',
  materialId: 'material_456',
  progressPercentage: 0.75,
);
```

---

## 🗄️ Setup Local SQLite Database

### Create Drift Database

**File**: `lib/src/data/local/app_database.dart` (create new)

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Define Tables
class CachedMaterials extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text()();
  TextColumn get type => text()();
  TextColumn get url => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  TextColumn get creatorId => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get tags => text()(); // JSON
  IntColumn get difficulty => integer()();
  IntColumn get estimatedDuration => integer()();
  TextColumn get metadata => text()(); // JSON
  IntColumn get cachedAt => integer()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedGroups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text()();
  TextColumn get creatorId => text()();
  TextColumn get members => text()(); // JSON array
  IntColumn get maxMembers => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get isPublic => boolean()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get settings => text()(); // JSON
  IntColumn get cachedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class OfflineProgress extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get materialId => text()();
  RealColumn get progress => real()();
  IntColumn get lastUpdated => integer()();
  IntColumn get completedAt => integer().nullable()();
  IntColumn get timeSpent => integer()();
  TextColumn get additionalData => text()(); // JSON
  TextColumn get syncStatus => text()(); // 'pending', 'synced', 'error'

  @override
  Set<Column> get primaryKey => {id};
}

// Database class
@DriftDatabase(tables: [CachedMaterials, CachedGroups, OfflineProgress])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD Operations

  // Materials
  Future<List<CachedMaterial>> getAllMaterials() => select(cachedMaterials).get();

  Future<CachedMaterial?> getMaterialById(String id) =>
    (select(cachedMaterials)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<int> insertMaterial(CachedMaterialsCompanion material) =>
    into(cachedMaterials).insert(material);

  Future<bool> updateMaterial(CachedMaterial material) =>
    update(cachedMaterials).replace(material);

  Future<int> deleteMaterial(String id) =>
    (delete(cachedMaterials)..where((m) => m.id.equals(id))).go();

  // Progress
  Future<List<OfflineProgres>> getUserProgress(String userId) =>
    (select(offlineProgress)..where((p) => p.userId.equals(userId))).get();

  Future<int> insertProgress(OfflineProgressCompanion progress) =>
    into(offlineProgress).insert(progress, mode: InsertMode.insertOrReplace);

  // Sync
  Future<List<OfflineProgres>> getPendingSync() =>
    (select(offlineProgress)..where((p) => p.syncStatus.equals('pending'))).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'belajarbareng.db'));
    return NativeDatabase.createInBackground(file);
  });
}
```

---

### Generate Drift Code

```bash
# Run build runner to generate database code
dart run build_runner build --delete-conflicting-outputs
```

---

### Use Local Database

```dart
// Initialize database
final database = AppDatabase();

// Insert material
await database.insertMaterial(
  CachedMaterialsCompanion.insert(
    id: 'material_1',
    title: 'Flutter Basics',
    category: 'Programming',
    type: 'video',
    url: 'https://...',
    creatorId: 'user_123',
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
    tags: json.encode(['flutter', 'dart']),
    difficulty: 1,
    estimatedDuration: 45,
    metadata: json.encode({'viewCount': 1000}),
    cachedAt: DateTime.now().millisecondsSinceEpoch,
  ),
);

// Get all materials
final materials = await database.getAllMaterials();

// Update progress
await database.insertProgress(
  OfflineProgressCompanion.insert(
    id: 'user_123_material_1',
    userId: 'user_123',
    materialId: 'material_1',
    progress: 0.5,
    lastUpdated: DateTime.now().millisecondsSinceEpoch,
    timeSpent: 1200,
    additionalData: json.encode({}),
    syncStatus: const Value('pending'),
  ),
);

// Get pending sync items
final pending = await database.getPendingSync();
```

---

## 🔄 Sync Strategy Implementation

**File**: `lib/src/data/services/sync_service.dart` (create new)

```dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../local/app_database.dart';
import '../../api/firebase/firestore_service.dart';

class SyncService {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;
  final Connectivity _connectivity;

  Timer? _syncTimer;
  bool _isSyncing = false;

  SyncService({
    required AppDatabase localDb,
    required FirestoreService firestoreService,
  }) : _localDb = localDb,
       _firestoreService = firestoreService,
       _connectivity = Connectivity();

  // Start periodic sync (every 15 minutes)
  void startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => syncAll(),
    );
  }

  // Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  // Check if device is online
  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Sync all data
  Future<void> syncAll() async {
    if (_isSyncing || !await isOnline()) return;

    _isSyncing = true;
    try {
      // 1. Upload pending progress to cloud
      await _syncProgressToCloud();

      // 2. Download latest data from cloud
      await _syncMaterialsFromCloud();
      await _syncGroupsFromCloud();

    } catch (e) {
      print('Sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // Sync progress to cloud
  Future<void> _syncProgressToCloud() async {
    final pendingProgress = await _localDb.getPendingSync();

    for (final progress in pendingProgress) {
      try {
        await _firestoreService.updateUserProgress(
          userId: progress.userId,
          materialId: progress.materialId,
          progressPercentage: progress.progress,
          additionalData: json.decode(progress.additionalData),
        );

        // Update sync status
        await _localDb.update(_localDb.offlineProgress).replace(
          progress.copyWith(syncStatus: 'synced'),
        );
      } catch (e) {
        print('Error syncing progress: $e');
        await _localDb.update(_localDb.offlineProgress).replace(
          progress.copyWith(syncStatus: 'error'),
        );
      }
    }
  }

  // Sync materials from cloud
  Future<void> _syncMaterialsFromCloud() async {
    final materials = await _firestoreService.getLearningMaterials(limit: 100);

    for (final doc in materials.docs) {
      final data = doc.data() as Map<String, dynamic>;

      await _localDb.insertMaterial(
        CachedMaterialsCompanion.insert(
          id: doc.id,
          title: data['title'] ?? '',
          description: Value(data['description']),
          category: data['category'] ?? '',
          type: data['type'] ?? '',
          url: data['url'] ?? '',
          thumbnailUrl: Value(data['thumbnailUrl']),
          creatorId: data['creatorId'] ?? '',
          createdAt: (data['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0,
          updatedAt: (data['updatedAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0,
          tags: json.encode(data['tags'] ?? []),
          difficulty: data['difficulty'] ?? 1,
          estimatedDuration: data['estimatedDuration'] ?? 0,
          metadata: json.encode(data['metadata'] ?? {}),
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }

  // Sync groups from cloud
  Future<void> _syncGroupsFromCloud() async {
    final groups = await _firestoreService.getStudyGroups(limit: 100);

    for (final doc in groups.docs) {
      final data = doc.data() as Map<String, dynamic>;

      await _localDb.into(_localDb.cachedGroups).insert(
        CachedGroupsCompanion.insert(
          id: doc.id,
          name: data['name'] ?? '',
          description: Value(data['description']),
          category: data['category'] ?? '',
          creatorId: data['creatorId'] ?? '',
          members: json.encode(data['members'] ?? []),
          maxMembers: data['maxMembers'] ?? 50,
          createdAt: (data['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0,
          updatedAt: (data['updatedAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0,
          isPublic: data['isPublic'] ?? true,
          imageUrl: Value(data['imageUrl']),
          settings: json.encode(data['settings'] ?? {}),
          cachedAt: DateTime.now().millisecondsSinceEpoch,
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }
}
```

---

## 🎯 Integration with Riverpod

**File**: `lib/src/core/providers/database_providers.dart` (create new)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/app_database.dart';
import '../../api/firebase/firestore_service.dart';
import '../../data/services/sync_service.dart';

// Local Database Provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Firestore Service Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Sync Service Provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final localDb = ref.watch(appDatabaseProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  final syncService = SyncService(
    localDb: localDb,
    firestoreService: firestoreService,
  );

  // Start periodic sync
  syncService.startPeriodicSync();

  ref.onDispose(() => syncService.stopPeriodicSync());

  return syncService;
});
```

---

## 📊 Testing Database Connection

```dart
// Test Firestore
void testFirestoreConnection() async {
  final service = FirestoreService();

  try {
    // Create test user
    await service.createOrUpdateUser(
      userId: 'test_user_1',
      userData: {
        'email': 'test@example.com',
        'displayName': 'Test User',
        'createdAt': FieldValue.serverTimestamp(),
      },
    );

    print('✅ Firestore connection successful!');

    // Get user data
    final userData = await service.getUserData('test_user_1');
    print('User data: ${userData.data()}');

  } catch (e) {
    print('❌ Firestore error: $e');
  }
}

// Test SQLite
void testSQLiteConnection() async {
  final db = AppDatabase();

  try {
    // Insert test material
    await db.insertMaterial(
      CachedMaterialsCompanion.insert(
        id: 'test_material_1',
        title: 'Test Material',
        category: 'Programming',
        type: 'video',
        url: 'https://example.com',
        creatorId: 'test_user',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        tags: '[]',
        difficulty: 1,
        estimatedDuration: 30,
        metadata: '{}',
        cachedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    print('✅ SQLite connection successful!');

    // Get all materials
    final materials = await db.getAllMaterials();
    print('Materials count: ${materials.length}');

  } catch (e) {
    print('❌ SQLite error: $e');
  }
}
```

---

## ✅ Checklist

### Firebase Setup

- [ ] Create Firebase project
- [ ] Add web app
- [ ] Add Android app
- [ ] Add iOS app (if needed)
- [ ] Enable Firestore
- [ ] Set security rules
- [ ] Enable Authentication (Email/Password, Google)
- [ ] Run `flutterfire configure`
- [ ] Test connection

### Local Database Setup

- [ ] Create `app_database.dart`
- [ ] Define tables
- [ ] Run build_runner
- [ ] Test insert/read operations
- [ ] Implement sync service

### Integration

- [ ] Create Riverpod providers
- [ ] Implement sync strategy
- [ ] Test offline functionality
- [ ] Test online sync

---

**Status**: ✅ Ready for Implementation  
**Last Updated**: November 4, 2025
