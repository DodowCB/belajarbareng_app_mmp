import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../data/models/pengumuman_model.dart';
import 'blocs/blocs.dart';
import 'tugas_siswa_screen.dart';
import 'quiz_siswa_screen.dart';
import 'kelas_siswa_screen.dart';
import 'kalender_siswa_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../notifications/notifications_screen.dart';
import '../help/help_support_screen.dart';
import '../login/login_screen.dart';

class HalamanSiswaScreen extends ConsumerStatefulWidget {
  const HalamanSiswaScreen({super.key});

  @override
  ConsumerState<HalamanSiswaScreen> createState() => _HalamanSiswaScreenState();
}

class _HalamanSiswaScreenState extends ConsumerState<HalamanSiswaScreen> {
  bool _statsLoaded = false;
  bool _isSidebarCollapsed = false;
  bool _isProfileMenuExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SiswaProfileBloc>(
          create: (context) =>
              SiswaProfileBloc()..add(const LoadSiswaProfile()),
        ),
        BlocProvider<SiswaStatsBloc>(create: (context) => SiswaStatsBloc()),
      ],
      child: Scaffold(
        body: BlocListener<SiswaProfileBloc, SiswaProfileState>(
          listener: (context, profileState) {
            if (profileState is SiswaProfileLoaded && !_statsLoaded) {
              context.read<SiswaStatsBloc>().add(
                LoadSiswaStats(profileState.siswaId),
              );
              _statsLoaded = true;
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1024;
              final isTablet = constraints.maxWidth >= 768;

              if (!isDesktop) {
                return Scaffold(
                  appBar: AppBar(
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        tooltip: 'Menu',
                      ),
                    ),
                    title: const Text('Dashboard Siswa'),
                  ),
                  drawer: _buildDrawer(context),
                  body: _buildMainContent(
                    context,
                    isDesktop: false,
                    isTablet: isTablet,
                  ),
                );
              }

              return Row(
                children: [
                  _buildSidebar(context),
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

  Widget _buildSidebar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isSidebarCollapsed ? 70 : 250,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundDark : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
                if (_isSidebarCollapsed) {
                  _isProfileMenuExpanded = false;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              child: _isSidebarCollapsed
                  ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  : Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Student Portal',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Sekolah Menengah',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
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
          ),
          if (!_isSidebarCollapsed) _buildExpandableProfileMenu(context),
          if (_isSidebarCollapsed)
            _buildSidebarItem(
              icon: Icons.account_circle,
              title: 'Profile',
              onTap: () {
                setState(() {
                  _isSidebarCollapsed = false;
                  _isProfileMenuExpanded = true;
                });
              },
            ),
          if (!_isSidebarCollapsed) const Divider(height: 1),
          if (_isSidebarCollapsed) const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: true,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  icon: Icons.calendar_today,
                  title: 'Jadwal Kelas',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KalenderSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.assignment,
                  title: 'Tugas Saya',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TugasSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.book,
                  title: 'Materi Kelas',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KelasSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.campaign,
                  title: 'Pengumuman',
                  onTap: () {
                    // Navigate to announcements
                  },
                ),
              ],
            ),
          ),
          if (!_isSidebarCollapsed) ...[
            const Divider(height: 1),
            _buildSidebarItem(
              icon: Icons.settings,
              title: 'Pengaturan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            _buildSidebarItem(
              icon: Icons.logout,
              title: 'Keluar',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            _buildSidebarProfileSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandableProfileMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isProfileMenuExpanded = !_isProfileMenuExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.account_circle, size: 22),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Profile & Settings',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(
                  _isProfileMenuExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        if (_isProfileMenuExpanded) ...[
          _buildSidebarItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          _buildSidebarItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          _buildSidebarItem(
            icon: Icons.light_mode,
            title: 'Light Mode',
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.light,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
              activeColor: AppTheme.primaryPurple,
            ),
          ),
          _buildSidebarItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          _buildSidebarItem(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
          ),
          _buildSidebarItem(
            icon: Icons.logout,
            title: 'Logout',
            iconColor: AppTheme.accentOrange,
            textColor: AppTheme.accentOrange,
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ],
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppTheme.primaryPurple),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school,
                    color: AppTheme.primaryPurple,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'BelajarBareng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Platform Siswa',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.light_mode,
                  title: 'Light Mode',
                  trailing: Switch(
                    value: Theme.of(context).brightness == Brightness.light,
                    onChanged: (value) {
                      ref.read(themeModeProvider.notifier).toggleTheme();
                    },
                    activeColor: AppTheme.primaryPurple,
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: true,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.assignment,
                  title: 'Tugas',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TugasSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.quiz,
                  title: 'Quiz',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.class_,
                  title: 'Kelas',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KelasSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.calendar_today,
                  title: 'Kalender',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KalenderSiswaScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  iconColor: AppTheme.accentOrange,
                  textColor: AppTheme.accentOrange,
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    bool isActive = false,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color:
            iconColor ??
            (isActive
                ? AppTheme.primaryPurple
                : (isDark ? Colors.grey[400] : Colors.grey[600])),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? (isActive ? AppTheme.primaryPurple : null),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: trailing,
      onTap:
          onTap ??
          () {
            Navigator.pop(context);
          },
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    bool isActive = false,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: _isSidebarCollapsed ? title : '',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryPurple.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(
            icon,
            color:
                iconColor ??
                (isActive
                    ? AppTheme.primaryPurple
                    : (isDark ? Colors.grey[400] : Colors.grey[600])),
            size: 22,
          ),
          title: _isSidebarCollapsed
              ? null
              : Text(
                  title,
                  style: TextStyle(
                    color:
                        textColor ?? (isActive ? AppTheme.primaryPurple : null),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
          trailing: _isSidebarCollapsed ? null : trailing,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildSidebarProfileSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SiswaProfileBloc, SiswaProfileState>(
      builder: (context, state) {
        String userName = 'Siswa';
        String userEmail = 'email@example.com';

        if (state is SiswaProfileLoaded) {
          userName = state.siswaData['nama_lengkap'] ?? 'Siswa';
          userEmail = state.siswaData['email'] ?? 'email@example.com';
        }

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryPurple,
                radius: 20,
                child: Text(
                  userName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
                  _buildJadwalHariIni(isDesktop: isDesktop),
                  SizedBox(height: isDesktop ? 32 : 24),
                  _buildKelasSemesterIni(isDesktop: isDesktop),
                  SizedBox(height: isDesktop ? 32 : 24),
                  _buildPengumumanTerbaru(isDesktop: isDesktop),
                  const SizedBox(height: 24),
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

    return BlocBuilder<SiswaProfileBloc, SiswaProfileState>(
      builder: (context, state) {
        String siswaName = 'Siswa';
        String kelas = '';

        if (state is SiswaProfileLoaded) {
          siswaName = state.siswaData['nama_lengkap'] ?? 'Siswa';
          kelas = state.siswaData['kelas'] ?? '';
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppTheme.primaryPurple.withOpacity(0.3),
                      AppTheme.secondaryTeal.withOpacity(0.2),
                    ]
                  : [
                      AppTheme.primaryPurple.withOpacity(0.1),
                      AppTheme.secondaryTeal.withOpacity(0.05),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $siswaName! 👋',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isDesktop ? 28 : 22,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selamat datang kembali, siap untuk belajar hari ini?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: isDesktop ? 16 : 14,
                      ),
                    ),
                    if (kelas.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Kelas $kelas',
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.primaryPurple.withOpacity(0.9)
                                : AppTheme.primaryPurple,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCards({required bool isDesktop, required bool isTablet}) {
    return BlocBuilder<SiswaStatsBloc, SiswaStatsState>(
      builder: (context, state) {
        if (state is SiswaStatsLoaded) {
          final tugasPending = state.totalTugas - state.tugasSelesai;
          final nilaiPersentase = state.rataRataNilai;
          final kehadiranPersentase =
              95.0; // Placeholder, bisa diambil dari state nanti

          return LayoutBuilder(
            builder: (context, constraints) {
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildModernStatCard(
                        title: 'Tugas Tertunda',
                        value: tugasPending.toString(),
                        subtitle: '2 jatuh tempo besok',
                        icon: Icons.assignment_outlined,
                        color: const Color(0xFFFF6B6B),
                        isDesktop: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernStatCard(
                        title: 'Rata-rata Nilai',
                        value: '${nilaiPersentase.toInt()}%',
                        subtitle: '+2% dari bulan lalu',
                        icon: Icons.trending_up,
                        color: const Color(0xFF4CAF50),
                        isDesktop: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernStatCard(
                        title: 'Kehadiran',
                        value: '${kehadiranPersentase.toInt()}%',
                        subtitle: 'Sangat baik',
                        icon: Icons.people_outline,
                        color: AppTheme.primaryPurple,
                        isDesktop: true,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildModernStatCard(
                      title: 'Tugas Tertunda',
                      value: tugasPending.toString(),
                      subtitle: '2 jatuh tempo besok',
                      icon: Icons.assignment_outlined,
                      color: const Color(0xFFFF6B6B),
                      isDesktop: false,
                    ),
                    const SizedBox(height: 12),
                    _buildModernStatCard(
                      title: 'Rata-rata Nilai',
                      value: '${nilaiPersentase.toInt()}%',
                      subtitle: '+2% dari bulan lalu',
                      icon: Icons.trending_up,
                      color: const Color(0xFF4CAF50),
                      isDesktop: false,
                    ),
                    const SizedBox(height: 12),
                    _buildModernStatCard(
                      title: 'Kehadiran',
                      value: '${kehadiranPersentase.toInt()}%',
                      subtitle: 'Sangat baik',
                      icon: Icons.people_outline,
                      color: AppTheme.primaryPurple,
                      isDesktop: false,
                    ),
                  ],
                );
              }
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildModernStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDesktop,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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

    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: isDesktop ? 28 : 24),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 16 : 12),
          Text(
            title,
            style: TextStyle(
              fontSize: isDesktop ? 14 : 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? 28 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions({required bool isDesktop, required bool isTablet}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: isDesktop ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (isDesktop) {
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildActionCard(
                    'Lihat Tugas',
                    Icons.assignment,
                    AppTheme.primaryPurple,
                    isDesktop: isDesktop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasSiswaScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    'Kerjakan Quiz',
                    Icons.quiz,
                    AppTheme.secondaryTeal,
                    isDesktop: isDesktop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizSiswaScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    'Lihat Kelas',
                    Icons.class_,
                    AppTheme.accentGreen,
                    isDesktop: isDesktop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelasSiswaScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    'Buka Kalender',
                    Icons.calendar_today,
                    AppTheme.accentOrange,
                    isDesktop: isDesktop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KalenderSiswaScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildActionCard(
                    'Lihat Tugas',
                    Icons.assignment,
                    AppTheme.primaryPurple,
                    isDesktop: isDesktop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasSiswaScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    'Kerjakan Quiz',
                    Icons.quiz,
                    AppTheme.secondaryTeal,
                    isDesktop: isDesktop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizSiswaScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    'Lihat Kelas',
                    Icons.class_,
                    AppTheme.accentGreen,
                    isDesktop: isDesktop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelasSiswaScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    'Buka Kalender',
                    Icons.calendar_today,
                    AppTheme.accentOrange,
                    isDesktop: isDesktop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KalenderSiswaScreen(),
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

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color, {
    required bool isDesktop,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: isDesktop ? 200 : double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities({required bool isDesktop}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activities = [
      {
        'title': 'Tugas Matematika dikumpulkan',
        'subtitle': '2 jam yang lalu',
        'icon': Icons.assignment_turned_in,
        'color': AppTheme.accentGreen,
      },
      {
        'title': 'Quiz Fisika diselesaikan',
        'subtitle': 'Kemarin',
        'icon': Icons.check_circle,
        'color': AppTheme.secondaryTeal,
      },
      {
        'title': 'Tugas Bahasa Indonesia baru',
        'subtitle': '3 hari yang lalu',
        'icon': Icons.assignment,
        'color': AppTheme.primaryPurple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktivitas Terbaru',
          style: TextStyle(
            fontSize: isDesktop ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDark ? Colors.grey[800] : Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (activity['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: 24,
                  ),
                ),
                title: Text(
                  activity['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  activity['subtitle'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJadwalHariIni({required bool isDesktop}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Data jadwal dummy - nanti bisa diganti dengan data dari Firestore
    final jadwal = [
      {
        'waktu': '08:00 - 09:30',
        'mataPelajaran': 'Matematika Wajib',
        'ruang': 'Ruang 304 • Pak Bambang',
        'status': 'Sedang Berlangsung',
        'color': const Color(0xFF4CAF50),
      },
      {
        'waktu': '10:00 - 11:30',
        'mataPelajaran': 'Bahasa Inggris',
        'ruang': 'Lab Bahasa 1 • Mrs. Sarah',
        'status': '',
        'color': AppTheme.primaryPurple,
      },
      {
        'waktu': '13:00 - 14:30',
        'mataPelajaran': 'Fisika Dasar',
        'ruang': 'Ruang 202 • Bu Rina',
        'status': '',
        'color': AppTheme.secondaryTeal,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jadwal Hari Ini',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full schedule
              },
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...jadwal
            .map(
              (item) => _buildJadwalCard(
                waktu: item['waktu'] as String,
                mataPelajaran: item['mataPelajaran'] as String,
                ruang: item['ruang'] as String,
                status: item['status'] as String,
                color: item['color'] as Color,
                isDark: isDark,
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildJadwalCard({
    required String waktu,
    required String mataPelajaran,
    required String ruang,
    required String status,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        waktu,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      if (status.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mataPelajaran,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ruang,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                // Join class action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Masuk Kelas'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKelasSemesterIni({required bool isDesktop}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Data kelas dummy
    final kelas = [
      {
        'nama': 'Matematika Lanjut',
        'guru': 'Bu Bambang',
        'image':
            'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=400',
      },
      {
        'nama': 'Fisika Terapan',
        'guru': 'Bu Risa',
        'image':
            'https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=400',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kelas Semester Ini',
          style: TextStyle(
            fontSize: isDesktop ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 2 : 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isDesktop ? 3 : 2.5,
          ),
          itemCount: kelas.length,
          itemBuilder: (context, index) {
            final item = kelas[index];
            return _buildKelasCard(
              nama: item['nama'] as String,
              guru: item['guru'] as String,
              image: item['image'] as String,
              isDark: isDark,
            );
          },
        ),
      ],
    );
  }

  Widget _buildKelasCard({
    required String nama,
    required String guru,
    required String image,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 120,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
              ),
              child: const Icon(Icons.image, size: 40, color: Colors.grey),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nama,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      guru,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPengumumanTerbaru({required bool isDesktop}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Data pengumuman dummy
    final pengumuman = [
      {
        'icon': Icons.campaign,
        'title': 'Ujian Tengah Semester',
        'subtitle':
            'Jadwal UTS dimulai pada hari Senin Tanggal 17 Agustus dengan...',
      },
      {
        'icon': Icons.celebration,
        'title': 'Libur Nasional',
        'subtitle':
            'Sekolah ditutup pada hari Jum\'at Tanggal 13 Juni\'21 Agustus dalam...',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengumuman Terbaru',
          style: TextStyle(
            fontSize: isDesktop ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...pengumuman
            .map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: AppTheme.primaryPurple,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
