import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/theme.dart';
import '../../../api/youtube/youtube_api_service.dart';
import '../../../api/models/youtube_models.dart';
import '../../../api/api_config.dart';

class CreateMaterialScreen extends ConsumerStatefulWidget {
  const CreateMaterialScreen({super.key});

  @override
  ConsumerState<CreateMaterialScreen> createState() => _CreateMaterialScreenState();
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
              content: const Text('Kata kunci pencarian terlalu pendek (minimal 2 karakter)'),
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
              content: const Text('YouTube API key belum dikonfigurasi. Menampilkan data demo.'),
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
              child: Text('Material "${video.title}" saved to $_selectedCategory!'),
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
        description: 'Learn Flutter from scratch with this comprehensive tutorial. Perfect for beginners who want to start mobile app development.',
        thumbnailUrl: 'https://img.youtube.com/vi/1gDhl4leEzA/maxresdefault.jpg',
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
        description: 'Master state management in Flutter using Riverpod. Learn best practices and advanced patterns.',
        thumbnailUrl: 'https://img.youtube.com/vi/A5iK2TwsY_A/maxresdefault.jpg',
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
        description: 'Learn modern JavaScript features including arrow functions, async/await, destructuring and more.',
        thumbnailUrl: 'https://img.youtube.com/vi/nZ1DMMsyVyI/maxresdefault.jpg',
        channelTitle: 'Web Dev Pro',
        channelId: 'UCwebdev',
        publishedAt: DateTime.now().subtract(const Duration(days: 12)),
        duration: 'PT38M20S',
        viewCount: 156000,
        likeCount: 9200,
        commentCount: 520,
      ),
      YouTubeVideo(
        id: 'prog4',
        title: 'Python Data Science Complete Guide',
        description: 'Complete guide to data science with Python. Learn pandas, numpy, matplotlib and scikit-learn.',
        thumbnailUrl: 'https://img.youtube.com/vi/rfscVS0vtbw/maxresdefault.jpg',
        channelTitle: 'Data Science Hub',
        channelId: 'UCdatascience',
        publishedAt: DateTime.now().subtract(const Duration(days: 20)),
        duration: 'PT52M10S',
        viewCount: 234000,
        likeCount: 12500,
        commentCount: 680,
      ),
      // Mathematics Videos
      YouTubeVideo(
        id: 'math1',
        title: 'Linear Algebra for Machine Learning',
        description: 'Essential linear algebra concepts every programmer should know. Great for machine learning and graphics.',
        thumbnailUrl: 'https://img.youtube.com/vi/aircAruvnKk/maxresdefault.jpg',
        channelTitle: 'Math Academy',
        channelId: 'UCmath',
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        duration: 'PT28M45S',
        viewCount: 67000,
        likeCount: 3800,
        commentCount: 190,
      ),
      YouTubeVideo(
        id: 'math2',
        title: 'Calculus Made Easy - Complete Course',
        description: 'Master calculus from basics to advanced topics. Perfect for students and professionals.',
        thumbnailUrl: 'https://img.youtube.com/vi/WUvTyaaNkzM/maxresdefault.jpg',
        channelTitle: 'Math Masters',
        channelId: 'UCmathmaster',
        publishedAt: DateTime.now().subtract(const Duration(days: 25)),
        duration: 'PT55M20S',
        viewCount: 89000,
        likeCount: 5200,
        commentCount: 310,
      ),
      // Science Videos
      YouTubeVideo(
        id: 'sci1',
        title: 'Physics for Beginners - Mechanics',
        description: 'Introduction to classical mechanics and physics fundamentals.',
        thumbnailUrl: 'https://img.youtube.com/vi/ZM8ECpBuQYE/maxresdefault.jpg',
        channelTitle: 'Science World',
        channelId: 'UCscience',
        publishedAt: DateTime.now().subtract(const Duration(days: 18)),
        duration: 'PT42M15S',
        viewCount: 75000,
        likeCount: 4100,
        commentCount: 230,
      ),
      YouTubeVideo(
        id: 'sci2',
        title: 'Chemistry Basics - Atomic Structure',
        description: 'Understanding atoms, molecules, and chemical bonds.',
        thumbnailUrl: 'https://img.youtube.com/vi/yQP4UJhNn0I/maxresdefault.jpg',
        channelTitle: 'Chemistry Central',
        channelId: 'UCchem',
        publishedAt: DateTime.now().subtract(const Duration(days: 14)),
        duration: 'PT35M30S',
        viewCount: 62000,
        likeCount: 3400,
        commentCount: 180,
      ),
      // Languages Videos
      YouTubeVideo(
        id: 'lang1',
        title: 'English Grammar Essentials',
        description: 'Master English grammar with practical examples and exercises.',
        thumbnailUrl: 'https://img.youtube.com/vi/P8mAnhNZIbM/maxresdefault.jpg',
        channelTitle: 'Language Learning Hub',
        channelId: 'UClang',
        publishedAt: DateTime.now().subtract(const Duration(days: 10)),
        duration: 'PT38M45S',
        viewCount: 95000,
        likeCount: 5800,
        commentCount: 420,
      ),
      // Business Videos
      YouTubeVideo(
        id: 'biz1',
        title: 'Entrepreneurship 101 - Starting Your Business',
        description: 'Learn the fundamentals of starting and running a successful business.',
        thumbnailUrl: 'https://img.youtube.com/vi/lJjP8Kj_bJY/maxresdefault.jpg',
        channelTitle: 'Business Mastery',
        channelId: 'UCbiz',
        publishedAt: DateTime.now().subtract(const Duration(days: 8)),
        duration: 'PT48M20S',
        viewCount: 112000,
        likeCount: 6700,
        commentCount: 520,
      ),
    ];

    // Filter by category first
    List<YouTubeVideo> filteredByCategory = [];

    switch (_selectedCategory) {
      case 'Programming':
        filteredByCategory = allDummyVideos.where((video) =>
          video.id.startsWith('prog') ||
          video.title.toLowerCase().contains('flutter') ||
          video.title.toLowerCase().contains('javascript') ||
          video.title.toLowerCase().contains('python') ||
          video.title.toLowerCase().contains('programming')).toList();
        break;
      case 'Mathematics':
        filteredByCategory = allDummyVideos.where((video) =>
          video.id.startsWith('math') ||
          video.title.toLowerCase().contains('algebra') ||
          video.title.toLowerCase().contains('calculus') ||
          video.title.toLowerCase().contains('math')).toList();
        break;
      case 'Science':
        filteredByCategory = allDummyVideos.where((video) =>
          video.id.startsWith('sci') ||
          video.title.toLowerCase().contains('physics') ||
          video.title.toLowerCase().contains('chemistry') ||
          video.title.toLowerCase().contains('science')).toList();
        break;
      case 'Languages':
        filteredByCategory = allDummyVideos.where((video) =>
          video.id.startsWith('lang') ||
          video.title.toLowerCase().contains('english') ||
          video.title.toLowerCase().contains('grammar') ||
          video.title.toLowerCase().contains('language')).toList();
        break;
      case 'Business':
        filteredByCategory = allDummyVideos.where((video) =>
          video.id.startsWith('biz') ||
          video.title.toLowerCase().contains('business') ||
          video.title.toLowerCase().contains('entrepreneur')).toList();
        break;
      default:
        // For other categories, show programming videos as fallback
        filteredByCategory = allDummyVideos.where((video) =>
          video.id.startsWith('prog')).toList();
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
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.black, // Text berwarna hitam
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for tutorials, courses...',
                    hintStyle: TextStyle(
                      color: Colors.grey[600], // Hint text berwarna abu-abu
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchResults = [];
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.blue),
                          onPressed: _searchVideos,
                        ),
                      ],
                    )
                        : IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.grey),
                      onPressed: _searchVideos,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onSubmitted: (_) => _searchVideos(),
                  onChanged: (value) => setState(() {}), // Update clear button visibility
                ),
                const SizedBox(height: 16),
                // Category Selection
                const Text(
                  'Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ApiConfig.categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Container(
                      margin: const EdgeInsets.only(right: 4, bottom: 4),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                            // Trigger search with new category if there's a query
                            if (_searchController.text.isNotEmpty || _searchResults.isNotEmpty) {
                              _searchResults = _getDummyVideos(); // Update results immediately
                            }
                          });
                        },
                        selectedColor: AppTheme.secondaryTeal,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        elevation: isSelected ? 3 : 1,
                        pressElevation: 6,
                        shadowColor: AppTheme.secondaryTeal.withValues(alpha: 0.3),
                        side: isSelected
                          ? BorderSide(color: Colors.white.withValues(alpha: 0.8), width: 2)
                          : null,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Results Section
          Expanded(
            child: _buildResultsSection(),
          ),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for "Flutter tutorial" or "Math lessons"',
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
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Category indicator
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryPurple.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.category_rounded,
                size: 16,
                color: AppTheme.primaryPurple,
              ),
              const SizedBox(width: 6),
              Text(
                'Category: $_selectedCategory (${_searchResults.length} videos)',
                style: TextStyle(
                  color: AppTheme.primaryPurple,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        // Videos grid - 5 kolom
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 5 kolom
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7, // Rasio tinggi/lebar card
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final video = _searchResults[index];
              return _VideoResultCard(
                video: video,
                onSave: () => _saveMaterial(video),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VideoResultCard extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onSave;

  const _VideoResultCard({
    required this.video,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppTheme.primaryPurple.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            // Show details
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _VideoDetailsSheet(
                video: video,
                onSave: onSave,
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail with gradient overlay
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryPurple.withValues(alpha: 0.1),
                            AppTheme.secondaryTeal.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: Image.network(
                        video.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.primaryPurple.withValues(alpha: 0.3),
                                  AppTheme.secondaryTeal.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_outline_rounded,
                                size: 72,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Gradient overlay for better text readability
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Duration badge with improved styling
                    if (video.formattedDuration.isNotEmpty)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            video.formattedDuration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    // Play icon overlay
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: AppTheme.primaryPurple,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content with enhanced styling
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with better typography
                    Text(
                      video.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Channel info with icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_circle_rounded,
                            size: 20,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            video.channelTitle,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryPurple,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // Stats row
                    if (video.viewCount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            video.formattedViewCount,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (video.likeCount > 0) ...[
                            const SizedBox(width: 16),
                            Icon(
                              Icons.thumb_up_outlined,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${video.likeCount}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Enhanced Add button
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryPurple,
                              AppTheme.primaryPurple.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: onSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.library_add_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'Add to Library',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoDetailsSheet extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onSave;

  const _VideoDetailsSheet({
    required this.video,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.textLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    video.thumbnailUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  video.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.account_circle, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      video.channelTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  children: [
                    if (video.viewCount > 0)
                      _InfoChip(
                        icon: Icons.visibility_outlined,
                        label: video.formattedViewCount,
                      ),
                    if (video.likeCount > 0)
                      _InfoChip(
                        icon: Icons.thumb_up_outlined,
                        label: '${video.likeCount}',
                      ),
                    if (video.formattedDuration.isNotEmpty)
                      _InfoChip(
                        icon: Icons.access_time,
                        label: video.formattedDuration,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  video.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onSave();
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add to Library'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryPurple,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryPurple),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.primaryPurple,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
