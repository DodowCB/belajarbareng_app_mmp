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
      ];
}
