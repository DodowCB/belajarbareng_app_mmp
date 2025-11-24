import 'package:cloud_firestore/cloud_firestore.dart';

class DataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seed sample announcements to Firestore
  static Future<void> seedAnnouncements() async {
    try {
      print('🌱 Seeding sample announcements...');

      final announcements = [
        {
          'judul': 'Rapat Wali Murid',
          'deskripsi':
              'Jadwal rapat wali murid untuk kelas 10 akan diumumkan besok.',
          'guru_id': null,
          'nama_guru': null,
          'pembuat': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'judul': 'Update Sistem E-learning',
          'deskripsi':
              'Akan ada maintenance sistem pada hari Sabtu pukul 22:00 WIB.',
          'guru_id': null,
          'nama_guru': null,
          'pembuat': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'judul': 'Pengumpulan Nilai Rapor',
          'deskripsi':
              'Batas akhir pengumpulan nilai rapor semester ganjil adalah 15 Desember.',
          'guru_id': '1',
          'nama_guru': 'Castorice',
          'pembuat': 'guru',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'judul': 'Ujian Tengah Semester',
          'deskripsi':
              'Ujian tengah semester akan dilaksanakan mulai tanggal 1 Desember 2024.',
          'guru_id': null,
          'nama_guru': null,
          'pembuat': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'judul': 'Workshop Digital Learning',
          'deskripsi':
              'Workshop pelatihan digital learning untuk semua guru akan diadakan minggu depan.',
          'guru_id': '1',
          'nama_guru': 'Castorice',
          'pembuat': 'guru',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      final batch = _firestore.batch();

      for (final announcement in announcements) {
        final docRef = _firestore.collection('pengumuman').doc();
        batch.set(docRef, announcement);
      }

      await batch.commit();
      print('✅ Successfully seeded ${announcements.length} announcements');
    } catch (e) {
      print('❌ Error seeding announcements: $e');
    }
  }

  /// Seed sample tugas data
  static Future<void> seedTugas() async {
    try {
      print('🌱 Seeding sample tugas...');

      final tugas = [
        {
          'nama': 'Presentasi Sejarah Kemerdekaan',
          'deskripsi':
              'Presentasi kelompok tentang sejarah kemerdekaan Indonesia',
          'guru_id': '1',
          'kelas_id': 'kelas1',
          'mapel_id': 'mapel1',
          'deadline': Timestamp.fromDate(DateTime(2024, 11, 28)),
          'status': 'perlu_dinilai',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'nama': 'Ujian Praktik Biologi',
          'deskripsi': 'Ujian praktikum laboratorium biologi',
          'guru_id': '1',
          'kelas_id': 'kelas2',
          'mapel_id': 'mapel2',
          'deadline': Timestamp.fromDate(DateTime(2024, 11, 30)),
          'status': 'perlu_dinilai',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'nama': 'Esai Sastra Indonesia',
          'deskripsi': 'Menulis esai tentang karya sastra Indonesia modern',
          'guru_id': '1',
          'kelas_id': 'kelas3',
          'mapel_id': 'mapel3',
          'deadline': Timestamp.fromDate(DateTime(2024, 12, 2)),
          'status': 'perlu_dinilai',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'nama': 'Laporan Kimia',
          'deskripsi': 'Laporan hasil eksperimen kimia tentang asam basa',
          'guru_id': '1',
          'kelas_id': 'kelas4',
          'mapel_id': 'mapel4',
          'deadline': Timestamp.fromDate(DateTime(2024, 12, 5)),
          'status': 'perlu_dinilai',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      final batch = _firestore.batch();

      for (final task in tugas) {
        final docRef = _firestore.collection('tugas').doc();
        batch.set(docRef, task);
      }

      await batch.commit();
      print('✅ Successfully seeded ${tugas.length} tugas');
    } catch (e) {
      print('❌ Error seeding tugas: $e');
    }
  }

  /// Seed sample kelas data
  static Future<void> seedKelas() async {
    try {
      print('🌱 Seeding sample kelas...');

      final kelas = [
        {
          'nama_kelas': 'X IPA 1',
          'namaKelas': 'X IPA 1',
          'tingkat': 'X',
          'jurusan': 'IPA',
          'tahun_ajaran': '2024/2025',
          'guru_id': '1', // Wali kelas
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'nama_kelas': 'XI IPA 2',
          'namaKelas': 'XI IPA 2',
          'tingkat': 'XI',
          'jurusan': 'IPA',
          'tahun_ajaran': '2024/2025',
          'guru_id': '1', // Wali kelas
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'nama_kelas': 'XII IPS 1',
          'namaKelas': 'XII IPS 1',
          'tingkat': 'XII',
          'jurusan': 'IPS',
          'tahun_ajaran': '2024/2025',
          'guru_id': '1', // Wali kelas
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      final batch = _firestore.batch();

      for (final kelasData in kelas) {
        final docRef = _firestore.collection('kelas').doc();
        batch.set(docRef, kelasData);
      }

      await batch.commit();
      print('✅ Successfully seeded ${kelas.length} kelas');
    } catch (e) {
      print('❌ Error seeding kelas: $e');
    }
  }

  /// Seed sample siswa_kelas data (many-to-many relation)
  static Future<void> seedSiswaKelas() async {
    try {
      print('🌱 Seeding sample siswa_kelas relations...');

      // Get existing kelas
      final kelasSnapshot = await _firestore.collection('kelas').limit(3).get();

      final siswaKelasData = <Map<String, dynamic>>[];

      for (int i = 0; i < kelasSnapshot.docs.length; i++) {
        final kelasDoc = kelasSnapshot.docs[i];

        // Create 25-30 students per class
        final studentCount = 25 + (i * 5); // 25, 30, 35 students

        for (int j = 1; j <= studentCount; j++) {
          siswaKelasData.add({
            'kelas_id': kelasDoc.id,
            'siswa_id': 'siswa_${kelasDoc.id}_$j',
            'tahun_ajaran': '2024/2025',
            'status': 'aktif',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      // Batch write in chunks of 500 (Firestore limit)
      final batch = _firestore.batch();
      int count = 0;

      for (final data in siswaKelasData) {
        final docRef = _firestore.collection('siswa_kelas').doc();
        batch.set(docRef, data);
        count++;

        if (count % 500 == 0) {
          await batch.commit();
          print('📦 Committed batch of $count siswa_kelas relations');
        }
      }

      // Commit remaining items
      if (count % 500 != 0) {
        await batch.commit();
      }

      print(
        '✅ Successfully seeded ${siswaKelasData.length} siswa_kelas relations',
      );
    } catch (e) {
      print('❌ Error seeding siswa_kelas: $e');
    }
  }

  /// Seed all sample data
  static Future<void> seedAll() async {
    print('🌱 Starting data seeding process...');

    await seedAnnouncements();
    await seedTugas();
    await seedKelas();
    await seedSiswaKelas();

    print('✅ All sample data seeded successfully!');
  }
}
