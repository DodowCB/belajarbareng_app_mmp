import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/app_user.dart';
import '../profile_menu/profile_menu_widget.dart';
import '../guru_data/teachers_screen.dart';
import '../siswa/students_screen.dart';
import '../mapel/subjects_screen.dart';
import '../kelas/classes_screen.dart';
import '../pengumuman/pengumuman_screen.dart';
import '../jadwal_mengajar/jadwal_mengajar_screen.dart';
import 'reports_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';
import '../notifications/notifications_screen.dart';
import '../location/guru_location_screen.dart';
import 'admin_bloc.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late AdminBloc _adminBloc = AdminBloc();

  @override
  void initState() {
    super.initState();
    _adminBloc = AdminBloc();
    // Load initial data
    _adminBloc.add(LoadAdminData());
  }

  @override
  void dispose() {
    _adminBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _adminBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            if (state.isLoading)
              return const Center(child: CircularProgressIndicator());
            if (state.error != null)
              return Center(child: Text('Error: ${state.error}'));

            return CustomScrollView(
              slivers: [
                _buildAppBar(context),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(child: _buildWelcomeCard()),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                if (!state.isOnline) ...[
                  SliverToBoxAdapter(child: _buildOfflineBanner(state)),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(child: _buildStatsSection(state)),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
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
            final isCollapsed = constraints.maxHeight <= 80;
            final screenWidth = MediaQuery.of(context).size.width;

            return Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isCollapsed ? 6 : 8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.sunsetGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: isCollapsed ? 20 : 24,
                  ),
                ),
                if (screenWidth >= 400) ...[
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Admin Panel',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isCollapsed ? 18 : 20,
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
        // Connection Status Indicator
        BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            final screenWidth = MediaQuery.of(context).size.width;
            final showText = screenWidth >= 450;

            return Container(
              margin: const EdgeInsets.only(right: 8, top: 12, bottom: 12),
              padding: EdgeInsets.symmetric(
                horizontal: showText ? 8 : 6,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: state.isOnline
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.isOnline ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    state.isOnline ? Icons.wifi : Icons.wifi_off,
                    color: state.isOnline ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  if (showText) ...[
                    const SizedBox(width: 4),
                    Text(
                      state.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: state.isOnline ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            );
          },
        ),

        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 4),
          child: ProfileDropdownMenu(
            userName: AppUser.displayName,
            userEmail: AppUser.email ?? 'No email',
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryPurpleLight,
                    AppTheme.secondaryTealLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppTheme.sunsetGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withOpacity(isDark ? 0.3 : 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppUser.displayName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Manage your system efficiently',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(AdminState state) {
    return StreamBuilder<List<QuerySnapshot>>(
      stream: Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
        return await Future.wait([
          FirebaseFirestore.instance.collection('guru').get(),
          FirebaseFirestore.instance.collection('siswa').get(),
          FirebaseFirestore.instance.collection('mapel').get(),
          FirebaseFirestore.instance.collection('kelas').get(),
          FirebaseFirestore.instance.collection('pengumuman').get(),
          FirebaseFirestore.instance.collection('kelas_ngajar').get(),
        ]);
      }),
      builder: (context, snapshot) {
        int totalTeachers = state.totalTeachers;
        int totalStudents = state.totalStudents;
        int totalMapels = state.totalMapels;
        int totalClasses = state.totalClasses;
        int totalPengumuman = state.totalPengumuman;
        int totalJadwalMengajar = state.totalJadwalMengajar;

        if (snapshot.hasData) {
          final guruSnapshot = snapshot.data![0];
          final siswaSnapshot = snapshot.data![1];
          final mapelSnapshot = snapshot.data![2];
          final kelasSnapshot = snapshot.data![3];
          final pengumumanSnapshot = snapshot.data![4];
          final kelasNgajarSnapshot = snapshot.data![5];

          // Filter out admin user
          final filteredGuruDocs = guruSnapshot.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final email = data['email']?.toString().toLowerCase() ?? '';
            return email != 'admin@gmail.com';
          }).toList();

          totalTeachers = filteredGuruDocs.length;
          totalStudents = siswaSnapshot.docs.length;
          totalMapels = mapelSnapshot.docs.length;
          totalClasses = kelasSnapshot.docs.length;
          totalPengumuman = pengumumanSnapshot.docs.length;
          totalJadwalMengajar = kelasNgajarSnapshot.docs.length;
        }

        final totalUsers = totalTeachers + totalStudents;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = MediaQuery.of(context).size.width;
              final crossAxisCount = screenWidth >= 1200
                  ? 4
                  : screenWidth >= 768
                  ? 3
                  : screenWidth >= 600
                  ? 2
                  : 2;

              final statCards = [
                _buildStatCard(
                  title: 'Total Users',
                  value: totalUsers.toString(),
                  subtitle: state.isOnline
                      ? 'Registered (Live)'
                      : 'Cached data',
                  icon: Icons.people,
                  color: AppTheme.primaryPurple,
                  onTap: () => _showAllUsersModal(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Teachers',
                  value: totalTeachers.toString(),
                  subtitle: state.isOnline ? 'Active (Live)' : 'Cached data',
                  icon: Icons.school,
                  color: AppTheme.secondaryTeal,
                  onTap: () => _navigateToGuruData(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Students',
                  value: totalStudents.toString(),
                  subtitle: state.isOnline ? 'Enrolled (Live)' : 'Cached data',
                  icon: Icons.groups,
                  color: AppTheme.accentGreen,
                  onTap: () => _navigateToSiswaData(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Mapel',
                  value: totalMapels.toString(),
                  subtitle: state.isOnline ? 'Available (Live)' : 'Cached data',
                  icon: Icons.library_books,
                  color: AppTheme.accentOrange,
                  onTap: () => _navigateToMapel(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Classes',
                  value: totalClasses.toString(),
                  subtitle: state.isOnline ? 'Available (Live)' : 'Cached data',
                  icon: Icons.class_,
                  color: AppTheme.accentPink,
                  onTap: () => _navigateToKelas(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Announcements',
                  value: totalPengumuman.toString(),
                  subtitle: state.isOnline
                      ? 'Posts Available (Live)'
                      : 'Cached data',
                  icon: Icons.announcement,
                  color: Colors.orange,
                  onTap: () => _navigateToPengumuman(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Teaching Schedule',
                  value: totalJadwalMengajar.toString(),
                  subtitle: state.isOnline
                      ? 'Teaching Classes (Live)'
                      : 'Cached data',
                  icon: Icons.schedule,
                  color: AppTheme.primaryPurple.withOpacity(0.8),
                  onTap: () => _navigateToJadwalMengajar(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Guru Locations',
                  value: '📍',
                  subtitle: 'Track teacher locations',
                  icon: Icons.location_on,
                  color: Colors.green,
                  onTap: () => _navigateToGuruLocations(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Reports',
                  value: '📊',
                  subtitle: 'View detailed reports',
                  icon: Icons.assessment,
                  color: Colors.blue,
                  onTap: () => _navigateToReports(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Analytics',
                  value: '📈',
                  subtitle: 'View analytics',
                  icon: Icons.analytics,
                  color: Colors.deepPurple,
                  onTap: () => _navigateToAnalytics(),
                  isOffline: !state.isOnline,
                ),
                _buildStatCard(
                  title: 'Settings',
                  value: '⚙️',
                  subtitle: 'System configuration',
                  icon: Icons.settings,
                  color: Colors.blueGrey,
                  onTap: () => _navigateToSettings(),
                  isOffline: !state.isOnline,
                ),
              ];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Overview',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: screenWidth >= 1200
                          ? 1.5
                          : screenWidth >= 768
                          ? 1.3
                          : 1.2,
                    ),
                    itemCount: statCards.length,
                    itemBuilder: (context, index) => statCards[index],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    bool isOffline = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = screenWidth >= 1200
        ? 20.0
        : screenWidth >= 768
        ? 18.0
        : 16.0;

    return MouseRegion(
      cursor: onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: isOffline ? Colors.grey : color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth >= 1200 ? 15 : 13,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isOffline) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.offline_bolt,
                            color: Colors.grey,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    icon,
                    color: isOffline ? Colors.grey : color,
                    size: screenWidth >= 1200 ? 24 : 22,
                  ),
                ],
              ),
              SizedBox(height: screenWidth >= 1200 ? 10 : 6),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isOffline ? Colors.grey : color,
                            fontSize: screenWidth >= 1200 ? 32 : 24,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isOffline
                            ? Colors.orange
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        fontSize: screenWidth >= 1200 ? 13 : 11,
                        fontWeight: isOffline
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  void _showAllUsersModal() {
    final searchController = TextEditingController();
    String searchQuery = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppTheme.sunsetGradient,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'All Users',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                            tooltip: 'Close',
                          ),
                        ],
                      ),
                    ),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setDialogState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search users by name...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    searchController.clear();
                                    setDialogState(() {
                                      searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[850]
                              : Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.primaryPurple,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('guru')
                            .snapshots(),
                        builder: (context, guruSnapshot) {
                          if (guruSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('siswa')
                                .snapshots(),
                            builder: (context, siswaSnapshot) {
                              if (siswaSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (guruSnapshot.hasError || siswaSnapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        size: 64,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Error loading users',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // Combine all users
                              final List<Map<String, String>> allUsers = [];

                              // Add teachers (excluding admin@gmail.com)
                              if (guruSnapshot.hasData) {
                                for (var doc in guruSnapshot.data!.docs) {
                                  final data = doc.data() as Map<String, dynamic>;
                                  final email =
                                      data['email']?.toString().toLowerCase() ?? '';
                                  // Skip admin user
                                  if (email == 'admin@gmail.com') continue;

                                  final name = data['nama_lengkap'] ?? 'Unknown';
                                  allUsers.add({'name': name, 'role': 'Teacher'});
                                }
                              }

                              // Add students
                              if (siswaSnapshot.hasData) {
                                for (var doc in siswaSnapshot.data!.docs) {
                                  final data = doc.data() as Map<String, dynamic>;
                                  final name = data['nama'] ?? 'Unknown';
                                  allUsers.add({'name': name, 'role': 'Student'});
                                }
                              }

                              // Sort by name
                              allUsers.sort(
                                (a, b) => a['name']!.compareTo(b['name']!),
                              );

                              // Filter by search query
                              final filteredUsers = searchQuery.isEmpty
                                  ? allUsers
                                  : allUsers
                                      .where((user) => user['name']!
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase()))
                                      .toList();

                              if (allUsers.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.people_outline,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No users found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Column(
                                children: [
                                  // Summary
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[850]
                                        : Colors.grey[100],
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Flexible(
                                          child: _buildUserSummaryItem(
                                            'Total',
                                            allUsers.length.toString(),
                                            AppTheme.primaryPurple,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: _buildUserSummaryItem(
                                            'Teachers',
                                            guruSnapshot.data!.docs
                                                .where((doc) {
                                                  final data =
                                                      doc.data()
                                                          as Map<String, dynamic>;
                                                  final email =
                                                      data['email']
                                                          ?.toString()
                                                          .toLowerCase() ??
                                                      '';
                                                  return email != 'admin@gmail.com';
                                                })
                                                .length
                                                .toString(),
                                            AppTheme.secondaryTeal,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: _buildUserSummaryItem(
                                            'Students',
                                            siswaSnapshot.data!.docs.length
                                                .toString(),
                                            AppTheme.accentGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  // User list
                                  Expanded(
                                    child: filteredUsers.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.search_off,
                                                  size: 48,
                                                  color: Colors.grey[400],
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  'No users match "$searchQuery"',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ListView.separated(
                                            padding: const EdgeInsets.all(16),
                                            itemCount: filteredUsers.length,
                                            separatorBuilder: (context, index) =>
                                                const SizedBox(height: 8),
                                            itemBuilder: (context, index) {
                                              final user = filteredUsers[index];
                                              final isTeacher = user['role'] == 'Teacher';

                                              return Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? Colors.grey[850]
                                                      : Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: isTeacher
                                                        ? AppTheme.secondaryTeal
                                                              .withOpacity(0.3)
                                                        : AppTheme.accentGreen
                                                              .withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: isTeacher
                                                          ? AppTheme.secondaryTeal
                                                                .withOpacity(0.2)
                                                          : AppTheme.accentGreen
                                                                .withOpacity(0.2),
                                                      child: Icon(
                                                        isTeacher
                                                            ? Icons.school
                                                            : Icons.person,
                                                        color: isTeacher
                                                            ? AppTheme.secondaryTeal
                                                            : AppTheme.accentGreen,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        '${user['name']} - ${user['role']}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: isTeacher
                                                            ? AppTheme.secondaryTeal
                                                                  .withOpacity(0.1)
                                                            : AppTheme.accentGreen
                                                                  .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        user['role']!,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w600,
                                                          color: isTeacher
                                                              ? AppTheme.secondaryTeal
                                                              : AppTheme.accentGreen,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserSummaryItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _navigateToGuruData() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _adminBloc,
          child: const TeachersScreen(),
        ),
      ),
    );
  }

  void _navigateToSiswaData() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _adminBloc,
          child: const StudentsScreen(),
        ),
      ),
    );
  }

  void _navigateToMapel() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _adminBloc,
          child: const SubjectsScreen(),
        ),
      ),
    );
  }

  void _navigateToKelas() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            BlocProvider.value(value: _adminBloc, child: const ClassesScreen()),
      ),
    );
  }

  void _navigateToPengumuman() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _adminBloc,
          child: const PengumumanScreen(),
        ),
      ),
    );
  }

  void _navigateToJadwalMengajar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _adminBloc,
          child: const JadwalMengajarScreen(),
        ),
      ),
    );
  }

  void _navigateToReports() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            BlocProvider.value(value: _adminBloc, child: const ReportsScreen()),
      ),
    );
  }

  void _navigateToAnalytics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _adminBloc,
          child: const AnalyticsScreen(),
        ),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _adminBloc,
          child: const SettingsScreen(),
        ),
      ),
    );
  }

  void _navigateToGuruLocations() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const GuruLocationScreen(),
        ),
      ),
    );
  }

  Widget _buildOfflineBanner(AdminState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.wifi_off, color: Colors.orange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offline Mode',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You can view cached data. Adding/editing/deleting is disabled.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.orange[700]),
                  ),
                  if (state.lastSync != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Last sync: ${_formatDateTime(state.lastSync)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Never';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
