import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:tostore/tostore.dart';

/// Service untuk mengelola penyimpanan data lokal
/// Menggunakan Tostore untuk database offline berkinerja tinggi
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  ToStore? _store;

  /// Initialize Tostore
  Future<void> initialize() async {
    try {
      _store = ToStore(
        version: 1,
        schemas: [], // Empty schemas for simple key-value storage
      );
      await _store!.initialize();
      debugPrint('LocalStorageService initialized successfully with Tostore');
    } catch (e) {
      debugPrint('Error initializing LocalStorageService: $e');
    }
  }

  /// Ensure Tostore is initialized
  ToStore get store {
    if (_store == null) {
      throw Exception(
        'LocalStorageService not initialized. Call initialize() first.',
      );
    }
    return _store!;
  }

  /// Create sample offline data for testing
  Future<void> createSampleOfflineData() async {
    debugPrint('🧪 Creating sample offline data for testing...');

    // Sample Siswa Data
    final sampleSiswa = [
      {
        'id': 'siswa_001',
        'nama': 'Ahmad Rizki',
        'email': 'ahmad.rizki@student.com',
        'kelas': 'X-A',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'siswa_002',
        'nama': 'Siti Nurhaliza',
        'email': 'siti.nurhaliza@student.com',
        'kelas': 'X-B',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'siswa_003',
        'nama': 'Budi Santoso',
        'email': 'budi.santoso@student.com',
        'kelas': 'XI-A',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    // Sample Guru Data
    final sampleGuru = [
      {
        'id': 'guru_001',
        'nama': 'Dr. Lestari Wijaya',
        'email': 'lestari.wijaya@teacher.com',
        'mapel': 'Matematika',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'guru_002',
        'nama': 'Prof. Andi Suryanto',
        'email': 'andi.suryanto@teacher.com',
        'mapel': 'Fisika',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    // Sample Kelas Data
    final sampleKelas = [
      {
        'id': 'kelas_001',
        'nama': 'X-A',
        'wali_kelas': 'Dr. Lestari Wijaya',
        'jumlah_siswa': 30,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'kelas_002',
        'nama': 'X-B',
        'wali_kelas': 'Prof. Andi Suryanto',
        'jumlah_siswa': 28,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'kelas_003',
        'nama': 'XI-A',
        'wali_kelas': 'Dr. Lestari Wijaya',
        'jumlah_siswa': 25,
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    // Sample Mapel Data
    final sampleMapel = [
      {
        'id': 'mapel_001',
        'nama': 'Matematika',
        'kode': 'MAT',
        'sks': 3,
        'deskripsi': 'Matematika Dasar dan Lanjutan',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'mapel_002',
        'nama': 'Fisika',
        'kode': 'FIS',
        'sks': 2,
        'deskripsi': 'Fisika Dasar dan Lanjutan',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'mapel_003',
        'nama': 'Kimia',
        'kode': 'KIM',
        'sks': 2,
        'deskripsi': 'Kimia Dasar dan Lanjutan',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'mapel_004',
        'nama': 'Biologi',
        'kode': 'BIO',
        'sks': 2,
        'deskripsi': 'Biologi Dasar dan Lanjutan',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    // Sample Pengumuman Data
    final samplePengumuman = [
      {
        'id': 'pengumuman_001',
        'judul': 'Libur Hari Raya',
        'isi': 'Sekolah akan libur pada tanggal 15-17 Mei 2024',
        'tanggal': DateTime.now().toIso8601String(),
        'penulis': 'Admin',
        'status': 'active',
      },
      {
        'id': 'pengumuman_002',
        'judul': 'Ujian Tengah Semester',
        'isi': 'UTS akan dilaksanakan mulai tanggal 20 Mei 2024',
        'tanggal': DateTime.now().toIso8601String(),
        'penulis': 'Dr. Lestari Wijaya',
        'status': 'active',
      },
    ];

    // Sample Siswa-Kelas Relations
    final sampleSiswaKelas = [
      {
        'id': 'sk_001',
        'siswa_id': 'siswa_001',
        'kelas_id': 'kelas_001',
        'tahun_ajaran': '2023/2024',
        'semester': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'sk_002',
        'siswa_id': 'siswa_002',
        'kelas_id': 'kelas_002',
        'tahun_ajaran': '2023/2024',
        'semester': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'sk_003',
        'siswa_id': 'siswa_003',
        'kelas_id': 'kelas_003',
        'tahun_ajaran': '2023/2024',
        'semester': 1,
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    // Save all sample data
    await saveSiswaData(sampleSiswa);
    await saveGuruData(sampleGuru);
    await saveKelasData(sampleKelas);
    await saveMapelData(sampleMapel);
    await savePengumumanData(samplePengumuman);
    await saveSiswaKelasData(sampleSiswaKelas);

    // Save admin stats
    await saveAdminStats(
      totalGuru: sampleGuru.length,
      totalSiswa: sampleSiswa.length,
      totalKelas: sampleKelas.length,
      totalMapel: sampleMapel.length,
      totalPengumuman: samplePengumuman.length,
    );

    debugPrint('🧪 Sample offline data created successfully!');
  }

  // ==================== KEYS ====================
  static const String _keyAdminStats = 'admin_stats';
  static const String _keyPengumumanData = 'pengumuman_data';
  static const String _keySiswaData = 'siswa_data';
  static const String _keyGuruData = 'guru_data';
  static const String _keyKelasData = 'kelas_data';
  static const String _keySiswaKelasData = 'siswa_kelas_data';
  static const String _keyMapelData = 'mapel_data';
  static const String _keyLastSync = 'last_sync';

  // ==================== ADMIN STATS ====================

  /// Save admin statistics to local storage
  Future<bool> saveAdminStats({
    required int totalGuru,
    required int totalSiswa,
    required int totalKelas,
    required int totalMapel,
    required int totalPengumuman,
  }) async {
    try {
      final data = {
        'totalGuru': totalGuru,
        'totalSiswa': totalSiswa,
        'totalKelas': totalKelas,
        'totalMapel': totalMapel,
        'totalPengumuman': totalPengumuman,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      await store.setValue(_keyAdminStats, jsonEncode(data));

      debugPrint('💾 Admin stats saved to local storage successfully');
      debugPrint(
        '💾 Saved data: Guru: $totalGuru, Siswa: $totalSiswa, Kelas: $totalKelas, Mapel: $totalMapel, Pengumuman: $totalPengumuman',
      );
      await _updateLastSync();

      return true;
    } catch (e) {
      debugPrint('Error saving admin stats: $e');
      return false;
    }
  }

  /// Get admin statistics from local storage
  Future<Map<String, dynamic>?> getAdminStats() async {
    try {
      final dataString = await store.getValue(_keyAdminStats);
      if (dataString == null) {
        debugPrint('💾 No admin stats found in local storage');
        return null;
      }

      final data = jsonDecode(dataString) as Map<String, dynamic>;

      debugPrint('💾 Admin stats loaded from local storage:');
      debugPrint('💾 Total Guru: ${data['totalGuru'] ?? 0}');
      debugPrint('💾 Total Siswa: ${data['totalSiswa'] ?? 0}');
      debugPrint('💾 Total Kelas: ${data['totalKelas'] ?? 0}');
      debugPrint('💾 Total Mapel: ${data['totalMapel'] ?? 0}');
      debugPrint('💾 Total Pengumuman: ${data['totalPengumuman'] ?? 0}');
      debugPrint('💾 Last Updated: ${data['lastUpdated']}');

      // Return default values if data is corrupted
      return {
        'totalGuru': data['totalGuru'] ?? 0,
        'totalSiswa': data['totalSiswa'] ?? 0,
        'totalKelas': data['totalKelas'] ?? 0,
        'totalMapel': data['totalMapel'] ?? 0,
        'totalPengumuman': data['totalPengumuman'] ?? 0,
        'lastUpdated': data['lastUpdated'] ?? DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error getting admin stats: $e');
      return null;
    }
  }

  // ==================== PENGUMUMAN DATA ====================

  /// Save pengumuman list to local storage
  Future<bool> savePengumumanData(
    List<Map<String, dynamic>> pengumumanList,
  ) async {
    try {
      final data = {
        'pengumuman': pengumumanList,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      await store.setValue(_keyPengumumanData, jsonEncode(data));

      debugPrint('💾 Pengumuman data saved: ${pengumumanList.length} items');
      await _updateLastSync();

      return true;
    } catch (e) {
      debugPrint('Error saving pengumuman data: $e');
      return false;
    }
  }

  /// Get pengumuman list from local storage
  Future<List<Map<String, dynamic>>?> getPengumumanData() async {
    try {
      final dataString = await store.getValue(_keyPengumumanData);
      if (dataString == null) return null;

      final data = jsonDecode(dataString) as Map<String, dynamic>;
      final pengumumanList = data['pengumuman'] as List<dynamic>;

      return pengumumanList.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting pengumuman data: $e');
      return null;
    }
  }

  // ==================== SISWA DATA ====================

  /// Save siswa list to local storage
  Future<bool> saveSiswaData(List<Map<String, dynamic>> siswaList) async {
    try {
      final data = {
        'siswa': siswaList,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      await store.setValue(_keySiswaData, jsonEncode(data));

      debugPrint('💾 Siswa data saved: ${siswaList.length} items');
      await _updateLastSync();

      return true;
    } catch (e) {
      debugPrint('Error saving siswa data: $e');
      return false;
    }
  }

  /// Get siswa list from local storage
  Future<List<Map<String, dynamic>>?> getSiswaData() async {
    try {
      final dataString = await store.getValue(_keySiswaData);
      if (dataString == null) return null;

      final data = jsonDecode(dataString) as Map<String, dynamic>;
      final siswaList = data['siswa'] as List<dynamic>;

      return siswaList.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting siswa data: $e');
      return null;
    }
  }

  // ==================== GURU DATA ====================

  /// Save guru list to local storage
  Future<bool> saveGuruData(List<Map<String, dynamic>> guruList) async {
    try {
      final data = {
        'guru': guruList,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      await store.setValue(_keyGuruData, jsonEncode(data));

      debugPrint('💾 Guru data saved: ${guruList.length} items');
      await _updateLastSync();

      return true;
    } catch (e) {
      debugPrint('Error saving guru data: $e');
      return false;
    }
  }

  /// Get guru list from local storage
  Future<List<Map<String, dynamic>>?> getGuruData() async {
    try {
      final dataString = await store.getValue(_keyGuruData);
      if (dataString == null) return null;

      final data = jsonDecode(dataString) as Map<String, dynamic>;
      final guruList = data['guru'] as List<dynamic>;

      return guruList.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting guru data: $e');
      return null;
    }
  }

  // ==================== KELAS DATA ====================

  /// Save kelas list to local storage
  Future<bool> saveKelasData(List<Map<String, dynamic>> kelasList) async {
    try {
      final data = {
        'kelas': kelasList,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      await store.setValue(_keyKelasData, jsonEncode(data));

      debugPrint('💾 Kelas data saved: ${kelasList.length} items');
      await _updateLastSync();

      return true;
    } catch (e) {
      debugPrint('Error saving kelas data: $e');
      return false;
    }
  }

  /// Get kelas list from local storage
  Future<List<Map<String, dynamic>>?> getKelasData() async {
    try {
      final dataString = await store.getValue(_keyKelasData);
      if (dataString == null) return null;

      final data = jsonDecode(dataString) as Map<String, dynamic>;
      final kelasList = data['kelas'] as List<dynamic>;

      return kelasList.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting kelas data: $e');
      return null;
    }
  }

  // ==================== SISWA-KELAS RELATION DATA ====================

  /// Save siswa-kelas relation list to local storage
  Future<bool> saveSiswaKelasData(
    List<Map<String, dynamic>> siswaKelasList,
  ) async {
    try {
      final data = {
        'siswa_kelas': siswaKelasList,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      await store.setValue(_keySiswaKelasData, jsonEncode(data));

      debugPrint('💾 Siswa-Kelas data saved: ${siswaKelasList.length} items');
      await _updateLastSync();

      return true;
    } catch (e) {
      debugPrint('Error saving siswa-kelas data: $e');
      return false;
    }
  }

  /// Get siswa-kelas relation list from local storage
  Future<List<Map<String, dynamic>>?> getSiswaKelasData() async {
    try {
      final dataString = await store.getValue(_keySiswaKelasData);
      if (dataString == null) return null;

      final data = jsonDecode(dataString) as Map<String, dynamic>;
      final siswaKelasList = data['siswa_kelas'] as List<dynamic>;

      return siswaKelasList.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting siswa-kelas data: $e');
      return null;
    }
  }

  // ==================== MAPEL DATA ====================

  /// Save mapel list to local storage
  Future<bool> saveMapelData(List<Map<String, dynamic>> mapelList) async {
    try {
      final data = {
        'mapel': mapelList,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      await store.setValue(_keyMapelData, jsonEncode(data));

      debugPrint('💾 Mapel data saved: ${mapelList.length} items');
      await _updateLastSync();

      return true;
    } catch (e) {
      debugPrint('Error saving mapel data: $e');
      return false;
    }
  }

  /// Get mapel list from local storage
  Future<List<Map<String, dynamic>>?> getMapelData() async {
    try {
      final dataString = await store.getValue(_keyMapelData);
      if (dataString == null) return null;

      final data = jsonDecode(dataString) as Map<String, dynamic>;
      final mapelList = data['mapel'] as List<dynamic>;

      return mapelList.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting mapel data: $e');
      return null;
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Update last sync timestamp
  Future<void> _updateLastSync() async {
    try {
      await store.setValue(_keyLastSync, DateTime.now().toIso8601String());
      debugPrint('💾 Last sync updated');
    } catch (e) {
      debugPrint('Error updating last sync: $e');
    }
  }

  /// Get last sync timestamp
  Future<DateTime?> getLastSync() async {
    try {
      final lastSyncString = await store.getValue(_keyLastSync);
      if (lastSyncString == null) return null;

      return DateTime.parse(lastSyncString);
    } catch (e) {
      debugPrint('Error getting last sync: $e');
      return null;
    }
  }

  /// Clear all local storage data
  Future<void> clearAllData() async {
    try {
      final keys = [
        _keyAdminStats,
        _keyPengumumanData,
        _keySiswaData,
        _keyGuruData,
        _keyKelasData,
        _keySiswaKelasData,
        _keyMapelData,
        _keyLastSync,
      ];

      for (final key in keys) {
        await store.setValue(key, null);
      }

      debugPrint('💾 All local storage data cleared');
    } catch (e) {
      debugPrint('Error clearing all data: $e');
    }
  }

  /// Check if any offline data exists
  Future<bool> hasOfflineData() async {
    try {
      final adminStats = await store.getValue(_keyAdminStats);
      final pengumuman = await store.getValue(_keyPengumumanData);
      final siswa = await store.getValue(_keySiswaData);
      final guru = await store.getValue(_keyGuruData);
      final kelas = await store.getValue(_keyKelasData);
      final siswaKelas = await store.getValue(_keySiswaKelasData);
      final mapel = await store.getValue(_keyMapelData);

      return adminStats != null ||
          pengumuman != null ||
          siswa != null ||
          guru != null ||
          kelas != null ||
          siswaKelas != null ||
          mapel != null;
    } catch (e) {
      debugPrint('Error checking offline data: $e');
      return false;
    }
  }

  /// Print all offline data for debugging
  Future<void> printAllOfflineData() async {
    try {
      debugPrint('🏪 ===== OFFLINE DATABASE CONTENT =====');

      // Print Admin Stats
      final adminStats = await getAdminStats();
      if (adminStats != null) {
        debugPrint('📊 ADMIN STATS:');
        debugPrint('   - Total Guru: ${adminStats['totalGuru']}');
        debugPrint('   - Total Siswa: ${adminStats['totalSiswa']}');
        debugPrint('   - Total Kelas: ${adminStats['totalKelas']}');
        debugPrint('   - Total Mapel: ${adminStats['totalMapel']}');
        debugPrint('   - Total Pengumuman: ${adminStats['totalPengumuman']}');
        debugPrint('   - Last Updated: ${adminStats['lastUpdated']}');
      } else {
        debugPrint('📊 ADMIN STATS: No data');
      }

      // Print Siswa Data
      final siswaData = await getSiswaData();
      if (siswaData != null && siswaData.isNotEmpty) {
        debugPrint('👨‍🎓 SISWA DATA (${siswaData.length} records):');
        for (final siswa in siswaData) {
          debugPrint(
            '   - ${siswa['nama']} (${siswa['email']}) - Kelas: ${siswa['kelas']}',
          );
        }
      } else {
        debugPrint('👨‍🎓 SISWA DATA: No data');
      }

      // Print Guru Data
      final guruData = await getGuruData();
      if (guruData != null && guruData.isNotEmpty) {
        debugPrint('👨‍🏫 GURU DATA (${guruData.length} records):');
        for (final guru in guruData) {
          debugPrint(
            '   - ${guru['nama']} (${guru['email']}) - Mapel: ${guru['mapel']}',
          );
        }
      } else {
        debugPrint('👨‍🏫 GURU DATA: No data');
      }

      // Print Kelas Data
      final kelasData = await getKelasData();
      if (kelasData != null && kelasData.isNotEmpty) {
        debugPrint('🏫 KELAS DATA (${kelasData.length} records):');
        for (final kelas in kelasData) {
          debugPrint(
            '   - ${kelas['nama']} - Wali: ${kelas['wali_kelas']} - Siswa: ${kelas['jumlah_siswa']}',
          );
        }
      } else {
        debugPrint('🏫 KELAS DATA: No data');
      }

      // Print Mapel Data
      final mapelData = await getMapelData();
      if (mapelData != null && mapelData.isNotEmpty) {
        debugPrint('📚 MAPEL DATA (${mapelData.length} records):');
        for (final mapel in mapelData) {
          debugPrint(
            '   - ${mapel['nama']} (${mapel['kode']}) - SKS: ${mapel['sks']}',
          );
        }
      } else {
        debugPrint('📚 MAPEL DATA: No data');
      }

      // Print Pengumuman Data
      final pengumumanData = await getPengumumanData();
      if (pengumumanData != null && pengumumanData.isNotEmpty) {
        debugPrint('📢 PENGUMUMAN DATA (${pengumumanData.length} records):');
        for (final pengumuman in pengumumanData) {
          debugPrint('   - ${pengumuman['judul']} by ${pengumuman['penulis']}');
        }
      } else {
        debugPrint('📢 PENGUMUMAN DATA: No data');
      }

      // Print Siswa-Kelas Relations
      final siswaKelasData = await getSiswaKelasData();
      if (siswaKelasData != null && siswaKelasData.isNotEmpty) {
        debugPrint(
          '🔗 SISWA-KELAS RELATIONS (${siswaKelasData.length} records):',
        );
        for (final relation in siswaKelasData) {
          debugPrint(
            '   - Siswa: ${relation['siswa_id']} -> Kelas: ${relation['kelas_id']}',
          );
        }
      } else {
        debugPrint('🔗 SISWA-KELAS RELATIONS: No data');
      }

      // Print Last Sync
      final lastSync = await getLastSync();
      if (lastSync != null) {
        debugPrint('⏰ LAST SYNC: $lastSync');
      } else {
        debugPrint('⏰ LAST SYNC: Never');
      }

      debugPrint('🏪 ===== END OFFLINE DATABASE CONTENT =====');
    } catch (e) {
      debugPrint('❌ Error printing offline data: $e');
    }
  }
}
