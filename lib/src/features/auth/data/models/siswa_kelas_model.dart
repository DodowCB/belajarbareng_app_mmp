import 'package:cloud_firestore/cloud_firestore.dart';

class SiswaKelasModel {
  final String id;
  final String siswaId; // Foreign key ke collection siswa
  final String kelasId; // Foreign key ke collection kelas

  SiswaKelasModel({
    required this.id,
    required this.siswaId,
    required this.kelasId,
  });

  // Factory constructor untuk membuat objek dari Firestore DocumentSnapshot
  factory SiswaKelasModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SiswaKelasModel(
      id: doc.id,
      siswaId: data['siswa_id'] ?? '',
      kelasId: data['kelas_id'] ?? '',
    );
  }

  // Method untuk konversi ke Map
  Map<String, dynamic> toMap() {
    return {
      'siswa_id': siswaId,
      'kelas_id': kelasId,
    };
  }

  // Method untuk membuat copy dengan perubahan
  SiswaKelasModel copyWith({
    String? id,
    String? siswaId,
    String? kelasId,
  }) {
    return SiswaKelasModel(
      id: id ?? this.id,
      siswaId: siswaId ?? this.siswaId,
      kelasId: kelasId ?? this.kelasId,
    );
  }

  @override
  String toString() {
    return 'SiswaKelasModel(id: $id, siswaId: $siswaId, kelasId: $kelasId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SiswaKelasModel &&
        other.id == id &&
        other.siswaId == siswaId &&
        other.kelasId == kelasId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ siswaId.hashCode ^ kelasId.hashCode;
  }

  // Method untuk validasi data
  bool get isValid {
    return siswaId.isNotEmpty && kelasId.isNotEmpty;
  }
}