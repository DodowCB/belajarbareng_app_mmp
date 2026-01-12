import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

/// Repository untuk mengelola notifications di Firestore
class NotificationRepository {
  final FirebaseFirestore _firestore;
  
  NotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Collection reference
  CollectionReference get _notificationsCollection =>
      _firestore.collection('notifications');

  /// Buat notifikasi baru
  Future<String> createNotification({
    required String userId,
    required String role,
    required NotificationType type,
    required String title,
    required String message,
    NotificationPriority priority = NotificationPriority.medium,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final notification = NotificationModel(
        id: '', // Will be set by Firestore
        userId: userId,
        role: role,
        type: type,
        title: title,
        message: message,
        priority: priority,
        isRead: false,
        actionUrl: actionUrl,
        metadata: metadata,
        createdAt: DateTime.now(),
      );

      final docRef = await _notificationsCollection.add(notification.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  /// Buat multiple notifications (batch)
  Future<void> createBatchNotifications(
      List<Map<String, dynamic>> notificationData) async {
    try {
      final batch = _firestore.batch();
      
      for (final data in notificationData) {
        final docRef = _notificationsCollection.doc();
        final notification = NotificationModel(
          id: docRef.id,
          userId: data['userId'],
          role: data['role'],
          type: data['type'],
          title: data['title'],
          message: data['message'],
          priority: data['priority'] ?? NotificationPriority.medium,
          isRead: false,
          actionUrl: data['actionUrl'],
          metadata: data['metadata'],
          createdAt: DateTime.now(),
        );
        batch.set(docRef, notification.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to create batch notifications: $e');
    }
  }

  /// Get notifications stream untuk user tertentu
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get unread notifications stream
  Stream<List<NotificationModel>> getUnreadNotifications(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get unread count
  Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();
      
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read untuk user
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Delete all notifications untuk user
  Future<void> deleteAllNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete all notifications: $e');
    }
  }

  /// Get notification by ID
  Future<NotificationModel?> getNotificationById(String notificationId) async {
    try {
      final doc = await _notificationsCollection.doc(notificationId).get();
      
      if (!doc.exists) return null;
      
      return NotificationModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get notification: $e');
    }
  }
}
