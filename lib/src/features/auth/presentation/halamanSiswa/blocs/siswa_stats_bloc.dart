import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class SiswaStatsEvent extends Equatable {
  const SiswaStatsEvent();

  @override
  List<Object> get props => [];
}

class LoadSiswaStats extends SiswaStatsEvent {
  final String siswaId;

  const LoadSiswaStats(this.siswaId);

  @override
  List<Object> get props => [siswaId];
}

// States
abstract class SiswaStatsState extends Equatable {
  const SiswaStatsState();

  @override
  List<Object> get props => [];
}

class SiswaStatsInitial extends SiswaStatsState {}

class SiswaStatsLoading extends SiswaStatsState {}

class SiswaStatsLoaded extends SiswaStatsState {
  final int totalTugas;
  final int tugasSelesai;
  final int totalQuiz;
  final int quizSelesai;
  final int totalKelas;
  final double rataRataNilai;

  const SiswaStatsLoaded({
    required this.totalTugas,
    required this.tugasSelesai,
    required this.totalQuiz,
    required this.quizSelesai,
    required this.totalKelas,
    required this.rataRataNilai,
  });

  @override
  List<Object> get props => [
    totalTugas,
    tugasSelesai,
    totalQuiz,
    quizSelesai,
    totalKelas,
    rataRataNilai,
  ];
}

class SiswaStatsError extends SiswaStatsState {
  final String message;

  const SiswaStatsError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class SiswaStatsBloc extends Bloc<SiswaStatsEvent, SiswaStatsState> {
  SiswaStatsBloc() : super(SiswaStatsInitial()) {
    on<LoadSiswaStats>(_onLoadSiswaStats);
  }

  Future<void> _onLoadSiswaStats(
    LoadSiswaStats event,
    Emitter<SiswaStatsState> emit,
  ) async {
    emit(SiswaStatsLoading());

    try {
      final firestore = FirebaseFirestore.instance;

      // Get kelas yang diikuti siswa
      final siswaKelasSnapshot = await firestore
          .collection('siswa_kelas')
          .where('siswa_id', isEqualTo: event.siswaId)
          .get();

      final kelasIds = siswaKelasSnapshot.docs
          .map((doc) => doc.data()['kelas_id'] as String)
          .toList();

      final totalKelas = kelasIds.length;

      // Get total tugas from all kelas
      int totalTugas = 0;
      if (kelasIds.isNotEmpty) {
        final tugasSnapshot = await firestore
            .collection('tugas')
            .where('id_kelas', whereIn: kelasIds)
            .get();
        totalTugas = tugasSnapshot.docs.length;
      }

      // Get tugas yang sudah dikumpulkan (count pengumpulan by siswa_id)
      print('DEBUG: Querying pengumpulan with siswa_id: ${event.siswaId}');

      final pengumpulanSnapshot = await firestore
          .collection('pengumpulan')
          .where('siswa_id', isEqualTo: event.siswaId)
          .get();

      final tugasSelesai = pengumpulanSnapshot.docs.length;

      print('DEBUG TUGAS SELESAI:');
      print('- siswa_id: ${event.siswaId}');
      print('- pengumpulan docs: ${pengumpulanSnapshot.docs.length}');
      print('- tugasSelesai: $tugasSelesai');
      if (pengumpulanSnapshot.docs.isNotEmpty) {
        print('- Sample data: ${pengumpulanSnapshot.docs.first.data()}');
      } else {
        print('- No documents found in pengumpulan collection');
        print(
          '- Query: collection(pengumpulan).where(siswa_id == ${event.siswaId})',
        );

        // Get total quiz from all kelas
        int totalQuiz = 0;
        if (kelasIds.isNotEmpty) {
          final quizSnapshot = await firestore
              .collection('quiz')
              .where('id_kelas', whereIn: kelasIds)
              .get();
          totalQuiz = quizSnapshot.docs.length;
        }

        // Get quiz selesai (dummy for now - needs quiz_answers collection)
        final quizSelesai = 0; // TODO: implement when quiz feature is ready

        // Calculate rata-rata nilai (dummy for now)
        final rataRataNilai =
            0.0; // TODO: implement when grading system is ready

        emit(
          SiswaStatsLoaded(
            totalTugas: totalTugas,
            tugasSelesai: tugasSelesai,
            totalQuiz: totalQuiz,
            quizSelesai: quizSelesai,
            totalKelas: totalKelas,
            rataRataNilai: rataRataNilai,
          ),
        );
      }
    } catch (e) {
      emit(SiswaStatsError('Gagal memuat statistik: ${e.toString()}'));
    }
  }
}
