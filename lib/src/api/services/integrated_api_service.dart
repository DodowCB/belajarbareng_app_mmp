import '../youtube/youtube_api_service.dart';
import '../firebase/firestore_service.dart';
import '../models/youtube_models.dart';
import '../models/firebase_models.dart';

/// Service class yang mengintegrasikan YouTube API dengan Firebase
/// untuk menyimpan dan mengelola learning materials dari YouTube
class IntegratedApiService {
  final YouTubeApiService _youtubeService;
  final FirestoreService _firestoreService;

  IntegratedApiService({
    required YouTubeApiService youtubeService,
    required FirestoreService firestoreService,
  })  : _youtubeService = youtubeService,
        _firestoreService = firestoreService;

  /// Mencari video YouTube dan menyimpannya sebagai learning material
  Future<List<LearningMaterialModel>> searchAndSaveVideos({
    required String query,
    required String category,
    required String creatorId,
    int maxResults = 10,
  }) async {
    try {
      // Search videos from YouTube
      final searchResult = await _youtubeService.searchVideos(
        query: query,
        maxResults: maxResults,
      );

      final List<LearningMaterialModel> materials = [];

      if (searchResult['items'] != null) {
        for (final item in searchResult['items']) {
          final video = YouTubeVideo.fromJson(item);

          // Get additional video details
          final videoDetails = await _youtubeService.getVideoDetails(video.id);
          final detailedVideo = YouTubeVideo.fromJson(videoDetails['items'][0]);

          // Create learning material from YouTube video
          final material = LearningMaterialModel(
            id: '', // Will be assigned by Firestore
            title: detailedVideo.title,
            description: detailedVideo.description,
            category: category,
            type: 'youtube_video',
            url: detailedVideo.youtubeUrl,
            thumbnailUrl: detailedVideo.thumbnailUrl,
            creatorId: creatorId,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            tags: [
              'youtube',
              category.toLowerCase(),
              detailedVideo.channelTitle.toLowerCase(),
            ],
            difficulty: _estimateDifficulty(detailedVideo.title, detailedVideo.description),
            estimatedDuration: _parseDurationToMinutes(detailedVideo.formattedDuration),
            metadata: {
              'youtubeVideoId': detailedVideo.id,
              'channelTitle': detailedVideo.channelTitle,
              'channelId': detailedVideo.channelId,
              'publishedAt': detailedVideo.publishedAt.toIso8601String(),
              'viewCount': detailedVideo.viewCount,
              'likeCount': detailedVideo.likeCount,
              'commentCount': detailedVideo.commentCount,
              'duration': detailedVideo.duration,
            },
          );

          // Save to Firestore
          final docRef = await _firestoreService.addLearningMaterial(
            material.toFirestore(),
          );

          // Create updated material with Firestore ID
          final savedMaterial = LearningMaterialModel(
            id: docRef.id,
            title: material.title,
            description: material.description,
            category: material.category,
            type: material.type,
            url: material.url,
            thumbnailUrl: material.thumbnailUrl,
            creatorId: material.creatorId,
            createdAt: material.createdAt,
            updatedAt: material.updatedAt,
            tags: material.tags,
            difficulty: material.difficulty,
            estimatedDuration: material.estimatedDuration,
            metadata: material.metadata,
          );

          materials.add(savedMaterial);
        }
      }

      return materials;
    } catch (e) {
      throw Exception('Error searching and saving videos: $e');
    }
  }

  /// Mendapatkan video recommendations berdasarkan preferensi user
  Future<List<YouTubeVideo>> getRecommendations({
    required String userId,
    int maxResults = 20,
  }) async {
    try {
      // Get user data to understand preferences
      final userDoc = await _firestoreService.getUserData(userId);

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final user = UserModel.fromFirestore(userDoc);
      final preferences = user.preferences;

      // Get user's learning history
      final progressDocs = await _firestoreService.getUserProgress(userId);

      // Analyze user's interests from progress and preferences
      final interests = <String>[];

      // Add explicit preferences
      if (preferences['categories'] != null) {
        interests.addAll(List<String>.from(preferences['categories']));
      }

      // Add categories from completed materials
      for (final doc in progressDocs.docs) {
        final progress = UserProgressModel.fromFirestore(doc);
        if (progress.isCompleted) {
          // Get material details to understand category
          // This would require additional Firestore query
          // For now, we'll use basic recommendations
        }
      }

      // Default interests if none found
      if (interests.isEmpty) {
        interests.addAll(['programming', 'tutorial', 'education']);
      }

      // Search YouTube for each interest
      final List<YouTubeVideo> recommendations = [];

      for (final interest in interests.take(3)) { // Limit to 3 interests
        final searchResult = await _youtubeService.searchVideos(
          query: interest,
          maxResults: maxResults ~/ interests.length,
          order: 'relevance',
        );

        if (searchResult['items'] != null) {
          for (final item in searchResult['items']) {
            recommendations.add(YouTubeVideo.fromJson(item));
          }
        }
      }

      // Remove duplicates and sort by relevance
      final uniqueRecommendations = <String, YouTubeVideo>{};
      for (final video in recommendations) {
        uniqueRecommendations[video.id] = video;
      }

      return uniqueRecommendations.values.toList()..shuffle();
    } catch (e) {
      throw Exception('Error getting recommendations: $e');
    }
  }

  /// Menyimpan video YouTube yang dipilih user sebagai learning material
  Future<LearningMaterialModel> saveVideoAsMaterial({
    required String videoId,
    required String category,
    required String creatorId,
    List<String> additionalTags = const [],
  }) async {
    try {
      // Get video details from YouTube
      final videoDetails = await _youtubeService.getVideoDetails(videoId);

      if (videoDetails['items'] == null || videoDetails['items'].isEmpty) {
        throw Exception('Video not found');
      }

      final video = YouTubeVideo.fromJson(videoDetails['items'][0]);

      // Create learning material
      final material = LearningMaterialModel(
        id: '', // Will be assigned by Firestore
        title: video.title,
        description: video.description,
        category: category,
        type: 'youtube_video',
        url: video.youtubeUrl,
        thumbnailUrl: video.thumbnailUrl,
        creatorId: creatorId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [
          'youtube',
          category.toLowerCase(),
          video.channelTitle.toLowerCase(),
          ...additionalTags,
        ],
        difficulty: _estimateDifficulty(video.title, video.description),
        estimatedDuration: _parseDurationToMinutes(video.formattedDuration),
        metadata: {
          'youtubeVideoId': video.id,
          'channelTitle': video.channelTitle,
          'channelId': video.channelId,
          'publishedAt': video.publishedAt.toIso8601String(),
          'viewCount': video.viewCount,
          'likeCount': video.likeCount,
          'commentCount': video.commentCount,
          'duration': video.duration,
        },
      );

      // Save to Firestore
      final docRef = await _firestoreService.addLearningMaterial(
        material.toFirestore(),
      );

      return LearningMaterialModel(
        id: docRef.id,
        title: material.title,
        description: material.description,
        category: material.category,
        type: material.type,
        url: material.url,
        thumbnailUrl: material.thumbnailUrl,
        creatorId: material.creatorId,
        createdAt: material.createdAt,
        updatedAt: material.updatedAt,
        tags: material.tags,
        difficulty: material.difficulty,
        estimatedDuration: material.estimatedDuration,
        metadata: material.metadata,
      );
    } catch (e) {
      throw Exception('Error saving video as material: $e');
    }
  }

  /// Update user progress dan sync dengan preferences
  Future<void> updateLearningProgress({
    required String userId,
    required String materialId,
    required double progress,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Update progress in Firestore
      await _firestoreService.updateUserProgress(
        userId: userId,
        materialId: materialId,
        progressPercentage: progress,
        additionalData: additionalData,
      );

      // If material is completed, update user preferences
      if (progress >= 1.0) {
        await _updateUserPreferencesFromCompletion(userId, materialId);
      }
    } catch (e) {
      throw Exception('Error updating learning progress: $e');
    }
  }

  /// Private method untuk memperbarui preferensi user berdasarkan material yang diselesaikan
  Future<void> _updateUserPreferencesFromCompletion(
    String userId,
    String materialId,
  ) async {
    try {
      // Get material details
      final materialQuery = await _firestoreService.getLearningMaterials();
      final materialDoc = materialQuery.docs.firstWhere(
        (doc) => doc.id == materialId,
        orElse: () => throw Exception('Material not found'),
      );

      final material = LearningMaterialModel.fromFirestore(materialDoc);

      // Get current user data
      final userDoc = await _firestoreService.getUserData(userId);
      final user = UserModel.fromFirestore(userDoc);

      // Update preferences
      final updatedPreferences = Map<String, dynamic>.from(user.preferences);

      // Add category to preferred categories
      final categories = List<String>.from(updatedPreferences['categories'] ?? []);
      if (!categories.contains(material.category)) {
        categories.add(material.category);
        updatedPreferences['categories'] = categories;
      }

      // Add tags to interests
      final interests = List<String>.from(updatedPreferences['interests'] ?? []);
      for (final tag in material.tags) {
        if (!interests.contains(tag)) {
          interests.add(tag);
        }
      }
      updatedPreferences['interests'] = interests;

      // Update user data
      await _firestoreService.createOrUpdateUser(
        userId: userId,
        userData: user.copyWith(
          preferences: updatedPreferences,
          updatedAt: DateTime.now(),
        ).toFirestore(),
      );
    } catch (e) {
      // Log error but don't throw, as this is not critical
      // In production, use proper logging instead of print
      // print('Error updating user preferences: $e');
    }
  }

  /// Estimate difficulty berdasarkan title dan description
  int _estimateDifficulty(String title, String description) {
    final content = '${title.toLowerCase()} ${description.toLowerCase()}';

    // Beginner keywords
    if (content.contains(RegExp(r'\b(beginner|basic|intro|introduction|tutorial|start)\b'))) {
      return 1;
    }

    // Advanced keywords
    if (content.contains(RegExp(r'\b(advanced|expert|professional|complex|deep)\b'))) {
      return 4;
    }

    // Intermediate keywords
    if (content.contains(RegExp(r'\b(intermediate|medium|guide|complete)\b'))) {
      return 3;
    }

    // Default to easy
    return 2;
  }

  /// Parse duration string ke menit
  int _parseDurationToMinutes(String formattedDuration) {
    if (formattedDuration.isEmpty) return 0;

    try {
      final parts = formattedDuration.split(':');
      if (parts.length == 2) {
        // Format: MM:SS
        return int.parse(parts[0]);
      } else if (parts.length == 3) {
        // Format: HH:MM:SS
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      }
    } catch (e) {
      // If parsing fails, return 0
    }

    return 0;
  }
}
