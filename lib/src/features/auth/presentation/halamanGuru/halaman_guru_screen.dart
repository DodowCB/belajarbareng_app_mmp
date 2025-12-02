import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/user_provider.dart';
import '../../data/models/pengumuman_model.dart';
import 'blocs/blocs.dart';
import 'component/nilai_siswa_screen.dart';
import 'component/tugas_guru_screen.dart';
import 'component/materi_guru_screen.dart';

// Import extension files
import 'component/guru_sidebar_widgets.dart';

class HalamanGuruScreen extends ConsumerStatefulWidget {
  const HalamanGuruScreen({super.key});

  @override
  ConsumerState<HalamanGuruScreen> createState() => HalamanGuruScreenState();
}

class HalamanGuruScreenState extends ConsumerState<HalamanGuruScreen> {
  bool _statsLoaded = false;
  bool _isSidebarCollapsed = false;
  bool _isProfileMenuExpanded = false;

  // Getters untuk diakses dari extension
  bool get isSidebarCollapsed => _isSidebarCollapsed;
  set isSidebarCollapsed(bool value) => _isSidebarCollapsed = value;

  bool get isProfileMenuExpanded => _isProfileMenuExpanded;
  set isProfileMenuExpanded(bool value) => _isProfileMenuExpanded = value;

  // Public wrapper untuk setState agar bisa diakses dari extension
  void updateState(VoidCallback fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GuruProfileBloc>(
          create: (context) {
            final bloc = GuruProfileBloc();
            bloc.add(const LoadGuruProfile());
            return bloc;
          },
        ),
        BlocProvider<GuruStatsBloc>(create: (context) => GuruStatsBloc()),
        BlocProvider<AnnouncementsBloc>(
          create: (context) =>
              AnnouncementsBloc()..add(const LoadAnnouncements()),
        ),
      ],
      child: Scaffold(
        body: BlocListener<GuruProfileBloc, GuruProfileState>(
          listener: (context, profileState) {
            print(
              '👂 [BlocListener] State changed: ${profileState.runtimeType}',
            );

            if (profileState is GuruProfileLoaded && !_statsLoaded) {
              print('✅ [BlocListener] GuruProfileLoaded detected!');
              print('📋 [BlocListener] guruId: ${profileState.guruId}');
              // Load stats only once when we have the guru ID
              context.read<GuruStatsBloc>().add(
                LoadGuruStats(profileState.guruId),
              );
              _statsLoaded = true;
            } else if (profileState is GuruProfileLoading) {
              print('⏳ [BlocListener] Loading...');
            } else if (profileState is GuruProfileError) {
              print('❌ [BlocListener] Error: ${profileState.message}');
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1024;
              final isTablet = constraints.maxWidth >= 768;

              if (!isDesktop) {
                // Mobile/Tablet: Use drawer instead of sidebar
                return Scaffold(
                  appBar: AppBar(
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        tooltip: 'Menu',
                      ),
                    ),
                    title: const Text('Dashboard Guru'),
                  ),
                  drawer: buildDrawer(context),
                  body: _buildMainContent(
                    context,
                    isDesktop: false,
                    isTablet: isTablet,
                  ),
                );
              }

              // Desktop: Use sidebar
              return Row(
                children: [
                  buildSidebar(context),
                  Expanded(
                    child: _buildMainContent(
                      context,
                      isDesktop: true,
                      isTablet: isTablet,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context, {
    required bool isDesktop,
    required bool isTablet,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _buildTopBar(context),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 24 : 16,
                vertical: isDesktop ? 8 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(isDesktop: isDesktop),
                  SizedBox(height: isDesktop ? 32 : 24),
                  _buildStatsCards(isDesktop: isDesktop, isTablet: isTablet),
                  SizedBox(height: isDesktop ? 32 : 24),
                  isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildImportantNotifications(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 3,
                              child: _buildUpcomingTasks(isDesktop: true),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildImportantNotifications(),
                            const SizedBox(height: 20),
                            _buildUpcomingTasks(isDesktop: false),
                            const SizedBox(height: 20),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Text(
          'Dashboard',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildWelcomeSection({required bool isDesktop}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ambil data langsung dari userProvider
    final guruName = userProvider.namaLengkap ?? 'Guru';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang, $guruName!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isDesktop ? 28 : 22,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Tambahkan info wali kelas dari GuruStatsBloc
        BlocBuilder<GuruStatsBloc, GuruStatsState>(
          builder: (context, state) {
            if (state is GuruStatsLoading) {
              return const SizedBox.shrink();
            }

            if (state is GuruStatsError) {
              return const SizedBox.shrink();
            }

            if (state is GuruStatsLoaded) {
              if (state.kelasWali.isNotEmpty) {
                final kelasWali = state.kelasWali.first;
                final namaKelas = kelasWali['namaKelas'] ?? 'Kelas';
                final jumlahSiswa = kelasWali['jumlahSiswa'] ?? 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryPurple.withOpacity(0.1),
                            AppTheme.secondaryTeal.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.primaryPurple.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school,
                            color: AppTheme.primaryPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Anda Wali Kelas ',
                            style: TextStyle(
                              fontSize: isDesktop ? 15 : 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                            ),
                          ),
                          Text(
                            namaKelas,
                            style: TextStyle(
                              fontSize: isDesktop ? 15 : 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryTeal.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$jumlahSiswa Siswa',
                              style: TextStyle(
                                fontSize: isDesktop ? 13 : 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.secondaryTeal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
        Text(
          'Berikut adalah ringkasan aktivitas Anda hari ini.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: isDesktop ? 16 : 14,
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile: Stack buttons vertically
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildActionButton(
                    'Input Nilai Baru',
                    AppTheme.primaryPurple,
                    Icons.add,
                    isDesktop: isDesktop,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NilaiSiswaScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    'Buat Tugas Baru',
                    AppTheme.secondaryTeal,
                    Icons.assignment_add,
                    isDesktop: isDesktop,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasGuruScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    'Unggah Materi Baru',
                    AppTheme.accentGreen,
                    Icons.upload_file,
                    isDesktop: isDesktop,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MateriGuruScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              // Tablet/Desktop: Wrap buttons
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildActionButton(
                    'Input Nilai Baru',
                    AppTheme.primaryPurple,
                    Icons.add,
                    isDesktop: isDesktop,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NilaiSiswaScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    'Buat Tugas Baru',
                    AppTheme.secondaryTeal,
                    Icons.assignment_add,
                    isDesktop: isDesktop,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasGuruScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    'Unggah Materi Baru',
                    AppTheme.accentGreen,
                    Icons.upload_file,
                    isDesktop: isDesktop,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MateriGuruScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    Color backgroundColor,
    IconData icon, {
    required bool isDesktop,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 2,
          shadowColor: backgroundColor.withOpacity(0.4),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 20 : 16,
            vertical: isDesktop ? 14 : 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards({required bool isDesktop, required bool isTablet}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<GuruStatsBloc, GuruStatsState>(
      builder: (context, state) {
        int totalClasses = 0;
        int totalStudents = 0;
        int tugasPerluDinilai = 0;

        if (state is GuruStatsLoaded) {
          totalClasses = state.totalClasses;
          totalStudents = state.totalStudents;
          tugasPerluDinilai = state.tugasPerluDinilai;
        } else if (state is GuruStatsLoading) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              child: CircularProgressIndicator(color: AppTheme.primaryPurple),
            ),
          );
        } else if (state is GuruStatsError) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.red[900]?.withOpacity(0.2)
                  : Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error loading stats: ${state.message}',
                    style: TextStyle(
                      color: isDark ? Colors.red[300] : Colors.red[800],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final profileState = context.read<GuruProfileBloc>().state;
                    if (profileState is GuruProfileLoaded) {
                      context.read<GuruStatsBloc>().add(
                        LoadGuruStats(profileState.guruId),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                if (isDesktop) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Kelas',
                          value: totalClasses.toString(),
                          icon: Icons.class_,
                          color: AppTheme.secondaryTeal,
                          isDesktop: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Siswa',
                          value: totalStudents.toString(),
                          icon: Icons.people,
                          color: AppTheme.accentGreen,
                          isDesktop: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Tugas Perlu Dinilai',
                          value: tugasPerluDinilai.toString(),
                          icon: Icons.assignment_turned_in,
                          color: AppTheme.accentOrange,
                          isDesktop: true,
                        ),
                      ),
                    ],
                  );
                } else if (isTablet) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total Kelas',
                              value: totalClasses.toString(),
                              icon: Icons.class_,
                              color: AppTheme.secondaryTeal,
                              isDesktop: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total Siswa',
                              value: totalStudents.toString(),
                              icon: Icons.people,
                              color: AppTheme.accentGreen,
                              isDesktop: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        title: 'Tugas Perlu Dinilai',
                        value: tugasPerluDinilai.toString(),
                        icon: Icons.assignment_turned_in,
                        color: AppTheme.accentOrange,
                        isDesktop: false,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildStatCard(
                        title: 'Total Kelas',
                        value: totalClasses.toString(),
                        icon: Icons.class_,
                        color: AppTheme.secondaryTeal,
                        isDesktop: false,
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        title: 'Total Siswa',
                        value: totalStudents.toString(),
                        icon: Icons.people,
                        color: AppTheme.accentGreen,
                        isDesktop: false,
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        title: 'Tugas Perlu Dinilai',
                        value: tugasPerluDinilai.toString(),
                        icon: Icons.assignment_turned_in,
                        color: AppTheme.accentOrange,
                        isDesktop: false,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDesktop,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<GuruStatsBloc, GuruStatsState>(
      builder: (context, state) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: () {
              // Show detail dialog for Total Kelas and Total Siswa
              if (title == 'Total Kelas' && state is GuruStatsLoaded) {
                _showKelasDetailDialog(context, state);
              } else if (title == 'Total Siswa' && state is GuruStatsLoaded) {
                _showSiswaDetailDialog(context, state);
              } else if (title == 'Tugas Perlu Dinilai') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TugasGuruScreen(),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(isDesktop ? 20 : 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isDesktop ? 12 : 10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: isDesktop ? 24 : 22,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.trending_up, color: color, size: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: isDesktop ? 20 : 16),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 32 : 28,
                      color: color,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 4 : 2),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImportantNotifications() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
      builder: (context, state) {
        List<PengumumanModel> announcements = [];

        if (state is AnnouncementsLoaded) {
          announcements = state.selectedAnnouncements;
        } else if (state is AnnouncementsLoading) {
          return Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryPurple),
            ),
          );
        } else if (state is AnnouncementsError) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.error, color: Colors.red[600], size: 48),
                const SizedBox(height: 12),
                Text(
                  'Error loading announcements',
                  style: TextStyle(
                    color: isDark ? Colors.red[300] : Colors.red[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(
                    color: isDark ? Colors.red[400] : Colors.red[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AnnouncementsBloc>().add(
                      const LoadAnnouncements(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.campaign, color: AppTheme.accentOrange, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Pemberitahuan Penting',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (announcements.isNotEmpty)
                ...announcements
                    .take(3)
                    .map(
                      (announcement) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildNotificationItem(
                          announcement.judul,
                          announcement.deskripsi,
                          Icons.campaign,
                        ),
                      ),
                    )
              else
                _buildNotificationItem(
                  'Belum ada pengumuman',
                  'Tidak ada pengumuman terbaru saat ini.',
                  Icons.info_outline,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(
    String title,
    String description,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          _showNotificationDetailDialog(context, title, description, icon);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AppTheme.accentOrange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingTasks({required bool isDesktop}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment, color: AppTheme.secondaryTeal, size: 24),
              const SizedBox(width: 12),
              Text(
                'Tugas Mendatang',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TugasGuruScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Lihat Semua'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isDesktop) ...[
            // Header table for desktop
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Nama Tugas',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Kelas',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Tanggal Tenggat',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Task items
            _buildTaskItem(
              'Presentasi Sejarah Kemerdekaan',
              '11 IPA 2',
              '28 Nov 2023',
              isDesktop: true,
            ),
            _buildTaskItem(
              'Ujian Praktik Biologi',
              '12 IPA 1',
              '30 Nov 2023',
              isDesktop: true,
            ),
            _buildTaskItem(
              'Esai Sastra Indonesia',
              '10 IPS 3',
              '02 Des 2023',
              isDesktop: true,
            ),
            _buildTaskItem(
              'Laporan Kimia',
              '11 IPA 1',
              '05 Des 2023',
              isDesktop: true,
            ),
          ] else ...[
            // Card layout for mobile/tablet
            _buildTaskCard(
              'Presentasi Sejarah Kemerdekaan',
              '11 IPA 2',
              '28 Nov 2023',
            ),
            const SizedBox(height: 12),
            _buildTaskCard('Ujian Praktik Biologi', '12 IPA 1', '30 Nov 2023'),
            const SizedBox(height: 12),
            _buildTaskCard('Esai Sastra Indonesia', '10 IPS 3', '02 Des 2023'),
            const SizedBox(height: 12),
            _buildTaskCard('Laporan Kimia', '11 IPA 1', '05 Des 2023'),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskItem(
    String taskName,
    String className,
    String dueDate, {
    required bool isDesktop,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          _showTaskDetailDialog(context, taskName, className, dueDate);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
            ),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.assignment,
                  size: 16,
                  color: AppTheme.secondaryTeal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Text(
                  taskName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    className,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dueDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
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

  Widget _buildTaskCard(String taskName, String className, String dueDate) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          _showTaskDetailDialog(context, taskName, className, dueDate);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.assignment,
                      size: 20,
                      color: AppTheme.secondaryTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      taskName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.class_,
                          size: 14,
                          color: AppTheme.accentGreen,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          className,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.accentGreen,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dueDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationDetailDialog(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppTheme.accentOrange, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Pemberitahuan',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Judul',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDetailDialog(
    BuildContext context,
    String taskName,
    String className,
    String dueDate,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: AppTheme.secondaryTeal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Tugas',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _buildDetailRowInDialog(
                Icons.assignment,
                'Nama Tugas',
                taskName,
                isDark,
              ),
              const SizedBox(height: 16),
              _buildDetailRowInDialog(Icons.class_, 'Kelas', className, isDark),
              const SizedBox(height: 16),
              _buildDetailRowInDialog(
                Icons.calendar_today,
                'Tanggal Tenggat',
                dueDate,
                isDark,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasGuruScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Lihat Detail'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showKelasDetailDialog(BuildContext context, GuruStatsLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.class_,
                      color: AppTheme.secondaryTeal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Total Kelas',
                          style: Theme.of(dialogContext).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${state.totalClasses} Kelas yang Diajar',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (state.kelasNgajarDetail.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Belum ada kelas yang diajar',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.kelasNgajarDetail.length,
                    itemBuilder: (listContext, index) {
                      final kelas = state.kelasNgajarDetail[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(dialogContext);
                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (context.mounted) {
                              _showSiswaKelasDialog(context, kelas);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey[800]!
                                  : Colors.grey[200]!,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondaryTeal.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      kelas['namaKelas'] ?? 'Kelas',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.secondaryTeal,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.book,
                                    size: 18,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      kelas['namaMapel'] ?? 'Mata Pelajaran',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDark
                                            ? Colors.grey[300]
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (kelas['hari'] != null &&
                                  kelas['hari'].toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: 18,
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${kelas['hari']} - ${kelas['jam'] ?? ''}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Method untuk menampilkan siswa dari kelas tertentu (dari siswa_kelas)
  void _showSiswaKelasDialog(BuildContext context, Map<String, dynamic> kelas) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.people,
                      color: AppTheme.secondaryTeal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Siswa ${kelas['namaKelas'] ?? 'Kelas'}',
                          style: Theme.of(dialogContext).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          kelas['namaMapel'] ?? 'Mata Pelajaran',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchSiswaKelas(kelas['kelasId']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Terjadi kesalahan: ${snapshot.error}',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  }

                  final siswaList = snapshot.data ?? [];

                  if (siswaList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Belum ada siswa di kelas ini',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        // Tombol Isi Absensi
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  if (context.mounted) {
                                    _showAbsensiMapelDialog(
                                      context,
                                      siswaList,
                                      kelas,
                                    );
                                  }
                                },
                              );
                            },
                            icon: const Icon(Icons.fact_check),
                            label: const Text('Isi Absensi Mapel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        // Tabel Siswa
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                  AppTheme.primaryPurple.withOpacity(0.1),
                                ),
                                columns: const [
                                  DataColumn(label: Text('No')),
                                  DataColumn(label: Text('Nama')),
                                  DataColumn(label: Text('NIS')),
                                ],
                                rows: List.generate(siswaList.length, (index) {
                                  final siswa = siswaList[index];
                                  return DataRow(
                                    color:
                                        WidgetStateProperty.resolveWith<Color?>(
                                          (states) => index % 2 == 0
                                              ? (isDark
                                                    ? Colors.grey[850]
                                                    : Colors.grey[50])
                                              : (isDark
                                                    ? Colors.grey[900]
                                                    : Colors.white),
                                        ),
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(
                                        Text(siswa['namaLengkap'] ?? '-'),
                                      ),
                                      DataCell(Text(siswa['nis'] ?? '-')),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetch siswa dari collection siswa_kelas
  Future<List<Map<String, dynamic>>> _fetchSiswaKelas(String? kelasId) async {
    if (kelasId == null) return [];

    try {
      // Query siswa_kelas berdasarkan kelas_id
      final siswaKelasSnapshot = await FirebaseFirestore.instance
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: kelasId)
          .get();

      final List<Map<String, dynamic>> siswaList = [];

      // Ambil detail siswa dari collection siswa
      for (final doc in siswaKelasSnapshot.docs) {
        final siswaId = doc['siswa_id'];
        if (siswaId != null) {
          final siswaDoc = await FirebaseFirestore.instance
              .collection('siswa')
              .doc(siswaId)
              .get();

          if (siswaDoc.exists) {
            siswaList.add({
              'siswaId': siswaDoc.id,
              'namaLengkap': siswaDoc['nama'],
              'nis': siswaDoc['nis'],
            });
          }
        }
      }

      return siswaList;
    } catch (e) {
      debugPrint('Error fetching siswa kelas: $e');
      rethrow;
    }
  }

  // Method untuk isi absensi mapel
  void _showAbsensiMapelDialog(
    BuildContext context,
    List<Map<String, dynamic>> siswaList,
    Map<String, dynamic> kelas,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final guruId = userProvider.userId ?? '';
    final today = DateTime.now();

    // Inisialisasi locale Indonesia
    await initializeDateFormatting('id_ID', null);

    final formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(today);

    // State untuk menyimpan status hadir (checked = hadir)
    final absensiChecked = <String, bool>{};

    // Initialize all students as unchecked
    for (final siswa in siswaList) {
      absensiChecked[siswa['siswaId'] as String] = false;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.fact_check,
                          color: AppTheme.secondaryTeal,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Absensi Mapel ${kelas['namaMapel'] ?? ''}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${kelas['namaKelas'] ?? ''} - $formattedDate',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Tabel Absensi
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          AppTheme.secondaryTeal.withOpacity(0.1),
                        ),
                        columns: const [
                          DataColumn(label: Text('No')),
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('NIS')),
                          DataColumn(label: Text('Hadir')),
                        ],
                        rows: List.generate(siswaList.length, (index) {
                          final siswa = siswaList[index];
                          final siswaId = siswa['siswaId'] as String;
                          return DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>(
                              (states) => index % 2 == 0
                                  ? (isDark
                                        ? Colors.grey[850]
                                        : Colors.grey[50])
                                  : (isDark ? Colors.grey[900] : Colors.white),
                            ),
                            cells: [
                              DataCell(Text('${index + 1}')),
                              DataCell(Text(siswa['namaLengkap'] ?? '-')),
                              DataCell(Text(siswa['nis'] ?? '-')),
                              DataCell(
                                Checkbox(
                                  value: absensiChecked[siswaId] ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      absensiChecked[siswaId] = value ?? false;
                                    });
                                  },
                                  activeColor: AppTheme.secondaryTeal,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Footer dengan tombol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _simpanAbsensiMapelCheckbox(
                            context,
                            siswaList,
                            kelas,
                            absensiChecked,
                            guruId,
                            today,
                          );
                        },
                        icon: const Icon(Icons.save, size: 18),
                        label: const Text('Simpan Absensi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Method untuk simpan absensi mapel
  Future<void> _simpanAbsensiMapelCheckbox(
    BuildContext context,
    List<Map<String, dynamic>> siswaList,
    Map<String, dynamic> kelas,
    Map<String, bool> absensiChecked,
    String guruId,
    DateTime tanggal,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Tampilkan loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Cek apakah sudah ada absensi untuk jadwal dan tanggal ini
      final dateString = DateFormat('yyyy-MM-dd').format(tanggal);
      final kelasId = kelas['kelasId'] ?? '';

      // Query sederhana
      final existingAbsensiCheck = await firestore
          .collection('absensi')
          .where('jadwal_id', isEqualTo: kelasId)
          .where('tipe_absen', isEqualTo: 'mapel')
          .get();

      // Filter secara manual berdasarkan tanggal
      final todayAbsensi = existingAbsensiCheck.docs.where((doc) {
        final data = doc.data();
        final timestamp = data['tanggal'] as Timestamp?;
        if (timestamp != null) {
          final docDate = timestamp.toDate();
          final docDateString = DateFormat('yyyy-MM-dd').format(docDate);
          return docDateString == dateString;
        }
        return false;
      }).toList();

      if (todayAbsensi.isNotEmpty) {
        // Tutup loading dialog
        if (context.mounted) Navigator.pop(context);

        // Tutup absensi dialog
        if (context.mounted) Navigator.pop(context);

        // Tampilkan peringatan
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  const Text('Peringatan'),
                ],
              ),
              content: Text(
                'Absensi untuk mapel ini pada tanggal $dateString sudah pernah diisi. Tidak dapat mengisi absensi dua kali dalam satu hari.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Ambil ID terakhir untuk generate numeric ID
      final allAbsensiDocs = await firestore.collection('absensi').get();
      int maxId = 0;
      for (final doc in allAbsensiDocs.docs) {
        final docId = int.tryParse(doc.id);
        if (docId != null && docId > maxId) {
          maxId = docId;
        }
      }

      // Batch write untuk semua siswa
      final batch = firestore.batch();
      final timestamp = Timestamp.fromDate(tanggal);

      for (final siswa in siswaList) {
        final siswaId = siswa['siswaId'] as String;
        final isHadir = absensiChecked[siswaId] ?? false;

        maxId++;
        final docRef = firestore.collection('absensi').doc(maxId.toString());

        batch.set(docRef, {
          'siswa_id': siswaId,
          'kelas_id': kelas['kelasId'] ?? '',
          'jadwal_id': kelasId,
          'tanggal': timestamp,
          'status': isHadir ? 'hadir' : 'alpa',
          'tipe_absen': 'mapel',
          'diabsen_oleh': guruId,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      // Tutup loading dialog
      if (context.mounted) Navigator.pop(context);

      // Tutup absensi dialog
      if (context.mounted) Navigator.pop(context);

      // Tampilkan sukses
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text('Berhasil menyimpan absensi ${siswaList.length} siswa'),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      // Tutup loading dialog
      if (context.mounted) Navigator.pop(context);

      // Tutup absensi dialog
      if (context.mounted) Navigator.pop(context);

      // Tampilkan error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Gagal menyimpan absensi: $e')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _showSiswaDetailDialog(BuildContext context, GuruStatsLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.people,
                      color: AppTheme.accentGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Total Siswa',
                          style: Theme.of(dialogContext).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${state.totalStudents} Siswa di Kelas Wali',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Tutup dialog detail siswa terlebih dahulu
                      Navigator.pop(dialogContext);
                      // Tunggu sedikit agar dialog tertutup sempurna
                      await Future.delayed(const Duration(milliseconds: 100));
                      // Buka dialog absensi dengan context yang benar
                      if (context.mounted) {
                        _showAbsensiDialog(context, state);
                      }
                    },
                    icon: const Icon(Icons.fact_check, size: 18),
                    label: const Text('Isi Absensi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (state.kelasWali.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Belum ada kelas wali',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.kelasWali.length,
                    itemBuilder: (listContext, index) {
                      final kelas = state.kelasWali[index];
                      final kelasId = kelas['id'] as String;
                      final siswaList = state.siswaPerKelas[kelasId] ?? [];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? Colors.grey[800]!
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    kelas['namaKelas'] ?? 'Kelas',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.accentGreen,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentGreen.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${siswaList.length} Siswa',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.accentGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (siswaList.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 8),
                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentGreen.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.accentGreen,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Nama',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.accentGreen,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'NIS',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.accentGreen,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.accentGreen,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Table Body
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.grey[700]!
                                        : Colors.grey[300]!,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  children: siswaList.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final siswa = entry.value;
                                    final isLastItem =
                                        index == siswaList.length - 1;

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? (isDark
                                                  ? Colors.grey[850]
                                                  : Colors.white)
                                            : (isDark
                                                  ? Colors.grey[800]
                                                  : Colors.grey[50]),
                                        border: isLastItem
                                            ? null
                                            : Border(
                                                bottom: BorderSide(
                                                  color: isDark
                                                      ? Colors.grey[700]!
                                                      : Colors.grey[300]!,
                                                  width: 0.5,
                                                ),
                                              ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark
                                                    ? Colors.grey[400]
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              siswa['nama'] ?? 'Siswa',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: isDark
                                                    ? Colors.grey[200]
                                                    : Colors.grey[800],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              siswa['nis'] ?? '-',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark
                                                    ? Colors.grey[300]
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.green
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Text(
                                                'Aktif',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green[700],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRowInDialog(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primaryPurple),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAbsensiDialog(BuildContext context, GuruStatsLoaded state) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final guruId = userProvider.userId ?? '';
    final today = DateTime.now();

    // Inisialisasi locale Indonesia
    await initializeDateFormatting('id_ID', null);

    final formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(today);

    // State untuk menyimpan status hadir (checked = hadir)
    final absensiChecked = <String, bool>{};

    // Initialize all students as unchecked
    for (final kelas in state.kelasWali) {
      final kelasId = kelas['id'] as String;
      final siswaList = state.siswaPerKelas[kelasId] ?? [];
      for (final siswa in siswaList) {
        absensiChecked[siswa['id'] as String] = false;
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.fact_check,
                          color: AppTheme.primaryPurple,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Absensi Siswa',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Daftar Siswa per Kelas
                  if (state.kelasWali.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Belum ada kelas wali'),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.kelasWali.length,
                        itemBuilder: (context, kelasIndex) {
                          final kelas = state.kelasWali[kelasIndex];
                          final kelasId = kelas['id'] as String;
                          final siswaList = state.siswaPerKelas[kelasId] ?? [];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey[850]
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey[200]!,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        kelas['namaKelas'] ?? 'Kelas',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryPurple,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryPurple
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${siswaList.length} Siswa',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primaryPurple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (siswaList.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  // Table Header
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryPurple.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryPurple,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Nama',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryPurple,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'NIS',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryPurple,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            'Hadir',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryPurple,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Table Body
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.grey[700]!
                                            : Colors.grey[300]!,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Column(
                                      children: siswaList.asMap().entries.map((
                                        entry,
                                      ) {
                                        final idx = entry.key;
                                        final siswa = entry.value;
                                        final siswaId = siswa['id'] as String;
                                        final isLastItem =
                                            idx == siswaList.length - 1;

                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: idx % 2 == 0
                                                ? (isDark
                                                      ? Colors.grey[850]
                                                      : Colors.white)
                                                : (isDark
                                                      ? Colors.grey[800]
                                                      : Colors.grey[50]),
                                            border: isLastItem
                                                ? null
                                                : Border(
                                                    bottom: BorderSide(
                                                      color: isDark
                                                          ? Colors.grey[700]!
                                                          : Colors.grey[300]!,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 40,
                                                child: Text(
                                                  '${idx + 1}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: isDark
                                                        ? Colors.grey[400]
                                                        : Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  siswa['nama'] ?? 'Siswa',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: isDark
                                                        ? Colors.grey[200]
                                                        : Colors.grey[800],
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  siswa['nis'] ?? '-',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: isDark
                                                        ? Colors.grey[300]
                                                        : Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Center(
                                                  child: Checkbox(
                                                    value:
                                                        absensiChecked[siswaId] ??
                                                        false,
                                                    activeColor:
                                                        AppTheme.primaryPurple,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        absensiChecked[siswaId] =
                                                            value ?? false;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Footer Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _simpanAbsensiCheckbox(
                            context,
                            state,
                            absensiChecked,
                            guruId,
                            today,
                          );
                        },
                        icon: const Icon(Icons.save, size: 18),
                        label: const Text('Simpan Absensi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _simpanAbsensiCheckbox(
    BuildContext context,
    GuruStatsLoaded state,
    Map<String, bool> absensiChecked,
    String guruId,
    DateTime tanggal,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Tampilkan loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Cek apakah sudah ada absensi untuk tanggal ini
      // Menggunakan format tanggal sebagai string untuk pengecekan yang lebih sederhana
      final dateString = DateFormat('yyyy-MM-dd').format(tanggal);

      // Query sederhana tanpa multiple where yang memerlukan composite index
      final existingAbsensiCheck = await firestore
          .collection('absensi')
          .where('diabsen_oleh', isEqualTo: guruId)
          .where('tipe_absen', isEqualTo: 'harian')
          .get();

      // Filter secara manual berdasarkan tanggal
      final todayAbsensi = existingAbsensiCheck.docs.where((doc) {
        final data = doc.data();
        final timestamp = data['tanggal'] as Timestamp?;
        if (timestamp != null) {
          final docDate = timestamp.toDate();
          final docDateString = DateFormat('yyyy-MM-dd').format(docDate);
          return docDateString == dateString;
        }
        return false;
      }).toList();

      if (todayAbsensi.isNotEmpty) {
        // Tutup loading dialog
        if (context.mounted) Navigator.pop(context);

        // Tutup absensi dialog
        if (context.mounted) Navigator.pop(context);

        // Tampilkan peringatan
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  const Text('Absensi Sudah Ada'),
                ],
              ),
              content: const Text(
                'Absensi untuk tanggal hari ini sudah pernah dilakukan.\n\n'
                'Anda tidak dapat melakukan absensi lebih dari sekali dalam satu hari.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Dapatkan ID terakhir untuk membuat ID numerik baru
      final allAbsensi = await firestore.collection('absensi').get();

      int nextId = 1;
      if (allAbsensi.docs.isNotEmpty) {
        // Cari ID numerik tertinggi
        int maxId = 0;
        for (var doc in allAbsensi.docs) {
          final numId = int.tryParse(doc.id);
          if (numId != null && numId > maxId) {
            maxId = numId;
          }
        }
        nextId = maxId + 1;
      }

      final batch = firestore.batch();

      for (final kelas in state.kelasWali) {
        final kelasId = kelas['id'] as String;
        final siswaList = state.siswaPerKelas[kelasId] ?? [];

        for (final siswa in siswaList) {
          final siswaId = siswa['id'] as String;
          final isHadir = absensiChecked[siswaId] ?? false;
          final status = isHadir ? 'hadir' : 'alpa';

          // Buat absensi baru dengan ID numerik
          final docRef = firestore.collection('absensi').doc(nextId.toString());
          batch.set(docRef, {
            'siswa_id': siswaId,
            'kelas_id': kelasId,
            'tanggal': Timestamp.fromDate(
              DateTime(tanggal.year, tanggal.month, tanggal.day),
            ),
            'tipe_absen': 'harian',
            'jadwal_id': null,
            'status': status,
            'diabsen_oleh': guruId,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          nextId++; // Increment untuk siswa berikutnya
        }
      }

      await batch.commit();

      // Tutup loading dialog
      if (context.mounted) Navigator.pop(context);

      // Tutup absensi dialog
      if (context.mounted) Navigator.pop(context);

      // Tampilkan success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Absensi berhasil disimpan'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Tutup loading dialog
      if (context.mounted) Navigator.pop(context);

      // Tampilkan error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal menyimpan absensi: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
