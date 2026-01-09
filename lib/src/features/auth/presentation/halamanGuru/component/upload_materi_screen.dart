import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/google_drive_service.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/providers/connectivity_provider.dart';
import '../../widgets/guru_app_scaffold.dart';
import 'dart:typed_data';

class UploadMateriScreen extends ConsumerStatefulWidget {
  const UploadMateriScreen({super.key});

  @override
  ConsumerState<UploadMateriScreen> createState() => _UploadMateriScreenState();
}

class _UploadMateriScreenState extends ConsumerState<UploadMateriScreen> {
  final _formKey = GlobalKey<FormState>();
  final _driveService = GoogleDriveService();
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool _isSignedIn = false;
  final List<Map<String, dynamic>> _uploadedFiles = [];
  final Map<String, double> _uploadProgress = {}; // Track progress per file
  String? _selectedKelasId;
  String? _selectedMapelId;
  List<Map<String, dynamic>> _kelasList = [];
  List<Map<String, dynamic>> _mapelList = [];
  bool _isDraggingOver = false;

  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeGoogleDrive();
    _loadKelasAndMapel();
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _initializeGoogleDrive() async {
    await _driveService.initialize();
    if (mounted) {
      setState(() {
        _isSignedIn = _driveService.isSignedIn;
      });
    }
  }

  Future<void> _loadKelasAndMapel() async {
    try {
      final guruId = userProvider.userId;

      if (guruId == null) return;

      // Load kelas ngajar
      final kelasNgajarSnapshot = await _firestore
          .collection('kelas_ngajar')
          .where('id_guru', isEqualTo: guruId)
          .get();

      final kelasList = <Map<String, dynamic>>[];
      final mapelIds = <String>{};

      for (final doc in kelasNgajarSnapshot.docs) {
        final data = doc.data();
        final kelasId = data['id_kelas']?.toString();
        final mapelId = data['id_mapel']?.toString();

        if (kelasId != null) {
          final kelasDoc = await _firestore
              .collection('kelas')
              .doc(kelasId)
              .get();
          if (kelasDoc.exists && kelasDoc.data()?['status'] == true) {
            kelasList.add({
              'id': kelasId,
              'nama': kelasDoc.data()?['nama_kelas'] ?? 'Kelas',
            });
          }
        }

        if (mapelId != null) {
          mapelIds.add(mapelId);
        }
      }

      // Load mapel
      final mapelList = <Map<String, dynamic>>[];
      for (final mapelId in mapelIds) {
        final mapelDoc = await _firestore
            .collection('mapel')
            .doc(mapelId)
            .get();
        if (mapelDoc.exists) {
          mapelList.add({
            'id': mapelId,
            'nama': mapelDoc.data()?['namaMapel'] ?? 'Mapel',
          });
        }
      }

      setState(() {
        _kelasList = kelasList;
        _mapelList = mapelList;
      });
    } catch (e) {
      debugPrint('Error loading kelas and mapel: $e');
    }
  }

  Future<void> _signInToGoogleDrive() async {
    try {
      setState(() => _isLoading = true);

      final account = await _driveService.signIn();

      setState(() {
        _isSignedIn = account != null;
        _isLoading = false;
      });

      if (account != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signed in as ${account.email}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
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

  Future<void> _signOutFromGoogleDrive() async {
    try {
      await _driveService.signOut();
      setState(() {
        _isSignedIn = false;
        _uploadedFiles.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickAndUploadFile() async {
    try {
      debugPrint('=== PICK AND UPLOAD FILE STARTED ===');

      // Check connectivity before uploading
      final isOnline = ref.read(isOnlineProvider);
      if (!isOnline) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Anda harus online untuk mengupload file.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      if (!_isSignedIn) {
        debugPrint('❌ User not signed in');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to Google Drive first'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      debugPrint('Showing file picker...');

      // Use file_picker for cross-platform support
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'xls',
          'xlsx',
          'jpg',
          'jpeg',
          'png',
          'mp4',
          'zip',
          'txt',
        ],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        debugPrint('No files selected');
        return;
      }

      debugPrint('Files selected: ${result.files.length}');

      // Upload files one by one with progress tracking
      int successCount = 0;
      int failCount = 0;

      for (final platformFile in result.files) {
        debugPrint('Processing: ${platformFile.name}');
        debugPrint('File size: ${platformFile.size} bytes');

        if (platformFile.bytes == null) {
          debugPrint('❌ Failed to read file bytes: ${platformFile.name}');
          failCount++;
          continue;
        }

        debugPrint('✓ File bytes loaded: ${platformFile.bytes!.length} bytes');

        try {
          await _uploadSingleFile(platformFile);
          successCount++;
          debugPrint('✓ Successfully uploaded: ${platformFile.name}');
        } catch (e) {
          debugPrint('❌ Failed to upload ${platformFile.name}: $e');
          failCount++;

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to upload ${platformFile.name}: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }

      if (mounted && successCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$successCount file(s) uploaded successfully!' +
                  (failCount > 0 ? ' ($failCount failed)' : '') +
                  ' Jangan lupa isi form dan klik "Simpan Materi"',
            ),
            backgroundColor: failCount > 0 ? Colors.orange : Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else if (mounted && failCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All $failCount file(s) failed to upload'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error in _pickAndUploadFile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload files: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadSingleFile(PlatformFile file) async {
    try {
      debugPrint('=== UPLOAD SINGLE FILE ===');
      debugPrint('File name: ${file.name}');
      debugPrint('File size: ${file.size}');
      debugPrint('File bytes null?: ${file.bytes == null}');
      // IMPORTANT: Don't access file.path on web - it will throw an exception
      debugPrint('Platform: Web');

      // Check if bytes are available (web platform)
      if (file.bytes == null) {
        debugPrint('❌ File bytes is NULL!');

        // For web, bytes should always be available
        // If null, it means file picker failed to read the file
        throw Exception(
          'File data not available. This may happen if:\n'
          '1. File is too large\n'
          '2. Browser blocked file access\n'
          '3. File picker was cancelled\n'
          '\nPlease try:\n'
          '- Using a smaller file\n'
          '- Drag & drop instead of browse\n'
          '- Refreshing the page',
        );
      }

      debugPrint('✓ File bytes available: ${file.bytes!.length} bytes');

      // Initialize progress for this file
      setState(() {
        _uploadProgress[file.name] = 0.0;
      });

      // Simulate progress updates (dalam real implementation, bisa dari Drive API)
      _updateProgress(file.name, 0.2);

      // Get or create folder: BelajarBareng MMP/{email}/
      final folderId = await _driveService.getOrCreateAppFolder();
      _updateProgress(file.name, 0.4);

      // Upload to Google Drive in user's folder
      final uploadedFile = await _driveService.uploadFile(
        fileBytes: file.bytes!,
        fileName: file.name,
        folderId: folderId,
        description: 'Uploaded from BelajarBareng App - ${DateTime.now()}',
      );
      _updateProgress(file.name, 0.7);

      if (uploadedFile != null) {
        // Get max ID for new file in 'files' collection
        final filesSnapshot = await _firestore.collection('files').get();
        int maxFileId = 0;
        for (final doc in filesSnapshot.docs) {
          final id = int.tryParse(doc.id) ?? 0;
          if (id > maxFileId) maxFileId = id;
        }
        final newFileId = (maxFileId + 1).toString();

        final driveFileId = uploadedFile['id'] as String;
        debugPrint('=== FILE UPLOADED ===');
        debugPrint('File name: ${uploadedFile['name']}');
        debugPrint('Firestore file_id: $newFileId');
        debugPrint('Google Drive file_id: $driveFileId');
        debugPrint('WebViewLink: ${uploadedFile['webViewLink']}');

        // Save file metadata to 'files' collection
        await _firestore.collection('files').doc(newFileId).set({
          'drive_file_id': driveFileId,
          'name': uploadedFile['name'],
          'mimeType': uploadedFile['mimeType'],
          'size': file.size,
          'webViewLink': uploadedFile['webViewLink'],
          'uploadedBy': userProvider.userId,
          'uploadedAt': FieldValue.serverTimestamp(),
        });
        _updateProgress(file.name, 0.9);

        setState(() {
          _uploadedFiles.add({
            'file_id': newFileId,
            'drive_file_id': driveFileId, // Store drive_file_id for deletion
            'name': uploadedFile['name'],
            'mimeType': uploadedFile['mimeType'],
            'size': file.size,
            'bytes': file.bytes, // Store for preview
          });
          _updateProgress(file.name, 1.0);
        });

        // Remove progress after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          _uploadProgress.remove(file.name);
        });
      }
    } catch (e) {
      setState(() {
        _uploadProgress.remove(file.name);
      });
      rethrow;
    }
  }

  void _updateProgress(String fileName, double progress) {
    setState(() {
      _uploadProgress[fileName] = progress;
    });
  }

  Future<void> _replaceFile(int index) async {
    try {
      if (!_isSignedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to Google Drive first'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Pick replacement file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'xls',
          'xlsx',
          'jpg',
          'jpeg',
          'png',
          'mp4',
          'zip',
          'txt',
        ],
      );

      if (result == null) return;

      final file = result.files.first;
      final oldFile = _uploadedFiles[index];

      // Remove old file from list
      setState(() {
        _uploadedFiles.removeAt(index);
      });

      // Upload new file
      await _uploadSingleFile(file);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File "${oldFile['name']}" replaced successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to replace file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFilePreview(Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      file['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildPreviewContent(file)),
              const SizedBox(height: 16),
              Text(
                'Size: ${GoogleDriveService.formatFileSize(file['size'])}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteFile(int index, Map<String, dynamic> file) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yakin ingin menghapus \"${file['name']}\"?'),
            const SizedBox(height: 12),
            const Text(
              'File akan dihapus dari Google Drive dan tidak bisa dikembalikan.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      setState(() => _isLoading = true);

      final fileId = file['file_id'] as String;
      final driveFileId = file['drive_file_id'] as String?;

      debugPrint('=== DELETE FILE DEBUG ===');
      debugPrint('File ID (Firestore): $fileId');
      debugPrint('Drive File ID: $driveFileId');
      debugPrint('File name: ${file['name']}');

      // Variables to track deletion status
      bool firestoreDeleted = false;
      bool driveDeleted = false;
      String? firestoreError;
      String? driveError;

      // Delete from Google Drive FIRST (if drive_file_id exists)
      if (driveFileId != null && driveFileId.isNotEmpty) {
        try {
          debugPrint('Attempting to delete from Google Drive...');
          final success = await _driveService.deleteFile(driveFileId);
          if (success) {
            driveDeleted = true;
            debugPrint('✓ Deleted from Google Drive');
          } else {
            driveError = 'Delete returned false';
            debugPrint('✗ Drive delete returned false');
          }
        } catch (e) {
          driveError = e.toString();
          debugPrint('✗ Failed to delete from Google Drive: $e');
          // Continue with Firestore deletion even if Drive fails
        }
      } else {
        debugPrint('⚠ No drive_file_id found, skipping Drive deletion');
      }

      // Delete from Firestore ALWAYS (even if Drive failed)
      try {
        debugPrint('Attempting to delete from Firestore...');
        await _firestore.collection('files').doc(fileId).delete();
        firestoreDeleted = true;
        debugPrint('✓ Deleted from Firestore');
      } catch (e) {
        firestoreError = e.toString();
        debugPrint('✗ Failed to delete from Firestore: $e');
        // Continue to remove from local list
      }

      // Remove from local list ALWAYS
      setState(() {
        _uploadedFiles.removeAt(index);
        _isLoading = false;
      });

      // Show appropriate message
      if (mounted) {
        if (firestoreDeleted && driveDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'File "${file['name']}" deleted successfully from all locations',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (firestoreDeleted && driveError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'File deleted from database, but Google Drive error: $driveError',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        } else if (driveDeleted && firestoreError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'File deleted from Google Drive, but Firestore error: $firestoreError',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        } else if (firestoreError != null || driveError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Partial deletion:\n'
                'Firestore: ${firestoreError ?? "OK"}\n'
                'Drive: ${driveError ?? "OK"}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File "${file['name']}" removed from list'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete file: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Widget _buildPreviewContent(Map<String, dynamic> file) {
    final mimeType = file['mimeType'] as String;
    final bytes = file['bytes'] as List<int>?;

    // Preview untuk gambar
    if (mimeType.contains('image') && bytes != null) {
      return Image.memory(bytes as dynamic, fit: BoxFit.contain);
    }

    // Preview untuk PDF, DOC, dll (hanya info)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFileIcon(mimeType),
            size: 100,
            color: AppTheme.primaryPurple,
          ),
          const SizedBox(height: 16),
          Text(
            file['name'],
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(mimeType, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 16),
          const Text(
            'Preview not available for this file type.\nFile will be viewable after upload.',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  /// Simpan metadata materi ke Firestore
  ///
  /// Fungsi ini menyimpan informasi materi pembelajaran ke database Firestore:
  /// - Judul dan deskripsi materi
  /// - Kelas dan mata pelajaran tujuan
  /// - Link file yang sudah diupload ke Google Drive (webViewLink)
  /// - ID guru yang membuat materi
  /// - Timestamp pembuatan dan update
  ///
  /// File fisik sudah tersimpan di Google Drive folder: BelajarBareng MMP/{email}/
  /// Firestore hanya menyimpan metadata dan link ke file tersebut
  Future<void> _saveMateriToFirestore() async {
    if (!_formKey.currentState!.validate()) return;
    if (_uploadedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload at least one file'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Check connectivity before saving
    final isOnline = ref.read(isOnlineProvider);
    if (!isOnline) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus online untuk menyimpan materi.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    try {
      setState(() => _isLoading = true);

      final guruId = userProvider.userId;

      // Get max ID for new materi
      final materiSnapshot = await _firestore.collection('materi').get();
      int maxId = 0;
      for (final doc in materiSnapshot.docs) {
        final id = int.tryParse(doc.id) ?? 0;
        if (id > maxId) maxId = id;
      }
      final newId = (maxId + 1).toString();

      // Save metadata to Firestore (without id_files)
      await _firestore.collection('materi').doc(newId).set({
        'judul': _judulController.text.trim(),
        'deskripsi': _deskripsiController.text.trim(),
        'id_guru': guruId,
        'id_kelas': _selectedKelasId,
        'id_mapel': _selectedMapelId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Create many-to-many relationships in materi_files collection
      // Get max ID for materi_files
      final materiFilesSnapshot = await _firestore
          .collection('materi_files')
          .get();
      int maxMateriFilesId = 0;
      for (final doc in materiFilesSnapshot.docs) {
        final id = int.tryParse(doc.id) ?? 0;
        if (id > maxMateriFilesId) maxMateriFilesId = id;
      }

      // Create junction table entries for each file
      final materiId = int.parse(newId);
      for (final uploadedFile in _uploadedFiles) {
        maxMateriFilesId++;
        final fileId = int.parse(uploadedFile['file_id'] as String);

        await _firestore
            .collection('materi_files')
            .doc(maxMateriFilesId.toString())
            .set({
              'id_materi': materiId,
              'id_files': fileId,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Materi saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _judulController.clear();
        _deskripsiController.clear();
        _uploadedFiles.clear();
        _selectedKelasId = null;
        _selectedMapelId = null;
        setState(() {});
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save materi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GuruAppScaffold(
      title: 'Upload Materi',
      icon: Icons.cloud_upload,
      currentRoute: '/upload-materi',
      additionalActions: [
        if (_isSignedIn)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOutFromGoogleDrive,
            tooltip: 'Sign out from Google Drive',
          ),
      ],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header info
                Container(
                  padding: const EdgeInsets.all(16),
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.cloud_upload,
                          color: AppTheme.primaryPurple,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Upload Materi Pembelajaran',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Upload file atau video pembelajaran untuk siswa',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Google Drive Status Card
                          _buildGoogleDriveStatusCard(isDark),
                          const SizedBox(height: 20),

                          if (_isSignedIn) ...[
                            // Form Section
                            _buildFormSection(isDark),
                            const SizedBox(height: 20),

                            // Upload Files Section
                            _buildUploadSection(isDark),
                            const SizedBox(height: 20),

                            // Uploaded Files List
                            if (_uploadedFiles.isNotEmpty) ...[
                              _buildUploadedFilesList(isDark),
                              const SizedBox(height: 20),
                            ],

                            // Save Button
                            ElevatedButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : _saveMateriToFirestore,
                              icon: const Icon(Icons.save),
                              label: const Text('Simpan Materi'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildGoogleDriveStatusCard(bool isDark) {
    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Use Icon instead of network image to avoid CORS issues
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.cloud,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Google Drive',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isSignedIn
                            ? 'Connected as ${_driveService.currentUser?.email ?? "Unknown"}'
                            : 'Not connected',
                        style: TextStyle(
                          color: _isSignedIn ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!_isSignedIn) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _signInToGoogleDrive,
                icon: const Icon(Icons.login),
                label: const Text('Sign in to Google Drive'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection(bool isDark) {
    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Materi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Judul
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Materi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Deskripsi
            TextFormField(
              controller: _deskripsiController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Kelas Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Kelas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.class_),
              ),
              items: _kelasList.map<DropdownMenuItem<String>>((kelas) {
                return DropdownMenuItem<String>(
                  value: kelas['id'] as String?,
                  child: Text(kelas['nama'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedKelasId = value);
              },
              validator: (value) {
                if (value == null) return 'Pilih kelas';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Mapel Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Mata Pelajaran',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              items: _mapelList.map<DropdownMenuItem<String>>((mapel) {
                return DropdownMenuItem<String>(
                  value: mapel['id'] as String?,
                  child: Text(mapel['nama'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedMapelId = value);
              },
              validator: (value) {
                if (value == null) return 'Pilih mata pelajaran';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(bool isDark) {
    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload File',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Upload Zone
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isDraggingOver
                      ? AppTheme.primaryPurple
                      : Colors.grey.shade300,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: _isDraggingOver
                    ? AppTheme.primaryPurple.withOpacity(0.1)
                    : Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 48,
                    color: _isDraggingOver
                        ? AppTheme.primaryPurple
                        : Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isDraggingOver
                        ? 'Drop files here'
                        : 'Drag & drop files here or click to browse',
                    style: TextStyle(
                      fontSize: 16,
                      color: _isDraggingOver
                          ? AppTheme.primaryPurple
                          : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You can select multiple files at once',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickAndUploadFile,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Browse Files'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Text(
              'Supported: PDF, DOC, PPT, XLS, JPG, PNG, MP4, ZIP, TXT',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

            // Show upload progress
            if (_uploadProgress.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Uploading...',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._uploadProgress.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${(entry.value * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: entry.value,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUploadedFilesList(bool isDark) {
    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'File yang Diupload',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_uploadedFiles.length} file(s)',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _uploadedFiles.length,
              itemBuilder: (context, index) {
                final file = _uploadedFiles[index];
                final isImage = (file['mimeType'] as String).contains('image');

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 1,
                  child: ListTile(
                    leading: isImage && file['bytes'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.memory(
                              file['bytes'] as dynamic,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            _getFileIcon(file['mimeType']),
                            color: AppTheme.primaryPurple,
                            size: 32,
                          ),
                    title: Text(file['name'], overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      GoogleDriveService.formatFileSize(file['size']),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Preview button
                        IconButton(
                          icon: const Icon(Icons.visibility, size: 20),
                          onPressed: () => _showFilePreview(file),
                          tooltip: 'Preview',
                          color: Colors.blue,
                        ),
                        // Replace button
                        IconButton(
                          icon: const Icon(Icons.swap_horiz, size: 20),
                          onPressed: () => _replaceFile(index),
                          tooltip: 'Replace',
                          color: Colors.orange,
                        ),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () => _deleteFile(index, file),
                          tooltip: 'Delete',
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String mimeType) {
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
    if (mimeType.contains('document')) return Icons.description;
    if (mimeType.contains('presentation')) return Icons.slideshow;
    if (mimeType.contains('spreadsheet')) return Icons.table_chart;
    if (mimeType.contains('image')) return Icons.image;
    if (mimeType.contains('video')) return Icons.video_file;
    if (mimeType.contains('zip') || mimeType.contains('compressed')) {
      return Icons.folder_zip;
    }
    return Icons.insert_drive_file;
  }
}
