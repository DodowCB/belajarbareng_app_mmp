import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../../../google_drive_options.dart';

/// Service untuk mengelola operasi Google Drive
class GoogleDriveService {
  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService() => _instance;
  GoogleDriveService._internal();

  GoogleSignIn? _googleSignIn;
  GoogleSignInAccount? _currentUser;
  Map<String, String>? _authHeaders;

  static const String _driveApiBaseUrl = 'https://www.googleapis.com/drive/v3';
  static const String _uploadApiBaseUrl =
      'https://www.googleapis.com/upload/drive/v3';

  /// Initialize Google Sign In dengan Drive scopes
  Future<void> initialize() async {
    final options = GoogleDriveOptions.instance;

    _googleSignIn = GoogleSignIn(
      clientId: options.currentClientId,
      scopes: options.scopes,
    );

    // Coba restore previous sign in
    try {
      _currentUser = await _googleSignIn?.signInSilently();
      if (_currentUser != null) {
        await _updateAuthHeaders();
      }
    } catch (e) {
      print('Error restoring sign in: $e');
    }
  }

  /// Sign in to Google Drive
  Future<GoogleSignInAccount?> signIn() async {
    try {
      if (_googleSignIn == null) {
        await initialize();
      }

      _currentUser = await _googleSignIn?.signIn();
      if (_currentUser != null) {
        await _updateAuthHeaders();
      }
      return _currentUser;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  /// Sign out from Google Drive
  Future<void> signOut() async {
    try {
      await _googleSignIn?.signOut();
      _currentUser = null;
      _authHeaders = null;
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  /// Update auth headers dengan access token terbaru
  Future<void> _updateAuthHeaders() async {
    if (_currentUser == null) return;

    final auth = await _currentUser!.authentication;
    _authHeaders = {
      'Authorization': 'Bearer ${auth.accessToken}',
      'Content-Type': 'application/json',
    };
  }

  /// Check if user is signed in
  bool get isSignedIn => _currentUser != null;

  /// Get current user
  GoogleSignInAccount? get currentUser => _currentUser;

  // ============================================================================
  // FILE OPERATIONS
  // ============================================================================

  /// Upload file ke Google Drive
  ///
  /// Parameters:
  /// - [fileBytes]: Bytes dari file yang akan diupload
  /// - [fileName]: Nama file di Drive
  /// - [folderId]: ID folder tujuan (opsional, default ke root)
  /// - [mimeType]: MIME type file (auto-detect jika null)
  /// - [description]: Deskripsi file (opsional)
  Future<Map<String, dynamic>?> uploadFile({
    required List<int> fileBytes,
    required String fileName,
    String? folderId,
    String? mimeType,
    String? description,
  }) async {
    try {
      await _updateAuthHeaders();
      if (_authHeaders == null) {
        throw Exception('Not authenticated. Please sign in first.');
      }

      final name = fileName;
      final mime = mimeType ?? _getMimeType(name);
      final bytes = fileBytes;

      // Create metadata
      final metadata = {
        'name': name,
        if (folderId != null) 'parents': [folderId],
        if (description != null) 'description': description,
      };

      // Multipart upload
      final uri = Uri.parse('$_uploadApiBaseUrl/files?uploadType=multipart');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(_authHeaders!);

      // Add metadata part
      request.files.add(
        http.MultipartFile.fromString(
          'metadata',
          json.encode(metadata),
          contentType: MediaType('application', 'json'),
        ),
      );

      // Add file content part
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: name,
          contentType: MediaType.parse(mime),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception(
          'Upload failed: ${response.statusCode} - $responseBody',
        );
      }
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  /// Download file dari Google Drive
  Future<Uint8List?> downloadFile(String fileId) async {
    try {
      await _updateAuthHeaders();
      if (_authHeaders == null) {
        throw Exception('Not authenticated');
      }

      final uri = Uri.parse('$_driveApiBaseUrl/files/$fileId?alt=media');
      final response = await http.get(uri, headers: _authHeaders);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Download failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
      rethrow;
    }
  }

  /// List files di Google Drive
  ///
  /// Parameters:
  /// - [folderId]: ID folder (null untuk root)
  /// - [pageSize]: Jumlah file per page (default 100)
  /// - [pageToken]: Token untuk pagination
  /// - [query]: Custom query (e.g., "mimeType='application/pdf'")
  Future<Map<String, dynamic>> listFiles({
    String? folderId,
    int pageSize = 100,
    String? pageToken,
    String? query,
  }) async {
    try {
      await _updateAuthHeaders();
      if (_authHeaders == null) {
        throw Exception('Not authenticated');
      }

      String q = query ?? '';
      if (folderId != null) {
        q = "'$folderId' in parents";
      }
      if (q.isEmpty) {
        q = "trashed=false";
      } else {
        q += " and trashed=false";
      }

      final queryParams = {
        'pageSize': pageSize.toString(),
        'fields':
            'nextPageToken, files(id, name, mimeType, size, createdTime, modifiedTime, webViewLink, iconLink, thumbnailLink)',
        'q': q,
        if (pageToken != null) 'pageToken': pageToken,
      };

      final uri = Uri.parse(
        '$_driveApiBaseUrl/files',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _authHeaders);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('List files failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error listing files: $e');
      rethrow;
    }
  }

  /// Get file metadata
  Future<Map<String, dynamic>?> getFileMetadata(String fileId) async {
    try {
      await _updateAuthHeaders();
      if (_authHeaders == null) {
        throw Exception('Not authenticated');
      }

      final uri = Uri.parse('$_driveApiBaseUrl/files/$fileId').replace(
        queryParameters: {
          'fields':
              'id, name, mimeType, size, createdTime, modifiedTime, webViewLink, iconLink, thumbnailLink, description',
        },
      );

      final response = await http.get(uri, headers: _authHeaders);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Get metadata failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting file metadata: $e');
      rethrow;
    }
  }

  /// Delete file dari Google Drive
  Future<bool> deleteFile(String fileId) async {
    try {
      await _updateAuthHeaders();
      if (_authHeaders == null) {
        throw Exception('Not authenticated');
      }

      final uri = Uri.parse('$_driveApiBaseUrl/files/$fileId');
      final response = await http.delete(uri, headers: _authHeaders);

      return response.statusCode == 204;
    } catch (e) {
      print('Error deleting file: $e');
      rethrow;
    }
  }

  /// Search for folder by name
  Future<String?> findFolderByName({
    required String folderName,
    String? parentFolderId,
  }) async {
    try {
      await _updateAuthHeaders();
      if (_authHeaders == null) {
        throw Exception('Not authenticated');
      }

      String query =
          "mimeType='application/vnd.google-apps.folder' and name='$folderName' and trashed=false";
      if (parentFolderId != null) {
        query += " and '$parentFolderId' in parents";
      }

      final uri = Uri.parse(
        '$_driveApiBaseUrl/files',
      ).replace(queryParameters: {'q': query, 'fields': 'files(id, name)'});

      final response = await http.get(uri, headers: _authHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final files = data['files'] as List;
        if (files.isNotEmpty) {
          return files.first['id'];
        }
      }
      return null;
    } catch (e) {
      print('Error finding folder: $e');
      return null;
    }
  }

  /// Create folder di Google Drive
  Future<Map<String, dynamic>?> createFolder({
    required String folderName,
    String? parentFolderId,
    String? description,
  }) async {
    try {
      await _updateAuthHeaders();
      if (_authHeaders == null) {
        throw Exception('Not authenticated');
      }

      final metadata = {
        'name': folderName,
        'mimeType': 'application/vnd.google-apps.folder',
        if (parentFolderId != null) 'parents': [parentFolderId],
        if (description != null) 'description': description,
      };

      final uri = Uri.parse('$_driveApiBaseUrl/files');
      final response = await http.post(
        uri,
        headers: _authHeaders,
        body: json.encode(metadata),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Create folder failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating folder: $e');
      rethrow;
    }
  }

  /// Get or create folder structure: BelajarBareng MMP/{email}/
  Future<String?> getOrCreateAppFolder() async {
    try {
      if (_currentUser == null) {
        throw Exception('User not signed in');
      }

      final userEmail = _currentUser!.email;

      // Check/Create root folder: BelajarBareng MMP
      String? rootFolderId = await findFolderByName(
        folderName: 'BelajarBareng MMP',
      );

      if (rootFolderId == null) {
        final rootFolder = await createFolder(
          folderName: 'BelajarBareng MMP',
          description: 'BelajarBareng App Storage',
        );
        rootFolderId = rootFolder?['id'];
      }

      if (rootFolderId == null) {
        throw Exception('Failed to create root folder');
      }

      // Check/Create user folder: {email}
      String? userFolderId = await findFolderByName(
        folderName: userEmail,
        parentFolderId: rootFolderId,
      );

      if (userFolderId == null) {
        final userFolder = await createFolder(
          folderName: userEmail,
          parentFolderId: rootFolderId,
          description: 'Files uploaded by $userEmail',
        );
        userFolderId = userFolder?['id'];
      }

      return userFolderId;
    } catch (e) {
      print('Error getting/creating app folder: $e');
      rethrow;
    }
  }

  /// Share file dengan permission
  ///
  /// [role]: 'reader', 'writer', 'commenter', 'owner'
  /// [type]: 'user', 'group', 'domain', 'anyone'
  Future<Map<String, dynamic>?> shareFile({
    required String fileId,
    required String role,
    required String type,
    String? emailAddress,
    String? domain,
  }) async {
    try {
      await _updateAuthHeaders();
      if (_authHeaders == null) {
        throw Exception('Not authenticated');
      }

      final permission = {
        'role': role,
        'type': type,
        if (emailAddress != null) 'emailAddress': emailAddress,
        if (domain != null) 'domain': domain,
      };

      final uri = Uri.parse('$_driveApiBaseUrl/files/$fileId/permissions');
      final response = await http.post(
        uri,
        headers: _authHeaders,
        body: json.encode(permission),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Share file failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sharing file: $e');
      rethrow;
    }
  }

  /// Search files by name or content
  Future<List<Map<String, dynamic>>> searchFiles(String searchTerm) async {
    try {
      final query =
          "name contains '$searchTerm' or fullText contains '$searchTerm'";
      final result = await listFiles(query: query);
      return List<Map<String, dynamic>>.from(result['files'] ?? []);
    } catch (e) {
      print('Error searching files: $e');
      rethrow;
    }
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get MIME type dari file extension
  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    final mimeTypes = {
      // Documents
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'ppt': 'application/vnd.ms-powerpoint',
      'pptx':
          'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'txt': 'text/plain',

      // Images
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'bmp': 'image/bmp',
      'svg': 'image/svg+xml',

      // Videos
      'mp4': 'video/mp4',
      'avi': 'video/x-msvideo',
      'mov': 'video/quicktime',
      'wmv': 'video/x-ms-wmv',

      // Audio
      'mp3': 'audio/mpeg',
      'wav': 'audio/wav',

      // Archives
      'zip': 'application/zip',
      'rar': 'application/x-rar-compressed',
      '7z': 'application/x-7z-compressed',
    };

    return mimeTypes[extension] ?? 'application/octet-stream';
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
