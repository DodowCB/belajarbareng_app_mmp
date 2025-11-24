import 'package:flutter_bloc/flutter_bloc.dart';
import 'guru_stats_event.dart';
import 'guru_stats_state.dart';

class GuruStatsBloc extends Bloc<GuruStatsEvent, GuruStatsState> {
  GuruStatsBloc() : super(const GuruStatsInitial()) {
    on<LoadGuruStats>(_onLoadGuruStats);
    on<RefreshGuruStats>(_onRefreshGuruStats);
    on<LoadGuruClasses>(_onLoadGuruClasses);
    on<LoadTeachingSchedule>(_onLoadTeachingSchedule);
  }

  Future<void> _onLoadGuruStats(
    LoadGuruStats event,
    Emitter<GuruStatsState> emit,
  ) async {
    try {
      emit(const GuruStatsLoading());
      
      // Dummy data untuk testing performance
      await Future.delayed(const Duration(milliseconds: 500));
      
      final kelasWali = [
        {
          'id': '1',
          'namaKelas': 'XII IPA 1',
          'jumlahSiswa': 32,
          'tingkat': 'XII',
          'jurusan': 'IPA',
          'tahun_ajaran': '2024/2025',
        },
        {
          'id': '2', 
          'namaKelas': 'XI IPA 2',
          'jumlahSiswa': 30,
          'tingkat': 'XI',
          'jurusan': 'IPA',
          'tahun_ajaran': '2024/2025',
        }
      ];

      final teachingStats = {
        'kelasWali': 2,
        'jadwalMengajar': 8,
        'totalKelas': 4,
        'materi': 12,
        'tugas': 3,
      };

      emit(GuruStatsLoaded(
        kelasWali: kelasWali,
        jadwalMengajar: [],
        teachingStats: teachingStats,
        totalStudents: 62,
        totalClasses: 2,
        tugasPerluDinilai: 3,
      ));
    } catch (e) {
      emit(GuruStatsError('Error: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshGuruStats(
    RefreshGuruStats event,
    Emitter<GuruStatsState> emit,
  ) async {
    add(LoadGuruStats(event.guruId));
  }

  Future<void> _onLoadGuruClasses(
    LoadGuruClasses event,
    Emitter<GuruStatsState> emit,
  ) async {
    // Dummy implementation
  }

  Future<void> _onLoadTeachingSchedule(
    LoadTeachingSchedule event,
    Emitter<GuruStatsState> emit,
  ) async {
    // Dummy implementation
  }
}