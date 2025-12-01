import 'package:equatable/equatable.dart';

abstract class GuruStatsState extends Equatable {
  const GuruStatsState();

  @override
  List<Object?> get props => [];
}

class GuruStatsInitial extends GuruStatsState {
  const GuruStatsInitial();
}

class GuruStatsLoading extends GuruStatsState {
  const GuruStatsLoading();
}

class GuruStatsLoaded extends GuruStatsState {
  final List<Map<String, dynamic>> kelasWali;
  final List<Map<String, dynamic>> jadwalMengajar;
  final Map<String, int> teachingStats;
  final int totalStudents;
  final int totalClasses;
  final int tugasPerluDinilai;
  final List<Map<String, dynamic>> kelasNgajarDetail;
  final Map<String, List<Map<String, dynamic>>> siswaPerKelas;

  const GuruStatsLoaded({
    required this.kelasWali,
    required this.jadwalMengajar,
    required this.teachingStats,
    required this.totalStudents,
    required this.totalClasses,
    required this.tugasPerluDinilai,
    this.kelasNgajarDetail = const [],
    this.siswaPerKelas = const {},
  });

  @override
  List<Object?> get props => [
    kelasWali,
    jadwalMengajar,
    teachingStats,
    totalStudents,
    totalClasses,
    tugasPerluDinilai,
    kelasNgajarDetail,
    siswaPerKelas,
  ];
}

class GuruStatsError extends GuruStatsState {
  final String message;

  const GuruStatsError(this.message);

  @override
  List<Object?> get props => [message];
}
