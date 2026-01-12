# 🔔 Quick Start Guide - Notification System

## Deploy Firestore Indexes

```bash
cd "d:\Dodow Kuliah\Semester 5\Multi-Platform Flutter - Ce Esther\project_mmp\belajarbareng_app\belajarbareng_app_mmp"

firebase deploy --only firestore:indexes
```

## Replace Notification Screen

Setelah yakin implementasi baru bekerja dengan baik:

```bash
# Windows PowerShell
Remove-Item "lib\src\features\auth\presentation\notifications\notifications_screen.dart"
Rename-Item "lib\src\features\auth\presentation\notifications\notifications_screen_new.dart" "notifications_screen.dart"
```

Atau manual:

1. Hapus file `notifications_screen.dart` (yang lama)
2. Rename `notifications_screen_new.dart` → `notifications_screen.dart`

## Test Notification Flow

### 1. Test TUGAS_BARU

1. Login sebagai Guru
2. Buat tugas baru untuk kelas tertentu
3. Login sebagai Siswa (di kelas tersebut)
4. Buka NotificationsScreen
5. ✅ Harus ada notifikasi "Tugas Baru: ..."

### 2. Test TUGAS_SUBMITTED

1. Login sebagai Siswa
2. Submit tugas
3. Login sebagai Guru (pengampu tugas)
4. Buka NotificationsScreen
5. ✅ Harus ada notifikasi "Tugas Dikumpulkan"

### 3. Test NILAI_KELUAR

1. Login sebagai Guru
2. Input nilai untuk siswa
3. Login sebagai Siswa
4. Buka NotificationsScreen
5. ✅ Harus ada notifikasi "Nilai Baru"

### 4. Test PENGUMUMAN

1. Login sebagai Admin/Guru
2. Buat pengumuman baru
3. Login sebagai user manapun (siswa/guru/admin)
4. Buka NotificationsScreen
5. ✅ Harus ada notifikasi "Pengumuman: ..."

### 5. Test DEADLINE REMINDER

1. Buat tugas dengan deadline besok
2. Panggil `notificationService.sendDeadlineReminders()`
3. Login sebagai Siswa (yang belum submit)
4. Buka NotificationsScreen
5. ✅ Harus ada notifikasi "Deadline Tugas: ..."

## Add Badge Counter

Di AppBar atau BottomNavigationBar, tambahkan badge counter:

```dart
import '../../../notifications/data/repositories/notification_repository.dart';
import '../../../notifications/data/models/notification_model.dart';

// In your widget
StreamBuilder<List<NotificationModel>>(
  stream: NotificationRepository().watchNotifications(userId, role),
  builder: (context, snapshot) {
    final unreadCount = snapshot.data?.where((n) => !n.isRead).length ?? 0;

    return Badge(
      label: Text('$unreadCount'),
      isLabelVisible: unreadCount > 0,
      child: IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationsScreen(),
            ),
          );
        },
      ),
    );
  },
)
```

## Add Periodic Deadline Check (Optional)

Di halaman siswa atau main screen, tambahkan timer untuk check deadline:

```dart
import 'dart:async';
import '../../../notifications/presentation/services/notification_service.dart';

class _YourScreenState extends State<YourScreen> {
  Timer? _deadlineCheckTimer;

  @override
  void initState() {
    super.initState();

    // Check every hour
    _deadlineCheckTimer = Timer.periodic(
      Duration(hours: 1),
      (timer) async {
        final notificationService = NotificationService();
        await notificationService.sendDeadlineReminders();
      },
    );
  }

  @override
  void dispose() {
    _deadlineCheckTimer?.cancel();
    super.dispose();
  }
}
```

## Firestore Security Rules (Optional)

Update `firestore.rules` untuk lebih secure:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Notifications collection
    match /notifications/{notificationId} {
      // User can only read their own notifications
      allow read: if request.auth != null &&
                     resource.data.userId == request.auth.uid;

      // Any authenticated user can create notifications (for triggers)
      allow create: if request.auth != null;

      // User can update/delete their own notifications
      allow update, delete: if request.auth != null &&
                                resource.data.userId == request.auth.uid;
    }

    // ... other rules ...
  }
}
```

Kemudian deploy:

```bash
firebase deploy --only firestore:rules
```

## Common Issues

### Issue: Notification tidak muncul

**Solution:**

1. Cek userId dan role sudah benar
2. Cek Firestore indexes sudah deployed
3. Cek collection name = "notifications" (lowercase)
4. Cek trigger code sudah dipanggil

### Issue: Real-time tidak update

**Solution:**

1. Gunakan `StreamBuilder`, bukan `FutureBuilder`
2. Cek Firestore connection
3. Restart aplikasi

### Issue: Badge counter tidak update

**Solution:**

1. Pastikan menggunakan `watchNotifications()` stream
2. Cek unread count calculation
3. Check widget rebuild

### Issue: Index error di Firestore

**Solution:**

```bash
firebase deploy --only firestore:indexes
```

Tunggu beberapa menit hingga index selesai dibuild.

## Performance Tips

1. **Batch Operations**: Gunakan bulk notifications untuk pengumuman
2. **Pagination**: Implementasi lazy loading jika notifikasi > 100
3. **Cache**: Flutter sudah handle caching Firestore otomatis
4. **Cleanup**: Hapus notifikasi lama secara periodic (optional)

## Next Phase (Phase 2)

Jika ingin implementasi Push Notifications (FCM):

1. Setup Firebase Cloud Messaging
2. Generate FCM tokens
3. Save tokens di user document
4. Send push notifications via FCM
5. Handle background notifications
6. Show local notifications

Dokumentasi lengkap: [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/flutter/client)

---

**Ready to go! 🚀**
