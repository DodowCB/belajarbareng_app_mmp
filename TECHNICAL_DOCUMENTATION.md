# 📚 Technical Documentation - BelajarBareng App

> Jawaban ringkas untuk pertanyaan teknis project

---

---

## ❓ Pertanyaan & Jawaban

### **1. Apakah terdapat 5 halaman dan navigation yang digunakan?**

**Jawaban:** Ya, ada **15+ halaman** dengan navigation.

**Halaman Admin:**
- `admin_screen.dart` - Dashboard
- `teachers_screen.dart` - Management guru
- `students_screen.dart` - Management siswa
- `subjects_screen.dart` - Management mapel
- `classes_screen.dart` - Management kelas
- `pengumuman_screen.dart` - Management pengumuman
- `jadwal_mengajar_screen.dart` - Jadwal mengajar
- `guru_location_screen.dart` - Tracking lokasi guru
- `reports_screen.dart` - Laporan
- `analytics_screen.dart` - Analitik
- `settings_screen.dart` - Pengaturan
- `notifications_screen.dart` - Notifikasi

**Halaman Guru:**
- `halaman_guru_screen.dart` - Dashboard guru
- `create_material_screen.dart` - Upload materi dengan YouTube

**Halaman Siswa:**
- `halaman_siswa_screen.dart` - Dashboard siswa

**Navigation:** Menggunakan `Navigator.push()` dengan `MaterialPageRoute`

---

### **2. Apa aja API yang digunakan?**

**Jawaban:**

**External APIs:**
1. **YouTube Data API v3** - Search video edukatif
   - Terletak: `lib/src/api/youtube/youtube_api_service.dart`
   - Digunakan di: `create_material_screen.dart`

2. **Geolocator API** (GPS/Location) - Track lokasi guru
   - Terletak: `lib/src/core/services/location_service.dart`
   - Digunakan di: `halaman_guru_screen.dart`, `guru_location_screen.dart`

3. **URL Launcher** - Open YouTube & Google Maps
   - Digunakan di: `create_material_screen.dart`, `guru_location_screen.dart`

4. **Excel Import API** - Import data dari Excel
   - Terletak: `lib/src/core/services/excel_import_service.dart`
   - Digunakan di: `teachers_screen.dart`, `students_screen.dart`

**Firebase Services:**
- **Firebase Authentication** - Login/Logout
- **Cloud Firestore** - Database NoSQL real-time

---

### **3. Apakah menggunakan Firebase atau Firestore?**

**Jawaban:** Menggunakan **KEDUANYA**

- **Firebase Authentication** untuk login/logout
  - Terletak di semua screen yang menggunakan `FirebaseAuth.instance`
  
- **Cloud Firestore** untuk database
  - Collections: `guru`, `siswa`, `mapel`, `kelas`, `pengumuman`, `kelas_ngajar`, `guru_locations`
  - Digunakan di semua screen management (CRUD operations)

---

### **4. Apakah menggunakan SQLite?**

**Jawaban:** **TIDAK**. 

Project ini menggunakan **Cloud Firestore** (NoSQL cloud database) dan **SharedPreferences** untuk local caching, bukan SQLite.

---

### **5. Apakah menggunakan BLoC?**

**Jawaban:** **YA**, menggunakan BLoC pattern.

**BLoC yang ada:**
- `AdminBloc` - Terletak: `lib/src/features/auth/presentation/admin/admin_bloc.dart`
  - Digunakan di: `admin_screen.dart`, `teachers_screen.dart`, `students_screen.dart`, dll.

- `GuruProfileBloc` - Terletak: `lib/src/features/auth/presentation/halamanGuru/blocs/guru_profile/guru_profile_bloc.dart`
  - Digunakan di: `halaman_guru_screen.dart`

- `PengumumanBloc` - Terletak: `lib/src/features/auth/presentation/pengumuman/pengumuman_bloc.dart`
  - Digunakan di: `pengumuman_screen.dart`

**Package:** `flutter_bloc: ^8.1.3`

---

### **6. Apakah menggunakan sensor seperti location?**

**Jawaban:** **YA**, menggunakan GPS/Location sensor.

**Location Service:**
- Terletak: `lib/src/core/services/location_service.dart`
- Digunakan di:
  - `halaman_guru_screen.dart` - Request permission & update lokasi
  - `guru_location_screen.dart` - Display lokasi real-time
  - `guru_app_scaffold.dart` - Set offline saat logout

**Repository:**
- Terletak: `lib/src/features/auth/data/repositories/location_repository.dart`

**Permission Helper:**
- Terletak: `lib/src/features/auth/presentation/location/location_permission_helper.dart`

**Package:** `geolocator: ^13.0.2`

**Fitur:**
- Request location permission dengan dialog
- Track koordinat GPS real-time
- Update ke Firestore collection `guru_locations`
- Auto-offline saat logout
- Open Google Maps
- Copy coordinates

---

### **7. Apakah terdapat Gemini API?**

**Jawaban:** **TIDAK**. 

Project ini tidak menggunakan AI API seperti Gemini, ChatGPT, atau sejenisnya.

---

### **8. Apakah terdapat automated testing?**

**Jawaban:** **YA**, ada **71 unit tests** (semua PASSED).

**Test Files:**
1. `test/core/services/camera_service_test.dart` - 16 tests
2. `test/core/utils/validators_test.dart` - 28 tests (email, NIP, NIS, phone validation)
3. `test/core/services/excel_import_service_test.dart` - 27 tests
4. `test/features/auth/presentation/admin/admin_bloc_test.dart` - BLoC state tests

**Package:** `flutter_test`, `bloc_test`, `mockito`

**Run:** `flutter test` → Output: `00:02 +71: All tests passed!`

---

### **9. Fitur-fitur apa aja yang digunakan atau dibuat?**

**Jawaban:**

**Core Features:**
1. Multi-role authentication (Admin, Guru, Siswa)
2. CRUD Management (Guru, Siswa, Mapel, Kelas, Pengumuman, Jadwal)
3. Excel import/export guru & siswa
4. YouTube video search untuk materi pembelajaran
5. GPS location tracking guru real-time
6. Notifications system
7. Offline mode dengan caching
8. Dark mode support
9. Responsive design (Mobile, Tablet, Desktop)
10. Real-time data updates dengan Firestore streams
11. Google Maps integration
12. Search & filter functionality

**UI Features:**
- Skeleton loading screens
- Progress indicators
- Success/error snackbars
- Profile dropdown menu
- Time picker GUI
- Multiple selection dengan checkbox

---

### **10. Daftar page yang menggunakan API**

**Jawaban:**

**YouTube Data API v3:**
- `create_material_screen.dart` - Search & add video ke materi

**Geolocator API (GPS):**
- `halaman_guru_screen.dart` - Request permission, update lokasi
- `guru_location_screen.dart` - Display lokasi, open Google Maps
- `guru_app_scaffold.dart` - Set offline on logout

**URL Launcher:**
- `create_material_screen.dart` - Open YouTube video
- `guru_location_screen.dart` - Open Google Maps

**Excel Import:**
- `teachers_screen.dart` - Import guru dari Excel
- `students_screen.dart` - Import siswa dari Excel

**Cloud Firestore (semua collections):**
- `admin_screen.dart` - Read all collections
- `teachers_screen.dart` - CRUD `guru`
- `students_screen.dart` - CRUD `siswa`
- `subjects_screen.dart` - CRUD `mapel`
- `classes_screen.dart` - CRUD `kelas`
- `pengumuman_screen.dart` - CRUD `pengumuman`
- `jadwal_mengajar_screen.dart` - CRUD `kelas_ngajar`
- `guru_location_screen.dart` - Read `guru_locations` (real-time stream)
- `notifications_screen.dart` - Read `notifications`

---

### **11. Jelaskan authentication dan authorization yang digunakan**

**Jawaban:**

**Authentication:**
- Menggunakan **Firebase Authentication** dengan email/password
- Login flow: `FirebaseAuth.instance.signInWithEmailAndPassword()`
- Session management: Firebase Auth tokens (auto-refresh)
- Logout: `FirebaseAuth.instance.signOut()` + set guru offline

**Authorization (Role-Based Access Control):**

**Role Detection:**
- Admin: Email = `admin@gmail.com`
- Guru: Check di Firestore collection `guru`
- Siswa: Check di Firestore collection `siswa`

**Access Control:**
- **Admin**: Full access semua fitur (CRUD, reports, tracking, settings)
- **Guru**: Upload materi, view jadwal, update location GPS
- **Siswa**: View materi, submit tugas, take quiz

**Implementation:**
- Client-side: Conditional rendering berdasarkan `AppUser.role`
- Server-side: Firestore Security Rules
  - Admin dapat write semua collections
  - Guru dapat update lokasi sendiri (`guru_locations/{userId}`)
  - Siswa read-only untuk materi

**Security:**
- Password hashing (Firebase automatic)
- HTTPS encryption (semua Firebase requests)
- Session tokens dengan auto-refresh
- Input validation (email, NIP, NIS format)
- Permission dialogs untuk GPS access

**Files terkait:**

---

## 📊 Summary Table

| Feature | Status | Details |
|---------|--------|---------|
| **Pages & Navigation** | ✅ **15+ pages** | Admin (12), Guru (3+), Siswa |
| **YouTube API** | ✅ **v3** | Search videos di `create_material_screen.dart` |
| **Location/GPS API** | ✅ **Geolocator** | Track di `halaman_guru_screen.dart`, `guru_location_screen.dart` |
| **URL Launcher** | ✅ **Yes** | Open YouTube & Google Maps |
| **Excel Import** | ✅ **Yes** | Import di `teachers_screen.dart`, `students_screen.dart` |
| **Firebase Auth** | ✅ **Yes** | Email/Password authentication |
| **Cloud Firestore** | ✅ **Yes** | Real-time NoSQL database (9 collections) |
| **SQLite** | ❌ **No** | Menggunakan Firestore |
| **BLoC Pattern** | ✅ **Yes** | AdminBloc, GuruProfileBloc, PengumumanBloc |
| **AI/Gemini API** | ❌ **No** | Not implemented |
| **Unit Testing** | ✅ **71 tests** | All PASSED |
| **Offline Support** | ✅ **Yes** | SharedPreferences caching |
| **Real-time Updates** | ✅ **Yes** | Firestore streams |
| **Dark Mode** | ✅ **Yes** | Theme switching |
| **Responsive Design** | ✅ **Yes** | Mobile, Tablet, Desktop |

---

**Last Updated:** January 13, 2026

#### **Admin Pages (12 halaman)**
| No | Page | Path | Deskripsi |
|----|------|------|-----------|
| 1 | AdminScreen | `/admin` | Dashboard utama admin dengan statistik real-time |
| 2 | TeachersScreen | `/admin/teachers` | Management data guru (CRUD + Excel import) |
| 3 | StudentsScreen | `/admin/students` | Management data siswa (CRUD + Excel import) |
| 4 | SubjectsScreen | `/admin/subjects` | Management mata pelajaran |
| 5 | ClassesScreen | `/admin/classes` | Management kelas |
| 6 | PengumumanScreen | `/admin/pengumuman` | Management pengumuman |
| 7 | JadwalMengajarScreen | `/admin/jadwal` | Management jadwal mengajar |
| 8 | GuruLocationScreen | `/admin/locations` | Tracking lokasi GPS guru real-time |
| 9 | ReportsScreen | `/admin/reports` | Laporan sistem |
| 10 | AnalyticsScreen | `/admin/analytics` | Analitik data |
| 11 | SettingsScreen | `/admin/settings` | Pengaturan sistem |
| 12 | NotificationsScreen | `/admin/notifications` | Notifikasi |

#### **Guru Pages (3+ halaman)**
| No | Page | Path | Deskripsi |
|----|------|------|-----------|
| 13 | HalamanGuruScreen | `/guru` | Dashboard guru dengan tracking lokasi |
| 14 | CreateMaterialScreen | `/guru/create-material` | Upload materi dengan YouTube integration |
| 15 | KelasGuruScreen | `/guru/kelas` | Management kelas yang diajar |

#### **Siswa Pages**
| No | Page | Path | Deskripsi |
|----|------|------|-----------|
| 16 | HalamanSiswaScreen | `/siswa` | Dashboard siswa |

### Navigation Implementation
```dart
// Standard Navigation
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const TeachersScreen(),
  ),
);

// Navigation dengan BLoC state
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => BlocProvider.value(
      value: _adminBloc,
      child: const TeachersScreen(),
    ),
  ),
);
```

---

## 🌐 2. API yang Digunakan

### **A. External APIs**

#### 1️⃣ **YouTube Data API v3**
- **Purpose**: Search video edukatif untuk materi pembelajaran
- **Package**: `http: ^1.2.2`
- **Base URL**: `https://www.googleapis.com/youtube/v3`
- **Endpoints Used**:
  - `GET /search` - Search videos
  - `GET /videos` - Get video details
  - `GET /channels` - Get channel info
  - `GET /playlists` - Get playlist info

**Implementation:**
```dart
class YouTubeApiService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  
  Future<Map<String, dynamic>> searchVideos({
    required String query,
    int maxResults = 10,
    String order = 'relevance',
  }) async {
    final queryParams = {
      'part': 'snippet',
      'q': query,
      'type': 'video',
      'maxResults': maxResults.toString(),
      'key': _apiKey,
    };
    
    final uri = Uri.parse('$_baseUrl/search')
      .replace(queryParameters: queryParams);
    final response = await http.get(uri);
    return json.decode(response.body);
  }
}
```

**Features:**
- ✅ Search video dengan keyword
- ✅ Filter by relevance, date, rating
- ✅ Get video statistics (views, likes)
- ✅ Get channel information
- ✅ Error handling (400, 403, 404)
- ✅ 10 second timeout

#### 2️⃣ **Geolocator API (GPS/Location)**
- **Package**: `geolocator: ^13.0.2`
- **Purpose**: Track lokasi guru real-time
- **Permissions**: 
  - `ACCESS_FINE_LOCATION`
  - `ACCESS_COARSE_LOCATION`

**Implementation:**
```dart
class LocationService {
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  
  double getDistanceBetween(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
```

**Features:**
- ✅ Request location permission dengan dialog
- ✅ Get current GPS coordinates
- ✅ Calculate distance between points
- ✅ Format accuracy (HIGH/MEDIUM/LOW)
- ✅ Update location ke Firestore real-time

#### 3️⃣ **URL Launcher**
- **Package**: `url_launcher: ^6.2.2`
- **Purpose**: Membuka link eksternal

**Use Cases:**

**a. Open YouTube Video**
```dart
final videoUrl = 'https://www.youtube.com/watch?v=$videoId';
await launchUrl(
  Uri.parse(videoUrl),
  mode: LaunchMode.externalApplication,
);
```

**b. Open Google Maps**
```dart
final mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
await launchUrl(
  Uri.parse(mapsUrl),
  mode: LaunchMode.externalApplication,
);
```

**c. Open Email**
```dart
final emailUrl = 'mailto:admin@belajarbareng.com';
await launchUrl(Uri.parse(emailUrl));
```

#### 4️⃣ **Excel Import/Export API**
- **Package**: `excel: ^4.0.6`
- **Purpose**: Import/export data guru & siswa

```dart
// Import Excel
final bytes = await file.readAsBytes();
final excel = Excel.decodeBytes(bytes);
final sheet = excel.tables['Sheet1'];

for (var row in sheet!.rows.skip(1)) {
  final data = {
    'nama_lengkap': row[0]?.value.toString(),
    'email': row[1]?.value.toString(),
    'nip': row[2]?.value.toString(),
  };
  await FirebaseFirestore.instance.collection('guru').add(data);
}
```

### **B. Firebase Services**

#### 1️⃣ **Firebase Authentication**
```dart
import 'package:firebase_auth/firebase_auth.dart';

// Login
final userCredential = await FirebaseAuth.instance
  .signInWithEmailAndPassword(email: email, password: password);

// Get current user
final user = FirebaseAuth.instance.currentUser;

// Logout
await FirebaseAuth.instance.signOut();
```

**Features:**
- ✅ Email/Password authentication
- ✅ User session management
- ✅ Auto token refresh
- ✅ Password reset (optional)

#### 2️⃣ **Cloud Firestore (Database)**
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Create
await FirebaseFirestore.instance
  .collection('guru')
  .add(data);

// Read (Real-time)
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
    .collection('guru')
    .snapshots(),
  builder: (context, snapshot) { ... },
)

// Update
await FirebaseFirestore.instance
  .collection('guru')
  .doc(id)
  .update(data);

// Delete
await FirebaseFirestore.instance
  .collection('guru')
  .doc(id)
  .delete();
```

**Collections:**
```
Firestore
├── guru/                    # Data guru
├── siswa/                   # Data siswa
├── mapel/                   # Mata pelajaran
├── kelas/                   # Kelas
├── pengumuman/              # Pengumuman
├── kelas_ngajar/            # Jadwal mengajar
├── guru_locations/          # GPS tracking guru
│   ├── {guruId}/
│   │   ├── guruName: String
│   │   ├── latitude: Double
│   │   ├── longitude: Double
│   │   ├── timestamp: Timestamp
│   │   ├── isOnline: Boolean
│   │   └── accuracy: String
├── notifications/           # Notifikasi sistem
├── tugas/                   # Tugas siswa
└── quiz/                    # Quiz
```

---

## 🗄️ 3. Database

### ❌ **TIDAK Menggunakan SQLite**

### ✅ **Menggunakan Cloud Firestore (NoSQL)**

**Alasan:**
- Real-time synchronization
- Offline support built-in
- Scalable
- No need local database management
- Auto-backup oleh Google

**Local Storage:**
- **SharedPreferences** untuk caching data offline
- Menyimpan: last_sync_timestamp, cached_stats

---

## 🎯 4. State Management - BLoC Pattern

### ✅ **Menggunakan BLoC (Business Logic Component)**

**Packages:**
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

dev_dependencies:
  bloc_test: ^9.1.5
```

### **BLoC Implementation**

#### **1. AdminBloc**
```dart
// Events
abstract class AdminEvent extends Equatable {}
class LoadAdminData extends AdminEvent {}
class UpdateUserStats extends AdminEvent {}
class TriggerManualSync extends AdminEvent {}
class GetSyncStatus extends AdminEvent {}

// States
class AdminState extends Equatable {
  final bool isLoading;
  final bool isOnline;
  final int totalTeachers;
  final int totalStudents;
  final DateTime? lastSync;
  final String? error;
}

// Bloc
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminState.initial()) {
    on<LoadAdminData>(_onLoadAdminData);
    on<TriggerManualSync>(_onTriggerManualSync);
  }
  
  Future<void> _onLoadAdminData(
    LoadAdminData event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    // Load data from Firestore
    final guruSnapshot = await FirebaseFirestore.instance
      .collection('guru').get();
    
    emit(state.copyWith(
      isLoading: false,
      totalTeachers: guruSnapshot.docs.length,
    ));
  }
}
```

#### **2. GuruProfileBloc**
```dart
class GuruProfileBloc extends Bloc<GuruProfileEvent, GuruProfileState> {
  // Mengelola state profile guru
  // Load profile data
  // Update profile
  // Handle errors
}
```

#### **3. PengumumanBloc**
```dart
class PengumumanBloc extends Bloc<PengumumanEvent, PengumumanState> {
  // Load announcements
  // Create announcement
  // Update announcement
  // Delete announcement
}
```

### **Usage in UI**
```dart
// Provide BLoC
BlocProvider(
  create: (context) => AdminBloc()..add(LoadAdminData()),
  child: AdminScreen(),
)

// Listen to state
BlocBuilder<AdminBloc, AdminState>(
  builder: (context, state) {
    if (state.isLoading) {
      return CircularProgressIndicator();
    }
    return Text('Total: ${state.totalTeachers}');
  },
)

// Dispatch events
context.read<AdminBloc>().add(TriggerManualSync());
```

---

## 📍 5. Sensor - GPS/Location Tracking

### ✅ **Menggunakan GPS Location Sensor**

**Package:** `geolocator: ^13.0.2`

### **Features Implemented:**

#### **1. Permission Handling**
```dart
class LocationPermissionHelper {
  static Future<bool> requestLocationPermission(BuildContext context) async {
    final permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      // Show explanation dialog
      final shouldRequest = await _showPermissionExplanationDialog(context);
      
      if (shouldRequest) {
        return await Geolocator.requestPermission();
      }
    }
    
    return permission == LocationPermission.whileInUse ||
           permission == LocationPermission.always;
  }
}
```

#### **2. Get Current Location**
```dart
Future<Position> getCurrentLocation() async {
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
    timeLimit: Duration(seconds: 10),
  );
}
```

#### **3. Update Location to Firestore**
```dart
Future<void> updateGuruLocation({
  required String guruId,
  required String guruName,
  required double latitude,
  required double longitude,
}) async {
  await FirebaseFirestore.instance
    .collection('guru_locations')
    .doc(guruId)
    .set({
      'guruId': guruId,
      'guruName': guruName,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
      'isOnline': true,
      'accuracy': 'HIGH',
    });
}
```

#### **4. Real-time Location Monitoring**
```dart
StreamBuilder<List<GuruLocation>>(
  stream: FirebaseFirestore.instance
    .collection('guru_locations')
    .where('isOnline', isEqualTo: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
      .map((doc) => GuruLocation.fromFirestore(doc))
      .toList()),
  builder: (context, snapshot) {
    // Display guru locations on map/list
  },
)
```

#### **5. Auto-Offline on Logout**
```dart
@override
void dispose() {
  // Set offline when screen disposed
  if (_currentGuruId != null) {
    LocationRepository().setGuruOffline(_currentGuruId!);
  }
  super.dispose();
}

// App lifecycle observer
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.paused) {
    LocationRepository().setGuruOffline(_currentGuruId!);
  }
}
```

#### **6. Google Maps Integration**
```dart
Future<void> _openInGoogleMaps(double lat, double lng) async {
  final url = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$lat,$lng'
  );
  await launchUrl(url, mode: LaunchMode.externalApplication);
}
```

### **Permissions (AndroidManifest.xml)**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

---

## 🤖 6. AI/Machine Learning APIs

### ❌ **TIDAK Menggunakan:**
- Google Gemini AI
- OpenAI ChatGPT
- TensorFlow Lite
- ML Kit

**Note:** Project fokus pada management sistem pendidikan, bukan AI/ML

---

## 🧪 7. Automated Testing

### ✅ **Unit Testing - 71 Tests (PASSED)**

**Test Coverage:**

#### **1. CameraService Tests** (16 tests)
```dart
test('should return null when permission denied', () async {
  when(mockImagePicker.pickImage(source: ImageSource.camera))
    .thenAnswer((_) async => null);
    
  final result = await cameraService.takePicture();
  expect(result, isNull);
});
```

#### **2. Validators Tests** (28 tests)
```dart
group('Email Validation', () {
  test('valid email should return true', () {
    expect(isValidEmail('test@example.com'), true);
  });
  
  test('invalid email should return false', () {
    expect(isValidEmail('invalid'), false);
  });
});

group('NIP Validation', () {
  test('18 digit NIP should be valid', () {
    expect(isValidNIP('123456789012345678'), true);
  });
});
```

#### **3. ExcelImportService Tests** (27 tests)
```dart
test('should parse Excel file correctly', () async {
  final result = await excelService.importFromExcel(testFile);
  expect(result.length, equals(10));
  expect(result[0]['nama_lengkap'], equals('John Doe'));
});
```

#### **4. AdminBloc Tests**
```dart
blocTest<AdminBloc, AdminState>(
  'emits loading state when LoadAdminData is added',
  build: () => AdminBloc(),
  act: (bloc) => bloc.add(LoadAdminData()),
  expect: () => [
    predicate<AdminState>((state) => state.isLoading == true),
  ],
);
```

### **Run Tests:**
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/utils/validators_test.dart

# Run with coverage
flutter test --coverage

# Output:
# 00:02 +71: All tests passed!
```

### **Test Packages:**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mockito: ^5.4.4
  build_runner: ^2.4.8
```

---

## 🎨 8. Fitur-Fitur Lengkap

### **A. Core Features**

#### 1. **Multi-Role Authentication**
- **Admin**: Full access ke semua fitur
- **Guru**: Upload materi, lihat jadwal, tracking lokasi
- **Siswa**: Lihat materi, submit tugas, quiz

#### 2. **CRUD Management**
| Module | Create | Read | Update | Delete | Import Excel |
|--------|--------|------|--------|--------|--------------|
| Guru | ✅ | ✅ | ✅ | ✅ | ✅ |
| Siswa | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mapel | ✅ | ✅ | ✅ | ✅ | ❌ |
| Kelas | ✅ | ✅ | ✅ | ✅ | ❌ |
| Pengumuman | ✅ | ✅ | ✅ | ✅ | ❌ |
| Jadwal | ✅ | ✅ | ✅ | ✅ | ❌ |

#### 3. **YouTube Integration**
- ✅ Search educational videos
- ✅ Preview video thumbnail
- ✅ Get video statistics (views, likes)
- ✅ Add to learning materials
- ✅ Open in YouTube app

#### 4. **GPS Location Tracking**
- ✅ Track guru location real-time
- ✅ Online/Offline status
- ✅ Last update timestamp
- ✅ Accuracy indicator (HIGH/MEDIUM/LOW)
- ✅ Open in Google Maps
- ✅ Copy coordinates
- ✅ Auto-offline on logout

#### 5. **Notifications System**
- ✅ Real-time notifications
- ✅ Deadline reminders
- ✅ New announcement alerts
- ✅ Quiz reminders

#### 6. **Offline Mode**
- ✅ Cache data with SharedPreferences
- ✅ Offline indicator banner
- ✅ Last sync timestamp
- ✅ Auto-sync when online
- ✅ Disable write operations offline

### **B. UI/UX Features**

#### 1. **Responsive Design**
```dart
final screenWidth = MediaQuery.of(context).size.width;
final crossAxisCount = screenWidth >= 1200 ? 4
  : screenWidth >= 768 ? 3
  : screenWidth >= 600 ? 2
  : 2;
```
- Mobile: 2 columns
- Tablet: 3 columns
- Desktop: 4 columns

#### 2. **Dark Mode Support**
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
final backgroundColor = isDark 
  ? AppTheme.backgroundDark 
  : AppTheme.backgroundLight;
```

#### 3. **Real-time Updates**
```dart
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
    .collection('guru')
    .snapshots(),
  builder: (context, snapshot) {
    // Auto-refresh setiap ada perubahan
  },
)
```

#### 4. **Loading States**
- Skeleton screens
- Shimmer effects
- Progress indicators
- Success/error snackbars

#### 5. **Search & Filter**
```dart
final filteredList = allData.where((item) {
  final name = item['nama'].toLowerCase();
  final searchQuery = _searchController.text.toLowerCase();
  return name.contains(searchQuery);
}).toList();
```

---

## 📄 9. Pages yang Menggunakan API

### **A. YouTube Data API v3**

| Page | Usage | Endpoint |
|------|-------|----------|
| CreateMaterialScreen | Search videos untuk materi | `GET /search` |
| CreateMaterialScreen | Get video details | `GET /videos` |
| CreateMaterialScreen | Get channel info | `GET /channels` |

**Example:**
```dart
// CreateMaterialScreen
final videos = await _youtubeService.searchVideos(
  query: 'matematika kelas 10',
  maxResults: 20,
  order: 'relevance',
);
```

### **B. Geolocator API (GPS)**

| Page | Usage | Methods |
|------|-------|---------|
| HalamanGuruScreen | Request permission, update location | `getCurrentPosition()`, `checkPermission()` |
| GuruLocationScreen | Display locations, open maps | `getDistanceBetween()`, `launchUrl()` |
| GuruAppScaffold | Set offline on logout | `setGuruOffline()` |

### **C. Cloud Firestore**

| Page | Collections Used | Operations |
|------|------------------|------------|
| AdminScreen | All collections | Read (real-time) |
| TeachersScreen | `guru` | CRUD + Stream |
| StudentsScreen | `siswa` | CRUD + Stream |
| SubjectsScreen | `mapel` | CRUD |
| ClassesScreen | `kelas` | CRUD |
| PengumumanScreen | `pengumuman` | CRUD |
| JadwalMengajarScreen | `kelas_ngajar`, `guru`, `mapel`, `kelas` | CRUD + Joins |
| GuruLocationScreen | `guru_locations` | Read (real-time stream) |
| HalamanGuruScreen | `guru`, `guru_locations` | Read + Update |
| NotificationsScreen | `notifications` | Read |

### **D. URL Launcher**

| Page | Usage | URL Format |
|------|-------|------------|
| CreateMaterialScreen | Open YouTube video | `https://youtube.com/watch?v={videoId}` |
| GuruLocationScreen | Open Google Maps | `https://google.com/maps/search/?api=1&query={lat},{lng}` |
| Various | Open email | `mailto:{email}` |

### **E. Excel Import**

| Page | Usage |
|------|-------|
| TeachersScreen | Import guru dari Excel file (.xlsx) |
| StudentsScreen | Import siswa dari Excel file (.xlsx) |

---

## 🔐 10. Authentication & Authorization

### **Authentication Flow**

#### **1. Login dengan Email/Password**
```dart
Future<UserCredential> login(String email, String password) async {
  return await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}
```

#### **2. Role Detection**
```dart
Future<String> detectUserRole(String email) async {
  // Check if admin
  if (email == 'admin@gmail.com') {
    return 'admin';
  }
  
  // Check di collection guru
  final guruSnapshot = await FirebaseFirestore.instance
    .collection('guru')
    .where('email', isEqualTo: email)
    .get();
    
  if (guruSnapshot.docs.isNotEmpty) {
    return 'guru';
  }
  
  // Check di collection siswa
  final siswaSnapshot = await FirebaseFirestore.instance
    .collection('siswa')
    .where('email', isEqualTo: email)
    .get();
    
  if (siswaSnapshot.docs.isNotEmpty) {
    return 'siswa';
  }
  
  throw Exception('User role not found');
}
```

#### **3. Session Management**
```dart
class AppUser {
  static String? _uid;
  static String? _email;
  static String? _displayName;
  static String? _role;
  
  static void setUser({
    required String uid,
    required String email,
    required String displayName,
    required String role,
  }) {
    _uid = uid;
    _email = email;
    _displayName = displayName;
    _role = role;
  }
  
  static void clear() {
    _uid = null;
    _email = null;
    _displayName = null;
    _role = null;
  }
}
```

#### **4. Logout**
```dart
Future<void> logout() async {
  // Set guru offline if guru
  if (AppUser.role == 'guru') {
    await LocationRepository().setGuruOffline(AppUser.uid);
  }
  
  // Sign out dari Firebase
  await FirebaseAuth.instance.signOut();
  
  // Clear local session
  AppUser.clear();
  
  // Navigate to login
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (route) => false,
  );
}
```

### **Authorization (Role-Based Access Control)**

#### **Role Hierarchy:**
```
┌─────────────────────────────────────────┐
│              ADMIN                       │
│  - Full system access                   │
│  - CRUD all data                        │
│  - View teacher locations               │
│  - Generate reports                     │
│  - System settings                      │
└─────────────────────────────────────────┘
           │
           ├──────────────────┬─────────────────
           │                  │
┌──────────────────┐  ┌──────────────────┐
│      GURU        │  │      SISWA       │
│  - View profile  │  │  - View profile  │
│  - Update GPS    │  │  - View materi   │
│  - Upload materi │  │  - Submit tugas  │
│  - Create tugas  │  │  - Take quiz     │
│  - View jadwal   │  │  - View nilai    │
└──────────────────┘  └──────────────────┘
```

#### **UI Authorization**
```dart
// Conditional rendering based on role
if (AppUser.role == 'admin') {
  return FloatingActionButton(
    onPressed: () => _showAddDialog(),
    child: Icon(Icons.add),
  );
}

// Disable buttons for non-admin
ElevatedButton(
  onPressed: AppUser.role == 'admin' ? _handleEdit : null,
  child: Text('Edit'),
)

// Route protection
if (AppUser.role != 'admin') {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Access denied: Admin only')),
  );
  return;
}
```

#### **Firestore Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function
    function isAdmin() {
      return request.auth.token.email == 'admin@gmail.com';
    }
    
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Guru collection - Read: All authenticated, Write: Admin only
    match /guru/{guruId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Siswa collection - Read: All authenticated, Write: Admin only
    match /siswa/{siswaId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Guru locations - Read: Admin, Write: Own location
    match /guru_locations/{locationId} {
      allow read: if isAdmin();
      allow write: if isAuthenticated() && request.auth.uid == locationId;
    }
    
    // Pengumuman - Read: All, Write: Admin
    match /pengumuman/{pengumumanId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Mapel, Kelas, JadwalMengajar - Admin only
    match /mapel/{mapelId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    match /kelas/{kelasId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    match /kelas_ngajar/{jadwalId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
  }
}
```

### **Security Features:**

| Feature | Status | Implementation |
|---------|--------|----------------|
| Password Hashing | ✅ | Firebase Auth (automatic) |
| Session Tokens | ✅ | Firebase Auth tokens (auto-refresh) |
| Role-Based Access | ✅ | Custom AppUser + Firestore rules |
| HTTPS Encryption | ✅ | All Firebase communication |
| Input Validation | ✅ | Client-side validators |
| SQL Injection Prevention | ✅ | NoSQL Firestore (no SQL) |
| Permission Dialogs | ✅ | Location permission handling |
| Auto-logout on Close | ✅ | Lifecycle management |

---

## 📊 Summary Table

| Feature | Status | Details |
|---------|--------|---------|
| **Pages & Navigation** | ✅ **15+ pages** | Admin (12), Guru (3+), Siswa |
| **YouTube API** | ✅ **v3** | Search videos, get details, statistics |
| **Location/GPS API** | ✅ **Geolocator** | Real-time tracking, Google Maps |
| **URL Launcher** | ✅ **Yes** | YouTube, Google Maps, Email |
| **Excel Import** | ✅ **Yes** | Import guru & siswa from .xlsx |
| **Firebase Auth** | ✅ **Yes** | Email/Password authentication |
| **Cloud Firestore** | ✅ **Yes** | Real-time NoSQL database |
| **SQLite** | ❌ **No** | Using Firestore (cloud) |
| **BLoC Pattern** | ✅ **Yes** | AdminBloc, GuruProfileBloc, etc |
| **AI/Gemini API** | ❌ **No** | Not implemented |
| **Unit Testing** | ✅ **71 tests** | CameraService, Validators, Excel, BLoC |
| **Offline Support** | ✅ **Yes** | SharedPreferences caching |
| **Real-time Updates** | ✅ **Yes** | Firestore streams |
| **Dark Mode** | ✅ **Yes** | Theme switching |
| **Responsive Design** | ✅ **Yes** | Mobile, Tablet, Desktop |

---

## 🚀 API Keys Required

### **1. YouTube Data API v3**
```dart
// lib/src/api/config/api_config.dart
class ApiConfig {
  static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY';
}
```

**Get API Key:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project
3. Enable **YouTube Data API v3**
4. Create credentials (API Key)
5. Restrict API key to YouTube Data API v3 only

### **2. Firebase Configuration**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize Firebase
firebase init

# Configure Firebase for Flutter
flutterfire configure
```

**Files Generated:**
- `firebase.json`
- `firestore.rules`
- `lib/firebase_options.dart`

---

## 📱 Permissions Required

### **Android (AndroidManifest.xml)**
```xml
<!-- Internet -->
<uses-permission android:name="android.permission.INTERNET"/>

<!-- Location/GPS -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

<!-- File Access -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

<!-- Network State -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### **iOS (Info.plist)**
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to track attendance</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location for attendance tracking</string>

<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>
```

---

## 🔧 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  flutter_riverpod: ^2.6.1
  equatable: ^2.0.5
  
  # Firebase
  firebase_core: ^3.15.2
  firebase_auth: ^5.7.0
  cloud_firestore: ^5.6.12
  firebase_storage: ^12.4.10
  
  # API & Network
  http: ^1.2.2                    # YouTube API
  geolocator: ^13.0.2             # GPS/Location
  url_launcher: ^6.2.2            # Open URLs
  
  # Local Storage
  shared_preferences: ^2.5.3
  flutter_secure_storage: ^9.2.4
  
  # File Handling
  excel: ^4.0.6                   # Excel import/export
  file_picker: ^8.3.7
  
  # UI
  google_fonts: ^6.3.2
  fl_chart: ^0.69.2              # Charts
  intl: ^0.19.0                  # Date formatting

dev_dependencies:
  # Testing
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mockito: ^5.4.4
  build_runner: ^2.4.8
  
  # Code Quality
  flutter_lints: ^5.0.0
  very_good_analysis: ^5.1.0
```

---

## 📖 Documentation Links

- [Architecture Overview](./docs/architecture/README.md)
- [YouTube Integration Guide](./docs/features/THEME_YOUTUBE_FEATURES.md)
- [Database Design](./docs/DATABASE_DESIGN.md)
- [Getting Started](./docs/GETTING_STARTED.md)
- [Testing Guide](./test/README.md)

---

## 👥 Credits

**Developed by:** Team BelajarBareng
**Framework:** Flutter 3.x
**Backend:** Firebase (Auth, Firestore, Storage)
**APIs:** YouTube Data API v3, Geolocator, URL Launcher

---

**Last Updated:** January 13, 2026
