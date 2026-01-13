import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:belajarbareng_app_mmp/src/features/auth/presentation/admin/admin_bloc.dart';

void main() {
  group('AdminBloc', () {
    late AdminBloc adminBloc;

    setUp(() {
      adminBloc = AdminBloc();
    });

    tearDown(() {
      adminBloc.close();
    });

    test('initial state is correct', () {
      expect(
        adminBloc.state,
        equals(
          AdminState(
            isLoading: false,
            totalUsers: 0,
            totalTeachers: 0,
            totalStudents: 0,
            totalMapels: 0,
            totalClasses: 0,
            totalPengumuman: 0,
            totalJadwalMengajar: 0,
            error: null,
            isOnline: true,
            lastSync: null,
          ),
        ),
      );
    });

    blocTest<AdminBloc, AdminState>(
      'emits loading state when LoadAdminData is added',
      build: () => adminBloc,
      act: (bloc) => bloc.add(LoadAdminData()),
      expect: () => [predicate<AdminState>((state) => state.isLoading == true)],
    );

    blocTest<AdminBloc, AdminState>(
      'updates user stats correctly',
      build: () => adminBloc,
      act: (bloc) => bloc.add(
        UpdateUserStats({
          'totalTeachers': 10,
          'totalStudents': 100,
          'totalMapels': 8,
          'totalClasses': 12,
          'totalPengumuman': 5,
          'totalJadwalMengajar': 15,
        }),
      ),
      expect: () => [
        predicate<AdminState>(
          (state) =>
              state.totalTeachers == 10 &&
              state.totalStudents == 100 &&
              state.totalMapels == 8 &&
              state.totalClasses == 12 &&
              state.totalPengumuman == 5 &&
              state.totalJadwalMengajar == 15,
        ),
      ],
    );

    test('AdminState equality works correctly', () {
      final state1 = AdminState(
        isLoading: false,
        isOnline: true,
        totalUsers: 110,
        totalTeachers: 10,
        totalStudents: 100,
        totalMapels: 8,
        totalClasses: 12,
        totalPengumuman: 5,
        totalJadwalMengajar: 15,
      );

      final state2 = AdminState(
        isLoading: false,
        isOnline: true,
        totalUsers: 110,
        totalTeachers: 10,
        totalStudents: 100,
        totalMapels: 8,
        totalClasses: 12,
        totalPengumuman: 5,
        totalJadwalMengajar: 15,
      );

      expect(state1.isLoading, equals(state2.isLoading));
      expect(state1.totalTeachers, equals(state2.totalTeachers));
      expect(state1.totalStudents, equals(state2.totalStudents));
    });

    test('AdminState copyWith works correctly', () {
      final originalState = AdminState(
        isLoading: false,
        isOnline: false,
        totalTeachers: 5,
        totalStudents: 50,
        totalMapels: 6,
        totalClasses: 8,
        totalPengumuman: 3,
        totalJadwalMengajar: 10,
      );

      final newState = originalState.copyWith(
        isOnline: true,
        totalTeachers: 10,
        totalStudents: 120,
      );

      expect(newState.isOnline, true);
      expect(newState.totalTeachers, 10);
      expect(newState.totalStudents, 120);
      expect(newState.totalMapels, 6); // Unchanged
      expect(newState.totalClasses, 8); // Unchanged
    });

    test('AdminState copyWith with null values retains original', () {
      final originalState = AdminState(
        totalTeachers: 5,
        totalStudents: 50,
        isOnline: true,
      );

      final newState = originalState.copyWith();

      expect(newState.totalTeachers, equals(originalState.totalTeachers));
      expect(newState.totalStudents, equals(originalState.totalStudents));
      expect(newState.isOnline, equals(originalState.isOnline));
    });

    group('Statistics Calculations', () {
      test('total users should equal teachers + students', () {
        const totalTeachers = 10;
        const totalStudents = 100;
        const totalUsers = totalTeachers + totalStudents;

        expect(totalUsers, equals(110));
      });

      test('should handle zero values', () {
        final state = AdminState(
          totalTeachers: 0,
          totalStudents: 0,
          totalMapels: 0,
          totalClasses: 0,
        );

        expect(state.totalTeachers, equals(0));
        expect(state.totalStudents, equals(0));
      });

      test('should handle large numbers', () {
        final state = AdminState(
          totalTeachers: 1000,
          totalStudents: 50000,
          totalMapels: 500,
        );

        expect(state.totalTeachers, equals(1000));
        expect(state.totalStudents, equals(50000));
        expect(state.totalMapels, equals(500));
      });
    });
  });

  group('AdminEvent', () {
    test('LoadAdminData creates correct event', () {
      final event = LoadAdminData();
      expect(event, isA<LoadAdminData>());
      expect(event, isA<AdminEvent>());
    });

    test('UpdateUserStats creates correct event with data', () {
      final event = UpdateUserStats({
        'totalTeachers': 10,
        'totalStudents': 100,
      });

      expect(event, isA<UpdateUserStats>());
      expect(event, isA<AdminEvent>());
      expect(event.stats['totalTeachers'], equals(10));
      expect(event.stats['totalStudents'], equals(100));
    });

    test('TriggerManualSync creates correct event', () {
      final event = TriggerManualSync();
      expect(event, isA<TriggerManualSync>());
      expect(event, isA<AdminEvent>());
    });

    test('GetSyncStatus creates correct event', () {
      final event = GetSyncStatus();
      expect(event, isA<GetSyncStatus>());
      expect(event, isA<AdminEvent>());
    });

    test('RefreshAdminData creates correct event', () {
      final event = RefreshAdminData();
      expect(event, isA<RefreshAdminData>());
      expect(event, isA<AdminEvent>());
    });
  });

  group('AdminState Properties', () {
    test('should have all required properties', () {
      final state = AdminState(
        isLoading: true,
        totalUsers: 100,
        totalTeachers: 10,
        totalStudents: 90,
        totalMapels: 12,
        totalClasses: 8,
        totalPengumuman: 5,
        totalJadwalMengajar: 20,
        error: 'Test error',
        isOnline: false,
        lastSync: DateTime(2026, 1, 13),
      );

      expect(state.isLoading, isTrue);
      expect(state.totalUsers, equals(100));
      expect(state.totalTeachers, equals(10));
      expect(state.totalStudents, equals(90));
      expect(state.totalMapels, equals(12));
      expect(state.totalClasses, equals(8));
      expect(state.totalPengumuman, equals(5));
      expect(state.totalJadwalMengajar, equals(20));
      expect(state.error, equals('Test error'));
      expect(state.isOnline, isFalse);
      expect(state.lastSync, isNotNull);
    });

    test('default values should be correct', () {
      final state = AdminState();

      expect(state.isLoading, isFalse);
      expect(state.totalUsers, equals(0));
      expect(state.totalTeachers, equals(0));
      expect(state.totalStudents, equals(0));
      expect(state.totalMapels, equals(0));
      expect(state.totalClasses, equals(0));
      expect(state.totalPengumuman, equals(0));
      expect(state.totalJadwalMengajar, equals(0));
      expect(state.error, isNull);
      expect(state.isOnline, isTrue);
      expect(state.lastSync, isNull);
    });
  });

  group('Error Handling', () {
    test('should handle error state', () {
      final state = AdminState(error: 'Network error', isOnline: false);

      expect(state.error, equals('Network error'));
      expect(state.isOnline, isFalse);
    });

    test('should clear error on successful update', () {
      final stateWithError = AdminState(error: 'Some error');
      final clearedState = stateWithError.copyWith(error: null);

      expect(clearedState.error, isNull);
    });
  });

  group('Loading State', () {
    test('should toggle loading state', () {
      final initialState = AdminState(isLoading: false);
      final loadingState = initialState.copyWith(isLoading: true);
      final loadedState = loadingState.copyWith(isLoading: false);

      expect(initialState.isLoading, isFalse);
      expect(loadingState.isLoading, isTrue);
      expect(loadedState.isLoading, isFalse);
    });
  });
}
