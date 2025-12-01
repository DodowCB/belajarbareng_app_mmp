import 'package:cloud_firestore/cloud_firestore.dart';

class AbsensiModel {
  final String id;
  final String siswaId;
  final String kelasId;
  final DateTime tanggal;
  final String tipeAbsen; // harian, mapel
  final String? jadwalId; // null jika harian
  final String status; // hadir, sakit, izin, absen, terlambat
  final String diabsenOleh; // guru_id
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AbsensiModel({
    required this.id,
    required this.siswaId,
    required this.kelasId,
    required this.tanggal,
    required this.tipeAbsen,
    this.jadwalId,
    required this.status,
    required this.diabsenOleh,
    this.createdAt,
    this.updatedAt,
  });

  factory AbsensiModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AbsensiModel(
      id: doc.id,
      siswaId: data['siswa_id'] ?? '',
      kelasId: data['kelas_id'] ?? '',
      tanggal: (data['tanggal'] as Timestamp?)?.toDate() ?? DateTime.now(),
      tipeAbsen: data['tipe_absen'] ?? 'harian',
      jadwalId: data['jadwal_id'],
      status: data['status'] ?? 'absen',
      diabsenOleh: data['diabsen_oleh'] ?? '',
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'siswa_id': siswaId,
      'kelas_id': kelasId,
      'tanggal': Timestamp.fromDate(tanggal),
      'tipe_absen': tipeAbsen,
      'jadwal_id': jadwalId,
      'status': status,
      'diabsen_oleh': diabsenOleh,
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

  AbsensiModel copyWith({
    String? id,
    String? siswaId,
    String? kelasId,
    DateTime? tanggal,
    String? tipeAbsen,
    String? jadwalId,
    String? status,
    String? diabsenOleh,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AbsensiModel(
      id: id ?? this.id,
      siswaId: siswaId ?? this.siswaId,
      kelasId: kelasId ?? this.kelasId,
      tanggal: tanggal ?? this.tanggal,
      tipeAbsen: tipeAbsen ?? this.tipeAbsen,
      jadwalId: jadwalId ?? this.jadwalId,
      status: status ?? this.status,
      diabsenOleh: diabsenOleh ?? this.diabsenOleh,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
