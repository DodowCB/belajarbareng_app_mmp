import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/services/google_drive_service.dart';
import '../../../../core/providers/connectivity_provider.dart';

class DetailTugasKelasScreen extends ConsumerStatefulWidget {
  final String kelasId;
  final String namaKelas;
  final String namaGuru;
  final Color color;

  const DetailTugasKelasScreen({
    super.key,
    required this.kelasId,
    required this.namaKelas,
    required this.namaGuru,
    required this.color,
  });

  @override
  ConsumerState<DetailTugasKelasScreen> createState() => _DetailTugasKelasScreenState();
}

class _DetailTugasKelasScreenState extends ConsumerState<DetailTugasKelasScreen> {
  String _selectedFilter = 'Semua';
  final GoogleDriveService _driveService = GoogleDriveService();
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadingFileName = '';
  bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final siswaId = userProvider.userId;
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(widget.namaKelas),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOnline ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOnline ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOnline ? Icons.wifi : Icons.wifi_off,
                  color: isOnline ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: isOnline ? Colors.green[700] : Colors.red[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Kelas Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.class_,
                    color: widget.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.namaKelas,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.namaGuru,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Filter Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardDark : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Belum Dikumpulkan'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Sudah Dikumpulkan'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Terlambat'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // List Tugas
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tugas')
                  .where('id_kelas', isEqualTo: widget.kelasId)
                  .snapshots(),
              builder: (context, tugasSnapshot) {
                if (tugasSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: widget.color),
                  );
                }

                if (tugasSnapshot.hasError) {
                  return Center(child: Text('Error: ${tugasSnapshot.error}'));
                }

                if (!tugasSnapshot.hasData ||
                    tugasSnapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada tugas',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final tugasDocs = tugasSnapshot.data!.docs;

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchTugasData(tugasDocs, siswaId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: widget.color),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada tugas'));
                    }

                    var tugasList = snapshot.data!;

                    // Filter by status
                    if (_selectedFilter != 'Semua') {
                      tugasList = tugasList
                          .where((t) => t['status'] == _selectedFilter)
                          .toList();
                    }

                    if (tugasList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tidak ada tugas dengan filter "$_selectedFilter"',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    // Sort by deadline
                    tugasList.sort((a, b) {
                      final deadlineA = (a['deadline'] as Timestamp).toDate();
                      final deadlineB = (b['deadline'] as Timestamp).toDate();
                      return deadlineA.compareTo(deadlineB);
                    });

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktop = constraints.maxWidth >= 1024;
                        final isTablet = constraints.maxWidth >= 600 && 
                                         constraints.maxWidth < 1024;
                        
                        if (isDesktop) {
                          // Desktop: 3 columns grid
                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                            itemCount: tugasList.length,
                            itemBuilder: (context, index) {
                              final tugas = tugasList[index];
                              return _buildTugasCard(
                                context: context,
                                tugas: tugas,
                                isDark: isDark,
                                siswaId: siswaId,
                              );
                            },
                          );
                        } else if (isTablet) {
                          // Tablet: 2 columns grid
                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.2,
                            ),
                            itemCount: tugasList.length,
                            itemBuilder: (context, index) {
                              final tugas = tugasList[index];
                              return _buildTugasCard(
                                context: context,
                                tugas: tugas,
                                isDark: isDark,
                                siswaId: siswaId,
                              );
                            },
                          );
                        } else {
                          // Mobile: ListView
                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: tugasList.length,
                            itemBuilder: (context, index) {
                              final tugas = tugasList[index];
                              return _buildTugasCard(
                                context: context,
                                tugas: tugas,
                                isDark: isDark,
                                siswaId: siswaId,
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: isDark ? AppTheme.cardDark : Colors.grey[200],
      selectedColor: widget.color.withOpacity(0.2),
      checkmarkColor: widget.color,
      labelStyle: TextStyle(
        color: isSelected
            ? widget.color
            : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchTugasData(
    List<QueryDocumentSnapshot> tugasDocs,
    String siswaId,
  ) async {
    final tugasList = <Map<String, dynamic>>[];

    for (var tugasDoc in tugasDocs) {
      final tugasData = tugasDoc.data() as Map<String, dynamic>;
      final tugasId = tugasDoc.id;

        // Check submission status (support numeric or string IDs)
        final dynamic parsedSiswaId = int.tryParse(siswaId) ?? siswaId;
        final dynamic parsedTugasId = int.tryParse(tugasId) ?? tugasId;
        final pengumpulanQuery = await FirebaseFirestore.instance
          .collection('pengumpulan')
          .where('siswa_id', isEqualTo: parsedSiswaId)
          .where('tugas_id', isEqualTo: parsedTugasId)
          .limit(1)
          .get();

      final isSubmitted = pengumpulanQuery.docs.isNotEmpty;
      final deadline = tugasData['deadline'] as Timestamp;
      final status = _getStatusFromDeadline(deadline, isSubmitted);

      tugasList.add({
        'tugasId': tugasId,
        'judul': tugasData['judul'] ?? tugasData['title'] ?? 'Tugas',
        'deskripsi': tugasData['deskripsi'] ?? tugasData['description'] ?? '',
        'deadline': deadline,
        'status': status,
        'isSubmitted': isSubmitted,
        'pengumpulanId': isSubmitted ? pengumpulanQuery.docs.first.id : null,
      });
    }

    return tugasList;
  }

  String _getStatusFromDeadline(Timestamp deadline, bool isSubmitted) {
    if (isSubmitted) return 'Sudah Dikumpulkan';

    final now = DateTime.now();
    final deadlineDate = deadline.toDate();

    if (now.isAfter(deadlineDate)) {
      return 'Terlambat';
    }
    return 'Belum Dikumpulkan';
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Sudah Dikumpulkan':
        return AppTheme.accentGreen;
      case 'Terlambat':
        return Colors.red;
      default:
        return AppTheme.accentOrange;
    }
  }

  Widget _buildTugasCard({
    required BuildContext context,
    required Map<String, dynamic> tugas,
    required bool isDark,
    required String siswaId,
  }) {
    final deadline = tugas['deadline'] as Timestamp;
    final status = tugas['status'] as String;
    final statusColor = _getColorForStatus(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          _showTugasDetail(context, tugas, siswaId);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [widget.color.withOpacity(0.08), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon assignment di sisi kiri
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment,
                    color: widget.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul tugas
                      Text(
                        tugas['judul'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Deadline dengan icon
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _formatDate(deadline),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTugasDetail(
    BuildContext context,
    Map<String, dynamic> tugas,
    String siswaId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.cardDark
                  : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: _buildTugasDetailContent(
                    context,
                    tugas,
                    siswaId,
                    scrollController,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTugasDetailContent(
    BuildContext context,
    Map<String, dynamic> tugas,
    String siswaId,
    ScrollController scrollController,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = tugas['status'] as String;
    final statusColor = _getColorForStatus(status);
    final isSubmitted = tugas['isSubmitted'] as bool;

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tugas['judul'],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSubmitted ? Icons.check_circle : Icons.pending,
                  size: 18,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Deadline: ${_formatDate(tugas['deadline'])}',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Deskripsi Tugas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tugas['deskripsi'].isEmpty
                ? 'Tidak ada deskripsi'
                : tugas['deskripsi'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          if (isSubmitted) ...[
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            _buildSubmissionSection(tugas['tugasId'], siswaId),
            const SizedBox(height: 24),
          ],
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 16),
          _buildUploadSection(
            context,
            tugas['tugasId'],
            siswaId,
            status,
            isSubmitted,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionSection(String tugasId, String siswaId) {
    // Get pengumpulan records by siswa_id dan tugas_id
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pengumpulan')
          .where('siswa_id', isEqualTo: int.tryParse(siswaId) ?? siswaId)
          .where('tugas_id', isEqualTo: int.tryParse(tugasId) ?? tugasId)
          .snapshots(),
      builder: (context, pengumpulanSnapshot) {
        if (!pengumpulanSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (pengumpulanSnapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }

        // Get file_ids from pengumpulan
        final fileIds = pengumpulanSnapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((data) => data['file_id'] != null)
            .map((data) => data['file_id'].toString())
            .toList();

        if (fileIds.isEmpty) {
          return const SizedBox();
        }

        // Get files from pengumpulan_files collection
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pengumpulan_files')
              .where(FieldPath.documentId, whereIn: fileIds)
              .snapshots(),
          builder: (context, filesSnapshot) {
            if (!filesSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final files = filesSnapshot.data!.docs;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.accentGreen,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'File Terkumpul',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (files.isEmpty)
                  Text(
                    'Tidak ada file',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                else
                  ...files.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildFileCard(data);
                  }),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFileCard(Map<String, dynamic> fileData) {
    final fileName = fileData['name'] ?? 'File';
    final driveFileId = fileData['drive_file_id']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(
          Icons.insert_drive_file,
          color: AppTheme.primaryPurple,
        ),
        title: Text(fileName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () async {
                if (driveFileId.isNotEmpty) {
                  final url =
                      'https://drive.google.com/file/d/$driveFileId/view';
                  final uri = Uri.parse(url);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                if (driveFileId.isNotEmpty) {
                  final url =
                      'https://drive.google.com/uc?export=download&id=$driveFileId';
                  final uri = Uri.parse(url);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(
    BuildContext context,
    String tugasId,
    String siswaId,
    String status,
    bool isSubmitted,
  ) {
    final isTerlambat = status == 'Terlambat';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isSubmitted ? 'Ganti File Tugas' : 'Kumpulkan Tugas',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (isSubmitted) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Upload file baru akan mengganti file yang sudah dikumpulkan',
                    style: TextStyle(fontSize: 13, color: Colors.blue[700]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (isTerlambat && !isSubmitted) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.red, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tugas sudah terlambat. Tolong hubungi ${widget.namaGuru} untuk pengumpulan tugas.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isUploading
                  ? null
                  : () => _pickAndUploadFile(context, tugasId, siswaId),
              icon: _isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(
                _isUploading
                    ? 'Mengupload...'
                    : isSubmitted
                    ? 'Pilih & Ganti File (PDF/ZIP)'
                    : 'Pilih & Upload File (PDF/ZIP)',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (_isUploading && _uploadProgress > 0) ...[
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mengupload: $_uploadingFileName',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _uploadProgress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Future<void> _pickAndUploadFile(
    BuildContext context,
    String tugasId,
    String siswaId,
  ) async {
    try {
      debugPrint('=== PICK AND UPLOAD FILE STARTED ===');

      // Check if signed in to Google Drive
      if (!_isSignedIn) {
        debugPrint('❌ User not signed in to Google Drive');
        if (context.mounted) {
          final shouldSignIn = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Sign In Required'),
              content: const Text(
                'You need to sign in to Google Drive first to upload files.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                  ),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          );

          if (shouldSignIn == true) {
            await _signInToGoogleDrive();
            if (!_isSignedIn) {
              return; // Sign in failed, don't proceed
            }
            // Continue to file picker after successful sign in
          } else {
            return; // User cancelled
          }
        }
      }

      // Use file_picker for cross-platform file selection
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'zip'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        debugPrint('No file selected');
        return;
      }

      final file = result.files.first;
      final fileName = file.name.toLowerCase();

      // Check file extension
      final isAllowed = fileName.endsWith('.pdf') || fileName.endsWith('.zip');

      if (!isAllowed) {
        debugPrint('❌ File type not supported: ${file.name}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hanya file PDF atau ZIP yang diperbolehkan'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Get file bytes
      final fileBytes = file.bytes;

      if (fileBytes == null || fileBytes.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Gagal membaca file')));
        }
        return;
      }

      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
        _uploadingFileName = file.name;
      });

      // Update progress
      setState(() => _uploadProgress = 0.2);

      // Find or create folder structure: BelajarBareng MMP/pengumpulan
      String? belajarBarengFolderId = await _driveService.findFolderByName(
        folderName: 'BelajarBareng MMP',
      );

      if (belajarBarengFolderId == null) {
        final folderResult = await _driveService.createFolder(
          folderName: 'BelajarBareng MMP',
        );
        belajarBarengFolderId = folderResult?['id'];
      }

      setState(() => _uploadProgress = 0.3);

      String? pengumpulanFolderId;
      if (belajarBarengFolderId != null) {
        pengumpulanFolderId = await _driveService.findFolderByName(
          folderName: 'pengumpulan',
          parentFolderId: belajarBarengFolderId,
        );

        if (pengumpulanFolderId == null) {
          final folderResult = await _driveService.createFolder(
            folderName: 'pengumpulan',
            parentFolderId: belajarBarengFolderId,
          );
          pengumpulanFolderId = folderResult?['id'];
        }
      }

      setState(() => _uploadProgress = 0.5);

      // Upload to Google Drive
      final uploadResult = await _driveService.uploadFile(
        fileName: file.name,
        fileBytes: fileBytes,
        mimeType: fileName.endsWith('.pdf')
            ? 'application/pdf'
            : 'application/zip',
        folderId: pengumpulanFolderId,
      );

      setState(() => _uploadProgress = 0.8);

      final driveFileId = uploadResult?['id'];

      if (driveFileId == null) {
        throw Exception('Gagal upload ke Google Drive');
      }

      // Check if there's existing submission and delete it
        final existingPengumpulan = await FirebaseFirestore.instance
          .collection('pengumpulan')
          .where('siswa_id', isEqualTo: int.tryParse(siswaId) ?? siswaId)
          .where('tugas_id', isEqualTo: int.tryParse(tugasId) ?? tugasId)
          .get();

      // Delete old pengumpulan records and their files
      for (var doc in existingPengumpulan.docs) {
        final data = doc.data();
        final oldFileId = data['file_id']?.toString();

        // Delete old file from Google Drive and Firestore
        if (oldFileId != null) {
          // Get drive_file_id from pengumpulan_files
          final fileDoc = await FirebaseFirestore.instance
              .collection('pengumpulan_files')
              .doc(oldFileId)
              .get();

          if (fileDoc.exists) {
            final fileData = fileDoc.data();
            final driveFileIdToDelete = fileData?['drive_file_id']?.toString();

            // Delete from Google Drive
            if (driveFileIdToDelete != null) {
              try {
                await _driveService.deleteFile(driveFileIdToDelete);
                debugPrint(
                  '✅ Deleted old file from Google Drive: $driveFileIdToDelete',
                );
              } catch (e) {
                debugPrint('⚠️ Failed to delete file from Drive: $e');
                // Continue even if Drive deletion fails
              }
            }

            // Delete file record from Firestore
            await fileDoc.reference.delete();
          }
        }

        // Delete pengumpulan record
        await doc.reference.delete();
      }

      // Get next ID for pengumpulan_files (string number: "1", "2", "3", etc)
      final filesSnapshot = await FirebaseFirestore.instance
          .collection('pengumpulan_files')
          .get();

      final nextFileId = (filesSnapshot.docs.length + 1).toString();

      // Save file to pengumpulan_files collection with manual ID
      await FirebaseFirestore.instance
          .collection('pengumpulan_files')
          .doc(nextFileId)
          .set({
            'name': file.name,
            'drive_file_id': driveFileId,
            'size': file.size,
            'mimeType': fileName.endsWith('.pdf')
                ? 'application/pdf'
                : 'application/zip',
            'uploadedAt': FieldValue.serverTimestamp(),
          });

      // Get next ID for pengumpulan
      final pengumpulanSnapshot = await FirebaseFirestore.instance
          .collection('pengumpulan')
          .get();

      final nextPengumpulanId = (pengumpulanSnapshot.docs.length + 1)
          .toString();

      // Save to pengumpulan (many-to-many relation) with manual ID
      await FirebaseFirestore.instance
          .collection('pengumpulan')
          .doc(nextPengumpulanId)
          .set({
            'siswa_id': int.tryParse(siswaId) ?? siswaId,
            'tugas_id': int.tryParse(tugasId) ?? tugasId,
            'file_id': int.tryParse(nextFileId) ?? nextFileId,
            'createdAt': FieldValue.serverTimestamp(),
          });

      setState(() {
        _uploadProgress = 1.0;
        _isUploading = false;
      });

      if (context.mounted) {
        Navigator.pop(context); // Close bottom sheet

        final isReplacing = existingPengumpulan.docs.isNotEmpty;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isReplacing
                  ? 'Berhasil mengganti file tugas: ${file.name}'
                  : 'Berhasil mengumpulkan tugas: ${file.name}',
            ),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal upload: $e')));
      }
    }
  }

  Future<void> _signInToGoogleDrive() async {
    try {
      final account = await _driveService.signIn();

      setState(() {
        _isSignedIn = account != null;
      });

      if (account != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signed in as ${account.email}'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sign in to Google Drive'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSignedIn = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final day = days[date.weekday % 7];
    final month = months[date.month - 1];

    return '$day, ${date.day} $month ${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
