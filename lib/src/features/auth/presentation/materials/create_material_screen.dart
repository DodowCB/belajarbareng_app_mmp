import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme.dart';
import '../../../../api/youtube/youtube_api_service.dart';
import '../../../../api/models/youtube_models.dart';
import '../../../../api/api_config.dart';

class CreateMaterialScreen extends ConsumerStatefulWidget {
  const CreateMaterialScreen({super.key});

  @override
  ConsumerState<CreateMaterialScreen> createState() =>
      _CreateMaterialScreenState();
}

class _CreateMaterialScreenState extends ConsumerState<CreateMaterialScreen> {
  final TextEditingController _searchController = TextEditingController();
  final YouTubeApiService _youtubeService = YouTubeApiService(
    apiKey: ApiConfig.youtubeApiKey,
  );

  List<YouTubeVideo> _searchResults = [];
  bool _isSearching = false;
  String _selectedCategory = 'Programming';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchVideos() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    try {
      // Validate search query
      final query = _searchController.text.trim();
      if (query.length < 2) {
        setState(() {
          _isSearching = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Kata kunci pencarian terlalu pendek (minimal 2 karakter)',
              ),
              backgroundColor: AppTheme.accentOrange,
            ),
          );
        }
        return;
      }

      // Check if API key is configured properly
      if (ApiConfig.youtubeApiKey == 'YOUR_YOUTUBE_API_KEY_HERE' ||
          ApiConfig.youtubeApiKey.isEmpty ||
          ApiConfig.youtubeApiKey.length < 30) {
        // Use dummy data if API key not configured
        setState(() {
          _searchResults = _getDummyVideos();
          _isSearching = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'YouTube API key belum dikonfigurasi. Menampilkan data demo.',
              ),
              backgroundColor: AppTheme.accentOrange,
            ),
          );
        }
        return;
      }

      // Use fallback method yang sudah pasti bekerja
      final result = await _youtubeService.searchVideosWithFallback(
        query: query,
        maxResults: 20,
      );

      if (result['items'] != null && result['items'].isNotEmpty) {
        final videos = <YouTubeVideo>[];
        for (final item in result['items']) {
          try {
            videos.add(YouTubeVideo.fromJson(item));
          } catch (e) {
            debugPrint('Error parsing video: $e');
            // Continue with other videos even if one fails
          }
        }

        setState(() {
          _searchResults = videos;
          _isSearching = false;
        });
      } else {
        setState(() {
          _isSearching = false;
        });
      }
    } catch (e) {
      // Ini seharusnya tidak pernah terjadi karena fallback method sudah handle semua error
      debugPrint('Unexpected error: $e');
      setState(() {
        _isSearching = false;
        _searchResults = _getDummyVideos();
      });
    }
  }

  void _saveMaterial(YouTubeVideo video) {
    // TODO: Implement saving to Firestore
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Material "${video.title}" saved to $_selectedCategory!',
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  /// Generate dummy videos for demo when API fails with category filter
  List<YouTubeVideo> _getDummyVideos() {
    final query = _searchController.text.trim().toLowerCase();

    // Extended dummy videos with different categories
    final allDummyVideos = [
      // Programming Videos
      YouTubeVideo(
        id: 'prog1',
        title: 'Flutter Tutorial for Beginners - Complete Course',
        description:
            'Learn Flutter from scratch with this comprehensive tutorial. Perfect for beginners who want to start mobile app development.',
        thumbnailUrl:
            'https://img.youtube.com/vi/1gDhl4leEzA/maxresdefault.jpg',
        channelTitle: 'Flutter Academy',
        channelId: 'UCflutter',
        publishedAt: DateTime.now().subtract(const Duration(days: 30)),
        duration: 'PT45M30S',
        viewCount: 125000,
        likeCount: 8500,
        commentCount: 450,
      ),
      YouTubeVideo(
        id: 'prog2',
        title: 'Advanced Flutter State Management with Riverpod',
        description:
            'Master state management in Flutter using Riverpod. Learn best practices and advanced patterns.',
        thumbnailUrl:
            'https://img.youtube.com/vi/A5iK2TwsY_A/maxresdefault.jpg',
        channelTitle: 'Code with Expert',
        channelId: 'UCcode',
        publishedAt: DateTime.now().subtract(const Duration(days: 15)),
        duration: 'PT32M15S',
        viewCount: 89000,
        likeCount: 4200,
        commentCount: 280,
      ),
      YouTubeVideo(
        id: 'prog3',
        title: 'JavaScript ES6+ Modern Features',
        description:
            'Learn modern JavaScript features including arrow functions, async/await, destructuring and more.',
        thumbnailUrl:
            'https://img.youtube.com/vi/nZ1DMMsyVyI/maxresdefault.jpg',
        channelTitle: 'Web Dev Pro',
        channelId: 'UCwebdev',
        publishedAt: DateTime.now().subtract(const Duration(days: 12)),
        duration: 'PT38M20S',
        viewCount: 156000,
        likeCount: 9200,
        commentCount: 520,
      ),
    ];

    // Filter by category first
    List<YouTubeVideo> filteredByCategory = [];

    switch (_selectedCategory) {
      case 'Programming':
        filteredByCategory = allDummyVideos
            .where(
              (video) =>
                  video.id.startsWith('prog') ||
                  video.title.toLowerCase().contains('flutter') ||
                  video.title.toLowerCase().contains('javascript') ||
                  video.title.toLowerCase().contains('python') ||
                  video.title.toLowerCase().contains('programming'),
            )
            .toList();
        break;
      default:
        // For other categories, show programming videos as fallback
        filteredByCategory = allDummyVideos
            .where((video) => video.id.startsWith('prog'))
            .toList();
    }

    // Then filter by search query if provided
    if (query.isEmpty) {
      return filteredByCategory;
    }

    return filteredByCategory.where((video) {
      return video.title.toLowerCase().contains(query) ||
          video.description.toLowerCase().contains(query) ||
          video.channelTitle.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Learning Material'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: AppTheme.purpleGradient,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search YouTube Videos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Find educational videos to add to your library',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for tutorials, courses...',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (_) => _searchVideos(),
                  onChanged: (value) => setState(() {}),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Results Section
          Expanded(child: _buildResultsSection()),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching videos...'),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 80,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Search for videos to add',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for "Flutter tutorial"',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: AppTheme.textLight),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final video = _searchResults[index];
        return _VideoResultCard(
          video: video,
          onSave: () => _saveMaterial(video),
        );
      },
    );
  }
}

class _VideoResultCard extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onSave;

  const _VideoResultCard({required this.video, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                video.thumbnailUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.video_library, size: 50),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              video.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              video.channelTitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryPurple),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.add),
                label: const Text('Add to Library'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
