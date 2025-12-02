import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' as drift;
import '../storage/app_database.dart';

/// Service untuk sinkronisasi data antara Firestore dan database offline
class DatabaseSyncService {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  DatabaseSyncService(this._db, this._firestore);

  // ============================================================================
  // KELAS SYNC
  // ============================================================================

  /// Sync kelas from Firestore to local database
  Future<void> syncKelasFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('kelas').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        await _db.upsertKelas(
          CachedKelasCompanion(
            id: drift.Value(doc.id),
            namaKelas: drift.Value(data['nama_kelas'] ?? ''),
            guruId: drift.Value(data['guru_id'] ?? ''),
            status: drift.Value(data['status'] ?? true),
            createdAt: drift.Value(
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            updatedAt: drift.Value(
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Sync single kelas to Firestore
  Future<void> syncKelasToFirestore(CachedKelasData kelas) async {
    try {
      await _firestore.collection('kelas').doc(kelas.id).set({
        'nama_kelas': kelas.namaKelas,
        'guru_id': kelas.guruId,
        'status': kelas.status,
        'createdAt': Timestamp.fromDate(kelas.createdAt),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Update synced_at timestamp
      await _db.upsertKelas(
        CachedKelasCompanion(
          id: drift.Value(kelas.id),
          syncedAt: drift.Value(DateTime.now()),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================================
  // MAPEL SYNC
  // ============================================================================

  /// Sync mapel from Firestore to local database
  Future<void> syncMapelFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('mapel').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        await _db.upsertMapel(
          CachedMapelCompanion(
            id: drift.Value(doc.id),
            namaMapel: drift.Value(data['namaMapel'] ?? ''),
            createdAt: drift.Value(
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            updatedAt: drift.Value(
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Sync single mapel to Firestore
  Future<void> syncMapelToFirestore(CachedMapelData mapel) async {
    try {
      await _firestore.collection('mapel').doc(mapel.id).set({
        'namaMapel': mapel.namaMapel,
        'createdAt': Timestamp.fromDate(mapel.createdAt),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Update synced_at timestamp
      await _db.upsertMapel(
        CachedMapelCompanion(
          id: drift.Value(mapel.id),
          syncedAt: drift.Value(DateTime.now()),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================================
  // KELAS NGAJAR SYNC
  // ============================================================================

  /// Sync kelas ngajar from Firestore to local database
  Future<void> syncKelasNgajarFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('kelas_ngajar').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        await _db.upsertKelasNgajar(
          CachedKelasNgajarCompanion(
            id: drift.Value(doc.id),
            idGuru: drift.Value(data['id_guru']?.toString() ?? ''),
            idKelas: drift.Value(data['id_kelas']?.toString() ?? ''),
            idMapel: drift.Value(data['id_mapel']?.toString() ?? ''),
            createdAt: drift.Value(
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            updatedAt: drift.Value(
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Sync single kelas ngajar to Firestore
  Future<void> syncKelasNgajarToFirestore(
    CachedKelasNgajarData kelasNgajar,
  ) async {
    try {
      await _firestore.collection('kelas_ngajar').doc(kelasNgajar.id).set({
        'id_guru': kelasNgajar.idGuru,
        'id_kelas': kelasNgajar.idKelas,
        'id_mapel': kelasNgajar.idMapel,
        'createdAt': Timestamp.fromDate(kelasNgajar.createdAt),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Update synced_at timestamp
      await _db.upsertKelasNgajar(
        CachedKelasNgajarCompanion(
          id: drift.Value(kelasNgajar.id),
          syncedAt: drift.Value(DateTime.now()),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================================
  // PENGUMUMAN SYNC
  // ============================================================================

  /// Sync pengumuman from Firestore to local database
  Future<void> syncPengumumanFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('pengumuman').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        await _db.upsertPengumuman(
          CachedPengumumanCompanion(
            id: drift.Value(doc.id),
            judul: drift.Value(data['judul'] ?? ''),
            isi: drift.Value(data['isi'] ?? ''),
            tipe: drift.Value(data['tipe'] ?? 'umum'),
            tanggalDibuat: drift.Value(
              (data['tanggalDibuat'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            createdAt: drift.Value(
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            updatedAt: drift.Value(
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Sync single pengumuman to Firestore
  Future<void> syncPengumumanToFirestore(
    CachedPengumumanData pengumuman,
  ) async {
    try {
      await _firestore.collection('pengumuman').doc(pengumuman.id).set({
        'judul': pengumuman.judul,
        'isi': pengumuman.isi,
        'tipe': pengumuman.tipe,
        'tanggalDibuat': Timestamp.fromDate(pengumuman.tanggalDibuat),
        'createdAt': Timestamp.fromDate(pengumuman.createdAt),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Update synced_at timestamp
      await _db.upsertPengumuman(
        CachedPengumumanCompanion(
          id: drift.Value(pengumuman.id),
          syncedAt: drift.Value(DateTime.now()),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================================
  // GURU SYNC
  // ============================================================================

  /// Sync guru from Firestore to local database
  Future<void> syncGuruFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('guru').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        await _db.upsertGuru(
          CachedGuruCompanion(
            id: drift.Value(doc.id),
            namaLengkap: drift.Value(data['nama_lengkap'] ?? ''),
            email: drift.Value(data['email'] ?? ''),
            nig: drift.Value(data['NIG'] ?? 0),
            createdAt: drift.Value(
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            updatedAt: drift.Value(
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================================
  // SISWA SYNC
  // ============================================================================

  /// Sync siswa from Firestore to local database
  Future<void> syncSiswaFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('siswa').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        await _db.upsertSiswa(
          CachedSiswaCompanion(
            id: drift.Value(doc.id),
            nama: drift.Value(data['nama'] ?? ''),
            email: drift.Value(data['email'] ?? ''),
            nis: drift.Value(data['nis'] ?? ''),
            createdAt: drift.Value(
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            updatedAt: drift.Value(
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================================
  // SISWA KELAS SYNC
  // ============================================================================

  /// Sync siswa kelas from Firestore to local database
  Future<void> syncSiswaKelasFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('siswa_kelas').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        await _db.upsertSiswaKelas(
          CachedSiswaKelasCompanion(
            id: drift.Value(doc.id),
            siswaId: drift.Value(data['siswa_id']?.toString() ?? ''),
            kelasId: drift.Value(data['kelas_id']?.toString() ?? ''),
            createdAt: drift.Value(
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            updatedAt: drift.Value(
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            ),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================================
  // BULK SYNC
  // ============================================================================

  /// Sync all data from Firestore to local database
  Future<void> syncAllFromFirestore() async {
    try {
      await syncKelasFromFirestore();
      await syncMapelFromFirestore();
      await syncKelasNgajarFromFirestore();
      await syncPengumumanFromFirestore();
      await syncGuruFromFirestore();
      await syncSiswaFromFirestore();
      await syncSiswaKelasFromFirestore();
    } catch (e) {
      rethrow;
    }
  }

  /// Process pending sync queue items
  Future<void> processSyncQueue() async {
    try {
      final pendingItems = await _db.getPendingSyncItems();

      for (final item in pendingItems) {
        try {
          switch (item.tableName) {
            case 'kelas':
              final kelas = await _db.getKelasById(item.recordId);
              if (kelas != null) {
                await syncKelasToFirestore(kelas);
              }
              break;

            case 'mapel':
              final mapel = await _db.getMapelById(item.recordId);
              if (mapel != null) {
                await syncMapelToFirestore(mapel);
              }
              break;

            case 'kelas_ngajar':
              final kelasNgajar = await _db.getAllKelasNgajar().then(
                (list) => list.firstWhere((k) => k.id == item.recordId),
              );
              await syncKelasNgajarToFirestore(kelasNgajar);
              break;

            case 'pengumuman':
              final pengumuman = await _db.getAllPengumuman().then(
                (list) => list.firstWhere((p) => p.id == item.recordId),
              );
              await syncPengumumanToFirestore(pengumuman);
              break;
          }

          // Mark as completed
          await _db.markSyncCompleted(item.id);
        } catch (e) {
          // Mark as failed with error message
          await _db.markSyncFailed(item.id, e.toString());
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Clear completed sync items older than 7 days
  Future<void> clearOldSyncItems() async {
    await _db.clearCompletedSyncItems();
  }
}
