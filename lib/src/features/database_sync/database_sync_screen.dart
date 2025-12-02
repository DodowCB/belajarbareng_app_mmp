import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/database_sync_service.dart';
import '../../core/storage/app_database.dart';

/// Example screen showing how to use offline database
/// This can be integrated into existing admin screens
class DatabaseSyncExampleScreen extends ConsumerStatefulWidget {
  const DatabaseSyncExampleScreen({super.key});

  @override
  ConsumerState<DatabaseSyncExampleScreen> createState() =>
      _DatabaseSyncExampleScreenState();
}

class _DatabaseSyncExampleScreenState
    extends ConsumerState<DatabaseSyncExampleScreen> {
  bool _isSyncing = false;
  String _statusMessage = 'Ready';
  Map<String, int>? _stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final database = ref.read(appDatabaseProvider);
    final stats = await database.getDatabaseStats();
    setState(() {
      _stats = stats;
    });
  }

  Future<void> _syncAllData() async {
    setState(() {
      _isSyncing = true;
      _statusMessage = 'Syncing data from Firestore...';
    });

    try {
      final database = ref.read(appDatabaseProvider);
      final firestore = FirebaseFirestore.instance;
      final syncService = DatabaseSyncService(database, firestore);

      await syncService.syncAllFromFirestore();

      await _loadStats();

      setState(() {
        _isSyncing = false;
        _statusMessage = '✅ Sync completed successfully';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Data berhasil disinkronkan'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSyncing = false;
        _statusMessage = '❌ Sync failed: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: $e')),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua data offline?\n\n'
          'Data di Firestore tidak akan terhapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final database = ref.read(appDatabaseProvider);
        await database.clearAllData();

        await _loadStats();

        setState(() {
          _statusMessage = '🗑️ All data cleared';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data offline berhasil dihapus'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _processPendingSync() async {
    setState(() {
      _isSyncing = true;
      _statusMessage = 'Processing pending sync...';
    });

    try {
      final database = ref.read(appDatabaseProvider);
      final firestore = FirebaseFirestore.instance;
      final syncService = DatabaseSyncService(database, firestore);

      await syncService.processSyncQueue();

      await _loadStats();

      setState(() {
        _isSyncing = false;
        _statusMessage = '✅ Pending sync processed';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pending sync berhasil diproses'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSyncing = false;
        _statusMessage = '❌ Process failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Offline Manager'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isSyncing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _statusMessage.startsWith('✅')
                                    ? Icons.check_circle
                                    : _statusMessage.startsWith('❌')
                                    ? Icons.error
                                    : Icons.info,
                                color: _statusMessage.startsWith('✅')
                                    ? Colors.green
                                    : _statusMessage.startsWith('❌')
                                    ? Colors.red
                                    : Colors.blue,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(_statusMessage),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Card
                  if (_stats != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.storage, color: Colors.deepPurple),
                                SizedBox(width: 12),
                                Text(
                                  'Database Statistics',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _buildStatRow('Kelas', _stats!['kelas'] ?? 0),
                            _buildStatRow('Mapel', _stats!['mapel'] ?? 0),
                            _buildStatRow(
                              'Kelas Ngajar',
                              _stats!['kelas_ngajar'] ?? 0,
                            ),
                            _buildStatRow(
                              'Pengumuman',
                              _stats!['pengumuman'] ?? 0,
                            ),
                            _buildStatRow('Guru', _stats!['guru'] ?? 0),
                            _buildStatRow('Siswa', _stats!['siswa'] ?? 0),
                            _buildStatRow(
                              'Siswa Kelas',
                              _stats!['siswa_kelas'] ?? 0,
                            ),
                            const Divider(height: 24),
                            _buildStatRow(
                              'Pending Sync',
                              _stats!['sync_queue'] ?? 0,
                              highlighted: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Actions
                  const Text(
                    'Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _syncAllData,
                    icon: const Icon(Icons.sync),
                    label: const Text('Sync All Data from Firestore'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _processPendingSync,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Process Pending Sync Queue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _loadStats,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Stats'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _clearAllData,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Clear All Offline Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatRow(String label, int value, {bool highlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
              color: highlighted ? Colors.deepPurple : null,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: highlighted
                  ? Colors.deepPurple.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: highlighted ? Colors.deepPurple : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
