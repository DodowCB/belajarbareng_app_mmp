# Notification Triggers - Implementation Status

## ✅ Completed Triggers (4/6)

Triggers untuk 4 dari 6 notifikasi Phase 2 telah berhasil ditambahkan.

---

### 1. ✅ GURU_REGISTERED

**Location:** `lib/src/features/auth/presentation/guru_data/guru_data_bloc.dart`

**Trigger:** Saat admin menambahkan guru baru

**Method:** `_onAddGuru()`

**Code Added:**

```dart
// Send notification to all admins about new guru registration
try {
  await _notificationService.sendGuruRegistered(
    guruId: id,
    guruName: event.guruData['nama_lengkap'] ?? 'Unknown',
    guruEmail: event.guruData['email'] ?? 'No Email',
  );
  debugPrint('✅ Notification sent: Guru registered (ID: $id)');
} catch (e) {
  debugPrint('❌ Failed to send guru registered notification: $e');
}
```

**Recipients:** All users with `userType: 'admin'`

**Testing:**

1. Login sebagai Admin
2. Navigate ke User Management → Guru
3. Tambahkan guru baru
4. Check Firestore collection `notifications` → Should have new notification for all admins

---

### 2. ✅ SISWA_REGISTERED

**Location:** `lib/src/features/auth/presentation/siswa/siswa_data_bloc.dart`

**Trigger:** Saat admin menambahkan siswa baru

**Method:** `_onAddSiswa()`

**Code Added:**

```dart
// Send notification to all admins about new siswa registration
try {
  await _notificationService.sendSiswaRegistered(
    siswaId: id,
    siswaName: event.siswaData['nama'] ?? 'Unknown',
    siswaEmail: event.siswaData['email'] ?? 'No Email',
  );
  debugPrint('✅ Notification sent: Siswa registered (ID: $id)');
} catch (e) {
  debugPrint('❌ Failed to send siswa registered notification: $e');
}
```

**Recipients:** All users with `userType: 'admin'`

**Testing:**

1. Login sebagai Admin
2. Navigate ke User Management → Siswa
3. Tambahkan siswa baru
4. Check Firestore collection `notifications` → Should have new notification for all admins

---

### 3. ✅ SISWA_JOIN_KELAS

**Location:** `lib/src/features/auth/presentation/kelas/siswa_kelas_screen.dart`

**Trigger:** Saat admin menambahkan siswa ke kelas

**Method:** `_addSiswaToKelas()`

**Code Added:**

```dart
// Send notification to all admins about siswa joining kelas
try {
  await _notificationService.sendSiswaJoinKelas(
    kelasId: widget.kelasId,
    siswaId: _selectedSiswaId!,
    siswaName: siswaName,
  );
  debugPrint('✅ Notification sent: Siswa joined kelas (${widget.namaKelas})');
} catch (e) {
  debugPrint('❌ Failed to send siswa join kelas notification: $e');
}
```

**Recipients:** All users with `userType: 'admin'`

**Testing:**

1. Login sebagai Admin
2. Navigate ke Classes → Select a class → Click "Add Student" button
3. Select student and add to class
4. Check Firestore collection `notifications` → Should have new notification for all admins

---

### 4. ✅ QUIZ_BARU

**Location:** `lib/src/features/auth/presentation/halamanGuru/component/create_quiz_screen.dart`

**Trigger:** Saat guru membuat quiz baru (not for editing)

**Method:** `_saveQuiz()` (after quiz creation succeeds)

**Code Added:**

```dart
// Send notification untuk quiz baru (bukan editing)
if (!isEditing) {
  try {
    // Get guru name from user provider or firestore
    final userProv = UserProvider();
    final guruDoc = await _firestore.collection('guru').doc(idGuru).get();
    final guruName = guruDoc.data()?['nama_lengkap'] ?? 'Unknown Teacher';

    await _notificationService.sendQuizBaru(
      quizId: quizId.toString(),
      quizJudul: judulController.text.trim(),
      deadline: null, // Quiz doesn't have deadline field yet
      kelasId: selectedKelasId!,
      guruName: guruName,
    );
    debugPrint('✅ Notification sent: Quiz created (ID: $quizId)');
  } catch (e) {
    debugPrint('❌ Failed to send quiz notification: $e');
  }
}
```

**Recipients:** All siswa in the selected kelas

**Testing:**

1. Login sebagai Guru
2. Navigate to Quiz → Create New Quiz
3. Fill in quiz details (title, kelas, mapel, questions)
4. Submit quiz
5. Login sebagai Siswa (in that kelas)
6. Check Notifications Screen → Should see "Quiz Baru" notification

---

## ⏳ Pending Triggers (2/6)

### 5. ⚠️ QNA_JAWABAN_GURU (Pending)

**Reason:** QnA feature not yet implemented in the application

**Required Implementation:**

1. Create QnA feature (screen, bloc, model, repository)
2. Add collection: `qna` with fields:

   - `id`: String
   - `siswa_id`: String (author of question)
   - `pertanyaan`: String
   - `kelas_id`: String
   - `mapel_id`: String
   - `createdAt`: Timestamp
   - `answers`: Array<{userId, userName, answer, createdAt}>

3. Add trigger in QnA answer submission:

```dart
// TODO: Add this code when QnA feature is implemented
// Location: qna_bloc.dart or qna_screen.dart (after answer posted)

import '../../../notifications/presentation/services/notification_service_extended.dart';

final notificationService = NotificationServiceExtended();

// When guru answers a question
await notificationService.sendQnaJawabanGuru(
  qnaId: qnaId,
  guruId: answererUserId,
  answererName: answererName,
  pertanyaan: pertanyaan,
);

debugPrint('✅ Notification sent: Guru answered QnA');
```

**Recipients:** Original siswa who asked the question (stored in `siswa_id`)

---

### 6. ⚠️ QNA_JAWABAN_SISWA (Pending)

**Reason:** QnA feature not yet implemented in the application

**Required Implementation:**
Same as above, but for siswa answers:

```dart
// TODO: Add this code when QnA feature is implemented
// Location: qna_bloc.dart or qna_screen.dart (after answer posted)

// When siswa answers a question
await notificationService.sendQnaJawabanSiswa(
  qnaId: qnaId,
  siswaId: answererUserId,
  answererName: answererName,
  pertanyaan: pertanyaan,
);

debugPrint('✅ Notification sent: Siswa answered QnA');
```

**Recipients:** Original siswa who asked the question (stored in `siswa_id`)

---

## 📊 Summary

| No  | Notification Type | Status     | Location                | Trigger Event               |
| --- | ----------------- | ---------- | ----------------------- | --------------------------- |
| 1   | GURU_REGISTERED   | ✅ Done    | guru_data_bloc.dart     | Admin adds guru             |
| 2   | SISWA_REGISTERED  | ✅ Done    | siswa_data_bloc.dart    | Admin adds siswa            |
| 3   | SISWA_JOIN_KELAS  | ✅ Done    | siswa_kelas_screen.dart | Admin adds siswa to kelas   |
| 4   | QUIZ_BARU         | ✅ Done    | create_quiz_screen.dart | Guru creates quiz           |
| 5   | QNA_JAWABAN_GURU  | ⏳ Pending | -                       | QnA feature not implemented |
| 6   | QNA_JAWABAN_SISWA | ⏳ Pending | -                       | QnA feature not implemented |

**Completion Rate:** 4/6 = **66.7%** ✅

---

## 🧪 Testing Checklist

### Test GURU_REGISTERED

- [ ] Login as Admin
- [ ] Add new guru via User Management
- [ ] Check Admin's notification screen
- [ ] Verify notification appears with correct data

### Test SISWA_REGISTERED

- [ ] Login as Admin
- [ ] Add new siswa via User Management
- [ ] Check Admin's notification screen
- [ ] Verify notification appears with correct data

### Test SISWA_JOIN_KELAS

- [ ] Login as Admin
- [ ] Navigate to Classes → Select kelas → Add Student
- [ ] Check Admin's notification screen
- [ ] Verify notification with siswa name and kelas name

### Test QUIZ_BARU

- [ ] Login as Guru
- [ ] Create new quiz for specific kelas
- [ ] Login as Siswa (in that kelas)
- [ ] Check Siswa's notification screen
- [ ] Verify notification with quiz title and guru name

### Test Preferences

- [ ] Open Notification Preferences Screen
- [ ] Toggle off "Notifikasi User Management"
- [ ] Add new guru/siswa
- [ ] Verify notification NOT sent when preference disabled
- [ ] Toggle back on
- [ ] Add another guru/siswa
- [ ] Verify notification sent when preference enabled

### Test Analytics

- [ ] Open notification
- [ ] Check Firestore `notification_analytics` collection
- [ ] Verify `viewedAt` timestamp created
- [ ] Click on notification
- [ ] Verify `clickedAt` timestamp updated

---

## 🚀 Next Actions

### Immediate

1. **Test all 4 implemented triggers** using checklist above
2. **Verify preferences work** (toggle off notifications → no notification sent)
3. **Verify analytics tracking** (check Firestore collection)

### Short-term

4. **Implement QnA feature** to complete remaining 2 notifications
5. **Setup Workmanager** for automatic deadline reminders
6. **Deploy Firestore indexes** for better query performance

### Long-term

7. **Add deadline field to Quiz** (optional enhancement)
8. **Implement FCM push notifications** (mobile alerts)
9. **Create admin analytics dashboard** (view notification metrics)

---

## 📝 Notes

### Important Considerations

1. **Error Handling:** All notification triggers wrapped in try-catch blocks to prevent app crashes if notification sending fails

2. **Debug Logging:** Each trigger includes `debugPrint()` statements for easy debugging:

   - ✅ Success: "Notification sent: [type] (ID: [id])"
   - ❌ Failure: "Failed to send [type] notification: [error]"

3. **Non-blocking:** Notifications sent asynchronously without blocking main app flow

4. **Preferences Checked:** `NotificationServiceExtended` automatically checks user preferences before sending

5. **Deduplication:** Built-in deduplication prevents spam (12-hour window)

6. **Offline Queue:** Notifications auto-queued when offline, synced when online

### Known Limitations

1. **Quiz Deadline:** Quiz doesn't have deadline field, so `deadline: null` passed to notification. Consider adding this field in future.

2. **QnA Feature:** Not implemented yet, so QnA notifications can't be tested. This is expected and documented.

3. **Bulk Import:** When importing multiple guru/siswa via Excel, each will trigger individual notification. May want to batch these in future.

---

## 🎓 Developer Guide

### Adding More Notification Triggers

If you need to add more notification types in the future, follow this pattern:

1. **Add to NotificationType enum:**

```dart
// lib/src/features/notifications/domain/entities/notification_type.dart
enum NotificationType {
  // ... existing
  new_notification_type,
}
```

2. **Create template:**

```dart
// lib/src/features/notifications/data/models/notification_template.dart
NotificationType.new_notification_type: NotificationTemplate(
  type: NotificationType.new_notification_type,
  titleTemplate: 'New Notification: {data}',
  messageTemplate: '{description}',
  actionUrl: '/route/{id}',
),
```

3. **Add service method:**

```dart
// lib/src/features/notifications/presentation/services/notification_service_extended.dart
Future<void> sendNewNotification({
  required String recipientId,
  required String data,
}) async {
  // Check preferences
  final prefs = await NotificationPreferences.load(recipientId);
  if (!prefs.enableNewNotifications) {
    debugPrint('⏭️ New notification disabled for user: $recipientId');
    return;
  }

  // Prepare data
  final template = NotificationTemplate.getTemplate(NotificationType.new_notification_type);

  // Create notification
  final notification = NotificationModel(
    userId: recipientId,
    type: NotificationType.new_notification_type,
    title: template?.renderTitle({'data': data}) ?? 'Fallback Title',
    message: template?.renderMessage({'description': 'Details'}) ?? 'Fallback Message',
    // ... other fields
  );

  // Send
  await _repository.createNotification(notification);
}
```

4. **Add trigger in relevant file:**

```dart
// Location where event occurs
await _notificationService.sendNewNotification(
  recipientId: userId,
  data: eventData,
);
debugPrint('✅ Notification sent: New notification');
```

---

**Last Updated:** January 12, 2026  
**Status:** 🟢 **4/6 TRIGGERS IMPLEMENTED** (66.7%)
