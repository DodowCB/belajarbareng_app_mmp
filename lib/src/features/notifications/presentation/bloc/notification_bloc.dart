import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc({required NotificationRepository repository})
      : _repository = repository,
        super(NotificationInitial()) {
    on<FetchNotifications>(_onFetchNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<DeleteAllNotifications>(_onDeleteAllNotifications);
    on<CreateNotification>(_onCreateNotification);
    on<CreateBulkNotifications>(_onCreateBulkNotifications);
    on<CheckDeadlineReminders>(_onCheckDeadlineReminders);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<TrackNotificationViewed>(_onTrackNotificationViewed);
    on<TrackNotificationClicked>(_onTrackNotificationClicked);
    on<TrackNotificationAction>(_onTrackNotificationAction);
  }

  Future<void> _onFetchNotifications(
    FetchNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final notifications = await _repository.getNotifications(
        event.userId,
        event.role,
      );

      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationError('Failed to load notifications: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    // Keep current state while processing
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      emit(NotificationOperationLoading(
        notifications: currentState.notifications,
        unreadCount: currentState.unreadCount,
      ));
    }

    try {
      await _repository.markAsRead(event.notificationId);

      // Update local state
      if (state is NotificationOperationLoading) {
        final currentState = state as NotificationOperationLoading;
        final updatedNotifications = currentState.notifications.map((n) {
          if (n.id == event.notificationId) {
            return n.copyWith(isRead: true, updatedAt: DateTime.now());
          }
          return n;
        }).toList();

        final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

        emit(NotificationOperationSuccess(
          message: 'Notification marked as read',
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ));
      }
    } catch (e) {
      emit(NotificationError('Failed to mark as read: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    // Keep current state while processing
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      emit(NotificationOperationLoading(
        notifications: currentState.notifications,
        unreadCount: currentState.unreadCount,
      ));
    }

    try {
      await _repository.markAllAsRead(event.userId, event.role);

      // Update local state
      if (state is NotificationOperationLoading) {
        final currentState = state as NotificationOperationLoading;
        final updatedNotifications = currentState.notifications
            .map((n) => n.copyWith(isRead: true, updatedAt: DateTime.now()))
            .toList();

        emit(NotificationOperationSuccess(
          message: 'All notifications marked as read',
          notifications: updatedNotifications,
          unreadCount: 0,
        ));
      }
    } catch (e) {
      emit(NotificationError('Failed to mark all as read: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    // Keep current state while processing
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      emit(NotificationOperationLoading(
        notifications: currentState.notifications,
        unreadCount: currentState.unreadCount,
      ));
    }

    try {
      await _repository.deleteNotification(event.notificationId);

      // Update local state
      if (state is NotificationOperationLoading) {
        final currentState = state as NotificationOperationLoading;
        final updatedNotifications = currentState.notifications
            .where((n) => n.id != event.notificationId)
            .toList();

        final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

        emit(NotificationOperationSuccess(
          message: 'Notification deleted',
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ));
      }
    } catch (e) {
      emit(NotificationError('Failed to delete notification: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteAllNotifications(
    DeleteAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      await _repository.deleteAllNotifications(event.userId, event.role);

      emit(const NotificationOperationSuccess(
        message: 'All notifications deleted',
        notifications: [],
        unreadCount: 0,
      ));
    } catch (e) {
      emit(NotificationError(
        'Failed to delete all notifications: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCreateNotification(
    CreateNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.createNotification(event.notification);

      // No need to emit success for background operations
      // The recipient will see it when they fetch notifications
    } catch (e) {
      print('Error creating notification: $e');
      // Don't emit error state as this is a background operation
    }
  }

  Future<void> _onCreateBulkNotifications(
    CreateBulkNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.createBulkNotifications(event.notifications);

      // No need to emit success for background operations
      // The recipients will see them when they fetch notifications
    } catch (e) {
      print('Error creating bulk notifications: $e');
      // Don't emit error state as this is a background operation
    }
  }

  Future<void> _onCheckDeadlineReminders(
    CheckDeadlineReminders event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.checkAndCreateDeadlineReminders();
      
      // No need to emit success for background operations
    } catch (e) {
      print('Error checking deadline reminders: $e');
      // Don't emit error state as this is a background operation
    }
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    // Don't show loading for refresh
    try {
      final notifications = await _repository.getNotifications(
        event.userId,
        event.role,
      );

      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationError('Failed to refresh notifications: ${e.toString()}'));
    }
  }

  // Analytics: Track notification viewed
  Future<void> _onTrackNotificationViewed(
    TrackNotificationViewed event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.createAnalytics(
        userId: event.userId,
        notificationId: event.notificationId,
        action: null, // Viewed, not clicked yet
      );
    } catch (e) {
      print('Error tracking notification viewed: $e');
    }
  }

  // Analytics: Track notification clicked
  Future<void> _onTrackNotificationClicked(
    TrackNotificationClicked event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.createAnalytics(
        userId: event.userId,
        notificationId: event.notificationId,
        action: event.action ?? 'clicked',
      );
    } catch (e) {
      print('Error tracking notification clicked: $e');
    }
  }

  // Analytics: Track notification action clicked
  Future<void> _onTrackNotificationAction(
    TrackNotificationAction event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.createAnalytics(
        userId: event.userId,
        notificationId: event.notificationId,
        action: 'action_${event.actionId}',
      );
    } catch (e) {
      print('Error tracking notification action: $e');
    }
  }
}
