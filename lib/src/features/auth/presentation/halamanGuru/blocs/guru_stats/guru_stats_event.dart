import 'package:equatable/equatable.dart';

abstract class GuruStatsEvent extends Equatable {
  const GuruStatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGuruStats extends GuruStatsEvent {
  final String guruId;

  const LoadGuruStats(this.guruId);

  @override
  List<Object?> get props => [guruId];
}

class RefreshGuruStats extends GuruStatsEvent {
  final String guruId;

  const RefreshGuruStats(this.guruId);

  @override
  List<Object?> get props => [guruId];
}

class LoadGuruClasses extends GuruStatsEvent {
  final String guruId;

  const LoadGuruClasses(this.guruId);

  @override
  List<Object?> get props => [guruId];
}

class LoadTeachingSchedule extends GuruStatsEvent {
  final String guruId;

  const LoadTeachingSchedule(this.guruId);

  @override
  List<Object?> get props => [guruId];
}
