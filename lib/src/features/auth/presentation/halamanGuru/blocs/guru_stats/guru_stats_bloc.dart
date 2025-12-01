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

      // Get all kelas IDs for this wali kelas
      final kelasIds = <String>{};
      for (final doc in kelasWaliSnapshot.docs) {
        kelasIds.add(doc.id);
      }

      print('🏫 [GuruStatsBloc] Kelas IDs as wali kelas: $kelasIds');

      // Get all students from siswa_kelas for these classes
      final allSiswaIds = <String>{};
      for (final kelasId in kelasIds) {
        final siswaKelasSnapshot = await _firestore
            .collection('siswa_kelas')
            .where('kelas_id', isEqualTo: kelasId)
            .get();

        for (final doc in siswaKelasSnapshot.docs) {
          final siswaId = doc.data()['siswa_id'];
          if (siswaId != null) {
            allSiswaIds.add(siswaId.toString());
          }
        }
      }

      final totalStudents = allSiswaIds.length;
      print(
        '👥 [GuruStatsBloc] Total unique students from siswa_kelas: $totalStudents',
      );

      // Process each wali kelas to get student count per class for the badge
      final kelasWali = <Map<String, dynamic>>[];

      for (final kelasDoc in kelasWaliSnapshot.docs) {
        final kelasData = kelasDoc.data();
        final kelasId = kelasDoc.id;

        // Count students in siswa_kelas for this specific class
        final siswaKelasForThisClass = await _firestore
            .collection('siswa_kelas')
            .where('kelas_id', isEqualTo: kelasId)
            .get();

        final jumlahSiswaKelas = siswaKelasForThisClass.docs.length;

        kelasWali.add({
          'id': kelasId,
          'namaKelas':
              kelasData['namaKelas'] ??
              '${kelasData['jenjang_kelas']} ${kelasData['nomor_kelas']}',
          'jumlahSiswa': jumlahSiswaKelas,
          'jenjang_kelas': kelasData['jenjang_kelas'] ?? '',
          'nomor_kelas': kelasData['nomor_kelas'] ?? '',
          'tahun_ajaran': kelasData['tahun_ajaran'] ?? '2024/2025',
        });

        print('📚 Kelas ${kelasData['namaKelas']}: $jumlahSiswaKelas siswa');
      }

      // Get kelas_ngajar details for this guru
      final kelasNgajarSnapshot = await _firestore
          .collection('kelas_ngajar')
          .where('id_guru', isEqualTo: event.guruId)
          .get();

      final kelasNgajarDetail = <Map<String, dynamic>>[];
      final kelasNgajarIds = <String>{};

      for (final doc in kelasNgajarSnapshot.docs) {
        final data = doc.data();
        final kelasId = data['id_kelas']?.toString() ?? '';
        kelasNgajarIds.add(kelasId);

        // Get kelas info
        final kelasDoc = await _firestore
            .collection('kelas')
            .doc(kelasId)
            .get();
        final kelasData = kelasDoc.exists ? kelasDoc.data() : null;

        // Get mapel info
        final mapelId = data['id_mapel']?.toString() ?? '';
        final mapelDoc = await _firestore
            .collection('mapel')
            .doc(mapelId)
            .get();
        final mapelData = mapelDoc.exists ? mapelDoc.data() : null;

        kelasNgajarDetail.add({
          'id': doc.id,
          'kelasId': kelasId,
          'namaKelas': kelasData?['namaKelas'] ?? 'Kelas Tidak Ditemukan',
          'mapelId': mapelId,
          'namaMapel': mapelData?['namaMapel'] ?? 'Mapel Tidak Ditemukan',
          'hari': data['hari'] ?? '',
          'jam': data['jam'] ?? '',
        });
      }

      // Get siswa details per kelas
      final siswaPerKelas = <String, List<Map<String, dynamic>>>{};
      for (final kelasId in kelasIds) {
        final siswaKelasSnapshot = await _firestore
            .collection('siswa_kelas')
            .where('kelas_id', isEqualTo: kelasId)
            .get();

        final siswaList = <Map<String, dynamic>>[];
        for (final doc in siswaKelasSnapshot.docs) {
          final siswaId = doc.data()['siswa_id']?.toString() ?? '';
          final siswaDoc = await _firestore
              .collection('siswa')
              .doc(siswaId)
              .get();
          if (siswaDoc.exists) {
            final siswaData = siswaDoc.data()!;
            siswaList.add({
              'id': siswaId,
              'nama': siswaData['nama'] ?? 'Siswa',
              'nis': siswaData['nis'] ?? siswaData['nisn'] ?? '-',
            });
          }
        }
        siswaPerKelas[kelasId] = siswaList;
      }

      // Stats summary
      final teachingStats = {
        'kelasWali': kelasWali.length,
        'jadwalMengajar': kelasNgajarSnapshot.docs.length,
        'totalKelas': kelasNgajarIds.length,
        'materi': 8,
        'tugas': 5, // Default untuk performance
      };

      print(
        '✅ [GuruStatsBloc] Stats loaded - Total Students: $totalStudents, Total Classes: ${kelasNgajarIds.length}',
      );
      print('📦 [GuruStatsBloc] kelasWali data: $kelasWali');

      emit(
        GuruStatsLoaded(
          kelasWali: kelasWali,
          jadwalMengajar: [], // Empty untuk performance
          teachingStats: teachingStats,
          totalStudents: totalStudents,
          totalClasses: kelasNgajarIds.length,
          tugasPerluDinilai: teachingStats['tugas'] as int,
          kelasNgajarDetail: kelasNgajarDetail,
          siswaPerKelas: siswaPerKelas,
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
