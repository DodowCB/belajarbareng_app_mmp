import 'package:equatable/equatable.dart';

abstract class GuruDataState extends Equatable {
  const GuruDataState();

  @override
  List<Object?> get props => [];
}

class GuruDataInitial extends GuruDataState {
  const GuruDataInitial();
}

class GuruDataLoading extends GuruDataState {
  const GuruDataLoading();
}

class GuruDataLoaded extends GuruDataState {
  final List<Map<String, dynamic>> guruList;

  const GuruDataLoaded(this.guruList);

  @override
  List<Object?> get props => [guruList];
}

class GuruDataError extends GuruDataState {
  final String message;

  const GuruDataError(this.message);

  @override
  List<Object?> get props => [message];
}

class GuruDataActionSuccess extends GuruDataState {
  final String message;

  const GuruDataActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
