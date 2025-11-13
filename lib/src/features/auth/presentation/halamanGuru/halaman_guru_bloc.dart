import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// HalamanGuru Events
abstract class HalamanGuruEvent {}

class LoadGuruData extends HalamanGuruEvent {}

class RefreshGuruData extends HalamanGuruEvent {}

class UpdateClassStats extends HalamanGuruEvent {
  final Map<String, int> stats;
  UpdateClassStats(this.stats);
}

class CreateNewMaterial extends HalamanGuruEvent {
  final String title;
  final String subject;
  CreateNewMaterial(this.title, this.subject);
}

// HalamanGuru State
class HalamanGuruState {
  final bool isLoading;
  final int totalClasses;
  final int totalStudents;
  final int totalMaterials;
  final int pendingAssignments;
  final List<Map<String, dynamic>> myClasses;
  final List<Map<String, dynamic>> recentMaterials;
  final String? error;

  HalamanGuruState({
    this.isLoading = false,
    this.totalClasses = 0,
    this.totalStudents = 0,
    this.totalMaterials = 0,
    this.pendingAssignments = 0,
    this.myClasses = const [],
    this.recentMaterials = const [],
    this.error,
  });

  HalamanGuruState copyWith({
    bool? isLoading,
    int? totalClasses,
    int? totalStudents,
    int? totalMaterials,
    int? pendingAssignments,
    List<Map<String, dynamic>>? myClasses,
    List<Map<String, dynamic>>? recentMaterials,
    String? error,
  }) {
    return HalamanGuruState(
      isLoading: isLoading ?? this.isLoading,
      totalClasses: totalClasses ?? this.totalClasses,
      totalStudents: totalStudents ?? this.totalStudents,
      totalMaterials: totalMaterials ?? this.totalMaterials,
      pendingAssignments: pendingAssignments ?? this.pendingAssignments,
      myClasses: myClasses ?? this.myClasses,
      recentMaterials: recentMaterials ?? this.recentMaterials,
      error: error,
    );
  }
}

// HalamanGuru Bloc
class HalamanGuruBloc extends Bloc<HalamanGuruEvent, HalamanGuruState> {
  HalamanGuruBloc() : super(HalamanGuruState()) {
    on<LoadGuruData>(_onLoadGuruData);
    on<RefreshGuruData>(_onRefreshGuruData);
    on<UpdateClassStats>(_onUpdateClassStats);
    on<CreateNewMaterial>(_onCreateNewMaterial);
  }

  Future<void> _onLoadGuruData(
    LoadGuruData event,
    Emitter<HalamanGuruState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));

      // Mock data for teacher
      const totalClasses = 3;
      const totalStudents = 85;
      const totalMaterials = 12;
      const pendingAssignments = 7;

      final myClasses = [
        {
          'name': 'Mathematics 10A',
          'subject': 'Advanced Mathematics',
          'students': 28,
          'id': 'math_10a',
        },
        {
          'name': 'Physics 11B',
          'subject': 'Modern Physics',
          'students': 32,
          'id': 'physics_11b',
        },
        {
          'name': 'Chemistry 12C',
          'subject': 'Organic Chemistry',
          'students': 25,
          'id': 'chemistry_12c',
        },
      ];

      final recentMaterials = [
        {
          'title': 'Quadratic Equations Guide',
          'subject': 'Mathematics',
          'date': 'Nov 10, 2025',
          'status': 'Published',
          'icon': Icons.calculate,
        },
        {
          'title': 'Newton\'s Laws Presentation',
          'subject': 'Physics',
          'date': 'Nov 8, 2025',
          'status': 'Draft',
          'icon': Icons.science,
        },
        {
          'title': 'Organic Compounds Lab',
          'subject': 'Chemistry',
          'date': 'Nov 5, 2025',
          'status': 'Published',
          'icon': Icons.biotech,
        },
        {
          'title': 'Trigonometry Exercises',
          'subject': 'Mathematics',
          'date': 'Nov 3, 2025',
          'status': 'Published',
          'icon': Icons.functions,
        },
        {
          'title': 'Wave Properties Video',
          'subject': 'Physics',
          'date': 'Nov 1, 2025',
          'status': 'Published',
          'icon': Icons.waves,
        },
      ];

      emit(
        state.copyWith(
          isLoading: false,
          totalClasses: totalClasses,
          totalStudents: totalStudents,
          totalMaterials: totalMaterials,
          pendingAssignments: pendingAssignments,
          myClasses: myClasses,
          recentMaterials: recentMaterials,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load teacher data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefreshGuruData(
    RefreshGuruData event,
    Emitter<HalamanGuruState> emit,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate some updates
      emit(
        state.copyWith(
          pendingAssignments: state.pendingAssignments + 1,
          totalStudents: state.totalStudents,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to refresh data: ${e.toString()}'));
    }
  }

  void _onUpdateClassStats(
    UpdateClassStats event,
    Emitter<HalamanGuruState> emit,
  ) {
    emit(
      state.copyWith(
        totalClasses: event.stats['totalClasses'],
        totalStudents: event.stats['totalStudents'],
        totalMaterials: event.stats['totalMaterials'],
        pendingAssignments: event.stats['pendingAssignments'],
      ),
    );
  }

  Future<void> _onCreateNewMaterial(
    CreateNewMaterial event,
    Emitter<HalamanGuruState> emit,
  ) async {
    try {
      // Simulate creating material
      await Future.delayed(const Duration(milliseconds: 500));

      final newMaterial = {
        'title': event.title,
        'subject': event.subject,
        'date': 'Today',
        'status': 'Draft',
        'icon': Icons.article,
      };

      final updatedMaterials = [newMaterial, ...state.recentMaterials];

      emit(
        state.copyWith(
          recentMaterials: updatedMaterials,
          totalMaterials: state.totalMaterials + 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to create material: ${e.toString()}'));
    }
  }

  // Helper methods for teacher operations
  Future<void> gradeAssignment(String assignmentId, double grade) async {
    // TODO: Implement assignment grading
    print('Grading assignment $assignmentId with grade: $grade');
  }

  Future<void> createAssignment(
    String classId,
    String title,
    String description,
  ) async {
    // TODO: Implement assignment creation
    print('Creating assignment for class $classId: $title');
  }

  Future<void> viewStudentProgress(String studentId) async {
    // TODO: Implement student progress viewing
    print('Viewing progress for student: $studentId');
  }

  Future<void> sendMessageToClass(String classId, String message) async {
    // TODO: Implement class messaging
    print('Sending message to class $classId: $message');
  }

  Future<void> scheduleClass(String classId, DateTime dateTime) async {
    // TODO: Implement class scheduling
    print('Scheduling class $classId for: $dateTime');
  }

  Future<List<Map<String, dynamic>>> getClassStudents(String classId) async {
    // TODO: Implement get class students
    print('Getting students for class: $classId');
    return [];
  }

  Future<void> exportGrades(String classId) async {
    // TODO: Implement grade export
    print('Exporting grades for class: $classId');
  }
}
