import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum untuk tipe notifikasi
enum NotificationType {
  tugasBaru('TUGAS_BARU'),
  tugasDeadline('TUGAS_DEADLINE'),
  tugasSubmitted('TUGAS_SUBMITTED'),
  nilaiKeluar('NILAI_KELUAR'),
  pengumuman('PENGUMUMAN');

  final String code;
  const NotificationType(this.code);

  static NotificationType fromCode(String code) {
    return NotificationType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => NotificationType.pengumuman,
    );
  }
}

/// Enum untuk priority notifikasi
enum NotificationPriority {
  high('high'),
  medium('medium'),
  low('low');

  final String code;
  const NotificationPriority(this.code);

  static NotificationPriority fromCode(String code) {
    return NotificationPriority.values.firstWhere(
      (priority) => priority.code == code,
      orElse: () => NotificationPriority.medium,
    );
  }
}

/// Model untuk notifikasi
class NotificationModel {
  final String id;
  final String userId;
  final String role; // 'admin', 'guru', 'siswa'
  final NotificationType type;
  final String title;
  final String message;
  final NotificationPriority priority;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.role,
    required this.type,
    required this.title,
    required this.message,
    required this.priority,
    this.isRead = false,
    this.actionUrl,
    this.metadata,
    required this.createdAt,
  });

  /// Convert to Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'role': role,
      'type': type.code,
      'title': title,
      'message': message,
      'priority': priority.code,
      'isRead': isRead,
      'actionUrl': actionUrl,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create dari Firestore DocumentSnapshot
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      role: data['role'] ?? 'siswa',
      type: NotificationType.fromCode(data['type'] ?? 'PENGUMUMAN'),
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      priority: NotificationPriority.fromCode(data['priority'] ?? 'medium'),
      isRead: data['isRead'] ?? false,
      actionUrl: data['actionUrl'],
      metadata: data['metadata'] as Map<String, dynamic>?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Create dari Map
  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      userId: map['userId'] ?? '',
      role: map['role'] ?? 'siswa',
      type: NotificationType.fromCode(map['type'] ?? 'PENGUMUMAN'),
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      priority: NotificationPriority.fromCode(map['priority'] ?? 'medium'),
      isRead: map['isRead'] ?? false,
      actionUrl: map['actionUrl'],
      metadata: map['metadata'] as Map<String, dynamic>?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Copy with
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? role,
    NotificationType? type,
    String? title,
    String? message,
    NotificationPriority? priority,
    bool? isRead,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
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
    );
  }
}
