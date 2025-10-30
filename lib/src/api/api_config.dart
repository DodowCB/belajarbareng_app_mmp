/// Konfigurasi API untuk aplikasi BelajarBareng
class ApiConfig {
  // YouTube API Configuration
  static const String youtubeApiKey = 'AIzaSyA3DMOyDiG7F9dL7YIWc54QjPouNn01820E';
  static const String youtubeBaseUrl = 'https://www.googleapis.com/youtube/v3';

  // Firebase Configuration (biasanya sudah dikonfigurasi di firebase_options.dart)
  // Tapi bisa ditambahkan konfigurasi tambahan di sini jika diperlukan

  // API Endpoints
  static const Map<String, String> youtubeEndpoints = {
    'search': '/search',
    'videos': '/videos',
    'channels': '/channels',
    'playlists': '/playlists',
  };

  // Default parameters
  static const Map<String, dynamic> defaultParams = {
    'maxResults': 25,
    'order': 'relevance',
    'type': 'video',
    'part': 'snippet',
  };

  // Firestore Collections
  static const Map<String, String> firestoreCollections = {
    'users': 'users',
    'studyGroups': 'study_groups',
    'learningMaterials': 'learning_materials',
    'userProgress': 'user_progress',
    'notifications': 'notifications',
    'discussions': 'discussions',
  };

  // Categories untuk learning materials
  static const List<String> categories = [
    'Programming',
    'Mathematics',
    'Science',
    'Languages',
    'Arts',
    'Business',
    'Technology',
    'History',
    'Philosophy',
    'Others',
  ];

  // Difficulty levels
  static const Map<int, String> difficultyLevels = {
    1: 'Beginner',
    2: 'Easy',
    3: 'Intermediate',
    4: 'Advanced',
    5: 'Expert',
  };

  // Material types
  static const List<String> materialTypes = [
    'youtube_video',
    'document',
    'quiz',
    'presentation',
    'website',
    'book',
    'course',
    'others',
  ];

  // Error messages
  static const Map<String, String> errorMessages = {
    'networkError': 'Gagal terhubung ke server. Periksa koneksi internet Anda.',
    'invalidApiKey': 'API key tidak valid. Hubungi administrator.',
    'quotaExceeded': 'Batas penggunaan API telah tercapai. Coba lagi nanti.',
    'videoNotFound': 'Video tidak ditemukan.',
    'channelNotFound': 'Channel tidak ditemukan.',
    'userNotFound': 'User tidak ditemukan.',
    'groupNotFound': 'Study group tidak ditemukan.',
    'materialNotFound': 'Learning material tidak ditemukan.',
    'permissionDenied': 'Anda tidak memiliki izin untuk melakukan aksi ini.',
    'unknown': 'Terjadi kesalahan yang tidak diketahui.',
  };

  // Cache settings
  static const Duration cacheTimeout = Duration(hours: 1);
  static const int maxCacheSize = 100; // Maximum number of cached items

  // Rate limiting
  static const Duration rateLimitWindow = Duration(minutes: 1);
  static const int maxRequestsPerWindow = 100;

  // Validation settings
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 1000;
  static const int maxGroupMembers = 50;
  static const int minPasswordLength = 6;

  /// Validasi YouTube API key format
  static bool isValidYouTubeApiKey(String apiKey) {
    // YouTube API keys biasanya 39 karakter dan dimulai dengan AIza
    return apiKey.length == 39 && apiKey.startsWith('AIza');
  }

  /// Validasi YouTube video ID format
  static bool isValidYouTubeVideoId(String videoId) {
    // YouTube video IDs biasanya 11 karakter alphanumeric dan beberapa simbol
    final regex = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    return regex.hasMatch(videoId);
  }

  /// Validasi YouTube channel ID format
  static bool isValidYouTubeChannelId(String channelId) {
    // YouTube channel IDs biasanya dimulai dengan UC dan panjang 24 karakter
    final regex = RegExp(r'^UC[a-zA-Z0-9_-]{22}$');
    return regex.hasMatch(channelId);
  }

  /// Extract video ID dari YouTube URL
  static String? extractVideoIdFromUrl(String url) {
    final patterns = [
      RegExp(r'(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com\/embed\/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com\/v\/([a-zA-Z0-9_-]{11})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }

  /// Build YouTube video URL dari video ID
  static String buildYouTubeVideoUrl(String videoId) {
    return 'https://www.youtube.com/watch?v=$videoId';
  }

  /// Build YouTube channel URL dari channel ID
  static String buildYouTubeChannelUrl(String channelId) {
    return 'https://www.youtube.com/channel/$channelId';
  }
}

