import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/providers/connectivity_provider.dart';
import 'create_tugas_screen.dart';
import '../../widgets/guru_app_scaffold.dart';

class TugasListScreen extends ConsumerStatefulWidget {
  const TugasListScreen({super.key});

  @override
  ConsumerState<TugasListScreen> createState() => _TugasListScreenState();
}

class _TugasListScreenState extends ConsumerState<TugasListScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  String _searchQuery = '';
  List<Map<String, dynamic>> _tugasList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    initializeDateFormatting('id_ID', null);
    _loadTugas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTugas() async {
    setState(() => _isLoading = true);

    try {
      final guruId = userProvider.userId ?? '';

      final snapshot = await _firestore
          .collection('tugas')
          .where('id_guru', isEqualTo: guruId)
          .get();

      final List<Map<String, dynamic>> tugasList = [];
      final batch = _firestore.batch();
      final now = DateTime.now();

      for (final doc in snapshot.docs) {
        final data = doc.data();

        // Check if deadline has passed and status is still Aktif
        var currentStatus = data['status'] ?? 'Aktif';
        if (data['deadline'] is Timestamp) {
          final deadline = (data['deadline'] as Timestamp).toDate();
          if (deadline.isBefore(now) && currentStatus == 'Aktif') {
            // Auto-update status to Selesai if deadline passed
            currentStatus = 'Selesai';
            batch.update(doc.reference, {'status': 'Selesai'});
          }
        }

        // Get jumlah pengumpulan - try both string and integer
        var pengumpulanSnapshot = await _firestore
            .collection('pengumpulan')
            .where('tugas_id', isEqualTo: int.parse(doc.id))
            .get();

        // If no results, try with string
        if (pengumpulanSnapshot.docs.isEmpty) {
          pengumpulanSnapshot = await _firestore
              .collection('pengumpulan')
              .where('tugas_id', isEqualTo: doc.id)
              .get();
        }

        // Count total files from pengumpulan_files
        int totalFiles = 0;

        for (final pengumpulanDoc in pengumpulanSnapshot.docs) {
          final pengumpulanData = pengumpulanDoc.data();

          // Get file_id from pengumpulan document
          final fileIds = pengumpulanData['file_id'];

          if (fileIds != null) {
            // file_id could be a single string, int, or array of strings/ints
            if (fileIds is List) {
              totalFiles += fileIds.length;
            } else if (fileIds is String && fileIds.isNotEmpty) {
              totalFiles += 1;
            } else if (fileIds is int) {
              totalFiles += 1;
            }
          }
        }

        tugasList.add({
          'id': doc.id,
          'judul': data['judul'] ?? '',
          'deskripsi': data['deskripsi'] ?? '',
          'id_kelas': data['id_kelas']?.toString() ?? '',
          'kelas': data['kelas'] ?? '',
          'deadline': data['deadline'],
          'status': currentStatus,
          'jumlahSiswa': data['jumlahSiswa'] ?? 0,
          'sudahMengumpulkan': pengumpulanSnapshot.docs.length,
          'totalFiles': totalFiles,
        });
      }

      // Commit batch update for status changes
      await batch.commit();

      // Sort by deadline (nearest first)
      tugasList.sort((a, b) {
        final deadlineA = a['deadline'] is Timestamp
            ? (a['deadline'] as Timestamp).toDate()
            : DateTime.now();
        final deadlineB = b['deadline'] is Timestamp
            ? (b['deadline'] as Timestamp).toDate()
            : DateTime.now();
        return deadlineA.compareTo(deadlineB);
      });

      setState(() {
        _tugasList = tugasList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getFilteredList(String status) {
    var list = status == 'Semua'
        ? _tugasList
        : _tugasList.where((t) => t['status'] == status).toList();

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (t) => '${t['judul']} ${t['deskripsi']} ${t['kelas']}'
                .toLowerCase()
                .contains(q),
          )
          .toList();
    }
    return list;
  }

  Future<void> _deleteTugas(String tugasId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firestore.collection('tugas').doc(tugasId).delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tugas berhasil dihapus'),
              backgroundColor: Colors.green,
            ),
          );
          _loadTugas();
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

  Future<void> _downloadAllFiles(String tugasId) async {
    try {
      // Show loading
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Mengunduh file...'),
              ],
            ),
          ),
        );
      }

      // Get all pengumpulan for this tugas
      var pengumpulanSnapshot = await _firestore
          .collection('pengumpulan')
          .where('tugas_id', isEqualTo: int.parse(tugasId))
          .get();

      // If no results, try with string
      if (pengumpulanSnapshot.docs.isEmpty) {
        pengumpulanSnapshot = await _firestore
            .collection('pengumpulan')
            .where('tugas_id', isEqualTo: tugasId)
            .get();
      }

      if (pengumpulanSnapshot.docs.isEmpty) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak ada file yang dikumpulkan'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      int downloadedCount = 0;

      // Get files for each pengumpulan using file_id
      for (final pengumpulanDoc in pengumpulanSnapshot.docs) {
        final pengumpulanData = pengumpulanDoc.data();
        final fileIds = pengumpulanData['file_id'];

        if (fileIds != null) {
          List<String> fileIdList = [];

          // Handle single string, int, or array of strings/ints
          if (fileIds is List) {
            fileIdList = fileIds.map((id) => id.toString()).toList();
          } else if (fileIds is String && fileIds.isNotEmpty) {
            fileIdList = [fileIds];
          } else if (fileIds is int) {
            fileIdList = [fileIds.toString()];
          }

          // Download each file by document ID
          for (final fileId in fileIdList) {
            try {
              final fileDoc = await _firestore
                  .collection('pengumpulan_files')
                  .doc(fileId)
                  .get();

              if (fileDoc.exists) {
                final fileData = fileDoc.data()!;

                // Get file URL and name
                final fileUrl =
                    fileData['url'] ??
                    fileData['file_url'] ??
                    fileData['drive_file_id'] ??
                    '';
                final fileName =
                    fileData['name'] ??
                    fileData['file_name'] ??
                    'file_${fileDoc.id}';

                if (fileUrl.isNotEmpty) {
                  // Open/download file using url_launcher
                  try {
                    final uri = Uri.parse(fileUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      downloadedCount++;
                    }
                  } catch (e) {
                    // Silent error handling for individual file
                  }

                  // Small delay between downloads
                  await Future.delayed(const Duration(milliseconds: 500));
                }
              }
            } catch (e) {
              // Silent error handling
            }
          }
        }
      }

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil mengunduh $downloadedCount file'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch connectivity status for real-time updates
    final isOnline = ref.watch(isOnlineProvider);

    return GuruAppScaffold(
      title: 'Manajemen Tugas',
      icon: Icons.assignment,
      currentRoute: '/tugas',
      additionalActions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            final isOnline = ref.read(isOnlineProvider);
            if (!isOnline) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anda harus online untuk membuat tugas.'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                ),
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateTugasScreen(),
              ),
            ).then((result) {
              if (result == true) {
                _loadTugas();
              }
            });
          },
          tooltip: 'Buat Tugas',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadTugas,
          tooltip: 'Refresh',
        ),
      ],
      body: Column(
        children: [
          if (!isOnline) _buildOfflineBanner(),
          // Search and Tabs
          Container(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: Column(
              children: [
                // Search
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Cari tugas...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
                    ),
                  ),
                ),
                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryPurple,
                  unselectedLabelColor: isDark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                  indicatorColor: AppTheme.primaryPurple,
                  tabs: const [
                    Tab(text: 'Semua'),
                    Tab(text: 'Aktif'),
                    Tab(text: 'Selesai'),
                  ],
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTugasTab(_getFilteredList('Semua')),
                      _buildTugasTab(_getFilteredList('Aktif')),
                      _buildTugasTab(_getFilteredList('Selesai')),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: null, // Removed since we have action in header
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.orange.shade100,
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.orange.shade900, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mode Offline - Fitur CRUD tidak tersedia',
              style: TextStyle(
                color: Colors.orange.shade900,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTugasTab(List<Map<String, dynamic>> tugasList) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (tugasList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada tugas',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Buat tugas baru dengan tombol + di bawah',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tugasList.length,
      itemBuilder: (context, index) {
        final tugas = tugasList[index];
        return _buildTugasCard(tugas, isDark);
      },
    );
  }

  Widget _buildTugasCard(Map<String, dynamic> tugas, bool isDark) {
    final deadline = tugas['deadline'] is Timestamp
        ? (tugas['deadline'] as Timestamp).toDate()
        : DateTime.now();
    final isOverdue = deadline.isBefore(DateTime.now());
    final jumlahSiswa = tugas['jumlahSiswa'] as int;
    final sudahMengumpulkan = tugas['sudahMengumpulkan'] as int;
    final progress = jumlahSiswa > 0 ? sudahMengumpulkan / jumlahSiswa : 0.0;
    final isActive = tugas['status'] == 'Aktif';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          _showTugasDetailDialog(tugas);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.primaryPurple.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: isActive ? AppTheme.primaryPurple : Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tugas['judul'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.class_,
                              size: 14,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tugas['kelas'] ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreateTugasScreen(tugas: tugas),
                          ),
                        );
                        if (result == true) {
                          _loadTugas();
                        }
                      } else if (value == 'delete') {
                        _deleteTugas(tugas['id']);
                      } else if (value == 'download') {
                        _downloadAllFiles(tugas['id']);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'download',
                        child: Row(
                          children: [
                            Icon(Icons.download, size: 18, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Download Semua File',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                tugas['deskripsi'] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      Icons.people,
                      'Total Siswa',
                      jumlahSiswa.toString(),
                      AppTheme.secondaryTeal,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildStatItem(
                      Icons.done_all,
                      'Mengumpulkan',
                      sudahMengumpulkan.toString(),
                      progress == 1.0 ? Colors.green : AppTheme.accentOrange,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildStatItem(
                      Icons.attach_file,
                      'Total File',
                      tugas['totalFiles']?.toString() ?? '0',
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress Pengumpulan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: progress == 1.0
                              ? Colors.green
                              : AppTheme.accentOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: isDark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress == 1.0 ? Colors.green : AppTheme.accentOrange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Deadline and Status
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue && isActive
                            ? Colors.red.withOpacity(0.1)
                            : AppTheme.secondaryTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isOverdue && isActive
                              ? Colors.red.withOpacity(0.3)
                              : AppTheme.secondaryTeal.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: isOverdue && isActive
                                ? Colors.red
                                : AppTheme.secondaryTeal,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              DateFormat(
                                'dd MMM yyyy, HH:mm',
                                'id_ID',
                              ).format(deadline),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isOverdue && isActive
                                    ? Colors.red
                                    : AppTheme.secondaryTeal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive
                            ? Colors.green.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tugas['status'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showTugasDetailDialog(Map<String, dynamic> tugas) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deadline = tugas['deadline'] is Timestamp
        ? (tugas['deadline'] as Timestamp).toDate()
        : DateTime.now();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: AppTheme.primaryPurple,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Detail Tugas',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.title,
                'Judul',
                tugas['judul'] ?? '',
                isDark,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.description,
                'Deskripsi',
                tugas['deskripsi'] ?? '',
                isDark,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.class_,
                'Kelas',
                tugas['kelas'] ?? '',
                isDark,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.calendar_today,
                'Deadline',
                DateFormat(
                  'EEEE, dd MMMM yyyy - HH:mm',
                  'id_ID',
                ).format(deadline),
                isDark,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.info,
                'Status',
                tugas['status'] ?? '',
                isDark,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.people,
                'Pengumpulan',
                '${tugas['sudahMengumpulkan']}/${tugas['jumlahSiswa']} siswa',
                isDark,
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 450) {
                    // Mobile: Stack buttons vertically
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            _downloadAllFiles(tugas['id']);
                          },
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Download File'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateTugasScreen(tugas: tugas),
                              ),
                            );
                            if (result == true) {
                              _loadTugas();
                            }
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Desktop/Tablet: Row layout
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            _downloadAllFiles(tugas['id']);
                          },
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Download File'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateTugasScreen(tugas: tugas),
                              ),
                            );
                            if (result == true) {
                              _loadTugas();
                            }
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
