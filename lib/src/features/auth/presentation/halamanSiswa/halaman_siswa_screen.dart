import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../data/models/pengumuman_model.dart';
import 'blocs/blocs.dart';
import 'tugas_siswa_screen.dart';
import 'kelas_siswa_screen.dart';
import 'quiz_kelas_siswa_screen.dart';
import 'kalender_siswa_screen.dart';
import 'semua_jadwal_screen.dart';
import 'pengumuman_screen.dart';
import 'absensi_siswa_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../notifications/notifications_screen.dart';
import '../help/help_support_screen.dart';
import '../login/login_screen.dart';
import 'widgets/siswa_widgets.dart';

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
  void initState() {
    super.initState();
    // Reset flag untuk memastikan BLoC di-trigger
    _statsLoaded = false;
  }

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
      child: Builder(
        builder: (context) {
          return BlocListener<SiswaProfileBloc, SiswaProfileState>(
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
                      actions: [
                        // Online/Offline Status Indicator
                        Consumer(
                          builder: (context, ref, _) {
                            final isOnline = ref.watch(isOnlineProvider);
                            return Container(
                              margin: const EdgeInsets.only(
                                right: 8,
                                top: 12,
                                bottom: 12,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isOnline
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isOnline ? Colors.green : Colors.red,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isOnline ? Icons.wifi : Icons.wifi_off,
                                    color: isOnline ? Colors.green : Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isOnline ? 'Online' : 'Offline',
                                    style: TextStyle(
                                      color: isOnline
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    drawer: _buildDrawer(context),
                    body: _buildMainContent(
                      context,
                      isDesktop: false,
                      isTablet: isTablet,
                    ),
                  );
                }

                return Scaffold(
                  body: Row(
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
                  ),
                );
              },
            ),
          );
        },
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
                                'BelajarBareng',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Platform Siswa',
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
                  icon: Icons.assignment,
                  title: 'Tugas',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TugasSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.quiz,
                  title: 'Quiz',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizKelasSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.class_,
                  title: 'Kelas',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KelasSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.calendar_today,
                  title: 'Kalender',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KalenderSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.event_available,
                  title: 'Absensi',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AbsensiSiswaScreen(),
                      ),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.campaign,
                  title: 'Pengumuman',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PengumumanScreen(),
                      ),
                    );
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
                        builder: (context) => const QuizKelasSiswaScreen(),
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

    // Gunakan userProvider langsung tanpa BlocBuilder untuk menghindari error
    final userName = userProvider.namaLengkap ?? 'Siswa';
    final userEmail = userProvider.email ?? 'email@example.com';

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
                  _buildWelcomeSection(context, isDesktop: isDesktop),
                  SizedBox(height: isDesktop ? 32 : 24),
                  _buildStatsCards(isDesktop: isDesktop, isTablet: isTablet),
                  SizedBox(height: isDesktop ? 32 : 24),
                  _buildJadwalHariIni(context, isDesktop: isDesktop),
                  SizedBox(height: isDesktop ? 32 : 24),
                  SiswaWidgets.buildTugasTertunda(
                    context: context,
                    isDesktop: isDesktop,
                  ),
                  SizedBox(height: isDesktop ? 32 : 24),
                  SiswaWidgets.buildKelasSemesterIni(
                    context: context,
                    isDesktop: isDesktop,
                  ),
                  SizedBox(height: isDesktop ? 32 : 24),
                  _buildPengumumanTerbaru(context, isDesktop: isDesktop),
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
        // Online/Offline Status Indicator
        Consumer(
          builder: (context, ref, _) {
            final isOnline = ref.watch(isOnlineProvider);
            return Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOnline
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isOnline ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOnline ? Icons.wifi : Icons.wifi_off,
                    color: isOnline ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: isOnline ? Colors.green : Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context, {required bool isDesktop}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SiswaProfileBloc, SiswaProfileState>(
      builder: (context, state) {
        // Ambil nama dari userProvider yang sudah di-set saat login
        String siswaName = userProvider.namaLengkap ?? 'Siswa';
        String kelas = '';

        if (state is SiswaProfileLoaded) {
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
    final siswaId = userProvider.userId ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('siswa_kelas')
          .where('siswa_id', isEqualTo: siswaId)
          .snapshots(),
      builder: (context, siswaKelasSnapshot) {
        if (siswaKelasSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!siswaKelasSnapshot.hasData ||
            siswaKelasSnapshot.data!.docs.isEmpty) {
          return _buildStatsCardsContent(
            tugasPending: 0,
            jatuhTempoText: 'Tidak ada tugas',
            kehadiranPersentase: 0.0,
            isDesktop: isDesktop,
          );
        }

        final kelasId = siswaKelasSnapshot.data!.docs.first.get('kelas_id');

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tugas')
              .where('id_kelas', isEqualTo: kelasId)
              .snapshots(),
          builder: (context, tugasSnapshot) {
            if (tugasSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            int tugasPending = 0;
            int jatuhTempoHariIni = 0;
            int jatuhTempoBesok = 0;

            if (tugasSnapshot.hasData) {
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final tomorrow = today.add(const Duration(days: 1));

              for (var doc in tugasSnapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final deadline = (data['deadline'] as Timestamp?)?.toDate();

                if (deadline != null && deadline.isAfter(now)) {
                  tugasPending++;

                  final deadlineDate = DateTime(
                    deadline.year,
                    deadline.month,
                    deadline.day,
                  );

                  if (deadlineDate == today) {
                    jatuhTempoHariIni++;
                  } else if (deadlineDate == tomorrow) {
                    jatuhTempoBesok++;
                  }
                }
              }
            }

            String jatuhTempoText = 'Semua tugas terkendali! 🎉';
            if (jatuhTempoHariIni > 0) {
              jatuhTempoText = '$jatuhTempoHariIni jatuh tempo hari ini';
            } else if (jatuhTempoBesok > 0) {
              jatuhTempoText = '$jatuhTempoBesok jatuh tempo besok';
            } else if (tugasPending > 0) {
              jatuhTempoText = 'Tenang, masih ada waktu';
            }

            // Query absensi untuk menghitung kehadiran
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('absensi')
                  .where('siswa_id', isEqualTo: siswaId)
                  .snapshots(),
              builder: (context, absensiSnapshot) {
                double kehadiranPersentase = 0.0;

                if (absensiSnapshot.hasData &&
                    absensiSnapshot.data!.docs.isNotEmpty) {
                  int totalAbsensi = absensiSnapshot.data!.docs.length;
                  int jumlahHadir = 0;

                  for (var doc in absensiSnapshot.data!.docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final status = (data['status'] ?? '')
                        .toString()
                        .toLowerCase();

                    // Hanya hitung yang statusnya "hadir"
                    if (status == 'hadir') {
                      jumlahHadir++;
                    }
                  }

                  if (totalAbsensi > 0) {
                    kehadiranPersentase = (jumlahHadir / totalAbsensi) * 100;
                  }
                }

                return _buildStatsCardsContent(
                  tugasPending: tugasPending,
                  jatuhTempoText: jatuhTempoText,
                  kehadiranPersentase: kehadiranPersentase,
                  isDesktop: isDesktop,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatsCardsContent({
    required int tugasPending,
    required String jatuhTempoText,
    required double kehadiranPersentase,
    required bool isDesktop,
  }) {
    final siswaId = userProvider.userId ?? '';
    final dynamic querySiswaId = int.tryParse(siswaId) ?? siswaId;

    // Langsung query collection pengumpulan, auto-update real-time
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pengumpulan')
          .where('siswa_id', isEqualTo: querySiswaId)
          .snapshots(),
      builder: (context, pengumpulanSnapshot) {
        // Hitung jumlah tugas terkumpul
        final tugasSelesai = pengumpulanSnapshot.hasData
            ? pengumpulanSnapshot.data!.docs.length
            : 0;

        return LayoutBuilder(
          builder: (context, constraints) {
            // Tentukan subtitle kehadiran berdasarkan persentase
            String kehadiranSubtitle;
            if (kehadiranPersentase >= 90) {
              kehadiranSubtitle = 'Sangat baik';
            } else if (kehadiranPersentase >= 80) {
              kehadiranSubtitle = 'Baik';
            } else if (kehadiranPersentase >= 70) {
              kehadiranSubtitle = 'Cukup';
            } else if (kehadiranPersentase > 0) {
              kehadiranSubtitle = 'Perlu ditingkatkan';
            } else {
              kehadiranSubtitle = 'Belum ada data';
            }

            if (isDesktop) {
              return Row(
                children: [
                  Expanded(
                    child: _buildModernStatCard(
                      title: 'Tugas Tertunda',
                      value: tugasPending.toString(),
                      subtitle: jatuhTempoText,
                      icon: Icons.assignment_outlined,
                      color: const Color(0xFFFF6B6B),
                      isDesktop: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModernStatCard(
                      title: 'Tugas Terkumpul',
                      value: tugasSelesai.toString(),
                      subtitle: 'Terus semangat! 💪',
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFF4CAF50),
                      isDesktop: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModernStatCard(
                      title: 'Kehadiran',
                      value: '${kehadiranPersentase.toInt()}%',
                      subtitle: kehadiranSubtitle,
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
                    subtitle: jatuhTempoText,
                    icon: Icons.assignment_outlined,
                    color: const Color(0xFFFF6B6B),
                    isDesktop: false,
                  ),
                  const SizedBox(height: 12),
                  _buildModernStatCard(
                    title: 'Tugas Terkumpul',
                    value: tugasSelesai.toString(),
                    subtitle: 'Terus semangat! 💪',
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF4CAF50),
                    isDesktop: false,
                  ),
                  const SizedBox(height: 12),
                  _buildModernStatCard(
                    title: 'Kehadiran',
                    value: '${kehadiranPersentase.toInt()}%',
                    subtitle: kehadiranSubtitle,
                    icon: Icons.people_outline,
                    color: AppTheme.primaryPurple,
                    isDesktop: false,
                  ),
                ],
              );
            }
          },
        );
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
                          builder: (context) => const QuizKelasSiswaScreen(),
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
                          builder: (context) => const QuizKelasSiswaScreen(),
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

  Widget _buildJadwalHariIni(BuildContext context, {required bool isDesktop}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final siswaId = userProvider.userId ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jadwal Pelajaran',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SemuaJadwalScreen(),
                  ),
                );
              },
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('siswa_kelas')
              .where('siswa_id', isEqualTo: siswaId)
              .snapshots(),
          builder: (context, siswaKelasSnapshot) {
            if (siswaKelasSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryPurple,
                  ),
                ),
              );
            }

            if (siswaKelasSnapshot.hasError) {
              return _buildEmptyJadwal('Gagal memuat jadwal', isDark);
            }

            if (!siswaKelasSnapshot.hasData ||
                siswaKelasSnapshot.data!.docs.isEmpty) {
              return _buildEmptyJadwal(
                'Anda belum terdaftar di kelas manapun',
                isDark,
              );
            }

            // Ambil SEMUA kelas_id dari siswa_kelas
            final kelasIdList = siswaKelasSnapshot.data!.docs
                .map((doc) => doc.get('kelas_id') as String)
                .toList();

            // Query kelas_ngajar untuk SEMUA kelas yang diikuti siswa
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('kelas_ngajar')
                  .where('id_kelas', whereIn: kelasIdList)
                  .snapshots(),
              builder: (context, kelasNgajarSnapshot) {
                if (kelasNgajarSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  );
                }

                if (kelasNgajarSnapshot.hasError) {
                  return _buildEmptyJadwal(
                    'Gagal memuat jadwal pelajaran',
                    isDark,
                  );
                }

                if (!kelasNgajarSnapshot.hasData ||
                    kelasNgajarSnapshot.data!.docs.isEmpty) {
                  return _buildEmptyJadwal(
                    'Belum ada jadwal pelajaran',
                    isDark,
                  );
                }

                final kelasNgajarList = kelasNgajarSnapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: kelasNgajarList.length,
                  itemBuilder: (context, index) {
                    final kelasNgajarDoc = kelasNgajarList[index];
                    final kelasNgajarData =
                        kelasNgajarDoc.data() as Map<String, dynamic>;
                    final mapelId = kelasNgajarData['id_mapel'] ?? '';
                    final guruId = kelasNgajarData['id_guru'] ?? '';
                    final jam = kelasNgajarData['jam'] ?? '';
                    final kelasIdJadwal = kelasNgajarData['id_kelas'] ?? '';

                    // Generate random color for each subject
                    final colors = [
                      AppTheme.primaryPurple,
                      AppTheme.secondaryTeal,
                      AppTheme.accentGreen,
                      AppTheme.accentOrange,
                      const Color(0xFF4CAF50),
                    ];
                    final colorIndex = index % colors.length;

                    // Fetch kelas details untuk nomor_kelas
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('kelas')
                          .doc(kelasIdJadwal)
                          .get(),
                      builder: (context, kelasSnapshot) {
                        String nomorKelas = '';
                        if (kelasSnapshot.hasData &&
                            kelasSnapshot.data!.exists) {
                          final kelasData =
                              kelasSnapshot.data!.data()
                                  as Map<String, dynamic>?;
                          nomorKelas = kelasData?['nomor_kelas'] ?? '';
                        }

                        // Fetch mapel details
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('mapel')
                              .doc(mapelId)
                              .get(),
                          builder: (context, mapelSnapshot) {
                            if (!mapelSnapshot.hasData) {
                              return const SizedBox.shrink();
                            }

                            final mapelData =
                                mapelSnapshot.data!.data()
                                    as Map<String, dynamic>?;
                            if (mapelData == null) {
                              return const SizedBox.shrink();
                            }

                            final namaMapel =
                                mapelData['namaMapel'] ?? 'Mata Pelajaran';

                            // Fetch guru details
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('guru')
                                  .doc(guruId)
                                  .get(),
                              builder: (context, guruSnapshot) {
                                String namaGuru = 'Guru';
                                if (guruSnapshot.hasData &&
                                    guruSnapshot.data!.exists) {
                                  final guruData =
                                      guruSnapshot.data!.data()
                                          as Map<String, dynamic>?;
                                  namaGuru =
                                      guruData?['nama_lengkap'] ?? 'Guru';
                                }

                                return _buildJadwalCard(
                                  jam: jam,
                                  mataPelajaran: namaMapel,
                                  guru: namaGuru,
                                  nomorKelas: nomorKelas,
                                  color: colors[colorIndex],
                                  isDark: isDark,
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyJadwal(String message, bool isDark) {
    return Container(
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
          Icon(Icons.info_outline, color: Colors.grey, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalCard({
    required String jam,
    required String mataPelajaran,
    required String guru,
    required String nomorKelas,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Column kiri - Jam
            Text(
              jam.isNotEmpty ? jam : '-',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[200] : Colors.black87,
                height: 1.2,
              ),
            ),
            const SizedBox(width: 16),
            // Column kanan - Mata Pelajaran dan Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mataPelajaran,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nomorKelas.isNotEmpty ? '$nomorKelas \u2022 $guru' : guru,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPengumumanTerbaru(
    BuildContext context, {
    required bool isDesktop,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pengumuman')
              .orderBy('createdAt', descending: true)
              .limit(3)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryPurple,
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  ),
                ),
                child: Text(
                  'Gagal memuat pengumuman',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
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
                    Icon(Icons.info_outline, color: Colors.grey, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Belum ada pengumuman',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            final pengumumanList = snapshot.data!.docs;

            return Column(
              children: pengumumanList.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final judul = data['judul'] ?? 'Tanpa Judul';
                final deskripsi = data['deskripsi'] ?? '';

                return Container(
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
                          Icons.campaign,
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
                              judul,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              deskripsi,
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
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
