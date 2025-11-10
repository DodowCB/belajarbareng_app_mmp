import 'package:cloud_firestore/cloud_firestore.dart';

class GuruModel {
  final String id;
  final String namaLengkap;
  final String email;
  final int nig;
  final String mataPelajaran;
  final String sekolah;
  final String jenisKelamin;
  final String status;
  final String? photoUrl;
  final DateTime tanggalLahir;

  GuruModel({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.nig,
    required this.mataPelajaran,
    required this.sekolah,
    required this.jenisKelamin,
    required this.status,
    this.photoUrl,
    required this.tanggalLahir,
  });

  factory GuruModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GuruModel(
      id: doc.id,
      namaLengkap: data['nama_lengkap'] ?? '',
      email: data['email'] ?? '',
      nig: data['nig'] ?? 0,
      mataPelajaran: data['mata_pelajaran'] ?? '',
      sekolah: data['sekolah'] ?? '',
      jenisKelamin: data['jenis_kelamin'] ?? '',
      status: data['status'] ?? 'aktif',
      photoUrl: data['photo_url']?.isEmpty == true ? null : data['photo_url'],
      tanggalLahir: (data['tanggal_lahir'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nama_lengkap': namaLengkap,
      'email': email,
      'nig': nig,
      'mata_pelajaran': mataPelajaran,
      'sekolah': sekolah,
      'jenis_kelamin': jenisKelamin,
      'status': status,
      'photo_url': photoUrl ?? '',
      'tanggal_lahir': Timestamp.fromDate(tanggalLahir),
    };
  }

  GuruModel copyWith({
    String? id,
    String? namaLengkap,
    String? email,
    int? nig,
    String? mataPelajaran,
    String? sekolah,
    String? jenisKelamin,
    String? status,
    String? photoUrl,
    DateTime? tanggalLahir,
  }) {
    return GuruModel(
      id: id ?? this.id,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      email: email ?? this.email,
      nig: nig ?? this.nig,
      mataPelajaran: mataPelajaran ?? this.mataPelajaran,
      sekolah: sekolah ?? this.sekolah,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
    );
  }
}
