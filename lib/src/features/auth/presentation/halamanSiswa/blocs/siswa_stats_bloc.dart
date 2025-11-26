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
      // Dummy data for demo - replace with actual Firestore queries
      // In production, you would query tugas, quiz, and kelas collections
      // filtered by siswaId
      
      await Future.delayed(const Duration(milliseconds: 500));

      emit(const SiswaStatsLoaded(
        totalTugas: 12,
        tugasSelesai: 8,
        totalQuiz: 6,
        quizSelesai: 4,
        totalKelas: 5,
        rataRataNilai: 85.5,
      ));
    } catch (e) {
      emit(SiswaStatsError('Gagal memuat statistik: ${e.toString()}'));
    }
  }
}
