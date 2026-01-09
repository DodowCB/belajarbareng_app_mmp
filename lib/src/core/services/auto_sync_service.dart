import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'local_storage_service.dart';
import 'connectivity_service.dart';

/// Service untuk auto background sync data dari Firebase ke database offline
class AutoSyncService {
  static final AutoSyncService _instance = AutoSyncService._internal();
  factory AutoSyncService() => _instance;
  AutoSyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalStorageService _localStorage = LocalStorageService();
  final ConnectivityService _connectivity = ConnectivityService();

  Timer? _syncTimer;
  bool _isSyncing = false;
  static const int _syncIntervalMinutes = 5; // Sync setiap 5 menit

  /// Memulai auto sync background
  Future<void> startAutoSync() async {
    debugPrint('🔄 Starting auto background sync service...');

    // Sync sekali saat startup
    await _performSync();

    // Setup timer untuk sync berkala
    _syncTimer = Timer.periodic(
      const Duration(minutes: _syncIntervalMinutes),
      (_) => _performSync(),
    );

    debugPrint('✅ Auto sync started - interval: ${_syncIntervalMinutes}m');
  }

  /// Menghentikan auto sync
  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    debugPrint('🛑 Auto sync stopped');
  }

  /// Melakukan sync manual
  Future<bool> syncNow() async {
    return await _performSync();
  }

  /// Perform sync operation
  Future<bool> _performSync() async {
    if (_isSyncing) {
      debugPrint('⏳ Sync already in progress, skipping...');
      return false;
    }

    // Check connectivity first before setting flag
    final hasConnection = _connectivity.hasConnection;
    if (!hasConnection) {
      debugPrint('📴 No internet connection, skipping sync');
      return false;
    }

    _isSyncing = true;

    try {
      debugPrint('🔄 Starting background sync from Firebase...');
      final startTime = DateTime.now();

      // Sync all collections in parallel
      await Future.wait([
        _syncGuru(),
        _syncSiswa(),
        _syncPengumuman(),
        _syncKelas(),
        _syncSiswaKelas(),
      ]);

      // Update last sync timestamp
      await _localStorage.saveLastSync(DateTime.now());

      final duration = DateTime.now().difference(startTime);
      debugPrint('✅ Background sync completed in ${duration.inSeconds}s');

      return true;
    } catch (e) {
      debugPrint('❌ Background sync failed: $e');
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync data guru dari Firebase
  Future<void> _syncGuru() async {
    try {
      debugPrint('👨‍🏫 Syncing guru data...');

      final snapshot = await _firestore
          .collection('guru')
          .orderBy('created_at', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final guruData = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'nama': data['nama'] ?? '',
            'email': data['email'] ?? '',
            'mapel': data['mapel'] ?? '',
            'no_hp': data['no_hp'] ?? '',
            'alamat': data['alamat'] ?? '',
            'status': data['status'] ?? 'active',
            'created_at':
                data['created_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
            'updated_at':
                data['updated_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
          };
        }).toList();

        await _localStorage.saveGuruData(guruData);
        debugPrint('✅ Synced ${guruData.length} guru records');
      }
    } catch (e) {
      debugPrint('❌ Error syncing guru: $e');
    }
  }

  /// Sync data siswa dari Firebase
  Future<void> _syncSiswa() async {
    try {
      debugPrint('👨‍🎓 Syncing siswa data...');

      final snapshot = await _firestore
          .collection('siswa')
          .orderBy('created_at', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final siswaData = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'nama': data['nama'] ?? '',
            'email': data['email'] ?? '',
            'kelas': data['kelas'] ?? '',
            'nisn': data['nisn'] ?? '',
            'no_hp': data['no_hp'] ?? '',
            'alamat': data['alamat'] ?? '',
            'tanggal_lahir':
                data['tanggal_lahir']?.toDate()?.toIso8601String() ?? '',
            'jenis_kelamin': data['jenis_kelamin'] ?? '',
            'status': data['status'] ?? 'active',
            'created_at':
                data['created_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
            'updated_at':
                data['updated_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
          };
        }).toList();

        await _localStorage.saveSiswaData(siswaData);
        debugPrint('✅ Synced ${siswaData.length} siswa records');
      }
    } catch (e) {
      debugPrint('❌ Error syncing siswa: $e');
    }
  }

  /// Sync data pengumuman dari Firebase
  Future<void> _syncPengumuman() async {
    try {
      debugPrint('📢 Syncing pengumuman data...');

      final snapshot = await _firestore
          .collection('pengumuman')
          .orderBy('created_at', descending: true)
          .limit(50) // Batasi hanya 50 pengumuman terbaru
          .get();

      if (snapshot.docs.isNotEmpty) {
        final pengumumanData = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'judul': data['judul'] ?? '',
            'isi': data['isi'] ?? '',
            'kategori': data['kategori'] ?? 'umum',
            'prioritas': data['prioritas'] ?? 'normal',
            'target_audience': data['target_audience'] ?? 'semua',
            'is_active': data['is_active'] ?? true,
            'author': data['author'] ?? '',
            'created_at':
                data['created_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
            'updated_at':
                data['updated_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
          };
        }).toList();

        await _localStorage.savePengumumanData(pengumumanData);
        debugPrint('✅ Synced ${pengumumanData.length} pengumuman records');
      }
    } catch (e) {
      debugPrint('❌ Error syncing pengumuman: $e');
    }
  }

  /// Sync data kelas dari Firebase
  Future<void> _syncKelas() async {
    try {
      debugPrint('🏫 Syncing kelas data...');

      final snapshot = await _firestore
          .collection('kelas')
          .orderBy('nama')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final kelasData = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'nama': data['nama'] ?? '',
            'tingkat': data['tingkat'] ?? '',
            'wali_kelas': data['wali_kelas'] ?? '',
            'wali_kelas_id': data['wali_kelas_id'] ?? '',
            'jumlah_siswa': data['jumlah_siswa'] ?? 0,
            'ruang': data['ruang'] ?? '',
            'tahun_ajaran': data['tahun_ajaran'] ?? '',
            'status': data['status'] ?? 'active',
            'created_at':
                data['created_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
            'updated_at':
                data['updated_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
          };
        }).toList();

        await _localStorage.saveKelasData(kelasData);
        debugPrint('✅ Synced ${kelasData.length} kelas records');
      }
    } catch (e) {
      debugPrint('❌ Error syncing kelas: $e');
    }
  }

  /// Sync data relasi siswa-kelas dari Firebase
  Future<void> _syncSiswaKelas() async {
    try {
      debugPrint('👥 Syncing siswa-kelas relationships...');

      final snapshot = await _firestore
          .collection('siswa_kelas')
          .orderBy('created_at', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final siswaKelasData = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'siswa_id': data['siswa_id'] ?? '',
            'kelas_id': data['kelas_id'] ?? '',
            'siswa_nama': data['siswa_nama'] ?? '',
            'kelas_nama': data['kelas_nama'] ?? '',
            'tahun_ajaran': data['tahun_ajaran'] ?? '',
            'semester': data['semester'] ?? 1,
            'status': data['status'] ?? 'active',
            'created_at':
                data['created_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
            'updated_at':
                data['updated_at']?.toDate()?.toIso8601String() ??
                DateTime.now().toIso8601String(),
          };
        }).toList();

        await _localStorage.saveSiswaKelasData(siswaKelasData);
        debugPrint('✅ Synced ${siswaKelasData.length} siswa-kelas records');
      }
    } catch (e) {
      debugPrint('❌ Error syncing siswa-kelas: $e');
    }
  }

  /// Get sync status
  Map<String, dynamic> getSyncStatus() {
    return {
      'isActive': _syncTimer?.isActive ?? false,
      'isSyncing': _isSyncing,
      'intervalMinutes': _syncIntervalMinutes,
      'lastSync': null, // Could be retrieved from localStorage
    };
  }

  /// Dispose resources
  void dispose() {
    stopAutoSync();
  }
}
