import 'package:equatable/equatable.dart';

abstract class GuruDataEvent extends Equatable {
  const GuruDataEvent();

  @override
  List<Object?> get props => [];
}

class LoadGuruData extends GuruDataEvent {
  const LoadGuruData();
}

class DeleteGuru extends GuruDataEvent {
  final String guruId;

  const DeleteGuru(this.guruId);

  @override
  List<Object?> get props => [guruId];
}

class DisableGuru extends GuruDataEvent {
  final String guruId;
  final bool isDisabled;

  const DisableGuru(this.guruId, this.isDisabled);

  @override
  List<Object?> get props => [guruId, isDisabled];
}

class ImportGuruFromExcel extends GuruDataEvent {
  const ImportGuruFromExcel();
}

class AddGuru extends GuruDataEvent {
  final Map<String, dynamic> guruData;

  const AddGuru(this.guruData);

  @override
  List<Object?> get props => [guruData];
}

class UpdateGuru extends GuruDataEvent {
  final String guruId;
  final Map<String, dynamic> guruData;

  const UpdateGuru(this.guruId, this.guruData);

  @override
  List<Object?> get props => [guruId, guruData];
}
