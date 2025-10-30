import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../api/api.dart';
import '../../../core/providers/theme_provider.dart';
import 'youtube_search_screen.dart';

/// Example screen showing how to use the API services
/// This file serves as a reference for developers
class ApiExampleScreen extends ConsumerStatefulWidget {
  const ApiExampleScreen({super.key});

  @override
  ConsumerState<ApiExampleScreen> createState() => _ApiExampleScreenState();
}

class _ApiExampleScreenState extends ConsumerState<ApiExampleScreen> {
  late final YouTubeApiService _youtubeService;
  late final FirebaseAuthService _authService;
  late final FirestoreService _firestoreService;
  late final IntegratedApiService _integratedService;

  List<YouTubeVideo> _searchResults = [];
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    // Initialize services
    // NOTE: Replace with actual API key
    _youtubeService = YouTubeApiService(apiKey: ApiConfig.youtubeApiKey);
    _authService = FirebaseAuthService();
    _firestoreService = FirestoreService();
    _integratedService = IntegratedApiService(
      youtubeService: _youtubeService,
      firestoreService: _firestoreService,
    );
  }

  Future<void> _searchYouTubeVideos() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Searching YouTube videos...';
    });

    try {
      final searchResult = await _youtubeService.searchVideos(
        query: 'flutter tutorial',
        maxResults: 5,
      );

      if (searchResult['items'] != null) {
        final videos = <YouTubeVideo>[];
        for (final item in searchResult['items']) {
          videos.add(YouTubeVideo.fromJson(item));
        }

        setState(() {
          _searchResults = videos;
          _statusMessage = 'Found ${videos.length} videos';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Signing in with Google...';
    });

    try {
      final userCredential = await _authService.signInWithGoogle();
      setState(() {
        _statusMessage = 'Signed in as ${userCredential.user?.displayName}';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Sign in error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createSampleStudyGroup() async {
    if (_authService.currentUser == null) {
      setState(() {
        _statusMessage = 'Please sign in first';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Creating study group...';
    });

    try {
      final groupData = {
        'name': 'Flutter Beginners Group',
        'description': 'A group for Flutter beginners to learn together',
        'category': 'Programming',
        'creatorId': _authService.currentUser!.uid,
        'members': [_authService.currentUser!.uid],
        'maxMembers': 20,
        'isPublic': true,
      };

      final docRef = await _firestoreService.createStudyGroup(groupData);

      setState(() {
        _statusMessage = 'Study group created with ID: ${docRef.id}';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error creating group: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveVideoAsMaterial() async {
    if (_searchResults.isEmpty) {
      setState(() {
        _statusMessage = 'Please search for videos first';
      });
      return;
    }

    if (_authService.currentUser == null) {
      setState(() {
        _statusMessage = 'Please sign in first';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Saving video as learning material...';
    });

    try {
      final firstVideo = _searchResults.first;
      final material = await _integratedService.saveVideoAsMaterial(
        videoId: firstVideo.id,
        category: 'Programming',
        creatorId: _authService.currentUser!.uid,
        additionalTags: ['flutter', 'mobile', 'tutorial'],
      );

      setState(() {
        _statusMessage = 'Material saved: ${material.title}';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error saving material: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BelajarBareng'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          _buildThemeToggle(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status message
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _statusMessage.isEmpty ? 'Ready to test APIs' : _statusMessage,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Auth Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Firebase Auth',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<User?>(
                      stream: _authService.authStateChanges,
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                        return Text(
                          user == null
                            ? 'Not signed in'
                            : 'Signed in as: ${user.displayName ?? user.email}',
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signInWithGoogle,
                      child: const Text('Sign in with Google'),
                    ),
                  ],
                ),
              ),
            ),

            // YouTube Search Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎥 YouTube Video Search',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Cari dan tonton video YouTube'),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const YouTubeSearchScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.video_library),
                      label: const Text('Buka YouTube Search'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // YouTube API Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YouTube API',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Found ${_searchResults.length} videos'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _searchYouTubeVideos,
                      child: const Text('Search Flutter Videos'),
                    ),
                  ],
                ),
              ),
            ),

            // Firestore Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Firestore',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _createSampleStudyGroup,
                      child: const Text('Create Study Group'),
                    ),
                  ],
                ),
              ),
            ),

            // Integrated API Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Integrated API',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveVideoAsMaterial,
                      child: const Text('Save Video as Material'),
                    ),
                  ],
                ),
              ),
            ),

            // Loading indicator
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),

            // Search results
            if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final video = _searchResults[index];
                    return ListTile(
                      leading: video.thumbnailUrl.isNotEmpty
                          ? Image.network(
                              video.thumbnailUrl,
                              width: 80,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.video_library);
                              },
                            )
                          : const Icon(Icons.video_library),
                      title: Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${video.channelTitle} • ${video.formattedViewCount}',
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
