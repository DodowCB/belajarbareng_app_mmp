import 'package:intl/intl.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import '../../domain/entities/notification_type.dart';
import '../../data/models/notification_template.dart';
import '../../data/models/notification_preferences.dart';
import 'notification_queue.dart';

/// Extended NotificationService with Phase 2 & 3 features
/// Includes all 15 notification types, preferences, templates, deduplication
class NotificationServiceExtended {
  final NotificationRepository _repository = NotificationRepository();
  final NotificationQueue _queue = NotificationQueue();

  // ============================================
  // PHASE 2: NEW NOTIFICATION METHODS (10)
  // ============================================

  // 6. GURU_REGISTERED - Admin notified when guru registers
  Future<void> sendGuruRegistered({
    required String guruId,
    required String guruName,
    required String guruEmail,
  }) async {
    try {
      final adminIds = await _repository.getAllAdminIds();
      if (adminIds.isEmpty) return;

      final template =
          NotificationTemplate.getTemplate(NotificationType.guru_registered);
      final data = {'guruName': guruName};

      for (var adminId in adminIds) {
        // Check preferences
        final prefs = await NotificationPreferences.load(adminId);
        if (!prefs.enableUserManagementNotif) continue;

        await _createNotification(
          userId: adminId,
          role: 'admin',
          type: NotificationType.guru_registered,
          title: template?.renderTitle(data) ?? 'Guru Baru Terdaftar',
          message: template?.renderMessage(data) ??
              '$guruName telah mendaftar sebagai guru',
          priority: 'medium',
          actionUrl: '/admin/guru/approve/$guruId',
          metadata: {'guruId': guruId, 'guruEmail': guruEmail},
          dedupKey: 'guru_registered_$guruId',
        );
      }

      print('✅ Sent GURU_REGISTERED notifications');
    } catch (e) {
      print('❌ Error sending GURU_REGISTERED: $e');
    }
  }

  // 7. SISWA_REGISTERED - Admin notified when siswa registers
  Future<void> sendSiswaRegistered({
    required String siswaId,
    required String siswaName,
    required String siswaEmail,
  }) async {
    try {
      final adminIds = await _repository.getAllAdminIds();
      if (adminIds.isEmpty) return;

      final template =
          NotificationTemplate.getTemplate(NotificationType.siswa_registered);
      final data = {'siswaName': siswaName};

      for (var adminId in adminIds) {
        final prefs = await NotificationPreferences.load(adminId);
        if (!prefs.enableUserManagementNotif) continue;

        await _createNotification(
          userId: adminId,
          role: 'admin',
          type: NotificationType.siswa_registered,
          title: template?.renderTitle(data) ?? 'Siswa Baru Terdaftar',
          message: template?.renderMessage(data) ??
              '$siswaName telah mendaftar sebagai siswa',
          priority: 'medium',
          actionUrl: '/admin/siswa/approve/$siswaId',
          metadata: {'siswaId': siswaId, 'siswaEmail': siswaEmail},
          dedupKey: 'siswa_registered_$siswaId',
        );
      }

      print('✅ Sent SISWA_REGISTERED notifications');
    } catch (e) {
      print('❌ Error sending SISWA_REGISTERED: $e');
    }
  }

  // 8. SISWA_JOIN_KELAS - Guru notified when siswa joins their class
  Future<void> sendSiswaJoinKelas({
    required String kelasId,
    required String siswaId,
    required String siswaName,
  }) async {
    try {
      // Get guru for this kelas
      final kelasData = await _repository.getKelasById(kelasId);
      if (kelasData == null) return;

      final guruId = kelasData['guru_id'];
      final kelasName = kelasData['nama_kelas'] ?? 'Kelas';

      if (guruId == null) return;

      // Check preferences
      final prefs = await NotificationPreferences.load(guruId);
      if (!prefs.enableUserManagementNotif) return;

      final template =
          NotificationTemplate.getTemplate(NotificationType.siswa_join_kelas);
      final data = {'siswaName': siswaName, 'kelasName': kelasName};

      await _createNotification(
        userId: guruId,
        role: 'guru',
        type: NotificationType.siswa_join_kelas,
        title: template?.renderTitle(data) ?? 'Siswa Bergabung ke Kelas',
        message: template?.renderMessage(data) ??
            '$siswaName telah bergabung ke kelas $kelasName',
        priority: 'low',
        actionUrl: '/kelas/detail/$kelasId',
        metadata: {'kelasId': kelasId, 'siswaId': siswaId},
        dedupKey: 'siswa_join_${kelasId}_$siswaId',
      );

      print('✅ Sent SISWA_JOIN_KELAS notification');
    } catch (e) {
      print('❌ Error sending SISWA_JOIN_KELAS: $e');
    }
  }

  // 9. QNA_JAWABAN - For guru when their question is answered
  Future<void> sendQnaJawabanGuru({
    required String qnaId,
    required String guruId,
    required String answererName,
    required String pertanyaan,
  }) async {
    try {
      final prefs = await NotificationPreferences.load(guruId);
      if (!prefs.enableQnaNotif) return;

      final template =
          NotificationTemplate.getTemplate(NotificationType.qna_jawaban_guru);
      final data = {'userName': answererName, 'pertanyaan': pertanyaan};

      await _createNotification(
        userId: guruId,
        role: 'guru',
        type: NotificationType.qna_jawaban_guru,
        title: template?.renderTitle(data) ?? 'Jawaban Baru di QnA Anda',
        message: template?.renderMessage(data) ??
            '$answererName menjawab pertanyaan "$pertanyaan"',
        priority: 'medium',
        actionUrl: '/qna/detail/$qnaId',
        metadata: {'qnaId': qnaId, 'answererName': answererName},
        groupKey: 'qna_$qnaId',
      );

      print('✅ Sent QNA_JAWABAN_GURU notification');
    } catch (e) {
      print('❌ Error sending QNA_JAWABAN_GURU: $e');
    }
  }

  // 10. QNA_JAWABAN - For siswa when their question is answered
  Future<void> sendQnaJawabanSiswa({
    required String qnaId,
    required String siswaId,
    required String answererName,
    required String pertanyaan,
  }) async {
    try {
      final prefs = await NotificationPreferences.load(siswaId);
      if (!prefs.enableQnaNotif) return;

      final template =
          NotificationTemplate.getTemplate(NotificationType.qna_jawaban_siswa);
      final data = {'userName': answererName, 'pertanyaan': pertanyaan};

      await _createNotification(
        userId: siswaId,
        role: 'siswa',
        type: NotificationType.qna_jawaban_siswa,
        title: template?.renderTitle(data) ?? 'Jawaban Baru di QnA Anda',
        message: template?.renderMessage(data) ??
            '$answererName menjawab pertanyaan "$pertanyaan"',
        priority: 'medium',
        actionUrl: '/qna/detail/$qnaId',
        metadata: {'qnaId': qnaId, 'answererName': answererName},
        groupKey: 'qna_$qnaId',
      );

      print('✅ Sent QNA_JAWABAN_SISWA notification');
    } catch (e) {
      print('❌ Error sending QNA_JAWABAN_SISWA: $e');
    }
  }

  // 11. QUIZ_BARU - Siswa notified when new quiz is created
  Future<void> sendQuizBaru({
    required String quizId,
    required String quizJudul,
    DateTime? deadline, // Made optional
    required String kelasId,
    required String guruName,
  }) async {
    try {
      final siswaList = await _repository.getSiswaByKelas(kelasId);
      if (siswaList.isEmpty) return;

      final kelasData = await _repository.getKelasById(kelasId);
      final kelasName = kelasData?['nama_kelas'] ?? 'Kelas';

      final template =
          NotificationTemplate.getTemplate(NotificationType.quiz_baru);
      final data = {
        'quizJudul': quizJudul,
        'guruName': guruName,
        'kelasName': kelasName,
        'deadline': deadline != null 
            ? DateFormat('dd MMM yyyy, HH:mm').format(deadline)
            : 'Belum ditentukan',
      };

      for (var siswa in siswaList) {
        final siswaId = siswa['id'];

        // Check preferences
        final prefs = await NotificationPreferences.load(siswaId);
        if (!prefs.enableQuizNotif) continue;

        await _createNotification(
          userId: siswaId,
          role: 'siswa',
          type: NotificationType.quiz_baru,
          title: template?.renderTitle(data) ?? 'Quiz Baru: $quizJudul',
          message: template?.renderMessage(data) ??
              '$guruName memberikan quiz baru untuk $kelasName',
          priority: 'high',
          actionUrl: '/quiz/detail/$quizId',
          metadata: {
            'quizId': quizId,
            'kelasId': kelasId,
            if (deadline != null) 'deadline': deadline.toIso8601String(),
          },
          dedupKey: 'quiz_baru_${quizId}_$siswaId',
        );
      }

      print('✅ Sent ${siswaList.length} QUIZ_BARU notifications');
    } catch (e) {
      print('❌ Error sending QUIZ_BARU: $e');
    }
  }

  // ============================================
  // HELPER METHOD: CREATE NOTIFICATION WITH ALL FEATURES
  // ============================================

  Future<void> _createNotification({
    required String userId,
    required String role,
    required NotificationType type,
    required String title,
    required String message,
    required String priority,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    String? groupKey,
    int? groupCount,
    List<Map<String, dynamic>>? actions,
    String? dedupKey,
  }) async {
    try {
      // Check for duplicates if dedupKey provided
      if (dedupKey != null) {
        final isDuplicate = await _checkDuplicate(userId, dedupKey);
        if (isDuplicate) {
          print('⚠️ Duplicate notification skipped: $dedupKey');
          return;
        }
      }

      final notification = NotificationModel(
        id: '',
        userId: userId,
        role: role,
        type: type.name,
        title: title,
        message: message,
        priority: priority,
        isRead: false,
        actionUrl: actionUrl,
        metadata: metadata ?? {},
        createdAt: DateTime.now(),
        groupKey: groupKey,
        groupCount: groupCount,
        actions: actions,
        dedupKey: dedupKey,
      );

      // Try to create, if fails queue it
      try {
        await _repository.createNotification(notification);
      } catch (e) {
        print('⚠️ Failed to create notification, adding to queue: $e');
        await _queue.enqueue(notification.toMap());
      }
    } catch (e) {
      print('❌ Error in _createNotification: $e');
    }
  }

  // Check for duplicate notifications
  Future<bool> _checkDuplicate(String userId, String dedupKey) async {
    try {
      return await _repository.checkDuplicateNotification(
        userId: userId,
        dedupKey: dedupKey,
        withinHours: 12, // Check within last 12 hours
      );
    } catch (e) {
      print('Error checking duplicate: $e');
      return false; // Allow notification if check fails
    }
  }
}
