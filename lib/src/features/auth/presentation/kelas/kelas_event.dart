// Kelas Events
abstract class KelasEvent {}

class LoadKelas extends KelasEvent {}

class RefreshKelas extends KelasEvent {}

class AddKelas extends KelasEvent {
  final String namaKelas;
  final String jenjangKelas;
  final String nomorKelas;
  final String tahunAjaran;
  final String? guruId;
  final String? namaGuru;

  AddKelas({
    required this.namaKelas,
    required this.jenjangKelas,
    required this.nomorKelas,
    required this.tahunAjaran,
    this.guruId,
    this.namaGuru,
  });
}

class UpdateKelas extends KelasEvent {
  final String id;
  final String namaKelas;
  final String jenjangKelas;
  final String nomorKelas;
  final String tahunAjaran;
  final String? guruId;
  final String? namaGuru;

  UpdateKelas({
    required this.id,
    required this.namaKelas,
    required this.jenjangKelas,
    required this.nomorKelas,
    required this.tahunAjaran,
    this.guruId,
    this.namaGuru,
  });
}

class DeleteKelas extends KelasEvent {
  final String id;

  DeleteKelas({required this.id});
}

class LoadGuru extends KelasEvent {}

class LoadSiswaByKelas extends KelasEvent {
  final String kelasId;

  LoadSiswaByKelas({required this.kelasId});
}
