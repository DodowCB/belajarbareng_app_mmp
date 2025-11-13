import 'package:equatable/equatable.dart';
import '../../data/models/guru_model.dart';

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
  final List<GuruModel> guruList;

  const GuruDataLoaded({required this.guruList});

  @override
  List<Object?> get props => [guruList];
}

class GuruDataError extends GuruDataState {
  final String message;

  const GuruDataError({required this.message});

  @override
  List<Object?> get props => [message];
}
