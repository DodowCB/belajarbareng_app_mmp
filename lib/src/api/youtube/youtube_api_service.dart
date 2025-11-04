import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class untuk berinteraksi dengan YouTube Data API v3
/// Digunakan untuk mengambil data video, channel, dan playlist dari YouTube
class YouTubeApiService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  final String _apiKey;

  YouTubeApiService({required String apiKey}) : _apiKey = apiKey;

  /// Mencari video berdasarkan query - Simple version untuk menghindari error 400
  /// [query] - kata kunci pencarian
  /// [maxResults] - maksimal hasil yang dikembalikan (default: 10)
  /// [order] - urutan hasil (relevance, date, rating, viewCount, title)
  Future<Map<String, dynamic>> searchVideos({
    required String query,
    int maxResults = 10,
    String order = 'relevance',
  }) async {
    // Validasi input
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty || cleanQuery.length < 2) {
      throw Exception('Query must be at least 2 characters long');
    }

    // Parameter paling minimal untuk menghindari error 400
    final queryParams = <String, String>{
      'part': 'snippet',
      'q': cleanQuery,
      'type': 'video',
      'maxResults': maxResults.clamp(1, 25).toString(),
      'key': _apiKey,
    };

    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Log untuk debugging
        print('YouTube API Error: ${response.statusCode} - ${response.body}');

        if (response.statusCode == 400) {
          throw Exception('API Error 400: Bad Request');
        } else if (response.statusCode == 403) {
          throw Exception('API Error 403: Forbidden - Check API key');
        } else {
          throw Exception('API Error ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e.toString().contains('API Error')) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Method pencarian dengan fallback ke dummy data jika API gagal
  Future<Map<String, dynamic>> searchVideosWithFallback({
    required String query,
    int maxResults = 10,
  }) async {
    try {
      // Coba API dulu
      return await searchVideos(query: query, maxResults: maxResults);
    } catch (e) {
      // Jika gagal, return dummy data
      print('API failed, using dummy data: $e');
      return _getDummySearchResult(query, maxResults);
    }
  }

  /// Generate dummy search result
  Map<String, dynamic> _getDummySearchResult(String query, int maxResults) {
    final dummyItems = [
      {
        'id': {'videoId': 'demo1'},
        'snippet': {
          'title': 'Flutter Tutorial for Beginners - Complete Course',
          'description': 'Learn Flutter from scratch with this comprehensive tutorial. Perfect for beginners who want to start mobile app development.',
          'thumbnails': {
            'default': {'url': 'https://i.ytimg.com/vi/1gDhl4leEzA/default.jpg'},
            'medium': {'url': 'https://i.ytimg.com/vi/1gDhl4leEzA/mqdefault.jpg'},
            'high': {'url': 'https://i.ytimg.com/vi/1gDhl4leEzA/hqdefault.jpg'}
          },
          'channelTitle': 'Flutter Academy',
          'channelId': 'UCflutter',
          'publishedAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        }
      },
      {
        'id': {'videoId': 'demo2'},
        'snippet': {
          'title': 'Advanced Flutter State Management with Riverpod',
          'description': 'Master state management in Flutter using Riverpod. Learn best practices and advanced patterns.',
          'thumbnails': {
            'default': {'url': 'https://i.ytimg.com/vi/A5iK2TwsY_A/default.jpg'},
            'medium': {'url': 'https://i.ytimg.com/vi/A5iK2TwsY_A/mqdefault.jpg'},
            'high': {'url': 'https://i.ytimg.com/vi/A5iK2TwsY_A/hqdefault.jpg'}
          },
          'channelTitle': 'Code with Expert',
          'channelId': 'UCcode',
          'publishedAt': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
        }
      },
      {
        'id': {'videoId': 'demo3'},
        'snippet': {
          'title': 'JavaScript ES6+ Modern Features',
          'description': 'Learn modern JavaScript features including arrow functions, async/await, destructuring and more.',
          'thumbnails': {
            'default': {'url': 'https://i.ytimg.com/vi/nZ1DMMsyVyI/default.jpg'},
            'medium': {'url': 'https://i.ytimg.com/vi/nZ1DMMsyVyI/mqdefault.jpg'},
            'high': {'url': 'https://i.ytimg.com/vi/nZ1DMMsyVyI/hqdefault.jpg'}
          },
          'channelTitle': 'Web Dev Pro',
          'channelId': 'UCwebdev',
          'publishedAt': DateTime.now().subtract(const Duration(days: 12)).toIso8601String(),
        }
      },
      {
        'id': {'videoId': 'demo4'},
        'snippet': {
          'title': 'Python Data Science Complete Guide',
          'description': 'Complete guide to data science with Python. Learn pandas, numpy, matplotlib and scikit-learn.',
          'thumbnails': {
            'default': {'url': 'https://i.ytimg.com/vi/rfscVS0vtbw/default.jpg'},
            'medium': {'url': 'https://i.ytimg.com/vi/rfscVS0vtbw/mqdefault.jpg'},
            'high': {'url': 'https://i.ytimg.com/vi/rfscVS0vtbw/hqdefault.jpg'}
          },
          'channelTitle': 'Data Science Hub',
          'channelId': 'UCdatascience',
          'publishedAt': DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
        }
      },
      {
        'id': {'videoId': 'demo5'},
        'snippet': {
          'title': 'Mathematics for Programmers - Linear Algebra',
          'description': 'Essential linear algebra concepts every programmer should know. Great for machine learning and graphics.',
          'thumbnails': {
            'default': {'url': 'https://i.ytimg.com/vi/aircAruvnKk/default.jpg'},
            'medium': {'url': 'https://i.ytimg.com/vi/aircAruvnKk/mqdefault.jpg'},
            'high': {'url': 'https://i.ytimg.com/vi/aircAruvnKk/hqdefault.jpg'}
          },
          'channelTitle': 'Math Academy',
          'channelId': 'UCmath',
          'publishedAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
        }
      },
    ];

    // Filter based on query
    final filteredItems = dummyItems.where((item) {
      final snippet = item['snippet'] as Map<String, dynamic>?;
      if (snippet == null) return false;

      final title = (snippet['title'] as String?)?.toLowerCase() ?? '';
      final description = (snippet['description'] as String?)?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery) || description.contains(searchQuery);
    }).take(maxResults).toList();

    return {
      'kind': 'youtube#searchListResponse',
      'items': filteredItems.isEmpty ? dummyItems.take(maxResults).toList() : filteredItems,
      'pageInfo': {
        'totalResults': filteredItems.isEmpty ? dummyItems.length : filteredItems.length,
        'resultsPerPage': maxResults
      }
    };
  }

  /// Mencari video dengan filter tambahan untuk menghindari error 400
  /// [query] - kata kunci pencarian
  /// [maxResults] - maksimal hasil yang dikembalikan (default: 10)
  /// [order] - urutan hasil (relevance, date, rating, viewCount, title)
  /// [duration] - durasi video (any, short, medium, long)
  /// [uploadDate] - tanggal upload (any, hour, today, week, month, year)
  Future<Map<String, dynamic>> searchVideosWithFilters({
    required String query,
    int maxResults = 10,
    String order = 'relevance',
    String duration = 'any',
    String uploadDate = 'any',
  }) async {
    // Buat query parameters yang lebih aman untuk menghindari error 400
    final queryParams = <String, String>{
      'part': 'snippet',
      'q': query.trim(),
      'type': 'video',
      'maxResults': maxResults.clamp(1, 50).toString(), // Batasi maxResults
      'order': order,
      'key': _apiKey,
      'safeSearch': 'moderate', // Tambahkan safe search
      'videoEmbeddable': 'true', // Hanya video yang bisa di-embed
    };

    // Tambahkan filter duration jika bukan 'any'
    if (duration != 'any') {
      switch (duration) {
        case 'short':
          queryParams['videoDuration'] = 'short';
          break;
        case 'medium':
          queryParams['videoDuration'] = 'medium';
          break;
        case 'long':
          queryParams['videoDuration'] = 'long';
          break;
      }
    }

    // Tambahkan filter publishedAfter berdasarkan uploadDate
    if (uploadDate != 'any') {
      final now = DateTime.now();
      DateTime? publishedAfter;

      switch (uploadDate) {
        case 'hour':
          publishedAfter = now.subtract(const Duration(hours: 1));
          break;
        case 'today':
          publishedAfter = now.subtract(const Duration(days: 1));
          break;
        case 'week':
          publishedAfter = now.subtract(const Duration(days: 7));
          break;
        case 'month':
          publishedAfter = now.subtract(const Duration(days: 30));
          break;
        case 'year':
          publishedAfter = now.subtract(const Duration(days: 365));
          break;
      }

      if (publishedAfter != null) {
        queryParams['publishedAfter'] = publishedAfter.toUtc().toIso8601String();
      }
    }

    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        'User-Agent': 'BelajarBareng-App/1.0',
      });

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Berikan error message yang lebih detail
        final errorBody = response.body;
        if (response.statusCode == 400) {
          throw Exception('API Error 400: Invalid request parameters. Check your API key and query parameters.');
        } else if (response.statusCode == 403) {
          throw Exception('API Error 403: API key invalid or quota exceeded.');
        } else {
          throw Exception('Failed to search videos: ${response.statusCode} - $errorBody');
        }
      }
    } catch (e) {
      if (e.toString().contains('API Error')) {
        rethrow; // Re-throw API errors as is
      }
      throw Exception('Network error searching videos: $e');
    }
  }

  /// Mendapatkan detail video berdasarkan video ID
  /// [videoId] - ID video YouTube
  Future<Map<String, dynamic>> getVideoDetails(String videoId) async {
    final uri = Uri.parse('$_baseUrl/videos').replace(queryParameters: {
      'part': 'snippet,statistics,contentDetails',
      'id': videoId,
      'key': _apiKey,
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get video details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting video details: $e');
    }
  }

  /// Mendapatkan daftar video dari channel
  /// [channelId] - ID channel YouTube
  /// [maxResults] - maksimal hasil yang dikembalikan (default: 25)
  Future<Map<String, dynamic>> getChannelVideos({
    required String channelId,
    int maxResults = 25,
  }) async {
    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: {
      'part': 'snippet',
      'channelId': channelId,
      'type': 'video',
      'maxResults': maxResults.toString(),
      'order': 'date',
      'key': _apiKey,
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get channel videos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting channel videos: $e');
    }
  }

  /// Mendapatkan informasi channel
  /// [channelId] - ID channel YouTube
  Future<Map<String, dynamic>> getChannelInfo(String channelId) async {
    final uri = Uri.parse('$_baseUrl/channels').replace(queryParameters: {
      'part': 'snippet,statistics',
      'id': channelId,
      'key': _apiKey,
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get channel info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting channel info: $e');
    }
  }
}
