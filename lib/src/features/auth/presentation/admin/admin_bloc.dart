import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final int totalMapels;
  final int totalClasses;
  final int totalPengumuman;
  final List<Map<String, dynamic>> recentActivities;
  final String? error;

  AdminState({
    this.isLoading = false,
    this.totalUsers = 0,
    this.totalTeachers = 0,
    this.totalStudents = 0,
    this.totalMapels = 0,
    this.totalClasses = 0,
    this.totalPengumuman = 0,
    this.recentActivities = const [],
    this.error,
  });

  AdminState copyWith({
    bool? isLoading,
    int? totalUsers,
    int? totalTeachers,
    int? totalStudents,
    int? totalMapels,
    int? totalClasses,
    int? totalPengumuman,
    List<Map<String, dynamic>>? recentActivities,
    String? error,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      totalUsers: totalUsers ?? this.totalUsers,
      totalTeachers: totalTeachers ?? this.totalTeachers,
      totalStudents: totalStudents ?? this.totalStudents,
      totalMapels: totalMapels ?? this.totalMapels,
      totalClasses: totalClasses ?? this.totalClasses,
      totalPengumuman: totalPengumuman ?? this.totalPengumuman,
      recentActivities: recentActivities ?? this.recentActivities,
      error: error,
    );
  }
}

// Admin Bloc
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminBloc() : super(AdminState()) {
    on<LoadAdminData>(_onLoadAdminData);
    on<RefreshAdminData>(_onRefreshAdminData);
    on<UpdateUserStats>(_onUpdateUserStats);
  }

  // Stream untuk real-time admin data
  Stream<AdminState> getAdminDataStream() async* {
    yield state.copyWith(isLoading: true);

    await for (final _ in Stream.periodic(const Duration(seconds: 1))) {
      try {
        final futures = await Future.wait([
          _firestore.collection('guru').get(),
          _firestore.collection('siswa').get(),
          _firestore.collection('mapel').get(),
          _firestore.collection('kelas').get(),
          _firestore.collection('pengumuman').get(),
        ]);

        final guruSnapshot = futures[0];
        final siswaSnapshot = futures[1];
        final mapelSnapshot = futures[2];
        final classesSnapshot = futures[3];
        final pengumumanSnapshot = futures[4];

        final totalTeachers = guruSnapshot.docs.length;
        final totalStudents = siswaSnapshot.docs.length;
        final totalUsers = totalTeachers + totalStudents;
        final totalMapels = mapelSnapshot.docs.length;
        final totalClasses = classesSnapshot.docs.length;
        final totalPengumuman = pengumumanSnapshot.docs.length;

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
            'title': 'Database optimized',
            'time': '3 hours ago',
            'icon': Icons.tune,
          },
          {
            'title': 'Security scan completed',
            'time': '6 hours ago',
            'icon': Icons.security,
          },
        ];

        yield AdminState(
          isLoading: false,
          totalUsers: totalUsers,
          totalTeachers: totalTeachers,
          totalStudents: totalStudents,
          totalMapels: totalMapels,
          totalClasses: totalClasses,
          totalPengumuman: totalPengumuman,
          recentActivities: recentActivities,
        );
      } catch (e) {
        yield AdminState(
          isLoading: false,
          error: 'Failed to load data: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _onLoadAdminData(
    LoadAdminData event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Get counts from Firebase collections
      final guruSnapshot = await _firestore.collection('guru').get();
      final siswaSnapshot = await _firestore.collection('siswa').get();
      final mapelSnapshot = await _firestore.collection('mapel').get();

      final totalTeachers = guruSnapshot.docs.length;
      final totalStudents = siswaSnapshot.docs.length;
      final totalUsers = totalTeachers + totalStudents;
      final totalMapels = mapelSnapshot.docs.length;

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
          totalMapels: totalMapels,
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
          totalMapels: state.totalMapels,
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
        totalMapels: event.stats['totalMapels'],
      ),
    );
  }

  // Helper methods for admin operations
  Future<void> addUser(String email, String role) async {
    // TODO: Implement add user functionality
    debugPrint('Adding user: $email with role: $role');
  }

  Future<void> removeUser(String userId) async {
    // TODO: Implement remove user functionality
    debugPrint('Removing user: $userId');
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    // TODO: Implement update user role functionality
    debugPrint('Updating user $userId to role: $newRole');
  }

  Future<void> generateReport() async {
    // TODO: Implement report generation
    debugPrint('Generating admin report...');
  }

  Future<void> backupData() async {
    // TODO: Implement data backup
    debugPrint('Starting data backup...');
  }
}
