import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../providers/app_user.dart';

class RecentActivityService {
  static final RecentActivityService _instance = RecentActivityService._internal();
  factory RecentActivityService() => _instance;
  RecentActivityService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'admin_recent_activities';

  /// Add a new activity. Only allowed for admin users (client-side check).
  /// activity must contain: title (String), details (String?), icon (String identifier)
  Future<void> addActivity(Map<String, dynamic> activity) async {
    if (!AppUser.hasRole('admin')) {
      // Not throwing here to avoid breaking caller flows; just log.
      debugPrint('RecentActivityService: caller is not admin, skipping addActivity');
      return;
    }

    final now = DateTime.now().toUtc();

    try {
      debugPrint('RecentActivityService: adding activity: ${activity['title']} by ${AppUser.email}');
      final docRef = await _firestore.collection(collectionName).add({
        'title': activity['title'] ?? 'Activity',
        'details': activity['details'] ?? '',
        'icon': activity['icon'] ?? 'info',
        'created_at': Timestamp.fromDate(now),
        'created_by': AppUser.email ?? AppUser.displayName,
      });

      // Enforce max 5 documents: delete oldest if count > 5
      try {
        final snapshot = await _firestore.collection(collectionName).orderBy('created_at', descending: false).get();
        final docs = snapshot.docs;
        if (docs.length > 5) {
          final toDelete = docs.length - 5;
          debugPrint('RecentActivityService: trimming $toDelete old activities');
          for (var i = 0; i < toDelete; i++) {
            try {
              await _firestore.collection(collectionName).doc(docs[i].id).delete();
              debugPrint('RecentActivityService: deleted old activity ${docs[i].id}');
            } catch (e) {
              debugPrint('RecentActivityService: failed deleting ${docs[i].id}: $e');
            }
          }
        }
      } catch (e) {
        debugPrint('RecentActivityService: error enforcing limit: $e');
      }
    } catch (e) {
      debugPrint('RecentActivityService: failed to add activity: $e');
    }
    return;
  }

  /// Stream last 5 activities ordered by created_at descending
  Stream<List<Map<String, dynamic>>> recentActivitiesStream() {
    return _firestore
        .collection(collectionName)
        .orderBy('created_at', descending: true)
        .limit(5)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final data = d.data();
              return {
                'id': d.id,
                'title': data['title'] ?? '',
                'details': data['details'] ?? '',
                'icon': data['icon'] ?? 'info',
                'created_at': data['created_at'],
                'created_by': data['created_by'] ?? '',
              };
            }).toList());
  }
}
