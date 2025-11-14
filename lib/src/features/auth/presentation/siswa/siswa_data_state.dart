import 'package:equatable/equatable.dart';

abstract class SiswaState extends Equatable {
  const SiswaState();

  @override
  List<Object?> get props => [];
}

class SiswaDataInitial extends SiswaState {}

class SiswaDataLoading extends SiswaState {}

class SiswaDataLoaded extends SiswaState {
  final List<Map<String, dynamic>> siswaList;

  const SiswaDataLoaded(this.siswaList);

  @override
  List<Object?> get props => [siswaList];
}

class SiswaDataError extends SiswaState {
  final String message;

  const SiswaDataError(this.message);

  @override
  List<Object?> get props => [message];
}

class SiswaDataActionSuccess extends SiswaState {
  final String message;

  const SiswaDataActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
