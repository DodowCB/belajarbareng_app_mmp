import 'package:equatable/equatable.dart';

abstract class SiswaEvent extends Equatable {
  const SiswaEvent();

  @override
  List<Object?> get props => [];
}

class LoadSiswaData extends SiswaEvent {
  const LoadSiswaData();
}

class DeleteSiswa extends SiswaEvent {
  final String siswaId;

  const DeleteSiswa(this.siswaId);

  @override
  List<Object?> get props => [siswaId];
}

class DisableSiswa extends SiswaEvent {
  final String siswaId;
  final bool isDisabled;

  const DisableSiswa(this.siswaId, this.isDisabled);

  @override
  List<Object?> get props => [siswaId, isDisabled];
}

class ImportSiswaFromExcel extends SiswaEvent {
  const ImportSiswaFromExcel();
}

class AddSiswa extends SiswaEvent {
  final Map<String, dynamic> siswaData;

  const AddSiswa(this.siswaData);

  @override
  List<Object?> get props => [siswaData];
}

class UpdateSiswa extends SiswaEvent {
  final String siswaId;
  final Map<String, dynamic> siswaData;

  const UpdateSiswa(this.siswaId, this.siswaData);

  @override
  List<Object?> get props => [siswaId, siswaData];
}
