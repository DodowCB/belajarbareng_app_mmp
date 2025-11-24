import 'package:equatable/equatable.dart';

abstract class GuruProfileState extends Equatable {
  const GuruProfileState();

  @override
  List<Object?> get props => [];
}

class GuruProfileInitial extends GuruProfileState {
  const GuruProfileInitial();
}

class GuruProfileLoading extends GuruProfileState {
  const GuruProfileLoading();
}

class GuruProfileLoaded extends GuruProfileState {
  final Map<String, dynamic> guruData;
  final String guruId;

  const GuruProfileLoaded({required this.guruData, required this.guruId});

  @override
  List<Object?> get props => [guruData, guruId];
}

class GuruProfileError extends GuruProfileState {
  final String message;

  const GuruProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
