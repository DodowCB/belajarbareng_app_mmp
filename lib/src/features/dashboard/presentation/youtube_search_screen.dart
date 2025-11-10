import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/api.dart';
import '../../../core/providers/theme_provider.dart';

/// Screen untuk mencari dan menampilkan video YouTube
/// Digunakan untuk mencari video pembelajaran dan tutorial
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

  // Filter options
  String _selectedOrder = 'relevance';
  String _selectedDuration = 'any';
  String _selectedUploadDate = 'any';
  int _selectedMaxResults = 10;

  @override
  void initState() {
    super.initState();
    _youtubeService = YouTubeApiService(apiKey: ApiConfig.youtubeApiKey);
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
      // Validate search query
      final query = _searchController.text.trim();
      if (query.length < 2) {
        setState(() {
          _statusMessage = 'Kata kunci pencarian terlalu pendek (minimal 2 karakter)';
        });
        return;
      }

      // Check if API key is configured properly
      if (ApiConfig.youtubeApiKey == 'YOUR_YOUTUBE_API_KEY_HERE' ||
          ApiConfig.youtubeApiKey.isEmpty ||
          ApiConfig.youtubeApiKey.length < 30) {
        setState(() {
          _statusMessage = 'YouTube API key belum dikonfigurasi. Menampilkan video demo.';
          _searchResults = _getDummyVideos();
        });
        return;
      }

      final searchResult = await _youtubeService.searchVideosWithFallback(
        query: query,
        maxResults: _selectedMaxResults,
      );

      if (searchResult['items'] != null && searchResult['items'].isNotEmpty) {
        final videos = <YouTubeVideo>[];
        for (final item in searchResult['items']) {
          try {
            videos.add(YouTubeVideo.fromJson(item));
          } catch (e) {
            debugPrint('Error parsing video: $e');
          }
        }

        setState(() {
          _searchResults = videos;
          _statusMessage = videos.isNotEmpty
              ? 'Ditemukan ${videos.length} video'
              : 'Video ditemukan tapi gagal diparse';
        });
      } else {
        setState(() {
          _statusMessage = 'Tidak ada video ditemukan untuk "$query"';
        });
      }
    } catch (e) {
      debugPrint('Unexpected error in search: $e');
      setState(() {
        _statusMessage = 'Terjadi kesalahan tidak terduga. Menampilkan video demo.';
        _searchResults = _getDummyVideos();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Generate dummy videos for demo when API fails
  List<YouTubeVideo> _getDummyVideos() {
    return [
      YouTubeVideo(
        id: 'demo1',
        title: 'Flutter Tutorial for Beginners - Complete Course',
        description: 'Learn Flutter from scratch with this comprehensive tutorial.',
        thumbnailUrl: 'https://i.ytimg.com/vi/1gDhl4leEzA/hqdefault.jpg',
        channelTitle: 'Flutter Academy',
        channelId: 'UCflutter',
        publishedAt: DateTime.now().subtract(const Duration(days: 30)),
        duration: 'PT45M30S',
        viewCount: 125000,
        likeCount: 8500,
        commentCount: 450,
      ),
      YouTubeVideo(
        id: 'demo2',
        title: 'Advanced Flutter State Management with Riverpod',
        description: 'Master state management in Flutter using Riverpod.',
        thumbnailUrl: 'https://i.ytimg.com/vi/A5iK2TwsY_A/hqdefault.jpg',
        channelTitle: 'Code with Expert',
        channelId: 'UCcode',
        publishedAt: DateTime.now().subtract(const Duration(days: 15)),
        duration: 'PT32M15S',
        viewCount: 89000,
        likeCount: 4200,
        commentCount: 280,
      ),
      YouTubeVideo(
        id: 'demo3',
        title: 'JavaScript ES6+ Modern Features',
        description: 'Learn modern JavaScript features.',
        thumbnailUrl: 'https://i.ytimg.com/vi/nZ1DMMsyVyI/hqdefault.jpg',
        channelTitle: 'Web Dev Pro',
        channelId: 'UCwebdev',
        publishedAt: DateTime.now().subtract(const Duration(days: 12)),
        duration: 'PT38M20S',
        viewCount: 156000,
        likeCount: 9200,
        commentCount: 520,
      ),
    ];
  }

  Future<void> _openVideo(YouTubeVideo video) async {
    final url = Uri.parse(video.youtubeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka video')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Search'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
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
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari video YouTube...',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onSubmitted: (_) => _searchVideos(),
                    onChanged: (value) => setState(() {}),
                    textInputAction: TextInputAction.search,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _isLoading ? null : _searchVideos,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.search),
                  label: const Text('Cari'),
                ),
              ],
            ),
          ),

          // Status card
          Container(
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
          ),

          const SizedBox(height: 8),

          // Results list
          Expanded(
            child: _searchResults.isEmpty
                ? _buildEmptyState()
                : _buildVideosList(),
          ),
        ],
        ),
      ),

      // Floating action button for quick clear
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
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        return _buildVideoCard(_searchResults[index]);
      },
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
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                SizedBox(
                  width: 120,
                  height: 68,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SizedBox(
                          width: 120,
                          height: 68,
                          child: video.thumbnailUrl.isNotEmpty
                              ? Image.network(
                                  video.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      child: const Icon(Icons.video_library, size: 24),
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      child: const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : ColoredBox(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: const Icon(Icons.video_library, size: 24),
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
                                fontWeight: FontWeight.w600,
                              ),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        video.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video.channelTitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        video.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        video.formattedViewCount,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
