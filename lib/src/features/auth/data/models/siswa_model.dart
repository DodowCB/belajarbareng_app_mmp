import 'package:cloud_firestore/cloud_firestore.dart';

class SiswaModel {
  final String id;
  final String nama;
  final String nis;
  final String? email;
  final String? telepon;
  final String? alamat;
  final DateTime? tanggalLahir;
  final String? jenisKelamin;
  final String? namaOrtu;
  final String? teleponOrtu;
  final bool status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SiswaModel({
    required this.id,
    required this.nama,
    required this.nis,
    this.email,
    this.telepon,
    this.alamat,
    this.tanggalLahir,
    this.jenisKelamin,
    this.namaOrtu,
    this.teleponOrtu,
    this.status = true,
    this.createdAt,
    this.updatedAt,
  });

  factory SiswaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SiswaModel(
      id: doc.id,
      nama: data['nama'] ?? '',
      nis: data['nis'] ?? '',
      email: data['email'],
      telepon: data['telepon'],
      alamat: data['alamat'],
      tanggalLahir: data['tanggal_lahir'] != null
          ? (data['tanggal_lahir'] as Timestamp).toDate()
          : null,
      jenisKelamin: data['jenis_kelamin'],
      namaOrtu: data['nama_ortu'],
      teleponOrtu: data['telepon_ortu'],
      status: data['status'] ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'nis': nis,
      'email': email,
      'telepon': telepon,
      'alamat': alamat,
      'tanggal_lahir': tanggalLahir != null
          ? Timestamp.fromDate(tanggalLahir!)
          : null,
      'jenis_kelamin': jenisKelamin,
      'nama_ortu': namaOrtu,
      'telepon_ortu': teleponOrtu,
      'status': status,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  SiswaModel copyWith({
    String? id,
    String? nama,
    String? nis,
    String? email,
    String? telepon,
    String? alamat,
    DateTime? tanggalLahir,
    String? jenisKelamin,
    String? namaOrtu,
    String? teleponOrtu,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SiswaModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      nis: nis ?? this.nis,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
      alamat: alamat ?? this.alamat,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      namaOrtu: namaOrtu ?? this.namaOrtu,
      teleponOrtu: teleponOrtu ?? this.teleponOrtu,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SiswaModel(id: $id, nama: $nama, nis: $nis, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SiswaModel &&
        other.id == id &&
        other.nama == nama &&
        other.nis == nis;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nama.hashCode ^ nis.hashCode;
  }
}
