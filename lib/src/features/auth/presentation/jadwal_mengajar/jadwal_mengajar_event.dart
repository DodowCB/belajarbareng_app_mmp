abstract class JadwalMengajarEvent {}

class LoadJadwalMengajar extends JadwalMengajarEvent {}

class RefreshJadwalMengajar extends JadwalMengajarEvent {}

class AddJadwalMengajar extends JadwalMengajarEvent {
  final String idGuru;
  final String idKelas;
  final String idMapel;
  final String jam;
  final String hari;
  final DateTime tanggal;

  AddJadwalMengajar({
    required this.idGuru,
    required this.idKelas,
    required this.idMapel,
    required this.jam,
    required this.hari,
    required this.tanggal,
  });
}

class UpdateJadwalMengajar extends JadwalMengajarEvent {
  final String jadwalId;
  final String idGuru;
  final String idKelas;
  final String idMapel;
  final String jam;
  final String hari;
  final DateTime tanggal;

  UpdateJadwalMengajar({
    required this.jadwalId,
    required this.idGuru,
    required this.idKelas,
    required this.idMapel,
    required this.jam,
    required this.hari,
    required this.tanggal,
  });
}

class DeleteJadwalMengajar extends JadwalMengajarEvent {
  final String jadwalId;

  DeleteJadwalMengajar(this.jadwalId);
}

class LoadGuruList extends JadwalMengajarEvent {}

class LoadKelasList extends JadwalMengajarEvent {}

class LoadMapelList extends JadwalMengajarEvent {}

class ImportJadwalFromExcel extends JadwalMengajarEvent {
  final String filePath;

  ImportJadwalFromExcel(this.filePath);
}

class SearchJadwal extends JadwalMengajarEvent {
  final String query;

  SearchJadwal(this.query);
}

class FilterJadwalByGuru extends JadwalMengajarEvent {
  final String? guruId;

  FilterJadwalByGuru(this.guruId);
}

class FilterJadwalByKelas extends JadwalMengajarEvent {
  final String? kelasId;

  FilterJadwalByKelas(this.kelasId);
}
