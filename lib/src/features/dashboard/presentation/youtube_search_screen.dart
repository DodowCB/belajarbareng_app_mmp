import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api/api.dart';
import '../../../core/providers/theme_provider.dart';

/// Enhanced YouTube search screen dengan theme toggle dan video player
class YouTubeSearchScreen extends ConsumerStatefulWidget {
  const YouTubeSearchScreen({super.key});

  @override
  ConsumerState<YouTubeSearchScreen> createState() => _YouTubeSearchScreenState();
}

class _YouTubeSearchScreenState extends ConsumerState<YouTubeSearchScreen> {
  late final YouTubeApiService _youtubeService;

  final TextEditingController _searchController = TextEditingController();
  List<YouTubeVideo> _searchResults = [];
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize services
    _youtubeService = YouTubeApiService(apiKey: ApiConfig.youtubeApiKey);

    // Set default search
    _searchController.text = 'flutter tutorial';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchVideos() async {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _statusMessage = 'Masukkan kata kunci pencarian';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Mencari video...';
      _searchResults.clear();
    });

    try {
      // Check if API key is configured
      if (ApiConfig.youtubeApiKey == 'YOUR_YOUTUBE_API_KEY_HERE' || ApiConfig.youtubeApiKey.isEmpty) {
        setState(() {
          _statusMessage = 'YouTube API key belum dikonfigurasi. Silakan update ApiConfig.youtubeApiKey';
          _searchResults = _getDummyVideos(); // Show dummy videos for demo
        });
        return;
      }

      final searchResult = await _youtubeService.searchVideos(
        query: _searchController.text.trim(),
        maxResults: 10, // Reduced to avoid rate limits
        order: 'relevance',
      );

      if (searchResult['items'] != null && searchResult['items'].isNotEmpty) {
        final videos = <YouTubeVideo>[];
        for (final item in searchResult['items']) {
          try {
            // Use basic search result first, then get details if needed
            videos.add(YouTubeVideo.fromJson(item));
          } catch (e) {
            debugPrint('Error parsing video: $e');
          }
        }

        setState(() {
          _searchResults = videos;
          _statusMessage = 'Ditemukan ${videos.length} video';
        });
      } else {
        setState(() {
          _statusMessage = 'Tidak ada video ditemukan';
        });
      }
    } catch (e) {
      String errorMessage = 'Error pencarian video';
      if (e.toString().contains('400')) {
        errorMessage = 'API key tidak valid atau quota habis. Menampilkan demo video.';
        setState(() {
          _statusMessage = errorMessage;
          _searchResults = _getDummyVideos();
        });
      } else {
        setState(() {
          _statusMessage = 'Error: ${e.toString()}';
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Dummy videos for demo when API key is not configured
  List<YouTubeVideo> _getDummyVideos() {
    return [
      YouTubeVideo(
        id: 'dQw4w9WgXcQ',
        title: 'Flutter Tutorial for Beginners - Complete Course',
        description: 'Learn Flutter development from scratch with this comprehensive tutorial covering widgets, state management, and more.',
        thumbnailUrl: 'https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
        channelTitle: 'Flutter Channel',
        channelId: 'UCwXdFgeE9KYzlDdR7TG9cMw',
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        duration: 'PT1H30M45S',
        viewCount: 1234567,
        likeCount: 12345,
        commentCount: 890,
      ),
      YouTubeVideo(
        id: 'abc123def456',
        title: 'Advanced Flutter State Management with Riverpod',
        description: 'Master state management in Flutter using Riverpod. Learn providers, state notifiers, and best practices.',
        thumbnailUrl: 'https://i.ytimg.com/vi/abc123def456/hqdefault.jpg',
        channelTitle: 'Code Academy',
        channelId: 'UCdef456ghi789',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        duration: 'PT45M20S',
        viewCount: 567890,
        likeCount: 8901,
        commentCount: 234,
      ),
      YouTubeVideo(
        id: 'xyz789abc012',
        title: 'Building Beautiful UI with Flutter Widgets',
        description: 'Explore Flutter widgets and create stunning user interfaces. Custom widgets, animations, and more.',
        thumbnailUrl: 'https://i.ytimg.com/vi/xyz789abc012/hqdefault.jpg',
        channelTitle: 'UI Masters',
        channelId: 'UCjkl012mno345',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        duration: 'PT25M15S',
        viewCount: 234567,
        likeCount: 3456,
        commentCount: 123,
      ),
    ];
  }

  Future<void> _openVideo(YouTubeVideo video) async {
    try {
      final uri = Uri.parse(video.youtubeUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka video')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildThemeToggle() {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return IconButton(
      onPressed: () {
        ref.read(themeModeProvider.notifier).toggleTheme();
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey(isDark),
        ),
      ),
      tooltip: isDark ? 'Light Mode' : 'Dark Mode',
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari video YouTube...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onSubmitted: (_) => _searchVideos(),
              textInputAction: TextInputAction.search,
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _isLoading ? null : _searchVideos,
            icon: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.search),
            label: const Text('Cari'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _statusMessage.isEmpty ? 'Siap untuk mencari video' : _statusMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(YouTubeVideo video) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: InkWell(
        onTap: () => _openVideo(video),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: 120,
                height: 90,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        width: 120,
                        height: 90,
                        child: video.thumbnailUrl.isNotEmpty
                            ? Image.network(
                                video.thumbnailUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    child: const Icon(Icons.video_library, size: 32),
                                  );
                                },
                              )
                            : Container(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.video_library, size: 32),
                              ),
                      ),
                    ),
                    // Duration badge
                    if (video.formattedDuration.isNotEmpty)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            video.formattedDuration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    // Play button overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.play_circle_outline,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Video info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Video title
                    Text(
                      video.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Channel name
                    Text(
                      video.channelTitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // View count
                    Text(
                      video.formattedViewCount,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Description (compact)
                    if (video.description.isNotEmpty)
                      Text(
                        video.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Action button
              IconButton(
                onPressed: () => _openVideo(video),
                icon: const Icon(Icons.play_arrow),
                tooltip: 'Tonton Video',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Search'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          _buildThemeToggle(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar - fixed at top
            _buildSearchBar(),

            // Status card - fixed
            _buildStatusCard(),

            const SizedBox(height: 8),

            // Results list - expandable
            Expanded(
              child: _searchResults.isEmpty
                  ? _buildEmptyState()
                  : _buildVideosList(),
            ),
          ],
        ),
      ),

      // Floating action button for quick search
      floatingActionButton: _searchResults.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults.clear();
                  _statusMessage = '';
                });
              },
              tooltip: 'Clear Results',
              child: const Icon(Icons.clear),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              _isLoading
                ? 'Mencari video...'
                : 'Cari video YouTube untuk mulai',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              FilledButton.icon(
                onPressed: _searchVideos,
                icon: const Icon(Icons.search),
                label: const Text('Mulai Pencarian'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80), // Space for FAB
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        return _buildVideoCard(_searchResults[index]);
      },
    );
  }
}
