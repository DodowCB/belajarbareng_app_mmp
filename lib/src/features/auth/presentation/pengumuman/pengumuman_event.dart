// Pengumuman Events
abstract class PengumumanEvent {}

class LoadPengumuman extends PengumumanEvent {}

class RefreshPengumuman extends PengumumanEvent {}

class AddPengumuman extends PengumumanEvent {
  final String judul;
  final String deskripsi;
  final String? guruId; // null jika admin yang buat
  final String? namaGuru; // null jika admin yang buat
  final String pembuat; // 'admin' atau 'guru'

  AddPengumuman({
    required this.judul,
    required this.deskripsi,
    this.guruId,
    this.namaGuru,
    required this.pembuat,
  });
}

class UpdatePengumuman extends PengumumanEvent {
  final String id;
  final String judul;
  final String deskripsi;

  UpdatePengumuman({
    required this.id,
    required this.judul,
    required this.deskripsi,
  });
}

class DeletePengumuman extends PengumumanEvent {
  final String id;

  DeletePengumuman({required this.id});
}
