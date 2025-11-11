import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/config/theme.dart';
import '../../../core/widgets/profile_menu.dart';
import '../domain/dashboard_provider.dart';
import 'widgets/dashboard_widgets.dart';
import 'create_material_screen.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/bloc/auth_state.dart';

import '../../auth/presentation/screens/login_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  late AnimationController _animationController;

  final List<Map<String, dynamic>> _categories = [
      {'name': 'All', 'icon': Icons.apps_rounded},
    {'name': 'Programming', 'icon': Icons.code_rounded},
    {'name': 'Mathematics', 'icon': Icons.calculate_rounded},
    {'name': 'Science', 'icon': Icons.science_rounded},
    {'name': 'Languages', 'icon': Icons.language_rounded},
    {'name': 'Arts', 'icon': Icons.palette_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    // Load dashboard data on init
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).loadDashboardData(userId: 'demo_user');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(dashboardProvider.notifier).refresh(userId: 'demo_user');
        },
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 24),

                  // Stats Cards
                  _buildStatsSection(dashboardState.userStats),
                  const SizedBox(height: 32),

                  // Categories Filter
                  _buildCategoriesFilter(),
                  const SizedBox(height: 32),

                  // Featured Content
                  _buildFeaturedContent(),
                  const SizedBox(height: 32),

                  // Trending Materials
                  if (dashboardState.isLoading)
                    _buildLoadingSection()
                  else if (dashboardState.trendingMaterials.isNotEmpty)
                    _buildTrendingSection(dashboardState.trendingMaterials)
                  else
                    _buildEmptyState(),
                  const SizedBox(height: 32),

                  // Study Groups
                  if (dashboardState.popularGroups.isNotEmpty)
                    _buildStudyGroupsSection(dashboardState.popularGroups),
                  const SizedBox(height: 32),

                  // Recent Videos
                  if (dashboardState.recentVideos.isNotEmpty)
                    _buildRecentVideosSection(dashboardState.recentVideos),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateMaterialScreen(),
            ),
          ).then((_) {
            // Refresh dashboard after creating material
            ref.read(dashboardProvider.notifier).refresh(userId: 'demo_user');
          });
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create'),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: LayoutBuilder(
          builder: (context, constraints) {
            // Hide title on very small screens when collapsed
            final isCollapsed = constraints.maxHeight <= 80;
            final screenWidth = MediaQuery.of(context).size.width;
            
            return Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isCollapsed ? 6 : 8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.oceanGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: isCollapsed ? 20 : 24,
                  ),
                ),
                if (screenWidth >= 400) ...[
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'BelajarBareng',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isCollapsed ? 18 : 24,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(child: Text('No new notifications')),
                  ],
                ),
                backgroundColor: AppTheme.primaryPurple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Padding(
                padding: const EdgeInsets.only(right: 12, left: 8),
                child: ProfileDropdownMenu(
                  userName: state.guruProfile?.namaLengkap ?? 'User',
                  userEmail: state.user.email ?? 'user@example.com',
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(right: 12, left: 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    
                    // Show icon only on very small screens
                    if (screenWidth < 380) {
                      return IconButton(
                        icon: const Icon(Icons.login_rounded),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryPurple,
                        ),
                      );
                    }
                    
                    return ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: const Text('Masuk'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search courses, videos, groups...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              // Show filter modal
            },
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        onSubmitted: (value) {
          ref.read(dashboardProvider.notifier).searchMaterials(value);
        },
      ),
    );
  }

  Widget _buildStatsSection(Map<String, int> stats) {
    if (stats.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive crossAxisCount based on screen width
        int crossAxisCount;
        double childAspectRatio;
        
        if (constraints.maxWidth >= 1200) {
          // Desktop/Large screens
          crossAxisCount = 4;
          childAspectRatio = 1.3;
        } else if (constraints.maxWidth >= 768) {
          // Tablet
          crossAxisCount = 4;
          childAspectRatio = 1.1;
        } else if (constraints.maxWidth >= 600) {
          // Small Tablet
          crossAxisCount = 2;
          childAspectRatio = 1.4;
        } else {
          // Mobile
          crossAxisCount = 2;
          childAspectRatio = 1.2;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
            children: [
              StatCard(
                title: 'Completed',
                value: '${stats['completed'] ?? 0}',
                icon: Icons.check_circle_outline,
                color: AppTheme.accentGreen,
              ),
              StatCard(
                title: 'In Progress',
                value: '${stats['inProgress'] ?? 0}',
                icon: Icons.timelapse_rounded,
                color: AppTheme.accentYellow,
              ),
              StatCard(
                title: 'Study Groups',
                value: '${stats['studyGroups'] ?? 0}',
                icon: Icons.groups_outlined,
                color: AppTheme.primaryPurple,
              ),
              StatCard(
                title: 'Total Materials',
                value: '${stats['totalMaterials'] ?? 0}',
                icon: Icons.library_books_outlined,
                color: AppTheme.secondaryTeal,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SectionHeader(title: 'Categories'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 45,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = _categories[index];
              return CategoryChip(
                label: category['name'],
                icon: category['icon'],
                isSelected: _selectedCategory == category['name'],
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive sizing
          final screenWidth = constraints.maxWidth;
          final fontSize = screenWidth < 400 ? 20.0 : 24.0;
          final iconSize = screenWidth < 400 ? 100.0 : 120.0;
          final buttonPadding = screenWidth < 400 
              ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
              : const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

          return GradientCard(
            gradient: AppTheme.oceanGradient,
            height: 180,
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  right: -30,
                  top: -30,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animationController.value * 2 * 3.14159,
                        child: Icon(
                          Icons.auto_awesome,
                          size: iconSize,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '✨ Featured',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            'Start Your Learning\nJourney Today!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryPurple,
                            padding: buttonPadding,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                screenWidth < 400 ? 'Explore' : 'Explore Now',
                                style: TextStyle(
                                  fontSize: screenWidth < 400 ? 14 : 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 18),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildTrendingSection(List materials) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionHeader(
            title: '🔥 Trending Now',
            subtitle: 'Popular learning materials',
            onSeeAll: () {},
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive card height
            double cardHeight;
            if (constraints.maxWidth >= 1200) {
              cardHeight = 320;
            } else if (constraints.maxWidth >= 768) {
              cardHeight = 310;
            } else {
              cardHeight = 300;
            }

            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: materials.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final material = materials[index];
                  return MaterialCard(
                    title: material.title,
                    description: material.description,
                    thumbnailUrl: material.thumbnailUrl,
                    category: material.category,
                    duration: material.formattedDuration,
                    difficulty: material.difficulty,
                    onTap: () {
                      // Navigate to material detail
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStudyGroupsSection(List groups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionHeader(
            title: '👥 Study Groups',
            subtitle: 'Join and collaborate',
            onSeeAll: () {},
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive crossAxisCount for study groups
            int crossAxisCount;
            double childAspectRatio;
            
            if (constraints.maxWidth >= 1200) {
              // Desktop
              crossAxisCount = 4;
              childAspectRatio = 0.85;
            } else if (constraints.maxWidth >= 900) {
              // Large Tablet
              crossAxisCount = 3;
              childAspectRatio = 0.85;
            } else if (constraints.maxWidth >= 600) {
              // Tablet
              crossAxisCount = 2;
              childAspectRatio = 0.9;
            } else {
              // Mobile
              crossAxisCount = 2;
              childAspectRatio = 0.85;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: groups.length > 8 ? 8 : groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return StudyGroupCard(
                  name: group.name,
                  category: group.category,
                  memberCount: group.memberCount,
                  maxMembers: group.maxMembers,
                  imageUrl: group.imageUrl,
                  onTap: () {
                    // Navigate to group detail
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentVideosSection(List videos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionHeader(
            title: '🎬 Recent Videos',
            subtitle: 'Latest from YouTube',
            onSeeAll: () {},
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive video card size
            double cardWidth;
            double cardHeight;
            
            if (constraints.maxWidth >= 1200) {
              cardWidth = 240;
              cardHeight = 240;
            } else if (constraints.maxWidth >= 768) {
              cardWidth = 220;
              cardHeight = 230;
            } else if (constraints.maxWidth >= 600) {
              cardWidth = 200;
              cardHeight = 220;
            } else {
              cardWidth = 180;
              cardHeight = 210;
            }

            return SizedBox(
              height: cardHeight,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: videos.length > 10 ? 10 : videos.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return Container(
                    width: cardWidth,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                video.thumbnailUrl,
                                height: cardWidth * 0.6, // 16:9 ratio
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: cardWidth * 0.6,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error_outline),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    video.formattedDuration,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    video.title,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  video.channelTitle,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No materials found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
