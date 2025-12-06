import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/google_drive_service.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';

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
  String? _selectedKelasId;
  String? _selectedMapelId;
  List<Map<String, dynamic>> _kelasList = [];
  List<Map<String, dynamic>> _mapelList = [];

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
      if (!_isSignedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to Google Drive first'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Pick file
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

      setState(() => _isLoading = true);

      final file = result.files.first;

      // Check if bytes are available (web platform)
      if (file.bytes == null) {
        throw Exception('File data not available');
      }

      // Get or create folder: BelajarBareng MMP/{email}/
      final folderId = await _driveService.getOrCreateAppFolder();

      // Upload to Google Drive in user's folder
      final uploadedFile = await _driveService.uploadFile(
        fileBytes: file.bytes!,
        fileName: file.name,
        folderId: folderId,
        description: 'Uploaded from BelajarBareng App - ${DateTime.now()}',
      );

      if (uploadedFile != null) {
        // Get max ID for new file in 'files' collection
        final filesSnapshot = await _firestore.collection('files').get();
        int maxFileId = 0;
        for (final doc in filesSnapshot.docs) {
          final id = int.tryParse(doc.id) ?? 0;
          if (id > maxFileId) maxFileId = id;
        }
        final newFileId = (maxFileId + 1).toString();

        // Save file metadata to 'files' collection
        await _firestore.collection('files').doc(newFileId).set({
          'drive_file_id': uploadedFile['id'],
          'name': uploadedFile['name'],
          'mimeType': uploadedFile['mimeType'],
          'size': file.size,
          'webViewLink': uploadedFile['webViewLink'],
          'uploadedBy': userProvider.userId,
          'uploadedAt': FieldValue.serverTimestamp(),
        });

        setState(() {
          _uploadedFiles.add({
            'file_id': newFileId, // Firestore files collection ID
            'name': uploadedFile['name'],
            'mimeType': uploadedFile['mimeType'],
            'size': file.size,
          });
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'File uploaded successfully! Jangan lupa isi form dan klik "Simpan Materi"',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Materi'),
        actions: [
          if (_isSignedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _signOutFromGoogleDrive,
              tooltip: 'Sign out from Google Drive',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                        onPressed: _isLoading ? null : _saveMateriToFirestore,
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
            OutlinedButton.icon(
              onPressed: _pickAndUploadFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Pilih File untuk Upload'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                side: BorderSide(color: AppTheme.primaryPurple),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supported: PDF, DOC, PPT, XLS, JPG, PNG, MP4, ZIP',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
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
            const Text(
              'File yang Diupload',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _uploadedFiles.length,
              itemBuilder: (context, index) {
                final file = _uploadedFiles[index];
                return ListTile(
                  leading: Icon(
                    _getFileIcon(file['mimeType']),
                    color: AppTheme.primaryPurple,
                  ),
                  title: Text(file['name']),
                  subtitle: Text(
                    GoogleDriveService.formatFileSize(file['size']),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _uploadedFiles.removeAt(index);
                      });
                    },
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
