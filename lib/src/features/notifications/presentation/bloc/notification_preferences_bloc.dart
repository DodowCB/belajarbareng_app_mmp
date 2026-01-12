import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/notification_preferences.dart';

// Events
abstract class NotificationPreferencesEvent extends Equatable {
  const NotificationPreferencesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationPreferences extends NotificationPreferencesEvent {
  final String userId;

  const LoadNotificationPreferences(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateTugasNotifPreference extends NotificationPreferencesEvent {
  final String userId;
  final bool value;

  const UpdateTugasNotifPreference(this.userId, this.value);

  @override
  List<Object?> get props => [userId, value];
}

class UpdateQuizNotifPreference extends NotificationPreferencesEvent {
  final String userId;
  final bool value;

  const UpdateQuizNotifPreference(this.userId, this.value);

  @override
  List<Object?> get props => [userId, value];
}

class UpdateQnaNotifPreference extends NotificationPreferencesEvent {
  final String userId;
  final bool value;

  const UpdateQnaNotifPreference(this.userId, this.value);

  @override
  List<Object?> get props => [userId, value];
}

class UpdatePengumumanNotifPreference extends NotificationPreferencesEvent {
  final String userId;
  final bool value;

  const UpdatePengumumanNotifPreference(this.userId, this.value);

  @override
  List<Object?> get props => [userId, value];
}

class UpdateNilaiNotifPreference extends NotificationPreferencesEvent {
  final String userId;
  final bool value;

  const UpdateNilaiNotifPreference(this.userId, this.value);

  @override
  List<Object?> get props => [userId, value];
}

class UpdateDeadlineReminderPreference extends NotificationPreferencesEvent {
  final String userId;
  final bool value;

  const UpdateDeadlineReminderPreference(this.userId, this.value);

  @override
  List<Object?> get props => [userId, value];
}

class UpdateUserManagementNotifPreference extends NotificationPreferencesEvent {
  final String userId;
  final bool value;

  const UpdateUserManagementNotifPreference(this.userId, this.value);

  @override
  List<Object?> get props => [userId, value];
}

class ResetNotificationPreferences extends NotificationPreferencesEvent {
  final String userId;

  const ResetNotificationPreferences(this.userId);

  @override
  List<Object?> get props => [userId];
}

// States
abstract class NotificationPreferencesState extends Equatable {
  const NotificationPreferencesState();

  @override
  List<Object?> get props => [];
}

class NotificationPreferencesInitial extends NotificationPreferencesState {}

class NotificationPreferencesLoading extends NotificationPreferencesState {}

class NotificationPreferencesLoaded extends NotificationPreferencesState {
  final NotificationPreferences preferences;

  const NotificationPreferencesLoaded(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class NotificationPreferencesError extends NotificationPreferencesState {
  final String message;

  const NotificationPreferencesError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class NotificationPreferencesBloc
    extends Bloc<NotificationPreferencesEvent, NotificationPreferencesState> {
  NotificationPreferencesBloc() : super(NotificationPreferencesInitial()) {
    on<LoadNotificationPreferences>(_onLoadPreferences);
    on<UpdateTugasNotifPreference>(_onUpdateTugasNotif);
    on<UpdateQuizNotifPreference>(_onUpdateQuizNotif);
    on<UpdateQnaNotifPreference>(_onUpdateQnaNotif);
    on<UpdatePengumumanNotifPreference>(_onUpdatePengumumanNotif);
    on<UpdateNilaiNotifPreference>(_onUpdateNilaiNotif);
    on<UpdateDeadlineReminderPreference>(_onUpdateDeadlineReminder);
    on<UpdateUserManagementNotifPreference>(_onUpdateUserManagementNotif);
    on<ResetNotificationPreferences>(_onResetPreferences);
  }

  Future<void> _onLoadPreferences(
    LoadNotificationPreferences event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    emit(NotificationPreferencesLoading());

    try {
      final preferences = await NotificationPreferences.load(event.userId);
      emit(NotificationPreferencesLoaded(preferences));
    } catch (e) {
      emit(NotificationPreferencesError(e.toString()));
    }
  }

  Future<void> _onUpdateTugasNotif(
    UpdateTugasNotifPreference event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    if (state is NotificationPreferencesLoaded) {
      final currentState = state as NotificationPreferencesLoaded;
      final updatedPreferences =
          currentState.preferences.copyWith(enableTugasNotif: event.value);

      await updatedPreferences.save(event.userId);
      emit(NotificationPreferencesLoaded(updatedPreferences));
    }
  }

  Future<void> _onUpdateQuizNotif(
    UpdateQuizNotifPreference event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    if (state is NotificationPreferencesLoaded) {
      final currentState = state as NotificationPreferencesLoaded;
      final updatedPreferences =
          currentState.preferences.copyWith(enableQuizNotif: event.value);

      await updatedPreferences.save(event.userId);
      emit(NotificationPreferencesLoaded(updatedPreferences));
    }
  }

  Future<void> _onUpdateQnaNotif(
    UpdateQnaNotifPreference event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    if (state is NotificationPreferencesLoaded) {
      final currentState = state as NotificationPreferencesLoaded;
      final updatedPreferences =
          currentState.preferences.copyWith(enableQnaNotif: event.value);

      await updatedPreferences.save(event.userId);
      emit(NotificationPreferencesLoaded(updatedPreferences));
    }
  }

  Future<void> _onUpdatePengumumanNotif(
    UpdatePengumumanNotifPreference event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    if (state is NotificationPreferencesLoaded) {
      final currentState = state as NotificationPreferencesLoaded;
      final updatedPreferences = currentState.preferences
          .copyWith(enablePengumumanNotif: event.value);

      await updatedPreferences.save(event.userId);
      emit(NotificationPreferencesLoaded(updatedPreferences));
    }
  }

  Future<void> _onUpdateNilaiNotif(
    UpdateNilaiNotifPreference event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    if (state is NotificationPreferencesLoaded) {
      final currentState = state as NotificationPreferencesLoaded;
      final updatedPreferences =
          currentState.preferences.copyWith(enableNilaiNotif: event.value);

      await updatedPreferences.save(event.userId);
      emit(NotificationPreferencesLoaded(updatedPreferences));
    }
  }

  Future<void> _onUpdateDeadlineReminder(
    UpdateDeadlineReminderPreference event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    if (state is NotificationPreferencesLoaded) {
      final currentState = state as NotificationPreferencesLoaded;
      final updatedPreferences = currentState.preferences
          .copyWith(enableDeadlineReminder: event.value);

      await updatedPreferences.save(event.userId);
      emit(NotificationPreferencesLoaded(updatedPreferences));
    }
  }

  Future<void> _onUpdateUserManagementNotif(
    UpdateUserManagementNotifPreference event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    if (state is NotificationPreferencesLoaded) {
      final currentState = state as NotificationPreferencesLoaded;
      final updatedPreferences = currentState.preferences
          .copyWith(enableUserManagementNotif: event.value);

      await updatedPreferences.save(event.userId);
      emit(NotificationPreferencesLoaded(updatedPreferences));
    }
  }

  Future<void> _onResetPreferences(
    ResetNotificationPreferences event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    try {
      await NotificationPreferences.clear(event.userId);
      final defaultPreferences = NotificationPreferences.defaultPreferences;
      await defaultPreferences.save(event.userId);
      emit(NotificationPreferencesLoaded(defaultPreferences));
    } catch (e) {
      emit(NotificationPreferencesError(e.toString()));
    }
  }
}
