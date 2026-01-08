import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/services/google_drive_service.dart';
import '../../widgets/guru_app_scaffold.dart';
import 'materi_guru_dialogs.dart';

class MateriGuruScreen extends ConsumerStatefulWidget {
  const MateriGuruScreen({super.key});

  @override
  ConsumerState<MateriGuruScreen> createState() => _MateriGuruScreenState();
}

class _MateriGuruScreenState extends ConsumerState<MateriGuruScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleDriveService _driveService = GoogleDriveService();
  String _searchQuery = '';
  String _selectedKelas = 'Semua Kelas';
  String _selectedMapel = 'Semua Mapel';

  List<Map<String, String>> _kelasList = [];
  List<Map<String, String>> _mapelList = [];

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final userProv = UserProvider();
    final guruId = userProv.userId;
    if (guruId == null) return;

    try {
      // Load kelas dari kelas_ngajar
      final kelasNgajarSnap = await _firestore
          .collection('kelas_ngajar')
          .where('id_guru', isEqualTo: guruId)
          .get();

      final kelasIds = <String>{};
      final mapelIds = <String>{};

      for (final doc in kelasNgajarSnap.docs) {
        final data = doc.data();
        if (data['id_kelas'] != null) kelasIds.add(data['id_kelas']);
        if (data['id_mapel'] != null) mapelIds.add(data['id_mapel']);
      }

      // Load nama kelas
      final kelasList = <Map<String, String>>[];
      for (final id in kelasIds) {
        final kelasDoc = await _firestore.collection('kelas').doc(id).get();
        if (kelasDoc.exists) {
          kelasList.add({
            'id': id,
            'nama': kelasDoc.data()?['nama_kelas'] ?? 'Kelas',
          });
        }
      }

      // Load nama mapel
      final mapelList = <Map<String, String>>[];
      for (final id in mapelIds) {
        final mapelDoc = await _firestore.collection('mapel').doc(id).get();
        if (mapelDoc.exists) {
          mapelList.add({
            'id': id,
            'nama': mapelDoc.data()?['namaMapel'] ?? 'Mapel',
          });
        }
      }

      setState(() {
        _kelasList = kelasList;
        _mapelList = mapelList;
      });
    } catch (e) {
      debugPrint('Error loading filters: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = UserProvider();
    final guruId = userProv.userId;

    return GuruAppScaffold(
      title: 'Materi Pembelajaran',
      icon: Icons.book,
      currentRoute: '/materi',
      additionalActions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _showUploadDialog(context),
          tooltip: 'Upload Materi',
        ),
      ],
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getMateriStream(guruId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                final materiList = _buildMateriList(snapshot.data!.docs);

                if (materiList.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildMateriGrid(materiList);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(context),
        icon: const Icon(Icons.upload_file, color: Colors.white),
        label: const Text(
          'Upload Materi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  Stream<QuerySnapshot> _getMateriStream(String? guruId) {
    if (guruId == null) {
      return const Stream.empty();
    }

    // Base query - hanya filter berdasarkan guru (tanpa orderBy untuk menghindari composite index)
    Query query = _firestore
        .collection('materi')
        .where('id_guru', isEqualTo: guruId);

    return query.snapshots();
  }

  List<Map<String, dynamic>> _buildMateriList(
    List<QueryDocumentSnapshot> docs,
  ) {
    List<Map<String, dynamic>> materiList = [];

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final judul = data['judul'] ?? 'Materi';
      final deskripsi = data['deskripsi'] ?? '';
      final idKelas = data['id_kelas'];
      final idMapel = data['id_mapel'];

      // Apply kelas filter
      if (_selectedKelas != 'Semua Kelas') {
        final kelasId = _kelasList.firstWhere(
          (k) => k['nama'] == _selectedKelas,
          orElse: () => {},
        )['id'];
        if (kelasId != null && idKelas != kelasId) {
          continue;
        }
      }

      // Apply mapel filter
      if (_selectedMapel != 'Semua Mapel') {
        final mapelId = _mapelList.firstWhere(
          (m) => m['nama'] == _selectedMapel,
          orElse: () => {},
        )['id'];
        if (mapelId != null && idMapel != mapelId) {
          continue;
        }
      }

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!judul.toLowerCase().contains(q) &&
            !deskripsi.toLowerCase().contains(q)) {
          continue;
        }
      }

      materiList.add({
        'id': doc.id,
        'judul': judul,
        'deskripsi': deskripsi,
        'id_kelas': idKelas,
        'id_mapel': idMapel,
        'createdAt': data['createdAt'],
        'updatedAt': data['updatedAt'],
      });
    }

    // Sort by createdAt descending (newest first)
    materiList.sort((a, b) {
      final aTime = a['createdAt'] as Timestamp?;
      final bTime = b['createdAt'] as Timestamp?;
      if (aTime == null || bTime == null) return 0;
      return bTime.compareTo(aTime);
    });

    return materiList;
  }

  Widget _buildFilterBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Build kelas dropdown items
    final kelasItems = ['Semua Kelas', ..._kelasList.map((k) => k['nama']!)];
    final mapelItems = ['Semua Mapel', ..._mapelList.map((m) => m['nama']!)];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Cari materi...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDark
                  ? AppTheme.backgroundDark
                  : AppTheme.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile: Stack vertically
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedKelas,
                      decoration: InputDecoration(
                        labelText: 'Filter Kelas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: kelasItems
                          .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedKelas = v!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedMapel,
                      decoration: InputDecoration(
                        labelText: 'Filter Mapel',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: mapelItems
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedMapel = v!),
                    ),
                  ],
                );
              } else {
                // Desktop/Tablet: Row layout
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedKelas,
                        decoration: InputDecoration(
                          labelText: 'Filter Kelas',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: kelasItems
                            .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedKelas = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedMapel,
                        decoration: InputDecoration(
                          labelText: 'Filter Mapel',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: mapelItems
                            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedMapel = v!),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.folder_open, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'Tidak ada materi',
          style: TextStyle(fontSize: 18, color: Colors.grey[400]),
        ),
      ],
    ),
  );

  Widget _buildMateriGrid(List<Map<String, dynamic>> materiList) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 1200
            ? 3
            : constraints.maxWidth >= 768
            ? 2
            : 1;
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: materiList.length,
          itemBuilder: (c, i) => _buildMateriCard(materiList[i], isDark),
        );
      },
    );
  }

  Widget _buildMateriCard(Map<String, dynamic> m, bool isDark) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getMateriDetails(m),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final details = snapshot.data!;
        final icon = _getIconForMimeType(details['mimeType']);
        final color = _getColorForMimeType(details['mimeType']);

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _showPreviewDialog(context, details),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      const Spacer(),
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        itemBuilder: (c) => [
                          const PopupMenuItem(
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(Icons.visibility, size: 20),
                                SizedBox(width: 8),
                                Text('Lihat'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (v) {
                          if (v == 'view') _showPreviewDialog(context, details);
                          if (v == 'edit') _showEditDialog(context, details);
                          if (v == 'delete') _confirmDelete(context, details);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    details['judul'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details['deskripsi'],
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.class_,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          details['kelas'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.book,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          details['mapel'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.folder,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${details['fileCount']} file',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        details['tanggal'],
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getMateriDetails(
    Map<String, dynamic> materi,
  ) async {
    // Get kelas name
    String kelasName = 'Kelas';
    if (materi['id_kelas'] != null) {
      final kelasDoc = await _firestore
          .collection('kelas')
          .doc(materi['id_kelas'])
          .get();
      if (kelasDoc.exists) {
        kelasName = kelasDoc.data()?['nama_kelas'] ?? 'Kelas';
      }
    }

    // Get mapel name
    String mapelName = 'Mapel';
    if (materi['id_mapel'] != null) {
      final mapelDoc = await _firestore
          .collection('mapel')
          .doc(materi['id_mapel'])
          .get();
      if (mapelDoc.exists) {
        mapelName = mapelDoc.data()?['namaMapel'] ?? 'Mapel';
      }
    }

    // Get file count and first file mime type
    final materiFilesSnap = await _firestore
        .collection('materi_files')
        .where('id_materi', isEqualTo: int.parse(materi['id']))
        .get();

    debugPrint('Materi ID: ${materi['id']}');
    debugPrint('Materi Files Count: ${materiFilesSnap.docs.length}');

    final fileCount = materiFilesSnap.docs.length;
    String mimeType = 'application/octet-stream';
    String? status;
    String? youtubeUrl;

    if (fileCount > 0) {
      final firstFileId = materiFilesSnap.docs.first.data()['id_files'];
      debugPrint('First File ID: $firstFileId');

      final fileDoc = await _firestore
          .collection('files')
          .doc(firstFileId.toString())
          .get();

      debugPrint('File Doc Exists: ${fileDoc.exists}');

      if (fileDoc.exists) {
        final fileData = fileDoc.data();
        debugPrint('File Data: $fileData');
        mimeType = fileData?['mimeType'] ?? 'application/octet-stream';
        status = fileData?['status'];
        youtubeUrl = fileData?['url_youtube'];

        debugPrint('Extracted - Status: $status, YouTube URL: $youtubeUrl');
      }
    }

    // Format date
    String tanggal = '';
    if (materi['createdAt'] != null) {
      final date = (materi['createdAt'] as Timestamp).toDate();
      tanggal = DateFormat('dd MMM yyyy').format(date);
    }

    return {
      ...materi,
      'kelas': kelasName,
      'mapel': mapelName,
      'fileCount': fileCount,
      'mimeType': mimeType,
      'status': status,
      'youtubeUrl': youtubeUrl,
      'tanggal': tanggal,
    };
  }

  IconData _getIconForMimeType(String mimeType) {
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
    if (mimeType.contains('video')) return Icons.video_library;
    if (mimeType.contains('presentation') || mimeType.contains('powerpoint')) {
      return Icons.slideshow;
    }
    if (mimeType.contains('word') || mimeType.contains('document')) {
      return Icons.description;
    }
    if (mimeType.contains('image')) return Icons.image;
    return Icons.insert_drive_file;
  }

  Color _getColorForMimeType(String mimeType) {
    if (mimeType.contains('pdf')) return Colors.red;
    if (mimeType.contains('video')) return Colors.blue;
    if (mimeType.contains('presentation') || mimeType.contains('powerpoint')) {
      return AppTheme.accentOrange;
    }
    if (mimeType.contains('word') || mimeType.contains('document')) {
      return Colors.indigo;
    }
    if (mimeType.contains('image')) return Colors.green;
    return AppTheme.secondaryTeal;
  }

  void _showPreviewDialog(BuildContext context, Map<String, dynamic> details) {
    MateriGuruDialogs.showPreviewDialog(context, details);
  }

  void _showUploadDialog(BuildContext context) {
    MateriGuruDialogs.showFormDialog(
      context,
      'Upload Materi Baru',
      null,
      _kelasList,
      _mapelList,
      (data) async {
        try {
          // Ambil ID guru dari UserProvider
          final userProv = UserProvider();
          final idGuru = userProv.userId;

          if (idGuru == null) {
            throw Exception('User tidak login');
          }

          // Buat dokumen materi dengan ID sequential
          final materiSnapshot = await FirebaseFirestore.instance
              .collection('materi')
              .get();

          final nextMateriId = (materiSnapshot.docs.length + 1).toString();

          // Simpan materi
          await FirebaseFirestore.instance
              .collection('materi')
              .doc(nextMateriId)
              .set({
                'id_guru': idGuru,
                'id_kelas': data['id_kelas'],
                'id_mapel': data['id_mapel'],
                'judul': data['judul'],
                'deskripsi': data['deskripsi'],
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),
              });

          // Jika mode YouTube, simpan ke collection files
          if (data['isYoutubeMode'] == true && data['youtubeUrl'] != null) {
            // Buat dokumen files dengan ID sequential
            final filesSnapshot = await FirebaseFirestore.instance
                .collection('files')
                .get();

            final nextFileId = (filesSnapshot.docs.length + 1).toString();

            // Simpan file YouTube
            await FirebaseFirestore.instance
                .collection('files')
                .doc(nextFileId)
                .set({
                  'url_youtube': data['youtubeUrl'],
                  'status': 'youtube',
                  'name': null,
                  'drive_file_id': null,
                  'size': null,
                  'mimeType': null,
                  'uploadedAt': FieldValue.serverTimestamp(),
                });

            // Simpan relasi materi_files
            final materiFilesSnapshot = await FirebaseFirestore.instance
                .collection('materi_files')
                .get();

            final nextRelationId = (materiFilesSnapshot.docs.length + 1)
                .toString();

            await FirebaseFirestore.instance
                .collection('materi_files')
                .doc(nextRelationId)
                .set({
                  'id_materi': int.parse(nextMateriId),
                  'id_files': int.parse(nextFileId),
                });

            debugPrint(
              'Saved materi_files: id_materi=${int.parse(nextMateriId)}, id_files=${int.parse(nextFileId)}',
            );
          }
          // Jika mode File, upload ke Google Drive
          else if (data['fileBytes'] != null && data['fileName'] != null) {
            try {
              // Cari atau buat folder BelajarBareng MMP
              String? folderId = await _driveService.findFolderByName(
                folderName: 'BelajarBareng MMP',
              );

              if (folderId == null) {
                final folderData = await _driveService.createFolder(
                  folderName: 'BelajarBareng MMP',
                );
                folderId = folderData?['id'];
              }

              // Cari atau buat subfolder materi
              String? materiFolderId = await _driveService.findFolderByName(
                folderName: 'materi',
                parentFolderId: folderId,
              );

              if (materiFolderId == null) {
                final folderData = await _driveService.createFolder(
                  folderName: 'materi',
                  parentFolderId: folderId,
                );
                materiFolderId = folderData?['id'];
              }

              // Upload file ke Google Drive
              final driveFile = await _driveService.uploadFile(
                fileName: data['fileName'],
                fileBytes: data['fileBytes'],
                folderId: materiFolderId,
              );

              if (driveFile == null) {
                throw Exception('Gagal upload file ke Google Drive');
              }

              // Buat dokumen files dengan ID sequential
              final filesSnapshot = await FirebaseFirestore.instance
                  .collection('files')
                  .get();

              final nextFileId = (filesSnapshot.docs.length + 1).toString();

              // Simpan metadata file ke Firestore
              await FirebaseFirestore.instance
                  .collection('files')
                  .doc(nextFileId)
                  .set({
                    'name': driveFile['name'],
                    'drive_file_id': driveFile['id'],
                    'size': driveFile['size'],
                    'mimeType': driveFile['mimeType'],
                    'status': 'file',
                    'url_youtube': null,
                    'uploadedAt': FieldValue.serverTimestamp(),
                  });

              // Simpan relasi materi_files
              final materiFilesSnapshot = await FirebaseFirestore.instance
                  .collection('materi_files')
                  .get();

              final nextRelationId = (materiFilesSnapshot.docs.length + 1)
                  .toString();

              await FirebaseFirestore.instance
                  .collection('materi_files')
                  .doc(nextRelationId)
                  .set({
                    'id_materi': int.parse(nextMateriId),
                    'id_files': int.parse(nextFileId),
                  });
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error upload file: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              return;
            }
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Materi berhasil diupload'),
                  ],
                ),
                backgroundColor: AppTheme.accentGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );

            // Refresh UI
            setState(() {});
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
            );
          }
        }
      },
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> details) {
    MateriGuruDialogs.showFormDialog(
      context,
      'Edit Materi',
      details,
      _kelasList,
      _mapelList,
      (data) {
        // TODO: Update Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Materi berhasil diperbarui'),
              ],
            ),
            backgroundColor: AppTheme.accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> details) {
    MateriGuruDialogs.showDeleteDialog(context, details, () {
      // TODO: Delete from Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Materi berhasil dihapus'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    });
  }
}
