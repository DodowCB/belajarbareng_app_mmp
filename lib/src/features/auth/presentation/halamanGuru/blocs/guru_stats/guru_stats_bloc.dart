import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'guru_stats_event.dart';
import 'guru_stats_state.dart';

class GuruStatsBloc extends Bloc<GuruStatsEvent, GuruStatsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache untuk menghindari repeated queries
  String? _cachedGuruId;
  DateTime? _lastLoadTime;
  static const Duration _cacheTimeout = Duration(minutes: 5);

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
      print('📊 [GuruStatsBloc] Loading stats for guru ID: ${event.guruId}');

      emit(const GuruStatsLoading());
      print('📊 [GuruStatsBloc] Emitted GuruStatsLoading state');

      // Load kelas where this guru is wali kelas (homeroom teacher)
      final kelasWaliSnapshot = await _firestore
          .collection('kelas')
          .where('guru_id', isEqualTo: event.guruId)
          .get();

      print(
        '🏫 [GuruStatsBloc] Found ${kelasWaliSnapshot.docs.length} classes as wali kelas',
      );

      // Process each class to get real student count
      final kelasWali = <Map<String, dynamic>>[];
      int totalStudents = 0;

      for (final kelasDoc in kelasWaliSnapshot.docs) {
        final kelasData = kelasDoc.data();
        final kelasId = kelasDoc.id;

        // Count students in kelas_ngajar for this class
        final kelasNgajarSnapshot = await _firestore
            .collection('kelas_ngajar')
            .where('id_kelas', isEqualTo: kelasId)
            .get();

        // Get unique siswa_id from kelas_ngajar
        final siswaIds = <String>{};
        for (final doc in kelasNgajarSnapshot.docs) {
          final siswaId = doc.data()['siswa_id'];
          if (siswaId != null) {
            siswaIds.add(siswaId.toString());
          }
        }

        final jumlahSiswa = siswaIds.length;
        totalStudents += jumlahSiswa;

        kelasWali.add({
          'id': kelasId,
          'namaKelas':
              kelasData['namaKelas'] ??
              '${kelasData['jenjang_kelas']} ${kelasData['nomor_kelas']}',
          'jumlahSiswa': jumlahSiswa,
          'jenjang_kelas': kelasData['jenjang_kelas'] ?? '',
          'nomor_kelas': kelasData['nomor_kelas'] ?? '',
          'tahun_ajaran': kelasData['tahun_ajaran'] ?? '2024/2025',
        });

        print('📚 Kelas ${kelasData['namaKelas']}: $jumlahSiswa siswa');
      }

      // Stats summary
      final teachingStats = {
        'kelasWali': kelasWali.length,
        'jadwalMengajar': kelasWali.length * 3, // Estimate
        'totalKelas': kelasWali.length,
        'materi': 8,
        'tugas': 5, // Default untuk performance
      };

      print(
        '✅ [GuruStatsBloc] Stats loaded - Total Students: $totalStudents, Total Classes: ${kelasWali.length}',
      );
      print('📦 [GuruStatsBloc] kelasWali data: $kelasWali');

      emit(
        GuruStatsLoaded(
          kelasWali: kelasWali,
          jadwalMengajar: [], // Empty untuk performance
          teachingStats: teachingStats,
          totalStudents: totalStudents,
          totalClasses: kelasWali.length,
          tugasPerluDinilai: teachingStats['tugas'] as int,
        ),
      );

      print('🎉 [GuruStatsBloc] GuruStatsLoaded state emitted successfully!');
      print('📊 [GuruStatsBloc] Current state type: ${state.runtimeType}');
    } catch (e) {
      print('❌ Error loading guru stats: $e');
      emit(GuruStatsError('Error loading stats: ${e.toString()}'));
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
    try {
      // Load classes where this guru is the homeroom teacher
      final kelasSnapshot = await _firestore
          .collection('kelas')
          .where('guru_id', isEqualTo: event.guruId)
          .get();

      final myClasses = <Map<String, dynamic>>[];

      for (final doc in kelasSnapshot.docs) {
        final kelasData = doc.data();

        // Get student count for this class
        final siswaKelasSnapshot = await _firestore
            .collection('siswa_kelas')
            .where('kelas_id', isEqualTo: doc.id)
            .get();

        myClasses.add({
          'id': doc.id,
          'nama_kelas': kelasData['nama_kelas'] ?? '',
          'tingkat': kelasData['tingkat'] ?? '',
          'jurusan': kelasData['jurusan'] ?? '',
          'tahun_ajaran': kelasData['tahun_ajaran'] ?? '',
          'student_count': siswaKelasSnapshot.docs.length,
        });
      }

      // This method doesn't emit state directly, it's used internally
    } catch (e) {
      emit(GuruStatsError('Error loading classes: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTeachingSchedule(
    LoadTeachingSchedule event,
    Emitter<GuruStatsState> emit,
  ) async {
    // Simplified - tidak perlu query Firebase untuk performance
    // Schedule data bisa di-cache atau di-hardcode untuk UI testing
  }
}
