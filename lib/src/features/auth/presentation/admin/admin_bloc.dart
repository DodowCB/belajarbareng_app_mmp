import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/auto_sync_service.dart';

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
  final List<Map<String, dynamic>> recentActivities;
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
    this.recentActivities = const [],
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
    List<Map<String, dynamic>>? recentActivities,
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
      recentActivities: recentActivities ?? this.recentActivities,
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

    // Start auto background sync after services are initialized
    await _autoSyncService.startAutoSync();
    debugPrint('🚀 AdminBloc initialized with auto sync service');
  }

  void _setupConnectivityListener() {
    _connectivityService.addListener(() {
      // When connectivity changes, reload data from appropriate source
      debugPrint('🌐🔄 Connectivity changed - triggering data reload');
      add(LoadAdminData());
    });
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
        ]);

        final guruSnapshot = futures[0];
        final siswaSnapshot = futures[1];
        final mapelSnapshot = futures[2];
        final classesSnapshot = futures[3];
        final pengumumanSnapshot = futures[4];

        final totalTeachers = guruSnapshot.docs.length;
        final totalStudents = siswaSnapshot.docs.length;
        final totalUsers = totalTeachers + totalStudents;
        final totalMapels = mapelSnapshot.docs.length;
        final totalClasses = classesSnapshot.docs.length;
        final totalPengumuman = pengumumanSnapshot.docs.length;

        final recentActivities = [
          {
            'title': 'New user registered',
            'time': '2 minutes ago',
            'icon': Icons.person_add,
          },
          {
            'title': 'Teacher uploaded material',
            'time': '15 minutes ago',
            'icon': Icons.upload_file,
          },
          {
            'title': 'System backup completed',
            'time': '1 hour ago',
            'icon': Icons.backup,
          },
          {
            'title': 'Database optimized',
            'time': '3 hours ago',
            'icon': Icons.tune,
          },
          {
            'title': 'Security scan completed',
            'time': '6 hours ago',
            'icon': Icons.security,
          },
        ];

        yield AdminState(
          isLoading: false,
          totalUsers: totalUsers,
          totalTeachers: totalTeachers,
          totalStudents: totalStudents,
          totalMapels: totalMapels,
          totalClasses: totalClasses,
          totalPengumuman: totalPengumuman,
          recentActivities: recentActivities,
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
    emit(state.copyWith(isLoading: true));

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
        // Load from local storage when offline
        debugPrint('🔄⚠️ Offline detected - checking for local data...');

        // Wait a bit for connectivity status to settle
        await Future.delayed(const Duration(milliseconds: 500));

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
      ]);

      final guruSnapshot = futures[0];
      final siswaSnapshot = futures[1];
      final mapelSnapshot = futures[2];
      final kelasSnapshot = futures[3];
      final pengumumanSnapshot = futures[4];

      final totalTeachers = guruSnapshot.docs.length;
      final totalStudents = siswaSnapshot.docs.length;
      final totalUsers = totalTeachers + totalStudents;
      final totalMapels = mapelSnapshot.docs.length;
      final totalClasses = kelasSnapshot.docs.length;
      final totalPengumuman = pengumumanSnapshot.docs.length;

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
      );

      await _localStorageService.saveAdminStats(
        totalGuru: totalTeachers,
        totalSiswa: totalStudents,
        totalKelas: totalClasses,
        totalMapel: totalMapels,
        totalPengumuman: totalPengumuman,
      );

      final recentActivities = [
        {
          'title': 'New user registered',
          'time': '2 minutes ago',
          'icon': Icons.person_add,
        },
        {
          'title': 'Teacher uploaded material',
          'time': '15 minutes ago',
          'icon': Icons.upload_file,
        },
        {
          'title': 'System backup completed',
          'time': '1 hour ago',
          'icon': Icons.backup,
        },
        {
          'title': 'New course created',
          'time': '2 hours ago',
          'icon': Icons.school,
        },
        {
          'title': 'Student completed course',
          'time': '3 hours ago',
          'icon': Icons.check_circle,
        },
      ];

      emit(
        state.copyWith(
          isLoading: false,
          totalUsers: totalUsers,
          totalTeachers: totalTeachers,
          totalStudents: totalStudents,
          totalMapels: totalMapels,
          totalClasses: totalClasses,
          totalPengumuman: totalPengumuman,
          recentActivities: recentActivities,
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

        final recentActivities = [
          {
            'title': 'Data loaded from cache',
            'time': 'Offline mode',
            'icon': Icons.offline_bolt,
          },
          {
            'title': 'Last sync: ${_formatDateTime(lastSync)}',
            'time': lastSync != null ? _getTimeAgo(lastSync) : 'Never',
            'icon': Icons.sync,
          },
        ];

        emit(
          state.copyWith(
            isLoading: false,
            totalUsers: localData['totalSiswa'] + localData['totalGuru'],
            totalTeachers: localData['totalGuru'],
            totalStudents: localData['totalSiswa'],
            totalMapels: localData['totalMapel'],
            totalClasses: localData['totalKelas'],
            totalPengumuman: localData['totalPengumuman'],
            recentActivities: recentActivities,
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
          final sampleActivities = [
            {
              'title': 'Sample data loaded',
              'time': 'Offline mode',
              'icon': Icons.offline_bolt,
            },
            {
              'title': 'Using test database',
              'time': 'Demo mode',
              'icon': Icons.science,
            },
          ];

          emit(
            state.copyWith(
              isLoading: false,
              totalUsers: sampleData['totalSiswa'] + sampleData['totalGuru'],
              totalTeachers: sampleData['totalGuru'],
              totalStudents: sampleData['totalSiswa'],
              totalMapels: sampleData['totalMapel'],
              totalClasses: sampleData['totalKelas'],
              totalPengumuman: sampleData['totalPengumuman'],
              recentActivities: sampleActivities,
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
  }) async {
    try {
      debugPrint('🔄 Starting full Firestore → Local Storage sync...');

      // Convert Firestore documents to local storage format

      // 1. Sync Guru data
      final guruData = guruSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'nama': data['nama'] ?? '',
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
          'nama': data['nama'] ?? '',
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
          'nama': data['nama'] ?? '',
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

      // Save all data to local storage
      await Future.wait([
        _localStorageService.saveGuruData(guruData),
        _localStorageService.saveSiswaData(siswaData),
        _localStorageService.saveKelasData(kelasData),
        _localStorageService.saveMapelData(mapelData),
        _localStorageService.savePengumumanData(pengumumanData),
      ]);

      debugPrint('✅ Firestore → Local Storage sync completed!');
      debugPrint(
        '📊 Synced: ${guruData.length} guru, ${siswaData.length} siswa, ${kelasData.length} kelas, ${mapelData.length} mapel, ${pengumumanData.length} pengumuman',
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
    // TODO: Implement add user functionality
    debugPrint('Adding user: $email with role: $role');
  }

  Future<void> removeUser(String userId) async {
    // TODO: Implement remove user functionality
    debugPrint('Removing user: $userId');
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    // TODO: Implement update user role functionality
    debugPrint('Updating user $userId to role: $newRole');
  }

  Future<void> generateReport() async {
    // TODO: Implement report generation
    debugPrint('Generating admin report...');
  }

  Future<void> backupData() async {
    // TODO: Implement data backup
    debugPrint('Starting data backup...');
  }

  @override
  Future<void> close() {
    // Dispose auto sync service when bloc is closed
    _autoSyncService.dispose();
    debugPrint('🛑 AdminBloc disposed - auto sync stopped');
    return super.close();
  }
}
