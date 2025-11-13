import 'package:equatable/equatable.dart';

abstract class GuruDataEvent extends Equatable {
  const GuruDataEvent();

  @override
  List<Object?> get props => [];
}

class LoadGuruData extends GuruDataEvent {
  const LoadGuruData();
}
