import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String role;
  final String type;
  final String title;
  final String message;
  final String priority;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Phase 2 & 3 additions
  final String? groupKey; // e.g., 'tugas_123', 'quiz_456'
  final int? groupCount; // Number of notifications in group
  final List<Map<String, dynamic>>? actions; // Notification actions
  final String? dedupKey; // For deduplication

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.role,
    required this.type,
    required this.title,
    required this.message,
    required this.priority,
    required this.isRead,
    this.actionUrl,
    required this.metadata,
    required this.createdAt,
    this.updatedAt,
    this.groupKey,
    this.groupCount,
    this.actions,
    this.dedupKey,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        role,
        type,
        title,
        message,
        priority,
        isRead,
        actionUrl,
        metadata,
        createdAt,
        updatedAt,
        groupKey,
        groupCount,
        actions,
        dedupKey,
      ];
}
