import 'package:cloud_firestore/cloud_firestore.dart';

class SiswaKelasModel {
  final String id;
  final String siswaId; // Foreign key ke collection siswa
  final String kelasId; // Foreign key ke collection kelas
  final String namaSiswa; // Untuk ditampilkan di UI
  final String namaKelas; // Untuk ditampilkan di UI
  final String tahunAjaran;
  final bool status; // aktif/tidak aktif
  final DateTime? tanggalMasuk;
  final DateTime? tanggalKeluar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SiswaKelasModel({
    required this.id,
    required this.siswaId,
    required this.kelasId,
    required this.namaSiswa,
    required this.namaKelas,
    required this.tahunAjaran,
    this.status = true,
    this.tanggalMasuk,
    this.tanggalKeluar,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor untuk membuat objek dari Firestore DocumentSnapshot
  factory SiswaKelasModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SiswaKelasModel(
      id: doc.id,
      siswaId: data['siswa_id'] ?? '',
      kelasId: data['kelas_id'] ?? '',
      namaSiswa: data['nama_siswa'] ?? '',
      namaKelas: data['nama_kelas'] ?? '',
      tahunAjaran: data['tahun_ajaran'] ?? '',
      status: data['status'] ?? true,
      tanggalMasuk: data['tanggal_masuk'] != null
          ? (data['tanggal_masuk'] as Timestamp).toDate()
          : null,
      tanggalKeluar: data['tanggal_keluar'] != null
          ? (data['tanggal_keluar'] as Timestamp).toDate()
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Factory constructor untuk membuat objek dari Map
  factory SiswaKelasModel.fromMap(Map<String, dynamic> map, String id) {
    return SiswaKelasModel(
      id: id,
      siswaId: map['siswa_id'] ?? '',
      kelasId: map['kelas_id'] ?? '',
      namaSiswa: map['nama_siswa'] ?? '',
      namaKelas: map['nama_kelas'] ?? '',
      tahunAjaran: map['tahun_ajaran'] ?? '',
      status: map['status'] ?? true,
      tanggalMasuk: map['tanggal_masuk'] != null
          ? (map['tanggal_masuk'] as Timestamp).toDate()
          : null,
      tanggalKeluar: map['tanggal_keluar'] != null
          ? (map['tanggal_keluar'] as Timestamp).toDate()
          : null,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Method untuk mengkonversi objek ke Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'siswa_id': siswaId,
      'kelas_id': kelasId,
      'nama_siswa': namaSiswa,
      'nama_kelas': namaKelas,
      'tahun_ajaran': tahunAjaran,
      'status': status,
      'tanggal_masuk': tanggalMasuk != null
          ? Timestamp.fromDate(tanggalMasuk!)
          : null,
      'tanggal_keluar': tanggalKeluar != null
          ? Timestamp.fromDate(tanggalKeluar!)
          : null,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Method untuk membuat copy dengan perubahan
  SiswaKelasModel copyWith({
    String? id,
    String? siswaId,
    String? kelasId,
    String? namaSiswa,
    String? namaKelas,
    String? tahunAjaran,
    bool? status,
    DateTime? tanggalMasuk,
    DateTime? tanggalKeluar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SiswaKelasModel(
      id: id ?? this.id,
      siswaId: siswaId ?? this.siswaId,
      kelasId: kelasId ?? this.kelasId,
      namaSiswa: namaSiswa ?? this.namaSiswa,
      namaKelas: namaKelas ?? this.namaKelas,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      status: status ?? this.status,
      tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
      tanggalKeluar: tanggalKeluar ?? this.tanggalKeluar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SiswaKelasModel(id: $id, siswaId: $siswaId, kelasId: $kelasId, namaSiswa: $namaSiswa, namaKelas: $namaKelas, tahunAjaran: $tahunAjaran, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SiswaKelasModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
