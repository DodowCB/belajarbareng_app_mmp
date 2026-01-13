import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

/// Service untuk menangani semua operasi camera dan image picking
/// Includes: take photo, pick from gallery, compress image, validate size
class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Ambil foto langsung dari camera
  /// Returns File jika sukses, null jika user cancel
  Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo == null) return null;

      // Save to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${appDir.path}/$fileName');

      await File(photo.path).copy(savedImage.path);

      debugPrint('📸 Photo taken: ${savedImage.path}');
      return savedImage;
    } catch (e) {
      debugPrint('❌ Error taking photo: $e');
      rethrow;
    }
  }

  /// Pilih gambar dari galeri
  /// Returns File jika sukses, null jika user cancel
  Future<File?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${appDir.path}/$fileName');

      await File(image.path).copy(savedImage.path);

      debugPrint('🖼️ Image picked: ${savedImage.path}');
      return savedImage;
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
      rethrow;
    }
  }

  /// Kompres gambar untuk mengurangi ukuran file
  /// [quality] - kualitas kompresi (0-100), default 85
  Future<File> compressImage(File imageFile, {int quality = 85}) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) return imageFile;

      // Resize jika terlalu besar
      img.Image resized = image;
      if (image.width > 1920 || image.height > 1080) {
        resized = img.copyResize(
          image,
          width: image.width > image.height ? 1920 : null,
          height: image.height > image.width ? 1080 : null,
        );
      }

      // Compress
      final compressed = img.encodeJpg(resized, quality: quality);

      // Save compressed image
      final compressedFile = File('${imageFile.path}_compressed.jpg');
      await compressedFile.writeAsBytes(compressed);

      final originalSize = imageFile.lengthSync();
      final compressedSize = compressedFile.lengthSync();
      final reduction = ((originalSize - compressedSize) / originalSize * 100)
          .toStringAsFixed(1);

      debugPrint(
        '🗜️ Image compressed: ${_formatBytes(originalSize)} -> ${_formatBytes(compressedSize)} ($reduction% reduction)',
      );

      return compressedFile;
    } catch (e) {
      debugPrint('❌ Error compressing image: $e');
      return imageFile;
    }
  }

  /// Hapus file gambar
  Future<void> deleteImage(File imageFile) async {
    try {
      if (await imageFile.exists()) {
        await imageFile.delete();
        debugPrint('🗑️ Image deleted: ${imageFile.path}');
      }
    } catch (e) {
      debugPrint('❌ Error deleting image: $e');
    }
  }

  /// Dapatkan ukuran file dalam MB
  double getImageSizeMB(File imageFile) {
    final bytes = imageFile.lengthSync();
    return bytes / (1024 * 1024);
  }

  /// Validasi ukuran gambar (default max 5MB)
  bool isValidImageSize(File imageFile, {double maxSizeMB = 5.0}) {
    final sizeMB = getImageSizeMB(imageFile);
    return sizeMB <= maxSizeMB;
  }

  /// Format bytes ke format human-readable (KB, MB, etc)
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Dapatkan ukuran gambar dengan format human-readable
  String getFormattedSize(File imageFile) {
    return _formatBytes(imageFile.lengthSync());
  }
}
