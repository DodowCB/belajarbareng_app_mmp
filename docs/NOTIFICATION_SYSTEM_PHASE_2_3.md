# Notification System Phase 2 & 3 - Implementation Guide

## 📋 Overview

Sistem notifikasi telah diupgrade dari Phase 1 (5 notifikasi core) menjadi Phase 2 & 3 dengan 15 tipe notifikasi total, sistem preferensi, analytics, templates, offline queue, dan deduplication.

## 🎯 Features Implemented

### Phase 1 - Core Notifications (5) ✅

1. `tugas_baru` - Tugas baru diberikan
2. `tugas_submitted` - Tugas dikumpulkan siswa
3. `nilai_keluar` - Nilai siswa keluar
4. `pengumuman` - Pengumuman baru
5. `tugas_deadline` - Deadline tugas hari ini

### Phase 2 - Enhanced Notifications (10) ✅

6. `guru_registered` - Guru baru mendaftar (Admin)
7. `siswa_registered` - Siswa baru mendaftar (Admin)
8. `tugas_deadline_approaching` - Tugas mendekati deadline (Admin/Guru)
9. `quiz_deadline_approaching` - Quiz mendekati deadline (Admin/Guru)
10. `siswa_join_kelas` - Siswa bergabung ke kelas (Guru)
11. `qna_jawaban_guru` - Jawaban di QnA guru (Guru)
12. `siswa_tugas_deadline_approaching` - Pengingat deadline tugas (Siswa)
13. `siswa_quiz_deadline_approaching` - Pengingat deadline quiz (Siswa)
14. `qna_jawaban_siswa` - Jawaban di QnA siswa (Siswa)
15. `quiz_baru` - Quiz baru diberikan (Siswa)

### Phase 3 - Advanced Features ✅

#### 1. Notification Preferences System

- **Model**: `notification_preferences.dart`
- **BLoC**: `notification_preferences_bloc.dart`
- **Storage**: SharedPreferences (per user)
- **Categories**:
  - Tugas notifications
  - Quiz notifications
  - QnA notifications
  - Pengumuman notifications
  - Nilai notifications
  - Deadline reminders
  - User management notifications (admin only)

#### 2. Notification Templates

- **File**: `notification_template.dart`
- **Features**:
  - Pre-defined templates for all 15 notification types
  - Variable substitution: `{tugasJudul}`, `{guruName}`, `{deadline}`, etc.
  - Automatic title and message rendering
  - Fallback to default messages if template missing

#### 3. Notification Analytics

- **Model**: `notification_analytics.dart`
- **Tracking**:
  - Notification viewed timestamp
  - Notification clicked timestamp
  - Action taken (opened, dismissed, clicked_action)
  - Metadata for detailed analysis

#### 4. Notification Actions

- **Model**: `notification_action.dart`
- **Features**:
  - Multiple actions per notification
  - Route navigation with parameters
  - Action tracking in analytics

#### 5. Notification Grouping

- **Fields**: `groupKey`, `groupCount` in NotificationModel
- **Use cases**:
  - Group multiple tugas notifications: `tugas_123`
  - Group quiz notifications: `quiz_456`
  - Show count badge: "3 tugas baru"

#### 6. Offline Notification Queue

- **Service**: `notification_queue.dart`
- **Features**:
  - Auto-queue notifications when offline
  - Persistent storage (SharedPreferences)
  - Auto-retry when connection restored
  - Manual retry option

#### 7. Notification Scheduler

- **Service**: `notification_scheduler.dart`
- **Features**:
  - Check tugas deadlines (24 hours before)
  - Check quiz deadlines (24 hours before)
  - Automatic batch sending to siswa
  - Deduplication to prevent spam

#### 8. Notification Deduplication

- **Field**: `dedupKey` in NotificationModel
- **Logic**:
  - Generate unique key per notification type + context
  - Check for duplicates within time window (e.g., 1 hour)
  - Skip sending if duplicate found

## 📁 File Structure

```
lib/src/features/notifications/
├── domain/
│   └── entities/
│       ├── notification_entity.dart (updated with new fields)
│       └── notification_type.dart (NEW - enum with 15 types)
├── data/
│   ├── models/
│   │   ├── notification_model.dart (updated)
│   │   ├── notification_preferences.dart (NEW)
│   │   ├── notification_action.dart (NEW)
│   │   ├── notification_template.dart (NEW)
│   │   └── notification_analytics.dart (NEW)
│   └── repositories/
│       └── notification_repository.dart (fixed query)
└── presentation/
    ├── bloc/
    │   ├── notification_bloc.dart (existing)
    │   └── notification_preferences_bloc.dart (NEW)
    ├── services/
    │   ├── notification_service.dart (existing)
    │   ├── notification_scheduler.dart (NEW)
    │   └── notification_queue.dart (NEW)
    └── notifications/
        └── notifications_screen.dart (existing)
```

## 🔧 Next Steps to Complete Implementation

### 1. Update NotificationService dengan Preferences & Templates

File: `notification_service.dart`

Tambahkan:

```dart
import '../data/models/notification_preferences.dart';
import '../data/models/notification_template.dart';
import '../../domain/entities/notification_type.dart';

// In sendTugasBaru method:
final prefs = await NotificationPreferences.load(siswaId);
if (!prefs.enableTugasNotif) continue;

final template = NotificationTemplate.getTemplate(NotificationType.tugas_baru);
final title = template?.renderTitle(data) ?? 'Tugas Baru';
```

### 2. Add MarkAllAsRead Event ke NotificationBloc

File: `notification_bloc.dart`

```dart
class MarkAllAsReadEvent extends NotificationEvent {
  final String userId;
  const MarkAllAsReadEvent(this.userId);
}

// Handler:
Future<void> _onMarkAllAsRead(event, emit) async {
  final batch = _firestore.batch();
  final unread = await _firestore
      .collection('notifications')
      .where('userId', isEqualTo: event.userId)
      .where('isRead', isEqualTo: false)
      .get();

  for (var doc in unread.docs) {
    batch.update(doc.reference, {'isRead': true});
  }
  await batch.commit();
}
```

### 3. Add Triggers untuk 10 Notifikasi Baru

**A. Guru/Siswa Registration (Admin)**
File: `guru_bloc.dart`, `siswa_bloc.dart`

```dart
// After approval
await notificationService.sendNotification(
  userId: guruId,
  type: NotificationType.guru_registered,
  title: 'Akun Disetujui',
  message: 'Akun guru Anda telah disetujui',
  senderRole: 'admin',
);
```

**B. Siswa Join Kelas (Guru)**
File: `siswa_kelas_screen.dart` or `kelas_bloc.dart`

```dart
// After siswa added to kelas
await notificationService.sendSiswaJoinKelas(
  kelasId: kelasId,
  siswaId: siswaId,
  siswaName: siswaName,
);
```

**C. QnA Jawaban**
File: `qna_bloc.dart`

```dart
// After answer posted
await notificationService.sendQnaJawaban(
  questionOwnerId: questionOwnerId,
  questionOwnerRole: role, // 'guru' or 'siswa'
  answererName: answererName,
  pertanyaan: pertanyaan,
  qnaId: qnaId,
);
```

**D. Quiz Baru**
File: `quiz_bloc.dart` or create_quiz_screen

```dart
// After quiz created
await notificationService.sendQuizBaru(
  quizId: quizId,
  quizJudul: judul,
  deadline: deadline,
  kelasId: kelasId,
  guruName: guruName,
);
```

### 4. Buat Notification Preferences Screen

File: `notification_preferences_screen.dart`

```dart
class NotificationPreferencesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = userProvider.userId;

    return Scaffold(
      appBar: AppBar(title: Text('Pengaturan Notifikasi')),
      body: BlocProvider(
        create: (_) => NotificationPreferencesBloc()
          ..add(LoadNotificationPreferences(userId)),
        child: BlocBuilder<NotificationPreferencesBloc, NotificationPreferencesState>(
          builder: (context, state) {
            if (state is NotificationPreferencesLoaded) {
              return ListView(
                children: [
                  SwitchListTile(
                    title: Text('Notifikasi Tugas'),
                    subtitle: Text('Tugas baru, deadline, dll'),
                    value: state.preferences.enableTugasNotif,
                    onChanged: (value) {
                      context.read<NotificationPreferencesBloc>().add(
                        UpdateTugasNotifPreference(userId, value),
                      );
                    },
                  ),
                  // ... more switches
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
```

### 5. Setup Workmanager untuk Scheduler

File: `main.dart`

```dart
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final scheduler = NotificationScheduler();
    await scheduler.scheduleDeadlineReminders();
    return Future.value(true);
  });
}

void main() async {
  // ... existing setup

  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    "deadline-reminder",
    "checkDeadlines",
    frequency: Duration(hours: 6),
  );

  runApp(MyApp());
}
```

Note: Anda perlu install `workmanager: ^0.5.2` di pubspec.yaml

### 6. Integrate NotificationQueue di NotificationService

```dart
final queue = NotificationQueue();

// In createNotification method:
try {
  await _repository.createNotification(...);
} catch (e) {
  // If offline, queue it
  await queue.enqueue(notificationData);
}
```

### 7. Add Analytics Tracking di NotificationBloc

```dart
// When notification viewed
on<NotificationViewedEvent>((event, emit) async {
  await _firestore.collection('notification_analytics').add({
    'userId': event.userId,
    'notificationId': event.notificationId,
    'viewedAt': FieldValue.serverTimestamp(),
  });
});

// When notification clicked
on<NotificationClickedEvent>((event, emit) async {
  await _firestore.collection('notification_analytics').add({
    'userId': event.userId,
    'notificationId': event.notificationId,
    'clickedAt': FieldValue.serverTimestamp(),
    'action': event.action,
  });
});
```

### 8. Update Notification UI dengan Actions

File: `notifications_screen.dart`

```dart
ListTile(
  title: Text(notification.title),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(notification.message),
      if (notification.actions != null)
        Wrap(
          children: notification.actions!.map((action) {
            return TextButton(
              onPressed: () {
                // Track action
                context.read<NotificationBloc>().add(
                  NotificationActionClicked(notification.id, action.id),
                );
                // Navigate
                Navigator.pushNamed(
                  context,
                  action.route,
                  arguments: action.params,
                );
              },
              child: Text(action.label),
            );
          }).toList(),
        ),
    ],
  ),
);
```

## 🧪 Testing Checklist

### Phase 2 Testing

- [ ] Preferences tersimpan dan ter-load dengan benar
- [ ] Preferences diaplikasikan (notif tidak terkirim jika disabled)
- [ ] Deadline scheduler berjalan otomatis setiap 6 jam
- [ ] Batch mark all as read bekerja
- [ ] Notifikasi tidak duplicate (deduplication works)
- [ ] Templates rendering dengan benar

### Phase 3 Testing

- [ ] Offline queue menyimpan notifikasi saat offline
- [ ] Queue ter-process otomatis saat online kembali
- [ ] Analytics tercatat dengan benar (viewed, clicked)
- [ ] Notification grouping menampilkan count yang benar
- [ ] Actions pada notifikasi berfungsi
- [ ] FCM notifications diterima (foreground & background)

### Integration Testing

- [ ] Semua 15 tipe notifikasi terkirim dengan benar
- [ ] Notifikasi muncul real-time di UI
- [ ] Navigasi dari notifikasi ke detail screen bekerja
- [ ] Mark as read sinkronisasi dengan benar
- [ ] Swipe-to-delete bekerja

## 🐛 Bug Fixes Applied

### Phase 1 Fixes ✅

1. Fixed `getSiswaByKelas()` query - now uses `siswa_kelas` junction table
2. Fixed import paths in notification_service.dart
3. Added missing `isRead: false` parameter
4. Fixed loading screen - now uses `userProvider` directly

## 📊 Database Structure

### Collections

**notifications**

```
{
  userId: string
  role: string
  type: string (enum)
  title: string
  message: string
  priority: string
  isRead: boolean
  actionUrl: string?
  metadata: map
  createdAt: timestamp
  updatedAt: timestamp?
  groupKey: string? (NEW)
  groupCount: int? (NEW)
  actions: array<map>? (NEW)
  dedupKey: string? (NEW)
}
```

**notification_analytics**

```
{
  userId: string
  notificationId: string
  viewedAt: timestamp
  clickedAt: timestamp?
  action: string?
  metadata: map
}
```

## 🔐 Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Notifications - users can only read their own
    match /notifications/{notificationId} {
      allow read: if request.auth != null &&
                     resource.data.userId == request.auth.uid;
      allow write: if request.auth != null; // Service can write
    }

    // Analytics - only service can write
    match /notification_analytics/{analyticsId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## 💡 Best Practices

1. **Always check preferences** before sending notifications
2. **Use templates** for consistent messaging
3. **Set dedupKey** untuk prevent spam
4. **Track analytics** untuk improve engagement
5. **Use offline queue** untuk reliability
6. **Batch operations** untuk efficiency
7. **Test deadline scheduler** dengan waktu yang tepat
8. **Monitor queue size** untuk prevent memory issues

## 🚀 Performance Optimization

1. **Batch Firestore writes** (max 500 per batch)
2. **Index Firestore queries**:
   - `notifications` collection: userId + isRead + createdAt
   - `notifications` collection: userId + dedupKey + createdAt
3. **Limit notification history** (e.g., auto-delete after 30 days)
4. **Use pagination** in notifications list
5. **Cache preferences** in memory (don't load every time)

## 📝 Notes

- workmanager requires additional platform-specific setup (Android/iOS)
- FCM requires firebase-messaging setup in native code
- Test scheduler manually first before enabling periodic task
- Monitor Firestore usage to avoid quota limits
- Consider archiving old notifications periodically

---

**Status**: Core infrastructure complete ✅
**Next**: Implement remaining triggers + UI updates
**Priority**: Test Phase 1 notifications working correctly first!
