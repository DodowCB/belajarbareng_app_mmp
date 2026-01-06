import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/services/google_drive_service.dart';

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
              // Info box
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
                    Expanded(
                      child: Text(
                        details['status'] == 'youtube'
                            ? 'Klik tombol \"Watch Video\" untuk memutar video'
                            : 'Fitur preview lengkap akan segera hadir!',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  if (details['status'] == 'youtube' &&
                      details['youtubeUrl'] != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        showYouTubeVideoDialog(context, details);
                      },
                      icon: const Icon(Icons.play_circle, size: 18),
                      label: const Text('Watch Video'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  else if (details['status'] != 'youtube')
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
    final youtubeUrlController = TextEditingController();
    String? selectedKelasId = materiData?['id_kelas'];
    String? selectedMapelId = materiData?['id_mapel'];
    bool isYoutubeMode = false;
    bool isSignedIn = false;
    bool isCheckingSignIn = true;
    bool isUploadingFile = false;
    double uploadProgress = 0.0;
    String? selectedFileName;
    List<int>? selectedFileBytes;
    final driveService = GoogleDriveService();

    // Check Google Sign In status
    Future<void> checkSignIn(Function(void Function()) setState) async {
      await driveService.initialize();
      setState(() {
        isSignedIn = driveService.isSignedIn;
        isCheckingSignIn = false;
      });
    }

    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setState) {
          // Initialize sign in check
          if (isCheckingSignIn) {
            checkSignIn(setState);
          }

          return AlertDialog(
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
              child: isCheckingSignIn
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : !isSignedIn
                  ? _buildSignInRequired(ctx, driveService, setState, (
                      newValue,
                    ) {
                      isSignedIn = newValue;
                    })
                  : Form(
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
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Wajib diisi' : null,
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
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Wajib diisi' : null,
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
                            onChanged: (v) =>
                                setState(() => selectedKelasId = v),
                            validator: (v) =>
                                v == null ? 'Wajib dipilih' : null,
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
                            onChanged: (v) =>
                                setState(() => selectedMapelId = v),
                            validator: (v) =>
                                v == null ? 'Wajib dipilih' : null,
                          ),
                          const SizedBox(height: 24),
                          // YouTube Switch
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.primaryPurple.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.video_library,
                                  color: AppTheme.primaryPurple,
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Upload dari YouTube',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: isYoutubeMode,
                                  onChanged: (v) =>
                                      setState(() => isYoutubeMode = v),
                                  activeColor: AppTheme.primaryPurple,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Conditional: YouTube URL atau File Upload
                          if (isYoutubeMode)
                            TextFormField(
                              controller: youtubeUrlController,
                              decoration: InputDecoration(
                                labelText: 'URL YouTube',
                                prefixIcon: const Icon(Icons.link),
                                hintText: 'https://www.youtube.com/watch?v=...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (v) {
                                if (v?.isEmpty ?? true) return 'Wajib diisi';
                                if (!v!.contains('youtube.com') &&
                                    !v.contains('youtu.be')) {
                                  return 'URL YouTube tidak valid';
                                }
                                return null;
                              },
                            )
                          else
                            Column(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: isUploadingFile
                                      ? null
                                      : () async {
                                          try {
                                            // Use file_picker for cross-platform support
                                            final result = await FilePicker
                                                .platform
                                                .pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [
                                                    'pdf',
                                                    'zip',
                                                  ],
                                                  withData: true,
                                                );

                                            if (result == null ||
                                                result.files.isEmpty) {
                                              return;
                                            }

                                            final file = result.files.first;

                                            // Validasi ukuran file (max 50MB)
                                            if (file.size > 50 * 1024 * 1024) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Ukuran file maksimal 50MB',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }

                                            setState(() {
                                              selectedFileName = file.name;
                                              isUploadingFile = true;
                                              uploadProgress = 0.0;
                                            });

                                            // Get file bytes
                                            final bytes = file.bytes;
                                            if (bytes == null) {
                                              throw Exception(
                                                'Failed to read file',
                                              );
                                            }

                                            setState(() {
                                              selectedFileBytes = bytes;
                                              uploadProgress = 1.0;
                                              isUploadingFile = false;
                                            });
                                          } catch (e) {
                                            setState(() {
                                              isUploadingFile = false;
                                            });
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Gagal memilih file: $e',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                  icon: Icon(
                                    selectedFileName != null
                                        ? Icons.check_circle
                                        : Icons.attach_file,
                                  ),
                                  label: Text(
                                    selectedFileName ??
                                        'Pilih File (.pdf atau .zip)',
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: selectedFileName != null
                                        ? Colors.green
                                        : AppTheme.primaryPurple,
                                  ),
                                ),
                                if (isUploadingFile) ...[
                                  const SizedBox(height: 12),
                                  LinearProgressIndicator(
                                    value: uploadProgress,
                                    backgroundColor: Colors.grey[200],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppTheme.primaryPurple,
                                        ),
                                  ),
                                ],
                                if (selectedFileName != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        selectedFileName!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, size: 16),
                                        onPressed: () => setState(() {
                                          selectedFileName = null;
                                          selectedFileBytes = null;
                                        }),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ),
            ),
            actions: !isSignedIn
                ? []
                : [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Validasi file jika bukan YouTube mode
                          if (!isYoutubeMode && selectedFileBytes == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Silakan pilih file terlebih dahulu',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final data = {
                            'id': materiData?['id'],
                            'judul': judulController.text,
                            'deskripsi': deskripsiController.text,
                            'id_kelas': selectedKelasId,
                            'id_mapel': selectedMapelId,
                            'isYoutubeMode': isYoutubeMode,
                            'youtubeUrl': isYoutubeMode
                                ? youtubeUrlController.text
                                : null,
                            'fileName': selectedFileName,
                            'fileBytes': selectedFileBytes,
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
          );
        },
      ),
    );
  }

  /// Widget untuk menampilkan pesan sign in required
  static Widget _buildSignInRequired(
    BuildContext context,
    GoogleDriveService driveService,
    Function(void Function()) setState,
    Function(bool) updateSignInStatus,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_off, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'Login Google Drive Diperlukan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Untuk upload materi (file atau YouTube),\nAnda harus login Google Drive terlebih dahulu',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () async {
            try {
              final account = await driveService.signIn();
              if (account != null) {
                setState(() {
                  updateSignInStatus(true);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Login berhasil sebagai ${account.email}'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Login gagal: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          icon: const Icon(Icons.login),
          label: const Text('Login ke Google Drive'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
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

  /// Build YouTube Player iframe
  static Widget _buildYouTubePlayer(String youtubeUrl) {
    // Extract video ID from YouTube URL
    String? videoId = _extractYouTubeId(youtubeUrl);

    if (videoId == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'URL YouTube tidak valid',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    // For mobile platforms, show a thumbnail with play button
    return GestureDetector(
      onTap: () async {
        try {
          final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
          // Try to launch with external application first
          final launched = await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );

          if (!launched) {
            // Fallback to platform default if external app fails
            await launchUrl(url, mode: LaunchMode.platformDefault);
          }
        } catch (e) {
          // Silent fail - just print to debug console
          debugPrint('Failed to open YouTube video: $e');
        }
      },
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(
              'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow, color: Colors.white, size: 48),
          ),
        ),
      ),
    );
  }

  /// Extract YouTube video ID from URL
  static String? _extractYouTubeId(String url) {
    // Support formats:
    // - https://www.youtube.com/watch?v=VIDEO_ID
    // - https://youtu.be/VIDEO_ID
    // - https://www.youtube.com/embed/VIDEO_ID

    final RegExp regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      caseSensitive: false,
    );

    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

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

  /// Show YouTube Video Dialog
  static void showYouTubeVideoDialog(
    BuildContext context,
    Map<String, dynamic> details,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (c) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details['judul'],
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Video Pembelajaran',
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
              // YouTube Player
              _buildYouTubePlayer(details['youtubeUrl']),
              const SizedBox(height: 16),
              // Description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description,
                          size: 20,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details['deskripsi'],
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
