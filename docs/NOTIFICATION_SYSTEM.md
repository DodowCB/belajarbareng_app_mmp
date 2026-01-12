# Sistem Notifikasi BelajarBareng - Phase 1

## Overview

Sistem notifikasi real-time menggunakan **BLoC pattern** dan **Firestore** untuk mengirim notifikasi ke pengguna berdasarkan aktivitas dalam aplikasi.

## Struktur Folder

```
lib/src/features/notifications/
├── data/
│   ├── models/
│   │   └── notification_model.dart      # Model notifikasi dengan fromFirestore/toMap
│   └── repositories/
│       └── notification_repository.dart  # CRUD operations & helper methods
├── domain/
│   └── entities/
│       └── notification_entity.dart      # Entity class dengan Equatable
└── presentation/
    ├── bloc/
    │   ├── notification_bloc.dart        # BLoC implementation
    │   ├── notification_event.dart       # Events (Fetch, MarkAsRead, Delete, etc.)
    │   └── notification_state.dart       # States (Loading, Loaded, Error, Success)
    └── services/
        └── notification_service.dart     # Helper service untuk trigger notifikasi
```

## Database Schema (Firestore)

### Collection: `notifications`

```json
{
  "id": "auto-generated",
  "userId": "string",
  "role": "string (admin/guru/siswa)",
  "type": "string (tugas_baru/tugas_deadline/tugas_submitted/nilai_keluar/pengumuman)",
  "title": "string",
  "message": "string",
  "priority": "string (high/medium/low)",
  "isRead": "boolean (default: false)",
  "actionUrl": "string (nullable)",
  "metadata": {
    "taskId": "string",
    "quizId": "string",
    "mapelId": "string",
    "kelasId": "string",
    "etc": "..."
  },
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp (nullable)"
}
```

### Indexes Required

```
Collection: notifications
- userId (Ascending) + role (Ascending) + createdAt (Descending)
- userId (Ascending) + role (Ascending) + isRead (Ascending)
```

## 5 Core Notifications Implemented

### 1. 📚 TUGAS_BARU (Siswa)

**Trigger:** Setelah guru membuat tugas baru  
**Lokasi:** `create_tugas_screen.dart` → `_saveTugas()`  
**Target:** Semua siswa di kelas  
**Priority:** High

```dart
await notificationService.sendTugasBaru(
  tugasId: docId,
  namaTugas: _judulController.text.trim(),
  deadline: _selectedDeadline!,
  kelasId: _selectedKelasId!,
);
```

### 2. ✅ TUGAS_SUBMITTED (Guru)

**Trigger:** Setelah siswa submit tugas  
**Lokasi:** `detail_tugas_kelas_screen.dart` → `_pickAndUploadFile()`  
**Target:** Guru pengampu  
**Priority:** Medium

```dart
await notificationService.sendTugasSubmitted(
  tugasId: tugasId,
  siswaId: siswaId,
  siswaName: siswaName,
);
```

### 3. 📊 NILAI_KELUAR (Siswa)

**Trigger:** Setelah guru input/update nilai  
**Lokasi:** `input_nilai_siswa_screen.dart` → `_saveNilai()`  
**Target:** Siswa yang nilainya diinput  
**Priority:** High

```dart
await notificationService.sendNilaiKeluar(
  siswaId: siswaId,
  mapelName: mapelName,
  jenisNilai: 'Rata-rata',
  nilai: rataRata,
  mapelId: widget.kelas['mapelId'] ?? '',
);
```

### 4. 📢 PENGUMUMAN (Semua)

**Trigger:** Setelah membuat pengumuman  
**Lokasi:** `pengumuman_bloc.dart` → `_onAddPengumuman()`  
**Target:** Semua user (siswa, guru, admin)  
**Priority:** High

```dart
await notificationService.sendPengumuman(
  pengumumanId: nextId.toString(),
  judul: event.judul,
  isi: event.deskripsi,
  target: 'all',
);
```

### 5. ⏰ TUGAS_DEADLINE (Siswa)

**Trigger:** Manual check (via Timer atau initState)  
**Lokasi:** `notification_repository.dart` → `checkAndCreateDeadlineReminders()`  
**Target:** Siswa yang belum submit & deadline besok  
**Priority:** High

```dart
// Panggil di initState halaman siswa
final notificationService = NotificationService();
await notificationService.sendDeadlineReminders();
```

## Usage

### 1. Fetch Notifications (dengan BLoC)

```dart
// In Widget
BlocProvider.of<NotificationBloc>(context).add(
  FetchNotifications(userId: userId, role: role),
);

// Listen to state
BlocBuilder<NotificationBloc, NotificationState>(
  builder: (context, state) {
    if (state is NotificationLoaded) {
      return ListView.builder(
        itemCount: state.notifications.length,
        itemBuilder: (context, index) {
          final notification = state.notifications[index];
          return NotificationTile(notification: notification);
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

### 2. Real-time Updates (dengan StreamBuilder)

```dart
StreamBuilder<List<NotificationModel>>(
  stream: notificationRepository.watchNotifications(userId, role),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final notifications = snapshot.data!;
      final unreadCount = notifications.where((n) => !n.isRead).length;
      return Badge(
        label: Text('$unreadCount'),
        child: Icon(Icons.notifications),
      );
    }
    return Icon(Icons.notifications);
  },
)
```

### 3. Mark as Read

```dart
BlocProvider.of<NotificationBloc>(context).add(
  MarkAsRead(notificationId),
);
```

### 4. Delete Notification

```dart
BlocProvider.of<NotificationBloc>(context).add(
  DeleteNotification(notificationId),
);
```

### 5. Mark All as Read

```dart
BlocProvider.of<NotificationBloc>(context).add(
  MarkAllAsRead(userId: userId, role: role),
);
```

## NotificationService Helper Methods

```dart
final notificationService = NotificationService();

// 1. Send TUGAS_BARU
await notificationService.sendTugasBaru(
  tugasId: '123',
  namaTugas: 'Tugas Matematika',
  deadline: DateTime.now().add(Duration(days: 7)),
  kelasId: '10A',
);

// 2. Send TUGAS_SUBMITTED
await notificationService.sendTugasSubmitted(
  tugasId: '123',
  siswaId: 'siswa-001',
  siswaName: 'Budi Santoso',
);

// 3. Send NILAI_KELUAR
await notificationService.sendNilaiKeluar(
  siswaId: 'siswa-001',
  mapelName: 'Matematika',
  jenisNilai: 'UTS',
  nilai: 85.0,
  mapelId: 'mapel-001',
);

// 4. Send PENGUMUMAN
await notificationService.sendPengumuman(
  pengumumanId: '456',
  judul: 'Libur Nasional',
  isi: 'Besok tanggal 17 Agustus libur...',
  target: 'all', // or 'siswa', 'guru', 'admin'
);

// 5. Send DEADLINE REMINDERS
await notificationService.sendDeadlineReminders();

// 6. Get Unread Count
final unreadCount = await notificationService.getUnreadCount(userId, role);
```

## BLoC Events

```dart
// Fetch notifications
FetchNotifications(userId: String, role: String)

// Mark single as read
MarkAsRead(String notificationId)

// Mark all as read
MarkAllAsRead(userId: String, role: String)

// Delete single notification
DeleteNotification(String notificationId)

// Delete all notifications
DeleteAllNotifications(userId: String, role: String)

// Create notification (background)
CreateNotification(NotificationModel notification)

// Create bulk notifications (background)
CreateBulkNotifications(List<NotificationModel> notifications)

// Check deadline reminders (background)
CheckDeadlineReminders()

// Refresh notifications (pull to refresh)
RefreshNotifications(userId: String, role: String)
```

## BLoC States

```dart
// Initial state
NotificationInitial()

// Loading state
NotificationLoading()

// Loaded state
NotificationLoaded(
  notifications: List<NotificationModel>,
  unreadCount: int,
)

// Error state
NotificationError(String message)

// Operation success (mark as read, delete)
NotificationOperationSuccess(
  message: String,
  notifications: List<NotificationModel>,
  unreadCount: int,
)

// Operation loading (for specific operations)
NotificationOperationLoading(
  notifications: List<NotificationModel>,
  unreadCount: int,
)
```

## UI Screen

File: `notifications_screen_new.dart` (ganti `notifications_screen.dart` saat siap)

Features:

- ✅ Real-time updates menggunakan StreamBuilder
- ✅ Tab filter: All, Unread, Read
- ✅ Badge counter untuk unread notifications
- ✅ Swipe to delete (Dismissible)
- ✅ Pull to refresh
- ✅ Mark all as read
- ✅ Delete all notifications
- ✅ Navigation ke actionUrl saat tap
- ✅ Auto mark as read saat tap
- ✅ Priority color coding
- ✅ Type-based icons

## Next Steps (Phase 2 - Optional)

1. **Push Notifications** (FCM):

   - Setup Firebase Cloud Messaging
   - Handle background notifications
   - Show local notifications

2. **Notification Preferences**:

   - Allow users to mute certain types
   - Notification settings screen

3. **Advanced Features**:
   - Group notifications by type
   - Search notifications
   - Export notification history

## Testing Checklist

- [x] Create tugas → Siswa receive TUGAS_BARU
- [x] Submit tugas → Guru receive TUGAS_SUBMITTED
- [x] Input nilai → Siswa receive NILAI_KELUAR
- [x] Create pengumuman → All users receive PENGUMUMAN
- [x] Deadline reminder → Siswa receive TUGAS_DEADLINE (deadline besok)
- [x] Mark as read → isRead = true
- [x] Delete notification → removed from list
- [x] Real-time updates → StreamBuilder updates automatically
- [x] Badge counter → Shows unread count
- [x] Tab filter → Filters by read status

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  cloud_firestore: ^5.4.4
  intl: ^0.18.0 # For date formatting
```

## Notes

- ⚠️ **No Cloud Functions** - Semua trigger dilakukan manual di client side
- ⚠️ **No Push Notifications** - Hanya in-app notifications (Phase 1)
- ✅ **Real-time** - Menggunakan Firestore snapshots
- ✅ **Scalable** - Bulk operations untuk efisiensi
- ✅ **Consistent** - Mengikuti BLoC pattern seperti fitur lain

## Troubleshooting

### Notifikasi tidak muncul

1. Cek Firestore rules (`notifications` collection harus readable)
2. Cek userId dan role sudah benar
3. Cek index Firestore sudah dibuat

### Real-time tidak update

1. Pastikan menggunakan `StreamBuilder` bukan `FutureBuilder`
2. Cek connection Firestore

### Badge counter tidak update

1. Pastikan `watchNotifications()` dipanggil dengan benar
2. Cek unread count calculation

---

**Created by:** AI Assistant  
**Date:** January 12, 2026  
**Version:** 1.0.0 (Phase 1 - Core Features)
