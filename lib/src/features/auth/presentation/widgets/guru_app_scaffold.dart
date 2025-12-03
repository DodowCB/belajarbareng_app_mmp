import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../halamanGuru/halaman_guru_screen.dart';
import '../halamanGuru/component/kelas_guru_screen.dart';
import '../halamanGuru/component/kelas_list_screen.dart';
import '../halamanGuru/component/kelas_nilai_list_screen.dart';
import '../halamanGuru/component/tugas_list_screen.dart';
import '../halamanGuru/component/materi_guru_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../notifications/notifications_screen.dart';
import '../help/help_support_screen.dart';
import '../login/login_screen.dart';

class GuruAppScaffold extends ConsumerStatefulWidget {
  final String title;
  final IconData icon;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? additionalActions;
  final String currentRoute;

  const GuruAppScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.body,
    required this.currentRoute,
    this.floatingActionButton,
    this.additionalActions,
  });

  @override
  ConsumerState<GuruAppScaffold> createState() => _GuruAppScaffoldState();
}

class _GuruAppScaffoldState extends ConsumerState<GuruAppScaffold> {
  bool _isSidebarCollapsed = false;
  bool _isProfileMenuExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: isDark
            ? AppTheme.backgroundDark
            : AppTheme.backgroundLight,
        body: Row(
          children: [
            _buildSidebar(isDark),
            Expanded(
              child: Column(
                children: [
                  _buildHeader(context, isDark),
                  Expanded(child: widget.body),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
      );
    }

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: _buildAppBar(context, isDark),
      drawer: _buildDrawer(context, isDark),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget _buildSidebar(bool isDark) {
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
          _buildSidebarLogo(isDark),
          // Profile Menu Section (Expandable)
          if (!_isSidebarCollapsed) _buildExpandableProfileMenu(),
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
          // Navigation Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: widget.currentRoute == '/halaman-guru',
                  onTap: () {
                    if (widget.currentRoute != '/halaman-guru') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HalamanGuruScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.class_,
                  title: 'Kelas',
                  isActive: widget.currentRoute == '/kelas',
                  onTap: () {
                    if (widget.currentRoute != '/kelas') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelasListScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.star,
                  title: 'Nilai Siswa',
                  isActive: widget.currentRoute == '/nilai-siswa',
                  onTap: () {
                    if (widget.currentRoute != '/nilai-siswa') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelasNilaiListScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.assignment,
                  title: 'Tugas',
                  isActive: widget.currentRoute == '/tugas',
                  onTap: () {
                    if (widget.currentRoute != '/tugas') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasListScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.book,
                  title: 'Materi Pembelajaran',
                  isActive: widget.currentRoute == '/materi',
                  onTap: () {
                    if (widget.currentRoute != '/materi') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MateriGuruScreen(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarLogo(bool isDark) {
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
                child: const Icon(Icons.school, color: Colors.white, size: 24),
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
                          'EduManage',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Platform Guru',
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
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool isActive,
    Widget? trailing,
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
          leading: Icon(
            icon,
            color: isActive
                ? AppTheme.primaryPurple
                : (isDark ? Colors.grey[400] : Colors.grey[600]),
            size: 22,
          ),
          title: _isSidebarCollapsed
              ? null
              : Text(
                  title,
                  style: TextStyle(
                    color: isActive ? AppTheme.primaryPurple : null,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
          trailing: _isSidebarCollapsed ? null : trailing,
          dense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: _isSidebarCollapsed ? 20 : 16,
            vertical: 4,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildExpandableProfileMenu() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Profile Header - Clickable to expand/collapse
        InkWell(
          onTap: () {
            setState(() {
              _isProfileMenuExpanded = !_isProfileMenuExpanded;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isProfileMenuExpanded
                  ? AppTheme.primaryPurple.withOpacity(0.1)
                  : (isDark ? Colors.grey[850] : Colors.grey[100]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isProfileMenuExpanded
                    ? AppTheme.primaryPurple.withOpacity(0.3)
                    : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryPurple,
                  radius: 20,
                  child: const Text(
                    'G',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Guru Matematika',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'guru@gmail.com',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
        // Expanded Menu Items
        if (_isProfileMenuExpanded) ...[
          _buildSidebarItem(
            icon: Icons.person,
            title: 'Profile',
            isActive: false,
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
            isActive: false,
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
            isActive: false,
            trailing: Switch(
              value: !isDark,
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
          const Divider(height: 1),
          _buildSidebarItem(
            icon: Icons.logout,
            title: 'Logout',
            isActive: false,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.additionalActions != null) ...widget.additionalActions!,
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
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

  Widget _buildDrawer(BuildContext context, bool isDark) {
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
                  'EduManage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Platform Guru',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Profile Section at Top
                _buildDrawerProfileSection(),
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
                  onTap: null,
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
                // Navigation Menu
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: widget.currentRoute == '/halaman-guru',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/halaman-guru') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HalamanGuruScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.class_,
                  title: 'Kelas',
                  isActive: widget.currentRoute == '/kelas',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/kelas') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelasListScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.star,
                  title: 'Nilai Siswa',
                  isActive: widget.currentRoute == '/nilai-siswa',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/nilai-siswa') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KelasNilaiListScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.assignment,
                  title: 'Tugas',
                  isActive: widget.currentRoute == '/tugas',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/tugas') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasListScreen(),
                        ),
                      );
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.book,
                  title: 'Materi Pembelajaran',
                  isActive: widget.currentRoute == '/materi',
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.currentRoute != '/materi') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MateriGuruScreen(),
                        ),
                      );
                    }
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  isActive: false,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerProfileSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            radius: 24,
            child: const Text(
              'G',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Guru Matematika',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'guru@gmail.com',
                  style: TextStyle(
                    fontSize: 12,
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryPurple.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
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
              Navigator.pop(context); // Close drawer
            },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text('Logout'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
