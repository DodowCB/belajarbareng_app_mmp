import 'package:cloud_firestore/cloud_firestore.dart';

class KelasModel {
  final String id;
  final String namaKelas;
  final String jenjangKelas;
  final String nomorKelas;
  final String tahunAjaran;
  final String? guruId; // Foreign key ke collection guru
  final String? namaGuru; // Untuk ditampilkan di UI
  final bool status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KelasModel({
    required this.id,
    required this.namaKelas,
    required this.jenjangKelas,
    required this.nomorKelas,
    required this.tahunAjaran,
    this.guruId,
    this.namaGuru,
    this.status = true,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor untuk membuat objek dari Firestore DocumentSnapshot
  factory KelasModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Buat nama kelas dari jenjang_kelas + nomor_kelas jika tidak ada namaKelas
    String namaKelas = data['nama_kelas'] ?? '';
    if (namaKelas.isEmpty) {
      final jenjang = data['jenjang_kelas'] ?? '';
      final nomor = data['nomor_kelas'] ?? '';
      namaKelas = jenjang.isNotEmpty && nomor.isNotEmpty
          ? '$jenjang $nomor'
          : 'Kelas Tidak Diketahui';
    }

    return KelasModel(
      id: doc.id,
      namaKelas: namaKelas,
      jenjangKelas: data['jenjang_kelas'] ?? '',
      nomorKelas: data['nomor_kelas'] ?? '',
      tahunAjaran: data['tahun_ajaran'] ?? '',
      guruId: data['guru_id']?.toString(),
      namaGuru: data['nama_guru'],
      status: data['status'] ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Factory constructor untuk membuat objek dari Map
  factory KelasModel.fromMap(Map<String, dynamic> map, String id) {
    return KelasModel(
      id: id,
      namaKelas: map['nama_kelas'] ?? '',
      jenjangKelas: map['jenjang_kelas'] ?? '',
      nomorKelas: map['nomor_kelas'] ?? '',
      tahunAjaran: map['tahun_ajaran'] ?? '',
      guruId: map['guru_id']?.toString(),
      namaGuru: map['nama_guru'],
      status: map['status'] ?? true,
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
      'nama_kelas': namaKelas,
      'jenjang_kelas': jenjangKelas,
      'nomor_kelas': nomorKelas,
      'tahun_ajaran': tahunAjaran,
      'guru_id': guruId,
      'nama_guru': namaGuru,
      'status': status,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Method untuk membuat copy dengan perubahan
  KelasModel copyWith({
    String? id,
    String? namaKelas,
    String? jenjangKelas,
    String? nomorKelas,
    String? tahunAjaran,
    String? guruId,
    String? namaGuru,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KelasModel(
      id: id ?? this.id,
      namaKelas: namaKelas ?? this.namaKelas,
      jenjangKelas: jenjangKelas ?? this.jenjangKelas,
      nomorKelas: nomorKelas ?? this.nomorKelas,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      guruId: guruId ?? this.guruId,
      namaGuru: namaGuru ?? this.namaGuru,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'KelasModel(id: $id, namaKelas: $namaKelas, jenjangKelas: $jenjangKelas, nomorKelas: $nomorKelas, tahunAjaran: $tahunAjaran, guruId: $guruId, namaGuru: $namaGuru, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KelasModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
