import 'package:cloud_firestore/cloud_firestore.dart';

class PengumumanModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String? guruId; // null jika dibuat oleh admin
  final String? namaGuru; // null jika dibuat oleh admin
  final String pembuat; // 'admin' atau 'guru'
  final DateTime createdAt;
  final DateTime? updatedAt;

  PengumumanModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    this.guruId,
    this.namaGuru,
    required this.pembuat,
    required this.createdAt,
    this.updatedAt,
  });

  factory PengumumanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PengumumanModel(
      id: doc.id,
      judul: data['judul'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      guruId: data['guru_id'],
      namaGuru: data['nama_guru'],
      pembuat: data['pembuat'] ?? 'admin',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'guru_id': guruId,
      'nama_guru': namaGuru,
      'pembuat': pembuat,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  PengumumanModel copyWith({
    String? id,
    String? judul,
    String? deskripsi,
    String? guruId,
    String? namaGuru,
    String? pembuat,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PengumumanModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      guruId: guruId ?? this.guruId,
      namaGuru: namaGuru ?? this.namaGuru,
      pembuat: pembuat ?? this.pembuat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'PengumumanModel(id: $id, judul: $judul, pembuat: $pembuat, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PengumumanModel &&
        other.id == id &&
        other.judul == judul &&
        other.deskripsi == deskripsi;
  }

  @override
  int get hashCode {
    return id.hashCode ^ judul.hashCode ^ deskripsi.hashCode;
  }

  // Helper methods
  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String get formattedDateTime {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  String get pembuatDisplay {
    if (pembuat == 'admin') {
      return 'Administrator';
    } else if (namaGuru != null) {
      return namaGuru!;
    } else {
      return 'Guru';
    }
  }
}
