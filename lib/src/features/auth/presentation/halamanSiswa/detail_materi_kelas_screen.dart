import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMateriKelasScreen extends StatelessWidget {
  final String namaMapel;
  final String namaGuru;
  final String kelasId;
  final Color color;
  final IconData icon;

  const DetailMateriKelasScreen({
    super.key,
    required this.namaMapel,
    required this.namaGuru,
    required this.kelasId,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Materi $namaMapel'), elevation: 0),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaMapel,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                namaGuru,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // List Materi
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('materi')
                  .where('id_kelas', isEqualTo: kelasId)
                  .snapshots(),
              builder: (context, materiSnapshot) {
                if (materiSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: color));
                }

                if (materiSnapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Terjadi kesalahan: ${materiSnapshot.error}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (!materiSnapshot.hasData ||
                    materiSnapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada materi',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final materiDocs = materiSnapshot.data!.docs;

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchMateriWithFiles(materiDocs),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: color),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada materi',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final materiList = snapshot.data!;

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: materiList.length,
                      itemBuilder: (context, index) {
                        final materi = materiList[index];
                        return _buildMateriCard(
                          context: context,
                          materi: materi,
                          color: color,
                          isDark: isDark,
                        );
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

  Future<List<Map<String, dynamic>>> _fetchMateriWithFiles(
    List<QueryDocumentSnapshot> materiDocs,
  ) async {
    final materiList = <Map<String, dynamic>>[];

    for (var materiDoc in materiDocs) {
      final materiId = materiDoc.id;
      final materiData = materiDoc.data() as Map<String, dynamic>;
      // Ambil judul dan deskripsi dari materi
      final judulMateri =
          materiData['judul'] ?? materiData['title'] ?? 'Materi';
      final deskripsiMateri =
          materiData['deskripsi'] ?? materiData['description'] ?? '';

      // Convert materiId ke integer untuk matching dengan field id_materi di materi_files
      final materiIdInt = int.tryParse(materiId);

      if (materiIdInt == null) {
        continue;
      }

      // Query materi_files berdasarkan id_materi (integer)
      try {
        final materiFilesQuery = await FirebaseFirestore.instance
            .collection('materi_files')
            .where('id_materi', isEqualTo: materiIdInt)
            .get();

        for (var materiFileDoc in materiFilesQuery.docs) {
          final materiFileData = materiFileDoc.data();
          // Field di Firestore adalah 'id_files' bukan 'id_file', dan kemungkinan juga integer
          final idFilesValue = materiFileData['id_files'];
          final idFile = idFilesValue?.toString();

          if (idFile != null && idFile.isNotEmpty) {
            try {
              final fileDoc = await FirebaseFirestore.instance
                  .collection('files')
                  .doc(idFile.toString())
                  .get();

              if (fileDoc.exists) {
                final fileData = fileDoc.data();
                // Get status and youtube_url from files collection
                final status = fileData?['status'] ?? 'file';
                final youtubeUrl = fileData?['url_youtube']?.toString();
                // If status is youtube, add as YouTube entry
                if (status == 'youtube' && youtubeUrl != null) {
                  materiList.add({
                    'materiId': materiId,
                    'materiFileId': materiFileDoc.id,
                    'fileId': idFile,
                    'judulMateri': judulMateri,
                    'deskripsiMateri': deskripsiMateri,
                    'status': 'youtube',
                    'youtubeUrl': youtubeUrl,
                    'uploadedAt': fileData?['uploadedAt'],
                  });
                } else {
                  // Add as file entry
                  materiList.add({
                    'materiId': materiId,
                    'materiFileId': materiFileDoc.id,
                    'fileId': idFile,
                    'judulMateri': judulMateri,
                    'deskripsiMateri': deskripsiMateri,
                    'status': 'file',
                    'name': fileData?['name'] ?? 'File',
                    'mimeType': fileData?['mimeType'] ?? '',
                    'size': fileData?['size'] ?? 0,
                    'uploadedAt': fileData?['uploadedAt'],
                    'uploadedBy': fileData?['uploadedBy'] ?? '',
                    'drive_file_id': fileData?['drive_file_id'] ?? '',
                    'webViewLink': fileData?['webViewLink'],
                  });
                }
              }
            } catch (e) {
              print('Error fetching file: $e');
            }
          } else {
            print('DEBUG: id_file is null or empty');
          }
        }
      } catch (e) {
        print('Error fetching materi_files: $e');
      }
    }

    print('DEBUG: Total files found: ${materiList.length}');
    return materiList;
  }

  Widget _buildMateriCard({
    required BuildContext context,
    required Map<String, dynamic> materi,
    required Color color,
    required bool isDark,
  }) {
    final judulMateri = materi['judulMateri'] ?? 'Materi';
    final deskripsiMateri = materi['deskripsiMateri'] ?? '';
    final status = materi['status'] ?? 'file';

    // If YouTube, show YouTube card
    if (status == 'youtube') {
      return _buildYouTubeCard(
        context: context,
        materi: materi,
        color: color,
        isDark: isDark,
      );
    }

    // Otherwise show file card
    final fileName = materi['name'] ?? 'File';
    final fileSize = _formatFileSize(materi['size'] ?? 0);
    final mimeType = materi['mimeType'] ?? '';
    final uploadedAt = materi['uploadedAt'] as Timestamp?;
    final webViewLink = materi['webViewLink'];
    final driveFileId = materi['drive_file_id']?.toString() ?? '';

    IconData fileIcon = Icons.insert_drive_file;
    Color iconColor = Colors.grey;

    if (mimeType.contains('pdf')) {
      fileIcon = Icons.picture_as_pdf;
      iconColor = Colors.red;
    } else if (mimeType.contains('word') || mimeType.contains('document')) {
      fileIcon = Icons.description;
      iconColor = Colors.blue;
    } else if (mimeType.contains('sheet') || mimeType.contains('excel')) {
      fileIcon = Icons.table_chart;
      iconColor = Colors.green;
    } else if (mimeType.contains('presentation') ||
        mimeType.contains('powerpoint')) {
      fileIcon = Icons.slideshow;
      iconColor = Colors.orange;
    } else if (mimeType.contains('image')) {
      fileIcon = Icons.image;
      iconColor = Colors.purple;
    } else if (mimeType.contains('video')) {
      fileIcon = Icons.video_library;
      iconColor = Colors.pink;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.05), Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Materi
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.book, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judulMateri,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (deskripsiMateri.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            deskripsiMateri,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey[300]),
              const SizedBox(height: 16),
              // File Info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(fileIcon, color: iconColor, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.folder_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              fileSize,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (uploadedAt != null) ...[
                              const SizedBox(width: 12),
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _formatDate(uploadedAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        String? previewUrl;

                        if (webViewLink != null &&
                            webViewLink.toString().isNotEmpty) {
                          previewUrl = webViewLink.toString();
                        } else if (driveFileId.isNotEmpty) {
                          previewUrl =
                              'https://drive.google.com/file/d/$driveFileId/view';
                        }

                        if (previewUrl != null) {
                          try {
                            final uri = Uri.parse(previewUrl);
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal membuka file: $e'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Link preview tidak tersedia'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text('Preview'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        if (driveFileId.isNotEmpty) {
                          try {
                            final downloadUrl =
                                'https://drive.google.com/uc?export=download&id=$driveFileId';
                            final uri = Uri.parse(downloadUrl);
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal mendownload file: $e'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Link download tidak tersedia'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Download'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(color: color, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes} menit lalu';
      }
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  Widget _buildYouTubeCard({
    required BuildContext context,
    required Map<String, dynamic> materi,
    required Color color,
    required bool isDark,
  }) {
    final judulMateri = materi['judulMateri'] ?? 'Materi';
    final deskripsiMateri = materi['deskripsiMateri'] ?? '';
    final youtubeUrl = materi['youtubeUrl'] ?? '';
    final uploadedAt = materi['uploadedAt'] as Timestamp?;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.red.withOpacity(0.05), Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Materi
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judulMateri,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            'Video YouTube',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (uploadedAt != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(uploadedAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
              if (deskripsiMateri.isNotEmpty) ...[
                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.description, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        deskripsiMateri,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              // Watch Video Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showYouTubeVideoDialog(
                      context,
                      judulMateri,
                      deskripsiMateri,
                      youtubeUrl,
                      isDark,
                    );
                  },
                  icon: const Icon(Icons.play_circle, size: 20),
                  label: const Text('Tonton Video'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showYouTubeVideoDialog(
    BuildContext context,
    String judul,
    String deskripsi,
    String youtubeUrl,
    bool isDark,
  ) {
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
                          judul,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Video Pembelajaran',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
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
              _buildYouTubePlayer(context, youtubeUrl),
              const SizedBox(height: 16),
              // Description
              if (deskripsi.isNotEmpty)
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
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        deskripsi,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // Close button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Tutup',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYouTubePlayer(BuildContext context, String youtubeUrl) {
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
          // Show error message if launching fails
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tidak dapat membuka video YouTube: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
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

  String? _extractYouTubeId(String url) {
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
}
