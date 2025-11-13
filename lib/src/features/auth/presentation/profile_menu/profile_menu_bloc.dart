import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Profile Menu Events
abstract class ProfileMenuEvent {}

class LoadProfileMenuData extends ProfileMenuEvent {}

class ToggleTheme extends ProfileMenuEvent {}

class NavigateToProfile extends ProfileMenuEvent {}

class NavigateToSettings extends ProfileMenuEvent {}

class NavigateToNotifications extends ProfileMenuEvent {}

class NavigateToHelp extends ProfileMenuEvent {}

class LogoutRequested extends ProfileMenuEvent {}

// Profile Menu State
class ProfileMenuState {
  final bool isLoading;
  final bool isDarkMode;
  final String userName;
  final String userEmail;
  final String? userPhotoUrl;
  final String? error;

  ProfileMenuState({
    this.isLoading = false,
    this.isDarkMode = false,
    this.userName = '',
    this.userEmail = '',
    this.userPhotoUrl,
    this.error,
  });

  ProfileMenuState copyWith({
    bool? isLoading,
    bool? isDarkMode,
    String? userName,
    String? userEmail,
    String? userPhotoUrl,
    String? error,
  }) {
    return ProfileMenuState(
      isLoading: isLoading ?? this.isLoading,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      error: error,
    );
  }
}

// Profile Menu Bloc
class ProfileMenuBloc extends Bloc<ProfileMenuEvent, ProfileMenuState> {
  ProfileMenuBloc() : super(ProfileMenuState()) {
    on<LoadProfileMenuData>(_onLoadProfileMenuData);
    on<ToggleTheme>(_onToggleTheme);
    on<NavigateToProfile>(_onNavigateToProfile);
    on<NavigateToSettings>(_onNavigateToSettings);
    on<NavigateToNotifications>(_onNavigateToNotifications);
    on<NavigateToHelp>(_onNavigateToHelp);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadProfileMenuData(
    LoadProfileMenuData event,
    Emitter<ProfileMenuState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Simulate loading user data
      await Future.delayed(const Duration(milliseconds: 500));

      // TODO: Load actual user data from provider or repository
      emit(
        state.copyWith(
          isLoading: false,
          userName: 'John Doe',
          userEmail: 'john.doe@example.com',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load profile data: ${e.toString()}',
        ),
      );
    }
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ProfileMenuState> emit) {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void _onNavigateToProfile(
    NavigateToProfile event,
    Emitter<ProfileMenuState> emit,
  ) {
    // Navigation will be handled by the UI
    print('Navigating to Profile');
  }

  void _onNavigateToSettings(
    NavigateToSettings event,
    Emitter<ProfileMenuState> emit,
  ) {
    // Navigation will be handled by the UI
    print('Navigating to Settings');
  }

  void _onNavigateToNotifications(
    NavigateToNotifications event,
    Emitter<ProfileMenuState> emit,
  ) {
    // Navigation will be handled by the UI
    print('Navigating to Notifications');
  }

  void _onNavigateToHelp(NavigateToHelp event, Emitter<ProfileMenuState> emit) {
    // Navigation will be handled by the UI
    print('Navigating to Help');
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileMenuState> emit,
  ) {
    // Logout logic will be handled by the UI or auth bloc
    print('Logout requested');
  }
}
