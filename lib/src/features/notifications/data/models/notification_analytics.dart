import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationAnalytics extends Equatable {
  final String id;
  final String userId;
  final String notificationId;
  final DateTime viewedAt;
  final DateTime? clickedAt;
  final String? action; // 'opened', 'dismissed', 'clicked_action'
  final Map<String, dynamic> metadata;

  const NotificationAnalytics({
    required this.id,
    required this.userId,
    required this.notificationId,
    required this.viewedAt,
    this.clickedAt,
    this.action,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        notificationId,
        viewedAt,
        clickedAt,
        action,
        metadata,
      ];

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'notificationId': notificationId,
      'viewedAt': Timestamp.fromDate(viewedAt),
      'clickedAt': clickedAt != null ? Timestamp.fromDate(clickedAt!) : null,
      'action': action,
      'metadata': metadata,
    };
  }

  // From Firestore
  factory NotificationAnalytics.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationAnalytics(
      id: doc.id,
      userId: data['userId'] ?? '',
      notificationId: data['notificationId'] ?? '',
      viewedAt: (data['viewedAt'] as Timestamp).toDate(),
      clickedAt: data['clickedAt'] != null
          ? (data['clickedAt'] as Timestamp).toDate()
          : null,
      action: data['action'],
      metadata: data['metadata'] ?? {},
    );
  }

  // To JSON
  Map<String, dynamic> toJson() => toMap();
}
