# 📍 Fitur Location/GPS Tracking untuk Guru

## ✅ Implementasi Selesai

Fitur camera pengumuman telah **dihapus** dan diganti dengan **Location/GPS tracking** untuk guru yang hanya bisa dilihat oleh admin.

---

## 🎯 Fitur yang Diimplementasikan

### 1. **LocationService** (`lib/src/core/services/location_service.dart`)
Service untuk mengelola GPS/Location:
- ✅ Check location service enabled
- ✅ Check & request permissions
- ✅ Get current location dengan timeout
- ✅ Calculate distance between coordinates
- ✅ Format distance (meters/km)
- ✅ Check if within school radius

### 2. **GuruLocationModel** (`lib/src/features/auth/data/models/guru_location_model.dart`)
Model untuk menyimpan data lokasi guru:
```dart
- guruId: String
- guruName: String
- latitude: double
- longitude: double
- timestamp: DateTime
- accuracy: String (high/medium/low)
- isOnline: bool
```

### 3. **LocationRepository** (`lib/src/features/auth/data/repositories/location_repository.dart`)
Repository untuk manage lokasi di Firestore:
- ✅ `updateGuruLocation()` - Update lokasi guru
- ✅ `setGuruOffline()` - Set guru offline saat logout
- ✅ `getGuruLocation()` - Get lokasi guru tertentu
- ✅ `getAllGuruLocations()` - Stream semua lokasi (untuk admin)
- ✅ `getOnlineGuruLocations()` - Stream hanya guru online
- ✅ `requestAndUpdateCurrentLocation()` - Request & update sekaligus

### 4. **LocationPermissionHelper** (`lib/src/features/auth/presentation/location/location_permission_helper.dart`)
Helper untuk request permission saat guru login:
- ✅ Explanation dialog yang user-friendly
- ✅ Handle permission denied/denied forever
- ✅ Open app settings jika denied forever
- ✅ Request & update location dalam 1 fungsi
- ✅ Loading indicator & success/error feedback

### 5. **GuruLocationScreen** (`lib/src/features/auth/presentation/location/guru_location_screen.dart`)
UI untuk admin melihat lokasi guru:
- ✅ List semua lokasi guru
- ✅ Toggle show online only / all
- ✅ Status indicator (online/offline)
- ✅ Coordinates display
- ✅ Last update timestamp
- ✅ Detail dialog dengan info lengkap
- ✅ Google Maps link (ready untuk url_launcher)

---

## 📱 Permissions

**AndroidManifest.xml** sudah dikonfigurasi:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**Camera permissions dihapus** ❌

---

## 🚀 Cara Implementasi

### A. Saat Guru Login

Tambahkan di login success callback:

```dart
// Setelah guru berhasil login
if (userType == 'guru') {
  await LocationPermissionHelper.requestAndUpdateLocation(
    context: context,
    guruId: guruId,
    guruName: guruName,
  );
}
```

**Flow:**
1. Guru login → Muncul dialog izin lokasi
2. Guru klik "Allow" → Request permission
3. Permission granted → Get current location
4. Update ke Firestore `guru_locations` collection
5. Show success message

### B. Untuk Admin Melihat Lokasi

Tambahkan navigation ke `GuruLocationScreen`:

```dart
// Di admin dashboard/menu
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const GuruLocationScreen(),
  ),
);
```

**Fitur Admin Screen:**
- Lihat semua guru locations
- Filter online/offline
- Klik card untuk detail
- Timestamp last update
- Koordinat GPS

### C. Saat Guru Logout

Panggil `setGuruOffline`:

```dart
await LocationRepository().setGuruOffline(guruId);
```

---

## 🗄️ Firestore Structure

### Collection: `guru_locations`

```
guru_locations/
  ├── {guruId}/
      ├── guruName: "Budi Santoso"
      ├── latitude: -6.200000
      ├── longitude: 106.816666
      ├── timestamp: Timestamp
      ├── accuracy: "high"
      └── isOnline: true
```

**Security Rules** (recommended):
```javascript
match /guru_locations/{guruId} {
  // Guru hanya bisa update lokasi sendiri
  allow write: if request.auth.uid == guruId;
  
  // Hanya admin yang bisa read
  allow read: if get(/databases/$(database)/documents/admin/$(request.auth.uid)).exists;
}
```

---

## 📦 Dependencies

**pubspec.yaml:**
```yaml
dependencies:
  geolocator: ^13.0.2  # ✅ Added
```

**Removed:**
- Camera features ❌
- Firebase Storage upload ❌
- Image handling untuk pengumuman ❌

---

## 💻 Code Examples

### 1. Request Location Saat Login

```dart
// Di login screen setelah success
if (userRole == 'guru') {
  final success = await LocationPermissionHelper.requestAndUpdateLocation(
    context: context,
    guruId: user.uid,
    guruName: user.displayName ?? 'Guru',
  );
  
  if (success) {
    print('Location updated');
  }
}
```

### 2. Monitor Guru Locations (Admin)

```dart
// Stream online guru
StreamBuilder<List<GuruLocation>>(
  stream: LocationRepository().getOnlineGuruLocations(),
  builder: (context, snapshot) {
    final locations = snapshot.data ?? [];
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final loc = locations[index];
        return ListTile(
          title: Text(loc.guruName),
          subtitle: Text(loc.coordinatesString),
          trailing: Text(loc.formattedTimestamp),
        );
      },
    );
  },
)
```

### 3. Check Distance dari Sekolah

```dart
final locationService = LocationService();

final distance = locationService.getDistanceBetween(
  lat1: guruLat,
  lon1: guruLon,
  lat2: schoolLat, // -6.200000
  lon2: schoolLon, // 106.816666
);

final isNearSchool = distance <= 500; // 500 meters radius

print('Distance: ${locationService.formatDistance(distance)}');
```

---

## 🎨 UI Components

### Permission Dialog
- 📍 Icon lokasi
- Explanation 3 alasan kenapa butuh akses:
  1. Track attendance location
  2. Admin monitoring
  3. Security & accountability
- Info: "Only visible to admin"
- Buttons: "Not Now" | "Allow"

### Admin Location Screen
- AppBar dengan title "Guru Locations"
- Toggle button: Online only / All
- Card list per guru:
  - Avatar icon (hijau = online, abu = offline)
  - Nama guru
  - Status badge
  - Koordinat
  - Last update time
- Detail dialog:
  - Full coordinates
  - Status
  - Timestamp
  - Accuracy
  - Link buka Google Maps

---

## ⚙️ Configuration

### Update Interval (Optional)
Jika ingin periodic update lokasi:

```dart
// Setiap 30 menit
Timer.periodic(Duration(minutes: 30), (timer) async {
  if (isGuruLoggedIn) {
    await LocationRepository().requestAndUpdateCurrentLocation(
      guruId: currentGuruId,
      guruName: currentGuruName,
    );
  }
});
```

### School Coordinates
Set koordinat sekolah untuk radius checking:

```dart
const double SCHOOL_LAT = -6.200000;
const double SCHOOL_LON = 106.816666;
const double SCHOOL_RADIUS_METERS = 500;

final isInSchool = LocationService().isWithinSchoolRadius(
  guruLat: currentLat,
  guruLon: currentLon,
  schoolLat: SCHOOL_LAT,
  schoolLon: SCHOOL_LON,
  radiusInMeters: SCHOOL_RADIUS_METERS,
);
```

---

## 🔒 Privacy & Security

1. **Permission Request:**
   - Explained clearly ke guru
   - Can be denied (optional)
   - Guide to settings jika denied forever

2. **Data Visibility:**
   - ✅ Admin dapat melihat semua lokasi guru
   - ❌ Guru tidak dapat melihat lokasi guru lain
   - ❌ Siswa tidak dapat melihat lokasi guru
   - Timestamp last update visible

3. **Data Storage:**
   - Lokasi disimpan di Firestore
   - Update only when guru online
   - Set offline saat logout
   - Historical tracking (optional - bisa tambah subcollection)

---

## 🧪 Testing Checklist

- [ ] Request permission dialog muncul saat guru login
- [ ] Permission granted → location updated
- [ ] Permission denied → app tetap jalan normal
- [ ] Admin bisa lihat list lokasi guru
- [ ] Toggle online/offline works
- [ ] Detail dialog shows correct info
- [ ] Guru set offline saat logout
- [ ] Coordinates akurat (check dengan Google Maps)
- [ ] Last update timestamp correct

---

## 🚧 Future Enhancements

### Potential improvements:

1. **Map View:**
   - Google Maps integration
   - Show all guru on map
   - Clustering untuk banyak guru

2. **Geofencing:**
   - Alert jika guru keluar dari radius sekolah
   - Automatic attendance based on location

3. **History Tracking:**
   - Simpan riwayat lokasi per hari
   - Report lokasi guru per bulan
   - Export ke Excel

4. **Real-time Updates:**
   - Background location tracking
   - Push notification untuk admin

5. **Distance Calculation:**
   - Show distance from school
   - Nearest guru finder

---

## 📝 Notes

- Location accuracy tergantung GPS device
- Battery consumption minimal (only on login/periodic)
- Offline mode: lokasi tidak diupdate
- Permission harus granted untuk tracking
- Admin dashboard sudah siap untuk integration

---

## ✨ Summary

**Removed:**
- ❌ Camera sensor untuk pengumuman
- ❌ Gallery picker
- ❌ Image upload ke Firebase Storage
- ❌ Image preview & validation

**Added:**
- ✅ GPS/Location tracking service
- ✅ Permission request dialog
- ✅ Guru location model & repository
- ✅ Admin screen untuk monitor lokasi
- ✅ Online/offline status
- ✅ Firestore integration
- ✅ Distance calculation utilities

**Status:** ✅ Fully Implemented & Ready to Use
