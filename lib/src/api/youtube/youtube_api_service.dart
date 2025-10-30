import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class untuk berinteraksi dengan YouTube Data API v3
/// Digunakan untuk mengambil data video, channel, dan playlist dari YouTube
class YouTubeApiService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  final String _apiKey;

  YouTubeApiService({required String apiKey}) : _apiKey = apiKey;

  /// Mencari video berdasarkan query
  /// [query] - kata kunci pencarian
  /// [maxResults] - maksimal hasil yang dikembalikan (default: 25)
  /// [order] - urutan hasil (relevance, date, rating, viewCount, title)
  Future<Map<String, dynamic>> searchVideos({
    required String query,
    int maxResults = 25,
    String order = 'relevance',
  }) async {
    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: {
      'part': 'snippet',
      'q': query,
      'type': 'video',
      'maxResults': maxResults.toString(),
      'order': order,
      'key': _apiKey,
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to search videos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching videos: $e');
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
