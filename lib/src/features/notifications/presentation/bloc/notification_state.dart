import 'package:equatable/equatable.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

// Initial state
class NotificationInitial extends NotificationState {}

// Loading state
class NotificationLoading extends NotificationState {}

// Loaded state with notifications
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

// Error state
class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Operation success state (for create, update, delete operations)
class NotificationOperationSuccess extends NotificationState {
  final String message;
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationOperationSuccess({
    required this.message,
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [message, notifications, unreadCount];
}

// Operation loading state (for specific operations like mark as read, delete)
class NotificationOperationLoading extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationOperationLoading({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}
