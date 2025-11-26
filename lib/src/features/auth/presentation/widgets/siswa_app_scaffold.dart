import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../halamanSiswa/blocs/blocs.dart';
import '../halamanSiswa/halaman_siswa_screen.dart';
import '../halamanSiswa/tugas_siswa_screen.dart';
import '../halamanSiswa/quiz_siswa_screen.dart';
import '../halamanSiswa/kelas_siswa_screen.dart';
import '../halamanSiswa/kalender_siswa_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../notifications/notifications_screen.dart';
import '../help/help_support_screen.dart';
import '../login/login_screen.dart';

class SiswaAppScaffold extends ConsumerStatefulWidget {
  final String title;
  final IconData icon;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? additionalActions;
  final String currentRoute;

  const SiswaAppScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.body,
    required this.currentRoute,
    this.floatingActionButton,
    this.additionalActions,
  });

  @override
  ConsumerState<SiswaAppScaffold> createState() => _SiswaAppScaffoldState();
}

class _SiswaAppScaffoldState extends ConsumerState<SiswaAppScaffold> {
  bool _isSidebarCollapsed = false;
  bool _isProfileMenuExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        
        if (!isDesktop) {
          // Mobile/Tablet: Use AppBar with Drawer
          return Scaffold(
            appBar: _buildAppBar(context),
            drawer: _buildDrawer(context),
            body: widget.body,
            floatingActionButton: widget.floatingActionButton,
          );
        }
        
        // Desktop: Use Sidebar
        return Scaffold(
          body: Row(
            children: [
              _buildSidebar(context),
              Expanded(child: widget.body),
            ],
          ),
          floatingActionButton: widget.floatingActionButton,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Menu',
        ),
      ),
      title: Text(widget.title),
      backgroundColor: isDark ? AppTheme.backgroundDark : Colors.white,
      elevation: 0,
      actions: widget.additionalActions,
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
          _buildSidebarHeader(context),
          if (!_isSidebarCollapsed) _buildExpandableProfileMenu(context),
          if (_isSidebarCollapsed)
            _buildSidebarItem(
              icon: Icons.account_circle,
              title: 'Profile',
              isActive: false,
              onTap: () {
                setState(() {
                  _isSidebarCollapsed = false;
                  _isProfileMenuExpanded = true;
                });
              },
            ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: widget.currentRoute == '/halaman-siswa',
                  onTap: () {
                    if (widget.currentRoute != '/halaman-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HalamanSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.assignment,
                  title: 'Tugas',
                  isActive: widget.currentRoute == '/tugas-siswa',
                  onTap: () {
                    if (widget.currentRoute != '/tugas-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.quiz,
                  title: 'Quiz',
                  isActive: widget.currentRoute == '/quiz-siswa',
                  onTap: () {
                    if (widget.currentRoute != '/quiz-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.class_,
                  title: 'Kelas',
                  isActive: widget.currentRoute == '/kelas-siswa',
                  onTap: () {
                    if (widget.currentRoute != '/kelas-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelasSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.calendar_today,
                  title: 'Kalender',
                  isActive: widget.currentRoute == '/kalender-siswa',
                  onTap: () {
                    if (widget.currentRoute != '/kalender-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KalenderSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          if (!_isSidebarCollapsed) _buildSidebarProfileSection(context),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
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
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Platform Siswa',
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
            isActive: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          _buildSidebarItem(
            icon: Icons.settings,
            title: 'Settings',
            isActive: false,
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
            icon: Icons.light_mode,
            title: 'Light Mode',
            isActive: false,
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
            isActive: false,
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
            isActive: false,
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
            isActive: false,
            iconColor: AppTheme.accentOrange,
            textColor: AppTheme.accentOrange,
            onTap: () => _showLogoutDialog(),
          ),
        ],
      ],
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool isActive,
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
            color: iconColor ?? (isActive ? AppTheme.primaryPurple : (isDark ? Colors.grey[400] : Colors.grey[600])),
            size: 22,
          ),
          title: _isSidebarCollapsed
              ? null
              : Text(
                  title,
                  style: TextStyle(
                    color: textColor ?? (isActive ? AppTheme.primaryPurple : null),
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

  Widget _buildDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
            ),
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
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
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
                  isActive: false,
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
                  isActive: false,
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
                  isActive: false,
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
                  isActive: widget.currentRoute == '/halaman-siswa',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/halaman-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HalamanSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.assignment,
                  title: 'Tugas',
                  isActive: widget.currentRoute == '/tugas-siswa',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/tugas-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.quiz,
                  title: 'Quiz',
                  isActive: widget.currentRoute == '/quiz-siswa',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/quiz-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.class_,
                  title: 'Kelas',
                  isActive: widget.currentRoute == '/kelas-siswa',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/kelas-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelasSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.calendar_today,
                  title: 'Kalender',
                  isActive: widget.currentRoute == '/kalender-siswa',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/kalender-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KalenderSiswaScreen(),
                        ),
                      );
                    }
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  isActive: false,
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
                  isActive: false,
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
                  isActive: false,
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
    required bool isActive,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? (isActive ? AppTheme.primaryPurple : (isDark ? Colors.grey[400] : Colors.grey[600])),
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
      onTap: onTap,
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
}
