import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/auto_sync_service.dart';
import '../../../../core/providers/app_user.dart';
import 'dart:async';

// Admin Events
abstract class AdminEvent {}

class LoadAdminData extends AdminEvent {}

class RefreshAdminData extends AdminEvent {}

class UpdateUserStats extends AdminEvent {
  final Map<String, int> stats;
  UpdateUserStats(this.stats);
}

class TriggerManualSync extends AdminEvent {}

class GetSyncStatus extends AdminEvent {}

// Admin State
class AdminState {
  final bool isLoading;
  final int totalUsers;
  final int totalTeachers;
  final int totalStudents;
  final int totalMapels;
  final int totalClasses;
  final int totalPengumuman;
  final int totalJadwalMengajar;
  final String? error;
  final bool isOnline;
  final DateTime? lastSync;

  AdminState({
    this.isLoading = false,
    this.totalUsers = 0,
    this.totalTeachers = 0,
    this.totalStudents = 0,
    this.totalMapels = 0,
    this.totalClasses = 0,
    this.totalPengumuman = 0,
    this.totalJadwalMengajar = 0,
    this.error,
    this.isOnline = true,
    this.lastSync,
  });

  AdminState copyWith({
    bool? isLoading,
    int? totalUsers,
    int? totalTeachers,
    int? totalStudents,
    int? totalMapels,
    int? totalClasses,
    int? totalPengumuman,
    int? totalJadwalMengajar,
    String? error,
    bool? isOnline,
    DateTime? lastSync,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      totalUsers: totalUsers ?? this.totalUsers,
      totalTeachers: totalTeachers ?? this.totalTeachers,
      totalStudents: totalStudents ?? this.totalStudents,
      totalMapels: totalMapels ?? this.totalMapels,
      totalClasses: totalClasses ?? this.totalClasses,
      totalPengumuman: totalPengumuman ?? this.totalPengumuman,
      totalJadwalMengajar: totalJadwalMengajar ?? this.totalJadwalMengajar,
      error: error,
      isOnline: isOnline ?? this.isOnline,
      lastSync: lastSync ?? this.lastSync,
    );
  }
}

// Admin Bloc
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivityService = ConnectivityService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final AutoSyncService _autoSyncService = AutoSyncService();

  // Track previous connectivity state to avoid unnecessary reloads
  bool _previousConnectivityState = true;
  Timer? _connectivityDebounceTimer;

  AdminBloc() : super(AdminState()) {
    on<LoadAdminData>(_onLoadAdminData);
    on<RefreshAdminData>(_onRefreshAdminData);
    on<UpdateUserStats>(_onUpdateUserStats);
    on<TriggerManualSync>(_onTriggerManualSync);
    on<GetSyncStatus>(_onGetSyncStatus);

    // Initialize services and setup connectivity listener
    _initializeServices();
    _setupConnectivityListener();
  }

  Future<void> _initializeServices() async {
    await _connectivityService.initialize();
    await _localStorageService.initialize();

    // Store initial connectivity state
    _previousConnectivityState = _connectivityService.isOnline;

    // Start auto background sync after services are initialized
    await _autoSyncService.startAutoSync();
    debugPrint('🚀 AdminBloc initialized with auto sync service');
  }

  void _setupConnectivityListener() {
    _connectivityService.addListener(() {
      final currentState = _connectivityService.isOnline;

      // Only trigger reload if connectivity state actually changed
      if (currentState != _previousConnectivityState) {
        // Cancel any pending reload
        _connectivityDebounceTimer?.cancel();

        // Debounce the reload to avoid rapid fire reloads
        _connectivityDebounceTimer = Timer(const Duration(milliseconds: 500), () {
          debugPrint(
            '🌐🔄 Connectivity changed: ${_previousConnectivityState ? "Online" : "Offline"} → ${currentState ? "Online" : "Offline"}',
          );
          _previousConnectivityState = currentState;
          add(LoadAdminData());
        });
      }
    });
  }

  @override
  Future<void> close() {
    _connectivityDebounceTimer?.cancel();
    _autoSyncService.dispose();
    debugPrint('🛑 AdminBloc disposed - auto sync stopped');
    return super.close();
  }

  // Stream untuk real-time admin data
  Stream<AdminState> getAdminDataStream() async* {
    yield state.copyWith(isLoading: true);

    await for (final _ in Stream.periodic(const Duration(seconds: 1))) {
      try {
        final futures = await Future.wait([
          _firestore.collection('guru').get(),
          _firestore.collection('siswa').get(),
          _firestore.collection('mapel').get(),
          _firestore.collection('kelas').get(),
          _firestore.collection('pengumuman').get(),
          _firestore.collection('kelas_ngajar').get(),
        ]);

        final guruSnapshot = futures[0];
        final siswaSnapshot = futures[1];
        final mapelSnapshot = futures[2];
        final classesSnapshot = futures[3];
        final pengumumanSnapshot = futures[4];
        final kelasNgajarSnapshot = futures[5];

        final totalTeachers = guruSnapshot.docs.length;
        final totalStudents = siswaSnapshot.docs.length;
        final totalUsers = totalTeachers + totalStudents;
        final totalMapels = mapelSnapshot.docs.length;
        final totalClasses = classesSnapshot.docs.length;
        final totalPengumuman = pengumumanSnapshot.docs.length;
        final totalJadwalMengajar = kelasNgajarSnapshot.docs.length;

        yield AdminState(
          isLoading: false,
          totalUsers: totalUsers,
          totalTeachers: totalTeachers,
          totalStudents: totalStudents,
          totalMapels: totalMapels,
          totalClasses: totalClasses,
          totalPengumuman: totalPengumuman,
          totalJadwalMengajar: totalJadwalMengajar,
        );
      } catch (e) {
        yield AdminState(
          isLoading: false,
          error: 'Failed to load data: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _onLoadAdminData(
    LoadAdminData event,
    Emitter<AdminState> emit,
  ) async {
    // Don't show loading if we're just refreshing with existing data
    final hasExistingData = state.totalUsers > 0;

    if (!hasExistingData) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      // Check connectivity
      final isOnline = _connectivityService.isOnline;
      debugPrint('🔄 Loading admin data - Online: $isOnline');

      if (isOnline) {
        // Try loading from Firebase with timeout fallback
        try {
          await _loadDataFromFirebase(emit).timeout(
            const Duration(seconds: 10),
            onTimeout: () async {
              debugPrint(
                '⏰ Firebase request timed out, falling back to local storage',
              );
              await _loadDataFromLocalStorage(emit);
            },
          );
        } catch (e) {
          debugPrint('❌ Firebase failed: $e, falling back to local storage');
          await _loadDataFromLocalStorage(emit);
        }
      } else {
        // Load from local storage when offline - no delay needed
        debugPrint('📴 Offline mode - loading from local storage...');
        await _loadDataFromLocalStorage(emit);
      }
    } catch (e) {
      debugPrint('❌ Failed to load admin data: $e');
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _loadDataFromFirebase(Emitter<AdminState> emit) async {
    try {
      debugPrint('🔥 Loading data from Firebase...');

      // Get counts from Firebase collections
      final futures = await Future.wait([
        _firestore.collection('guru').get(),
        _firestore.collection('siswa').get(),
        _firestore.collection('mapel').get(),
        _firestore.collection('kelas').get(),
        _firestore.collection('pengumuman').get(),
        _firestore.collection('kelas_ngajar').get(),
      ]);

      final guruSnapshot = futures[0];
      final siswaSnapshot = futures[1];
      final mapelSnapshot = futures[2];
      final kelasSnapshot = futures[3];
      final pengumumanSnapshot = futures[4];
      final kelasNgajarSnapshot = futures[5];

      final totalTeachers = guruSnapshot.docs.length;
      final totalStudents = siswaSnapshot.docs.length;
      final totalUsers = totalTeachers + totalStudents;
      final totalMapels = mapelSnapshot.docs.length;
      final totalClasses = kelasSnapshot.docs.length;
      final totalPengumuman = pengumumanSnapshot.docs.length;
      final totalJadwalMengajar = kelasNgajarSnapshot.docs.length;

      debugPrint('🔥 Firebase data loaded successfully:');
      debugPrint(
        '🔥 Guru: $totalTeachers, Siswa: $totalStudents, Kelas: $totalClasses, Mapel: $totalMapels, Pengumuman: $totalPengumuman',
      );

      // Save to local storage for offline use
      debugPrint('💾 Saving Firebase data to local storage...');
      await _syncFirestoreToLocalStorage(
        guruSnapshot: guruSnapshot,
        siswaSnapshot: siswaSnapshot,
        kelasSnapshot: kelasSnapshot,
        mapelSnapshot: mapelSnapshot,
        pengumumanSnapshot: pengumumanSnapshot,
        kelasNgajarSnapshot: kelasNgajarSnapshot,
      );

      await _localStorageService.saveAdminStats(
        totalGuru: totalTeachers,
        totalSiswa: totalStudents,
        totalKelas: totalClasses,
        totalMapel: totalMapels,
        totalPengumuman: totalPengumuman,
        totalJadwalMengajar: totalJadwalMengajar,
      );

      emit(
        state.copyWith(
          isLoading: false,
          totalUsers: totalUsers,
          totalTeachers: totalTeachers,
          totalStudents: totalStudents,
          totalMapels: totalMapels,
          totalClasses: totalClasses,
          totalPengumuman: totalPengumuman,
          totalJadwalMengajar: totalJadwalMengajar,
          isOnline: _connectivityService.isOnline,
          lastSync: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load data from Firebase: ${e.toString()}',
          isOnline: true,
        ),
      );
    }
  }

  IconData _mapIconFromString(String? name) {
    switch (name) {
      case 'person_add':
        return Icons.person_add;
      case 'upload_file':
        return Icons.upload_file;
      case 'backup':
        return Icons.backup;
      case 'school':
        return Icons.school;
      case 'check_circle':
        return Icons.check_circle;
      case 'person_remove':
        return Icons.person_remove;
      case 'analytics':
        return Icons.analytics;
      case 'security':
        return Icons.security;
      case 'tune':
        return Icons.tune;
      case 'info':
      default:
        return Icons.info;
    }
  }

  Future<void> _loadDataFromLocalStorage(Emitter<AdminState> emit) async {
    try {
      debugPrint('💾 Loading data from local storage...');

      final localData = await _localStorageService.getAdminStats();
      final lastSync = await _localStorageService.getLastSync();

      if (localData != null) {
        debugPrint('💾 Local data found and loaded successfully');
        debugPrint('💾 Last sync: ${lastSync ?? 'Never'}');

        // Print all offline database content
        debugPrint(
          '🏪 Switching to OFFLINE DATABASE mode - Printing all data:',
        );
        await _localStorageService.printAllOfflineData();

        emit(
          state.copyWith(
            isLoading: false,
            totalUsers: localData['totalSiswa'] + localData['totalGuru'],
            totalTeachers: localData['totalGuru'],
            totalStudents: localData['totalSiswa'],
            totalMapels: localData['totalMapel'],
            totalClasses: localData['totalKelas'],
            totalPengumuman: localData['totalPengumuman'],
            isOnline: _connectivityService.isOnline,
            lastSync: lastSync,
          ),
        );
      } else {
        // No local data available - create sample data for testing
        debugPrint('❌ No local data available - creating sample data...');
        await _localStorageService.createSampleOfflineData();

        // Print all offline database content
        debugPrint('🏪 OFFLINE DATABASE mode - Printing all data:');
        await _localStorageService.printAllOfflineData();

        // Try loading again after creating sample data
        final sampleData = await _localStorageService.getAdminStats();
        if (sampleData != null) {
          emit(
            state.copyWith(
              isLoading: false,
              totalUsers: sampleData['totalSiswa'] + sampleData['totalGuru'],
              totalTeachers: sampleData['totalGuru'],
              totalStudents: sampleData['totalSiswa'],
              totalMapels: sampleData['totalMapel'],
              totalClasses: sampleData['totalKelas'],
              totalPengumuman: sampleData['totalPengumuman'],
              isOnline: _connectivityService.isOnline,
              lastSync: DateTime.now(),
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              error: 'Failed to create sample data.',
              isOnline: _connectivityService.isOnline,
            ),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load offline data: ${e.toString()}',
          isOnline: false,
        ),
      );
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Never';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  Future<void> _onRefreshAdminData(
    RefreshAdminData event,
    Emitter<AdminState> emit,
  ) async {
    try {
      // Check connectivity and refresh accordingly
      final isOnline = _connectivityService.isOnline;

      if (isOnline) {
        await _loadDataFromFirebase(emit);
      } else {
        await _loadDataFromLocalStorage(emit);
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to refresh data: ${e.toString()}'));
    }
  }

  void _onUpdateUserStats(UpdateUserStats event, Emitter<AdminState> emit) {
    emit(
      state.copyWith(
        totalUsers: event.stats['totalUsers'],
        totalTeachers: event.stats['totalTeachers'],
        totalStudents: event.stats['totalStudents'],
        totalMapels: event.stats['totalMapels'],
      ),
    );
  }

  /// Handle manual sync trigger
  Future<void> _onTriggerManualSync(
    TriggerManualSync event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      debugPrint('🔄 Manual sync triggered from AdminBloc');
      final success = await _autoSyncService.syncNow();

      if (success) {
        // Reload admin data after successful sync
        add(LoadAdminData());
        debugPrint('✅ Manual sync completed successfully');
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error:
                'Sync failed - no internet connection or sync already in progress',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Manual sync failed: $e'));
      debugPrint('❌ Manual sync failed: $e');
    }
  }

  /// Handle get sync status
  void _onGetSyncStatus(GetSyncStatus event, Emitter<AdminState> emit) {
    final status = _autoSyncService.getSyncStatus();
    debugPrint('📊 Sync status: $status');
    // Could emit sync status in state if needed
  }

  /// Sync all Firestore collections to local storage
  Future<void> _syncFirestoreToLocalStorage({
    required QuerySnapshot guruSnapshot,
    required QuerySnapshot siswaSnapshot,
    required QuerySnapshot kelasSnapshot,
    required QuerySnapshot mapelSnapshot,
    required QuerySnapshot pengumumanSnapshot,
    required QuerySnapshot kelasNgajarSnapshot,
  }) async {
    try {
      debugPrint('🔄 Starting full Firestore → Local Storage sync...');

      // Convert Firestore documents to local storage format

      // 1. Sync Guru data
      final guruData = guruSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'nama_lengkap': data['nama_lengkap'] ?? data['nama'] ?? '',
          'email': data['email'] ?? '',
          'mapel': data['mapel'] ?? '',
          'created_at':
              data['created_at']?.toString() ??
              DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      // 2. Sync Siswa data
      final siswaData = siswaSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'nama': data['nama'] ?? '',
          'email': data['email'] ?? '',
          'kelas': data['kelas'] ?? '',
          'created_at':
              data['created_at']?.toString() ??
              DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      // 3. Sync Kelas data
      final kelasData = kelasSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'nama_kelas': data['nama_kelas'] ?? data['nama'] ?? '',
          'wali_kelas': data['wali_kelas'] ?? '',
          'jumlah_siswa': data['jumlah_siswa'] ?? 0,
          'created_at':
              data['created_at']?.toString() ??
              DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      // 4. Sync Mapel data
      final mapelData = mapelSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'namaMapel': data['namaMapel'] ?? data['nama'] ?? '',
          'kode': data['kode'] ?? '',
          'sks': data['sks'] ?? 0,
          'deskripsi': data['deskripsi'] ?? '',
          'created_at':
              data['created_at']?.toString() ??
              DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      // 5. Sync Pengumuman data
      final pengumumanData = pengumumanSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'judul': data['judul'] ?? '',
          'isi': data['isi'] ?? '',
          'tanggal':
              data['tanggal']?.toString() ?? DateTime.now().toIso8601String(),
          'penulis': data['penulis'] ?? '',
          'status': data['status'] ?? 'active',
          'created_at':
              data['created_at']?.toString() ??
              DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      // 6. Sync Kelas Ngajar (Teaching Schedule) data
      final kelasNgajarData = kelasNgajarSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'id_guru': data['id_guru'] ?? '',
          'id_kelas': data['id_kelas'] ?? '',
          'id_mapel': data['id_mapel'] ?? '',
          'hari': data['hari'] ?? '',
          'jam': data['jam'] ?? '',
          'tanggal':
              data['tanggal']?.toString() ?? DateTime.now().toIso8601String(),
          'createdAt':
              data['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
          'updatedAt':
              data['updatedAt']?.toString() ?? DateTime.now().toIso8601String(),
        };
      }).toList();

      // Save all data to local storage
      await Future.wait([
        _localStorageService.saveGuruData(guruData),
        _localStorageService.saveSiswaData(siswaData),
        _localStorageService.saveKelasData(kelasData),
        _localStorageService.saveMapelData(mapelData),
        _localStorageService.savePengumumanData(pengumumanData),
        _localStorageService.saveKelasNgajarData(kelasNgajarData),
      ]);

      debugPrint('✅ Firestore → Local Storage sync completed!');
      debugPrint(
        '📊 Synced: ${guruData.length} guru, ${siswaData.length} siswa, ${kelasData.length} kelas, ${mapelData.length} mapel, ${pengumumanData.length} pengumuman, ${kelasNgajarData.length} jadwal mengajar',
      );

      // Print all synced data for verification
      debugPrint('🏪 SYNC COMPLETE - Printing all synced data:');
      await _localStorageService.printAllOfflineData();
    } catch (e) {
      debugPrint('❌ Error syncing Firestore to Local Storage: $e');
    }
  }

  // Helper methods for admin operations
  Future<void> addUser(String email, String role) async {
    debugPrint('Adding user: $email with role: $role');
    // Here should be code to add user to Firebase (omitted)
  }

  Future<void> removeUser(String userId) async {
    debugPrint('Removing user: $userId');
    // Remove user logic (omitted)
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    debugPrint('Updating user $userId to role: $newRole');
    // Update role logic (omitted)
  }

  Future<void> generateReport() async {
    debugPrint('Generating admin report...');
    // Report generation (omitted)
  }

  Future<void> backupData() async {
    debugPrint('Starting data backup...');
    // Backup logic (omitted)
  }
}
