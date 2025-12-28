import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/services/google_drive_service.dart';
import '../../../../../core/providers/user_provider.dart';
import 'dart:typed_data';

/// Controller untuk menangani business logic upload materi
/// Memisahkan logic dari UI untuk better code organization
class UploadMateriController {
  final GoogleDriveService _driveService;
  final FirebaseFirestore _firestore;
  final BuildContext context;
  final Function(VoidCallback) setState;

  UploadMateriController({
    required GoogleDriveService driveService,
    required FirebaseFirestore firestore,
    required this.context,
    required this.setState,
  }) : _driveService = driveService,
       _firestore = firestore;

  // ============= GOOGLE DRIVE OPERATIONS =============

  Future<void> signInToGoogleDrive({
    required Function(bool) setLoading,
    required Function(bool) setSignedIn,
  }) async {
    try {
      setLoading(true);

      final account = await _driveService.signIn();

      setSignedIn(account != null);
      setLoading(false);

      if (account != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signed in as ${account.email}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> signOutFromGoogleDrive({
    required Function(bool) setSignedIn,
    required VoidCallback clearFiles,
  }) async {
    try {
      await _driveService.signOut();
      setSignedIn(false);
      clearFiles();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ============= FILE UPLOAD OPERATIONS =============

  Future<void> uploadSingleFile({
    required PlatformFile file,
    required Function(String, double) updateProgress,
    required Function(Map<String, dynamic>) addUploadedFile,
  }) async {
    try {
      if (file.bytes == null) {
        throw Exception('File data not available');
      }

      updateProgress(file.name, 0.0);
      updateProgress(file.name, 0.2);

      final folderId = await _driveService.getOrCreateAppFolder();
      updateProgress(file.name, 0.4);

      final uploadedFile = await _driveService.uploadFile(
        fileBytes: file.bytes!,
        fileName: file.name,
        folderId: folderId,
        description: 'Uploaded from BelajarBareng App - ${DateTime.now()}',
      );
      updateProgress(file.name, 0.7);

      if (uploadedFile != null) {
        final filesSnapshot = await _firestore.collection('files').get();
        int maxFileId = 0;
        for (final doc in filesSnapshot.docs) {
          final id = int.tryParse(doc.id) ?? 0;
          if (id > maxFileId) maxFileId = id;
        }
        final newFileId = (maxFileId + 1).toString();

        await _firestore.collection('files').doc(newFileId).set({
          'drive_file_id': uploadedFile['id'],
          'name': uploadedFile['name'],
          'mimeType': uploadedFile['mimeType'],
          'size': file.size,
          'webViewLink': uploadedFile['webViewLink'],
          'uploadedBy': userProvider.userId,
          'uploadedAt': FieldValue.serverTimestamp(),
        });
        updateProgress(file.name, 0.9);

        addUploadedFile({
          'file_id': newFileId,
          'drive_file_id': uploadedFile['id'],
          'name': uploadedFile['name'],
          'mimeType': uploadedFile['mimeType'],
          'size': file.size,
          'bytes': file.bytes,
        });
        updateProgress(file.name, 1.0);

        await Future.delayed(const Duration(milliseconds: 500));
        updateProgress(file.name, -1); // Signal to remove progress
      }
    } catch (e) {
      updateProgress(file.name, -1);
      rethrow;
    }
  }

  // handleDroppedFiles removed - use file_picker package instead for cross-platform support

  // ============= FILE MANAGEMENT =============

  Future<void> deleteFile({
    required String fileId,
    required String? driveFileId,
    required VoidCallback onSuccess,
  }) async {
    try {
      await _firestore.collection('files').doc(fileId).delete();

      if (driveFileId != null && driveFileId.isNotEmpty) {
        try {
          await _driveService.deleteFile(driveFileId);
        } catch (e) {
          debugPrint('Failed to delete from Google Drive: $e');
        }
      }

      onSuccess();
    } catch (e) {
      rethrow;
    }
  }

  // ============= SAVE MATERI =============

  Future<void> saveMateriToFirestore({
    required String judul,
    required String deskripsi,
    required String? kelasId,
    required String? mapelId,
    required List<Map<String, dynamic>> uploadedFiles,
    required VoidCallback onSuccess,
  }) async {
    try {
      final guruId = userProvider.userId;

      final materiSnapshot = await _firestore.collection('materi').get();
      int maxId = 0;
      for (final doc in materiSnapshot.docs) {
        final id = int.tryParse(doc.id) ?? 0;
        if (id > maxId) maxId = id;
      }
      final newId = (maxId + 1).toString();

      await _firestore.collection('materi').doc(newId).set({
        'judul': judul,
        'deskripsi': deskripsi,
        'id_guru': guruId,
        'id_kelas': kelasId,
        'id_mapel': mapelId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final materiFilesSnapshot = await _firestore
          .collection('materi_files')
          .get();
      int maxMateriFilesId = 0;
      for (final doc in materiFilesSnapshot.docs) {
        final id = int.tryParse(doc.id) ?? 0;
        if (id > maxMateriFilesId) maxMateriFilesId = id;
      }

      final materiId = int.parse(newId);
      for (final uploadedFile in uploadedFiles) {
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

      onSuccess();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Materi saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============= LOAD DATA =============

  Future<Map<String, dynamic>> loadKelasAndMapel() async {
    try {
      final guruId = userProvider.userId;
      if (guruId == null) {
        return {
          'kelas': <Map<String, dynamic>>[],
          'mapel': <Map<String, dynamic>>[],
        };
      }

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

      return {'kelas': kelasList, 'mapel': mapelList};
    } catch (e) {
      debugPrint('Error loading kelas and mapel: $e');
      return {
        'kelas': <Map<String, dynamic>>[],
        'mapel': <Map<String, dynamic>>[],
      };
    }
  }
}
