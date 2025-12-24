import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/config/theme.dart';

/// Helper class untuk dialog-dialog yang digunakan di MateriGuruScreen
class MateriGuruDialogs {
  /// Menampilkan dialog preview materi
  static void showPreviewDialog(
    BuildContext context,
    Map<String, dynamic> details,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (c) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getColorForMimeType(
                        details['mimeType'],
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForMimeType(details['mimeType']),
                      color: _getColorForMimeType(details['mimeType']),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preview Materi',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          details['judul'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
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
              _buildDetailRow(Icons.title, 'Judul', details['judul'], isDark),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.description,
                'Deskripsi',
                details['deskripsi'],
                isDark,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.class_, 'Kelas', details['kelas'], isDark),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.book, 'Mapel', details['mapel'], isDark),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.folder,
                'File',
                '${details['fileCount']} file',
                isDark,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey[800]
                      : AppTheme.primaryPurple.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryPurple.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Fitur preview lengkap akan segera hadir!',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showFileListDialog(context, details);
                    },
                    icon: const Icon(Icons.list_alt, size: 18),
                    label: const Text('Lihat List PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Tutup',
                      style: TextStyle(color: Colors.grey[600]),
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

  /// Menampilkan dialog untuk upload/edit materi
  static void showFormDialog(
    BuildContext context,
    String title,
    Map<String, dynamic>? materiData,
    List<Map<String, String>> kelasList,
    List<Map<String, String>> mapelList,
    Function(Map<String, dynamic>) onSave,
  ) {
    final formKey = GlobalKey<FormState>();
    final judulController = TextEditingController(text: materiData?['judul']);
    final deskripsiController = TextEditingController(
      text: materiData?['deskripsi'],
    );
    String? selectedKelasId = materiData?['id_kelas'];
    String? selectedMapelId = materiData?['id_mapel'];

    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.sunsetGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  materiData == null ? Icons.upload_file : Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: judulController,
                    decoration: InputDecoration(
                      labelText: 'Judul Materi',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: deskripsiController,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                    validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedKelasId,
                    decoration: InputDecoration(
                      labelText: 'Kelas',
                      prefixIcon: const Icon(Icons.class_),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: kelasList
                        .map(
                          (k) => DropdownMenuItem(
                            value: k['id'],
                            child: Text(k['nama'] ?? ''),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedKelasId = v),
                    validator: (v) => v == null ? 'Wajib dipilih' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedMapelId,
                    decoration: InputDecoration(
                      labelText: 'Mata Pelajaran',
                      prefixIcon: const Icon(Icons.book),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: mapelList
                        .map(
                          (m) => DropdownMenuItem(
                            value: m['id'],
                            child: Text(m['nama'] ?? ''),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedMapelId = v),
                    validator: (v) => v == null ? 'Wajib dipilih' : null,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Fitur upload file akan segera hadir',
                        ),
                        backgroundColor: AppTheme.primaryPurple,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Pilih File'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final data = {
                    'id': materiData?['id'],
                    'judul': judulController.text,
                    'deskripsi': deskripsiController.text,
                    'id_kelas': selectedKelasId,
                    'id_mapel': selectedMapelId,
                  };
                  onSave(data);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(materiData == null ? 'Upload' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  /// Menampilkan dialog konfirmasi hapus
  static void showDeleteDialog(
    BuildContext context,
    Map<String, dynamic> materiData,
    Function() onDelete,
  ) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Text(
          'Yakin hapus materi "${materiData['judul']}"? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Helper functions
  static Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppTheme.primaryPurple),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ],
  );

  static IconData _getIconForMimeType(String mimeType) {
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

  static Color _getColorForMimeType(String mimeType) {
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

  /// Menampilkan dialog list file PDF/dokumen
  static void showFileListDialog(
    BuildContext context,
    Map<String, dynamic> details,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                      Icons.folder_open,
                      color: AppTheme.primaryPurple,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daftar File',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          details['judul'],
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
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
              // Load files from Firestore
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _loadMateriFiles(details['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppTheme.primaryPurple,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Memuat file...',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }

                    final files = snapshot.data ?? [];

                    if (files.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tidak ada file',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];
                        return _buildFileItem(context, file, isDark);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
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

  /// Load materi files from Firestore
  static Future<List<Map<String, dynamic>>> _loadMateriFiles(
    String materiId,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Get materi_files
      final materiFilesSnap = await firestore
          .collection('materi_files')
          .where('id_materi', isEqualTo: int.parse(materiId))
          .get();

      final List<Map<String, dynamic>> filesList = [];

      for (final materiFileDoc in materiFilesSnap.docs) {
        final fileId = materiFileDoc.data()['id_files'];

        if (fileId != null) {
          // Get file details
          final fileDoc = await firestore
              .collection('files')
              .doc(fileId.toString())
              .get();

          if (fileDoc.exists) {
            final fileData = fileDoc.data();

            // Construct URL dari drive_file_id jika webViewLink null
            String downloadUrl = '';
            if (fileData != null) {
              // Cek webViewLink dulu
              downloadUrl = fileData['webViewLink'] ?? '';

              // Jika webViewLink null, gunakan drive_file_id untuk construct URL
              if (downloadUrl.isEmpty && fileData['drive_file_id'] != null) {
                final driveFileId = fileData['drive_file_id'];
                downloadUrl =
                    'https://drive.google.com/file/d/$driveFileId/view';
              }
            }

            filesList.add({
              'id': fileDoc.id,
              'name': fileData?['name'] ?? fileData?['fileName'] ?? 'Untitled',
              'mimeType':
                  fileData?['mimeType'] ??
                  fileData?['mime_type'] ??
                  'application/pdf',
              'downloadUrl': downloadUrl,
              'driveFileId': fileData?['drive_file_id'] ?? '',
              'size': fileData?['size'] ?? fileData?['fileSize'] ?? 0,
            });
          }
        }
      }

      return filesList;
    } catch (e) {
      debugPrint('Error loading materi files: $e');
      rethrow;
    }
  }

  /// Build file item widget
  static Widget _buildFileItem(
    BuildContext context,
    Map<String, dynamic> file,
    bool isDark,
  ) {
    final String fileName = file['name'] ?? 'Untitled';
    final String mimeType = file['mimeType'] ?? '';
    final String downloadUrl = file['downloadUrl'] ?? '';
    final int fileSize = file['size'] ?? 0;

    // Format file size
    String formattedSize = '';
    if (fileSize < 1024) {
      formattedSize = '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      formattedSize = '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      formattedSize = '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getColorForMimeType(mimeType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconForMimeType(mimeType),
                color: _getColorForMimeType(mimeType),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        formattedSize,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getFileTypeLabel(mimeType),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: downloadUrl.isEmpty
                      ? null
                      : () {
                          debugPrint('View button clicked: $downloadUrl');
                          _openFile(downloadUrl);
                        },
                  icon: const Icon(Icons.visibility),
                  color: downloadUrl.isEmpty
                      ? Colors.grey
                      : AppTheme.primaryPurple,
                  tooltip: downloadUrl.isEmpty
                      ? 'URL tidak tersedia'
                      : 'Lihat File',
                  style: IconButton.styleFrom(
                    backgroundColor: downloadUrl.isEmpty
                        ? Colors.grey.withOpacity(0.1)
                        : AppTheme.primaryPurple.withOpacity(0.1),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: downloadUrl.isEmpty
                      ? null
                      : () {
                          debugPrint('Download button clicked: $downloadUrl');
                          // Untuk download, gunakan driveFileId
                          final driveFileId = file['driveFileId'] ?? '';
                          if (driveFileId.isNotEmpty) {
                            final downloadLink =
                                'https://drive.google.com/uc?export=download&id=$driveFileId';
                            _downloadFile(downloadLink, fileName);
                          } else {
                            _downloadFile(downloadUrl, fileName);
                          }
                        },
                  icon: const Icon(Icons.download),
                  color: downloadUrl.isEmpty
                      ? Colors.grey
                      : AppTheme.secondaryTeal,
                  tooltip: downloadUrl.isEmpty
                      ? 'URL tidak tersedia'
                      : 'Download File',
                  style: IconButton.styleFrom(
                    backgroundColor: downloadUrl.isEmpty
                        ? Colors.grey.withOpacity(0.1)
                        : AppTheme.secondaryTeal.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Open file URL
  static Future<void> _openFile(String url) async {
    if (url.isEmpty) {
      debugPrint('URL is empty');
      return;
    }

    try {
      debugPrint('Opening file: $url');
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
  }

  /// Download file URL
  static Future<void> _downloadFile(String url, String fileName) async {
    if (url.isEmpty) {
      debugPrint('URL is empty');
      return;
    }

    try {
      debugPrint('Downloading file: $url');
      final uri = Uri.parse(url);
      // Open in browser untuk download
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error downloading file: $e');
    }
  }

  /// Get file type label
  static String _getFileTypeLabel(String mimeType) {
    if (mimeType.contains('pdf')) return 'PDF';
    if (mimeType.contains('video')) return 'Video';
    if (mimeType.contains('presentation') || mimeType.contains('powerpoint')) {
      return 'Presentasi';
    }
    if (mimeType.contains('word') || mimeType.contains('document')) {
      return 'Dokumen';
    }
    if (mimeType.contains('image')) return 'Gambar';
    return 'File';
  }
}
