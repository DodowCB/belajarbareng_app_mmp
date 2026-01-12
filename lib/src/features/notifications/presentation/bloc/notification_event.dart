import 'package:equatable/equatable.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

// Fetch notifications by userId and role
class FetchNotifications extends NotificationEvent {
  final String userId;
  final String role;

  const FetchNotifications({
    required this.userId,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, role];
}

// Mark single notification as read
class MarkAsRead extends NotificationEvent {
  final String notificationId;

  const MarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

// Mark all notifications as read
class MarkAllAsRead extends NotificationEvent {
  final String userId;
  final String role;

  const MarkAllAsRead({
    required this.userId,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, role];
}

// Delete single notification
class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

// Delete all notifications
class DeleteAllNotifications extends NotificationEvent {
  final String userId;
  final String role;

  const DeleteAllNotifications({
    required this.userId,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, role];
}

// Create single notification
class CreateNotification extends NotificationEvent {
  final NotificationModel notification;

  const CreateNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}

// Create bulk notifications
class CreateBulkNotifications extends NotificationEvent {
  final List<NotificationModel> notifications;

  const CreateBulkNotifications(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

// Check and create deadline reminders
class CheckDeadlineReminders extends NotificationEvent {
  const CheckDeadlineReminders();
}

// Refresh notifications (reload)
class RefreshNotifications extends NotificationEvent {
  final String userId;
  final String role;

  const RefreshNotifications({
    required this.userId,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, role];
}
