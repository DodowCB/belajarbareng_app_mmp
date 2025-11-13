import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Admin Events
abstract class AdminEvent {}

class LoadAdminData extends AdminEvent {}

class RefreshAdminData extends AdminEvent {}

class UpdateUserStats extends AdminEvent {
  final Map<String, int> stats;
  UpdateUserStats(this.stats);
}

// Admin State
class AdminState {
  final bool isLoading;
  final int totalUsers;
  final int totalTeachers;
  final int totalStudents;
  final int totalMaterials;
  final List<Map<String, dynamic>> recentActivities;
  final String? error;

  AdminState({
    this.isLoading = false,
    this.totalUsers = 0,
    this.totalTeachers = 0,
    this.totalStudents = 0,
    this.totalMaterials = 0,
    this.recentActivities = const [],
    this.error,
  });

  AdminState copyWith({
    bool? isLoading,
    int? totalUsers,
    int? totalTeachers,
    int? totalStudents,
    int? totalMaterials,
    List<Map<String, dynamic>>? recentActivities,
    String? error,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      totalUsers: totalUsers ?? this.totalUsers,
      totalTeachers: totalTeachers ?? this.totalTeachers,
      totalStudents: totalStudents ?? this.totalStudents,
      totalMaterials: totalMaterials ?? this.totalMaterials,
      recentActivities: recentActivities ?? this.recentActivities,
      error: error,
    );
  }
}

// Admin Bloc
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminState()) {
    on<LoadAdminData>(_onLoadAdminData);
    on<RefreshAdminData>(_onRefreshAdminData);
    on<UpdateUserStats>(_onUpdateUserStats);
  }

  Future<void> _onLoadAdminData(
    LoadAdminData event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));

      // Mock data
      const totalUsers = 150;
      const totalTeachers = 25;
      const totalStudents = 125;
      const totalMaterials = 48;

      final recentActivities = [
        {
          'title': 'New user registered',
          'time': '2 minutes ago',
          'icon': Icons.person_add,
        },
        {
          'title': 'Teacher uploaded material',
          'time': '15 minutes ago',
          'icon': Icons.upload_file,
        },
        {
          'title': 'System backup completed',
          'time': '1 hour ago',
          'icon': Icons.backup,
        },
        {
          'title': 'New course created',
          'time': '2 hours ago',
          'icon': Icons.school,
        },
        {
          'title': 'Student completed course',
          'time': '3 hours ago',
          'icon': Icons.check_circle,
        },
      ];

      emit(
        state.copyWith(
          isLoading: false,
          totalUsers: totalUsers,
          totalTeachers: totalTeachers,
          totalStudents: totalStudents,
          totalMaterials: totalMaterials,
          recentActivities: recentActivities,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load admin data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefreshAdminData(
    RefreshAdminData event,
    Emitter<AdminState> emit,
  ) async {
    // Refresh data without showing loading state
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Update with new mock data
      emit(
        state.copyWith(
          totalUsers: state.totalUsers + 1,
          totalTeachers: state.totalTeachers,
          totalStudents: state.totalStudents + 1,
          totalMaterials: state.totalMaterials,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to refresh data: ${e.toString()}'));
    }
  }

  void _onUpdateUserStats(UpdateUserStats event, Emitter<AdminState> emit) {
    emit(
      state.copyWith(
        totalUsers: event.stats['totalUsers'],
        totalTeachers: event.stats['totalTeachers'],
        totalStudents: event.stats['totalStudents'],
        totalMaterials: event.stats['totalMaterials'],
      ),
    );
  }

  // Helper methods for admin operations
  Future<void> addUser(String email, String role) async {
    // TODO: Implement add user functionality
    print('Adding user: $email with role: $role');
  }

  Future<void> removeUser(String userId) async {
    // TODO: Implement remove user functionality
    print('Removing user: $userId');
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    // TODO: Implement update user role functionality
    print('Updating user $userId to role: $newRole');
  }

  Future<void> generateReport() async {
    // TODO: Implement report generation
    print('Generating admin report...');
  }

  Future<void> backupData() async {
    // TODO: Implement data backup
    print('Starting data backup...');
  }
}
