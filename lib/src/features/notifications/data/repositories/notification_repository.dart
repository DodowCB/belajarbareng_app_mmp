import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get notifications by userId and role
  Future<List<NotificationModel>> getNotifications(
    String userId,
    String role,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('role', isEqualTo: role)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting notifications: $e');
      throw Exception('Failed to get notifications: $e');
    }
  }

  // Create single notification
  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _firestore.collection('notifications').add(notification.toMap());
    } catch (e) {
      print('Error creating notification: $e');
      throw Exception('Failed to create notification: $e');
    }
  }

  // Create bulk notifications
  Future<void> createBulkNotifications(
    List<NotificationModel> notifications,
  ) async {
    try {
      final batch = _firestore.batch();

      for (var notification in notifications) {
        final docRef = _firestore.collection('notifications').doc();
        batch.set(docRef, notification.toMap());
      }

      await batch.commit();
    } catch (e) {
      print('Error creating bulk notifications: $e');
      throw Exception('Failed to create bulk notifications: $e');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error marking notification as read: $e');
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userId, String role) async {
    try {
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('role', isEqualTo: role)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      print('Error deleting notification: $e');
      throw Exception('Failed to delete notification: $e');
    }
  }

  // Delete all notifications
  Future<void> deleteAllNotifications(String userId, String role) async {
    try {
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('role', isEqualTo: role)
          .get();

      final batch = _firestore.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error deleting all notifications: $e');
      throw Exception('Failed to delete all notifications: $e');
    }
  }

  // Watch notifications (real-time)
  Stream<List<NotificationModel>> watchNotifications(
    String userId,
    String role,
  ) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('role', isEqualTo: role)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  // Helper: Check and create deadline reminders
  Future<void> checkAndCreateDeadlineReminders() async {
    try {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final tomorrowEnd = DateTime(now.year, now.month, now.day + 2);

      // Get all tugas with deadline tomorrow
      final tugasSnapshot = await _firestore
          .collection('tugas')
          .where('deadline', isGreaterThanOrEqualTo: Timestamp.fromDate(tomorrow))
          .where('deadline', isLessThan: Timestamp.fromDate(tomorrowEnd))
          .get();

      for (var tugasDoc in tugasSnapshot.docs) {
        final tugasData = tugasDoc.data();
        final tugasId = tugasDoc.id;
        final tugasNama = tugasData['nama'] ?? 'Tugas';
        final kelasId = tugasData['kelas_id'];

        // Get all siswa in the class
        final siswaSnapshot = await _firestore
            .collection('siswa')
            .where('kelas_id', isEqualTo: kelasId)
            .get();

        // Get siswa who already submitted
        final submittedSnapshot = await _firestore
            .collection('tugas_siswa')
            .where('tugas_id', isEqualTo: tugasId)
            .where('status', isEqualTo: 'submitted')
            .get();

        final submittedSiswaIds =
            submittedSnapshot.docs.map((doc) => doc.data()['siswa_id']).toSet();

        // Create notifications for siswa who haven't submitted
        final notifications = <NotificationModel>[];
        for (var siswaDoc in siswaSnapshot.docs) {
          final siswaId = siswaDoc.id;
          
          if (!submittedSiswaIds.contains(siswaId)) {
            notifications.add(NotificationModel(
              id: '',
              userId: siswaId,
              role: 'siswa',
              type: 'tugas_deadline',
              title: '⏰ Deadline Tugas: $tugasNama',
              message: 'Segera dikumpulkan! Deadline besok',
              priority: 'high',
              isRead: false,
              actionUrl: '/tugas/detail/$tugasId',
              metadata: {'taskId': tugasId, 'kelasId': kelasId},
              createdAt: DateTime.now(),
            ));
          }
        }

        if (notifications.isNotEmpty) {
          await createBulkNotifications(notifications);
        }
      }
    } catch (e) {
      print('Error checking deadline reminders: $e');
      throw Exception('Failed to check deadline reminders: $e');
    }
  }

  // Helper: Get all siswa IDs
  Future<List<String>> getAllSiswaIds() async {
    try {
      final snapshot = await _firestore.collection('siswa').get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error getting all siswa IDs: $e');
      return [];
    }
  }

  // Helper: Get all guru IDs
  Future<List<String>> getAllGuruIds() async {
    try {
      final snapshot = await _firestore.collection('guru').get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error getting all guru IDs: $e');
      return [];
    }
  }

  // Helper: Get all admin IDs
  Future<List<String>> getAllAdminIds() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error getting all admin IDs: $e');
      return [];
    }
  }

  // Helper: Get siswa by kelas
  Future<List<Map<String, dynamic>>> getSiswaByKelas(String kelasId) async {
    try {
      // Step 1: Get siswa_kelas junction table records
      final siswaKelasSnapshot = await _firestore
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: kelasId)
          .get();

      if (siswaKelasSnapshot.docs.isEmpty) {
        print('No siswa_kelas records found for kelas: $kelasId');
        return [];
      }

      // Step 2: Extract siswa IDs
      final siswaIds = siswaKelasSnapshot.docs
          .map((doc) => doc.data()['siswa_id'] as String?)
          .where((id) => id != null)
          .cast<String>()
          .toSet()
          .toList();

      if (siswaIds.isEmpty) {
        print('No siswa IDs found in siswa_kelas for kelas: $kelasId');
        return [];
      }

      print('Found ${siswaIds.length} siswa IDs for kelas $kelasId: $siswaIds');

      // Step 3: Fetch siswa details (in batches of 10 due to Firestore 'in' limit)
      final List<Map<String, dynamic>> siswaList = [];
      
      for (int i = 0; i < siswaIds.length; i += 10) {
        final batch = siswaIds.skip(i).take(10).toList();
        final siswaSnapshot = await _firestore
            .collection('siswa')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        siswaList.addAll(
          siswaSnapshot.docs.map((doc) => {
            'id': doc.id,
            ...doc.data(),
          }),
        );
      }

      print('Fetched ${siswaList.length} siswa details');
      return siswaList;
    } catch (e) {
      print('Error getting siswa by kelas: $e');
      return [];
    }
  }

  // Helper: Get guru by ID
  Future<Map<String, dynamic>?> getGuruById(String guruId) async {
    try {
      final doc = await _firestore.collection('guru').doc(guruId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      print('Error getting guru by ID: $e');
      return null;
    }
  }

  // Helper: Get tugas by ID
  Future<Map<String, dynamic>?> getTugasById(String tugasId) async {
    try {
      final doc = await _firestore.collection('tugas').doc(tugasId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      print('Error getting tugas by ID: $e');
      return null;
    }
  }

  // Helper: Get kelas by ID
  Future<Map<String, dynamic>?> getKelasById(String kelasId) async {
    try {
      final doc = await _firestore.collection('kelas').doc(kelasId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      print('Error getting kelas by ID: $e');
      return null;
    }
  }

  // Helper: Check for duplicate notification
  Future<bool> checkDuplicateNotification({
    required String userId,
    required String dedupKey,
    int withinHours = 12,
  }) async {
    try {
      final timeThreshold =
          DateTime.now().subtract(Duration(hours: withinHours));

      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('dedupKey', isEqualTo: dedupKey)
          .where('createdAt', isGreaterThan: Timestamp.fromDate(timeThreshold))
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking duplicate notification: $e');
      return false;
    }
  }

  // Helper: Create notification analytics entry
  Future<void> createAnalytics({
    required String userId,
    required String notificationId,
    String? action,
  }) async {
    try {
      await _firestore.collection('notification_analytics').add({
        'userId': userId,
        'notificationId': notificationId,
        'viewedAt': FieldValue.serverTimestamp(),
        'clickedAt': action != null ? FieldValue.serverTimestamp() : null,
        'action': action,
        'metadata': {},
      });
    } catch (e) {
      print('Error creating analytics: $e');
    }
  }
}

