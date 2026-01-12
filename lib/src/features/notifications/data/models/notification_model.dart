import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.role,
    required super.type,
    required super.title,
    required super.message,
    required super.priority,
    required super.isRead,
    super.actionUrl,
    required super.metadata,
    required super.createdAt,
    super.updatedAt,
    super.groupKey,
    super.groupCount,
    super.actions,
    super.dedupKey,
  });

  // Factory constructor untuk membuat NotificationModel dari Firestore
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      role: data['role'] ?? '',
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      priority: data['priority'] ?? 'low',
      isRead: data['isRead'] ?? false,
      actionUrl: data['actionUrl'],
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      groupKey: data['groupKey'],
      groupCount: data['groupCount'],
      actions: data['actions'] != null ? List<Map<String, dynamic>>.from(data['actions']) : null,
      dedupKey: data['dedupKey'],
    );
  }

  // Factory constructor untuk membuat NotificationModel dari JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      role: json['role'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      priority: json['priority'] ?? 'low',
      isRead: json['isRead'] ?? false,
      actionUrl: json['actionUrl'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: json['createdAt'] is Timestamp 
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is Timestamp 
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt']))
          : null,
      groupKey: json['groupKey'],
      groupCount: json['groupCount'],
      actions: json['actions'] != null ? List<Map<String, dynamic>>.from(json['actions']) : null,
      dedupKey: json['dedupKey'],
    );
  }

  // Method untuk convert ke Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'role': role,
      'type': type,
      'title': title,
      'message': message,
      'priority': priority,
      'isRead': isRead,
      'actionUrl': actionUrl,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'groupKey': groupKey,
      'groupCount': groupCount,
      'actions': actions,
      'dedupKey': dedupKey,
    };
  }

  // Method untuk convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'role': role,
      'type': type,
      'title': title,
      'message': message,
      'priority': priority,
      'isRead': isRead,
      'actionUrl': actionUrl,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'groupKey': groupKey,
      'groupCount': groupCount,
      'actions': actions,
      'dedupKey': dedupKey,
    };
  }

  // Method untuk copy dengan perubahan
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? role,
    String? type,
    String? title,
    String? message,
    String? priority,
    bool? isRead,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? groupKey,
    int? groupCount,
    List<Map<String, dynamic>>? actions,
    String? dedupKey,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      groupKey: groupKey ?? this.groupKey,
      groupCount: groupCount ?? this.groupCount,
      actions: actions ?? this.actions,
      dedupKey: dedupKey ?? this.dedupKey,
    );
  }
}
