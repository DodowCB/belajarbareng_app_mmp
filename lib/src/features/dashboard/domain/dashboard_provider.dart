import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../api/models/firebase_models.dart';
import '../../../api/models/youtube_models.dart';

import '../../../api/youtube/youtube_api_service.dart';
import '../../../api/firebase/firestore_service.dart';
import '../../../core/utils/dummy_data.dart';

/// State untuk Dashboard
class DashboardState {
  final bool isLoading;
  final List<LearningMaterialModel> trendingMaterials;
  final List<LearningMaterialModel> recommendedMaterials;
  final List<YouTubeVideo> recentVideos;
  final List<StudyGroupModel> popularGroups;
  final Map<String, int> userStats;
  final String? error;

  DashboardState({
    this.isLoading = false,
    this.trendingMaterials = const [],
    this.recommendedMaterials = const [],
    this.recentVideos = const [],
    this.popularGroups = const [],
    this.userStats = const {},
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    List<LearningMaterialModel>? trendingMaterials,
    List<LearningMaterialModel>? recommendedMaterials,
    List<YouTubeVideo>? recentVideos,
    List<StudyGroupModel>? popularGroups,
    Map<String, int>? userStats,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      trendingMaterials: trendingMaterials ?? this.trendingMaterials,
      recommendedMaterials: recommendedMaterials ?? this.recommendedMaterials,
      recentVideos: recentVideos ?? this.recentVideos,
      popularGroups: popularGroups ?? this.popularGroups,
      userStats: userStats ?? this.userStats,
      error: error,
    );
  }
}

/// Dashboard Provider
class DashboardNotifier extends StateNotifier<DashboardState> {
  final YouTubeApiService _youtubeService;
  final FirestoreService _firestoreService;

  DashboardNotifier({
    required YouTubeApiService youtubeService,
    required FirestoreService firestoreService,
  }) : _youtubeService = youtubeService,
       _firestoreService = firestoreService,
       super(DashboardState());

  /// Load semua data dashboard
  Future<void> loadDashboardData({String? userId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate loading delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      // Use dummy data for now (Firebase might not be configured yet)
      state = state.copyWith(
        isLoading: false,
        trendingMaterials: DummyData.learningMaterials,
        recommendedMaterials: DummyData.learningMaterials.take(5).toList(),
        recentVideos: DummyData.youtubeVideos,
        popularGroups: DummyData.studyGroups,
        userStats: DummyData.userStats,
      );

      // Uncomment below for actual API calls when Firebase is ready
      /*
      final results = await Future.wait([
        _loadTrendingMaterials(),
        _loadRecommendations(userId),
        _loadRecentVideos(),
        _loadPopularGroups(),
        if (userId != null) _loadUserStats(userId),
      ]);

      state = state.copyWith(
        isLoading: false,
        trendingMaterials: results[0] as List<LearningMaterialModel>,
        recommendedMaterials: results[1] as List<LearningMaterialModel>,
        recentVideos: results[2] as List<YouTubeVideo>,
        popularGroups: results[3] as List<StudyGroupModel>,
        userStats: userId != null ? results[4] as Map<String, int> : {},
      );
      */
    } catch (e) {
      // If error, still show dummy data
      state = state.copyWith(
        isLoading: false,
        trendingMaterials: DummyData.learningMaterials,
        recentVideos: DummyData.youtubeVideos,
        popularGroups: DummyData.studyGroups,
        userStats: DummyData.userStats,
      );
    }
  }

  /// Load trending materials (materials dengan banyak views/likes)
  Future<List<LearningMaterialModel>> _loadTrendingMaterials() async {
    try {
      final snapshot = await _firestoreService.getLearningMaterials();
      final materials = snapshot.docs
          .map((doc) => LearningMaterialModel.fromFirestore(doc))
          .toList();

      // Sort berdasarkan created date (newest first)
      materials.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return materials.take(10).toList();
    } catch (e) {
      return [];
    }
  }

  /// Refresh dashboard data
  Future<void> refresh({String? userId}) async {
    await loadDashboardData(userId: userId);
  }

  /// Search materials by query
  Future<void> searchMaterials(String query) async {
    if (query.isEmpty) {
      await loadDashboardData();
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      // Search di Firestore
      final snapshot = await _firestoreService.getLearningMaterials();
      final allMaterials = snapshot.docs
          .map((doc) => LearningMaterialModel.fromFirestore(doc))
          .toList();

      final filtered = allMaterials.where((material) {
        final searchLower = query.toLowerCase();
        return material.title.toLowerCase().contains(searchLower) ||
            material.description.toLowerCase().contains(searchLower) ||
            material.tags.any((tag) => tag.toLowerCase().contains(searchLower));
      }).toList();

      state = state.copyWith(isLoading: false, trendingMaterials: filtered);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Gagal mencari materials: ${e.toString()}',
      );
    }
  }
}

/// Provider untuk Dashboard
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      // Initialize services
      final youtubeService = YouTubeApiService(
        apiKey: 'AIzaSyA3DMOyDiG7F9dL7YIWc54QjPouNn01820E',
      );
      final firestoreService = FirestoreService();
      return DashboardNotifier(
        youtubeService: youtubeService,
        firestoreService: firestoreService,
      );
    });
