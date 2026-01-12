import 'package:intl/intl.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

/// Service helper untuk trigger notifikasi dari berbagai lokasi
class NotificationService {
  final NotificationRepository _repository = NotificationRepository();

  // 1. TUGAS_BARU - Dipanggil setelah guru membuat tugas baru
  Future<void> sendTugasBaru({
    required String tugasId,
    required String namaTugas,
    required DateTime deadline,
    required String kelasId,
  }) async {
    try {
      // Ambil semua siswa di kelas
      final siswaList = await _repository.getSiswaByKelas(kelasId);

      if (siswaList.isEmpty) {
        print('No siswa found for kelas: $kelasId');
        return;
      }

      // Buat notifikasi untuk setiap siswa
      final notifications = siswaList.map((siswa) {
        return NotificationModel(
          id: '',
          userId: siswa['id'],
          role: 'siswa',
          type: 'tugas_baru',
          title: '📚 Tugas Baru: $namaTugas',
          message: 'Deadline: ${DateFormat('dd MMM yyyy, HH:mm').format(deadline)}',
          priority: 'high',
          isRead: false,
          actionUrl: '/tugas/detail/$tugasId',
          metadata: {
            'taskId': tugasId,
            'kelasId': kelasId,
            'deadline': deadline.toIso8601String(),
          },
          createdAt: DateTime.now(),
        );
      }).toList();

      await _repository.createBulkNotifications(notifications);
      print('✅ Sent ${notifications.length} TUGAS_BARU notifications');
    } catch (e) {
      print('❌ Error sending TUGAS_BARU notifications: $e');
    }
  }

  // 2. TUGAS_SUBMITTED - Dipanggil setelah siswa submit tugas
  Future<void> sendTugasSubmitted({
    required String tugasId,
    required String siswaId,
    required String siswaName,
  }) async {
    try {
      // Ambil data tugas untuk mendapatkan guru_id
      final tugasData = await _repository.getTugasById(tugasId);
      
      if (tugasData == null) {
        print('Tugas not found: $tugasId');
        return;
      }

      final guruId = tugasData['guru_id'];
      final tugasNama = tugasData['nama'] ?? 'Tugas';

      if (guruId == null) {
        print('Guru ID not found in tugas: $tugasId');
        return;
      }

      // Buat notifikasi untuk guru
      final notification = NotificationModel(
        id: '',
        userId: guruId,
        role: 'guru',
        type: 'tugas_submitted',
        title: '✅ Tugas Dikumpulkan',
        message: '$siswaName telah mengumpulkan $tugasNama',
        priority: 'medium',
        isRead: false,
        actionUrl: '/tugas/grading/$tugasId',
        metadata: {
          'taskId': tugasId,
          'siswaId': siswaId,
          'siswaName': siswaName,
        },
        createdAt: DateTime.now(),
      );

      await _repository.createNotification(notification);
      print('✅ Sent TUGAS_SUBMITTED notification to guru: $guruId');
    } catch (e) {
      print('❌ Error sending TUGAS_SUBMITTED notification: $e');
    }
  }

  // 3. NILAI_KELUAR - Dipanggil setelah guru input/update nilai
  Future<void> sendNilaiKeluar({
    required String siswaId,
    required String mapelName,
    required String jenisNilai,
    required double nilai,
    required String mapelId,
  }) async {
    try {
      final notification = NotificationModel(
        id: '',
        userId: siswaId,
        role: 'siswa',
        type: 'nilai_keluar',
        title: '📊 Nilai Baru',
        message: '$mapelName - $jenisNilai: ${nilai.toStringAsFixed(0)}',
        priority: 'high',
        isRead: false,
        actionUrl: '/nilai/detail',
        metadata: {
          'mapelId': mapelId,
          'mapelName': mapelName,
          'jenisNilai': jenisNilai,
          'nilai': nilai,
        },
        createdAt: DateTime.now(),
      );

      await _repository.createNotification(notification);
      print('✅ Sent NILAI_KELUAR notification to siswa: $siswaId');
    } catch (e) {
      print('❌ Error sending NILAI_KELUAR notification: $e');
    }
  }

  // 4. PENGUMUMAN - Dipanggil setelah membuat pengumuman
  Future<void> sendPengumuman({
    required String pengumumanId,
    required String judul,
    required String isi,
    required String target, // 'all', 'siswa', 'guru', 'admin'
  }) async {
    try {
      List<Map<String, String>> targetUsers = [];

      // Ambil user berdasarkan target
      if (target == 'all' || target.contains('siswa')) {
        final siswaIds = await _repository.getAllSiswaIds();
        targetUsers.addAll(
          siswaIds.map((id) => {'userId': id, 'role': 'siswa'}),
        );
      }

      if (target == 'all' || target.contains('guru')) {
        final guruIds = await _repository.getAllGuruIds();
        targetUsers.addAll(
          guruIds.map((id) => {'userId': id, 'role': 'guru'}),
        );
      }

      if (target == 'all' || target.contains('admin')) {
        final adminIds = await _repository.getAllAdminIds();
        targetUsers.addAll(
          adminIds.map((id) => {'userId': id, 'role': 'admin'}),
        );
      }

      if (targetUsers.isEmpty) {
        print('No target users found for pengumuman');
        return;
      }

      // Buat preview isi (max 100 karakter)
      final isiPreview = isi.length > 100 ? '${isi.substring(0, 100)}...' : isi;

      // Buat notifikasi untuk semua target users
      final notifications = targetUsers.map((user) {
        return NotificationModel(
          id: '',
          userId: user['userId']!,
          role: user['role']!,
          type: 'pengumuman',
          title: '📢 Pengumuman: $judul',
          message: isiPreview,
          priority: 'high',
          isRead: false,
          actionUrl: '/pengumuman/$pengumumanId',
          metadata: {
            'pengumumanId': pengumumanId,
            'judul': judul,
          },
          createdAt: DateTime.now(),
        );
      }).toList();

      await _repository.createBulkNotifications(notifications);
      print('✅ Sent ${notifications.length} PENGUMUMAN notifications');
    } catch (e) {
      print('❌ Error sending PENGUMUMAN notifications: $e');
    }
  }

  // 5. TUGAS_DEADLINE - Manual reminder (bisa dipanggil dari cron job atau timer)
  Future<void> sendDeadlineReminders() async {
    try {
      await _repository.checkAndCreateDeadlineReminders();
      print('✅ Deadline reminders checked and sent');
    } catch (e) {
      print('❌ Error sending deadline reminders: $e');
    }
  }

  // Helper: Get unread count for badge
  Future<int> getUnreadCount(String userId, String role) async {
    try {
      final notifications = await _repository.getNotifications(userId, role);
      return notifications.where((n) => !n.isRead).length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }
}
