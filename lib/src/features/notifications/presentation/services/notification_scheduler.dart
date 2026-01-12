import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/notification_repository.dart';
import '../../domain/entities/notification_type.dart';
import '../../data/models/notification_template.dart';

class NotificationScheduler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationRepository _repository = NotificationRepository();

  /// Check and send deadline reminders for tugas and quiz
  /// Should be called periodically (e.g., every 6 hours)
  Future<void> scheduleDeadlineReminders() async {
    print('Running deadline reminders check...');

    try {
      await _checkTugasDeadlines();
      await _checkQuizDeadlines();
    } catch (e) {
      print('Error in scheduleDeadlineReminders: $e');
    }
  }

  /// Check tugas deadlines and send reminders
  Future<void> _checkTugasDeadlines() async {
    try {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(hours: 24));

      // Get tugas with deadline in next 24 hours
      final tugasSnapshot = await _firestore
          .collection('tugas')
          .where('deadline', isGreaterThan: Timestamp.fromDate(now))
          .where('deadline', isLessThan: Timestamp.fromDate(tomorrow))
          .get();

      print('Found ${tugasSnapshot.docs.length} tugas approaching deadline');

      for (var doc in tugasSnapshot.docs) {
        final tugasData = doc.data();
        final tugasId = doc.id;
        final kelasId = tugasData['kelas_id'] ?? '';
        final tugasJudul = tugasData['judul'] ?? 'Tugas';
        final deadline = (tugasData['deadline'] as Timestamp).toDate();

        // Calculate hours left
        final hoursLeft = deadline.difference(now).inHours;

        // Get siswa in kelas
        final siswaList = await _repository.getSiswaByKelas(kelasId);

        print('Sending deadline reminder for tugas "$tugasJudul" to ${siswaList.length} siswa');

        // Get template
        final template = NotificationTemplate.getTemplate(
            NotificationType.siswa_tugas_deadline_approaching);

        // Send notification to each siswa
        for (var siswa in siswaList) {
          final siswaId = siswa['id'] as String;

          // Check if reminder already sent (prevent duplicates)
          final existingReminder = await _firestore
              .collection('notifications')
              .where('userId', isEqualTo: siswaId)
              .where('dedupKey', isEqualTo: 'tugas_deadline_$tugasId')
              .where('createdAt',
                  isGreaterThan:
                      Timestamp.fromDate(now.subtract(Duration(hours: 12))))
              .limit(1)
              .get();

          if (existingReminder.docs.isNotEmpty) {
            print('Reminder already sent to siswa $siswaId for tugas $tugasId');
            continue;
          }

          // Prepare notification data
          final notificationData = {
            'tugasJudul': tugasJudul,
            'hoursLeft': hoursLeft.toString(),
            'waktu': DateFormat('HH:mm').format(deadline),
          };

          final title = template?.renderTitle(notificationData) ??
              '⏰ Pengingat Deadline Tugas';
          final message = template?.renderMessage(notificationData) ??
              'Tugas "$tugasJudul" akan berakhir dalam $hoursLeft jam';

          // Create notification
          await _repository.createNotification(
            userId: siswaId,
            role: 'siswa',
            type: NotificationType.siswa_tugas_deadline_approaching.name,
            title: title,
            message: message,
            priority: 'high',
            actionUrl: '/tugas/detail/$tugasId',
            metadata: {
              'tugasId': tugasId,
              'kelasId': kelasId,
              'deadline': deadline.toIso8601String(),
              'hoursLeft': hoursLeft,
            },
            dedupKey: 'tugas_deadline_$tugasId',
          );
        }
      }
    } catch (e) {
      print('Error checking tugas deadlines: $e');
    }
  }

  /// Check quiz deadlines and send reminders
  Future<void> _checkQuizDeadlines() async {
    try {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(hours: 24));

      // Get quiz with deadline in next 24 hours
      final quizSnapshot = await _firestore
          .collection('quiz')
          .where('deadline', isGreaterThan: Timestamp.fromDate(now))
          .where('deadline', isLessThan: Timestamp.fromDate(tomorrow))
          .get();

      print('Found ${quizSnapshot.docs.length} quiz approaching deadline');

      for (var doc in quizSnapshot.docs) {
        final quizData = doc.data();
        final quizId = doc.id;
        final kelasId = quizData['kelas_id'] ?? '';
        final quizJudul = quizData['judul'] ?? 'Quiz';
        final deadline = (quizData['deadline'] as Timestamp).toDate();

        // Calculate hours left
        final hoursLeft = deadline.difference(now).inHours;

        // Get siswa in kelas
        final siswaList = await _repository.getSiswaByKelas(kelasId);

        print('Sending deadline reminder for quiz "$quizJudul" to ${siswaList.length} siswa');

        // Get template
        final template = NotificationTemplate.getTemplate(
            NotificationType.siswa_quiz_deadline_approaching);

        // Send notification to each siswa
        for (var siswa in siswaList) {
          final siswaId = siswa['id'] as String;

          // Check if reminder already sent
          final existingReminder = await _firestore
              .collection('notifications')
              .where('userId', isEqualTo: siswaId)
              .where('dedupKey', isEqualTo: 'quiz_deadline_$quizId')
              .where('createdAt',
                  isGreaterThan:
                      Timestamp.fromDate(now.subtract(Duration(hours: 12))))
              .limit(1)
              .get();

          if (existingReminder.docs.isNotEmpty) {
            print('Reminder already sent to siswa $siswaId for quiz $quizId');
            continue;
          }

          // Prepare notification data
          final notificationData = {
            'quizJudul': quizJudul,
            'hoursLeft': hoursLeft.toString(),
            'waktu': DateFormat('HH:mm').format(deadline),
          };

          final title = template?.renderTitle(notificationData) ??
              '⏰ Pengingat Deadline Quiz';
          final message = template?.renderMessage(notificationData) ??
              'Quiz "$quizJudul" akan berakhir dalam $hoursLeft jam';

          // Create notification
          await _repository.createNotification(
            userId: siswaId,
            role: 'siswa',
            type: NotificationType.siswa_quiz_deadline_approaching.name,
            title: title,
            message: message,
            priority: 'high',
            actionUrl: '/quiz/detail/$quizId',
            metadata: {
              'quizId': quizId,
              'kelasId': kelasId,
              'deadline': deadline.toIso8601String(),
              'hoursLeft': hoursLeft,
            },
            dedupKey: 'quiz_deadline_$quizId',
          );
        }
      }
    } catch (e) {
      print('Error checking quiz deadlines: $e');
    }
  }
}
