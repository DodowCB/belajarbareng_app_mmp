import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/theme_provider.dart';
import '../../../../../core/providers/user_provider.dart';
import '../halaman_guru_screen.dart';
import 'kelas_guru_screen.dart';
import 'kelas_list_screen.dart';
import 'kelas_nilai_list_screen.dart';
import 'tugas_list_screen.dart';
import 'materi_guru_screen.dart';
import 'absensi_guru_screen.dart';
import 'quiz_guru_screen.dart';
import '../../profile/profile_screen.dart';
import '../../settings/settings_screen.dart';
import '../../notifications/notifications_screen.dart';
import '../../help/help_support_screen.dart';

/// Extension untuk semua widget sidebar dan drawer
extension GuruSidebarWidgets on HalamanGuruScreenState {
  Widget buildSidebar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isSidebarCollapsed ? 70 : 250,
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
          // Header with logo and title - Clickable to toggle collapse
          InkWell(
            onTap: () {
              updateState(() {
                isSidebarCollapsed = !isSidebarCollapsed;
                if (isSidebarCollapsed) {
                  isProfileMenuExpanded = false;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              child: isSidebarCollapsed
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
          ),
          // Profile Menu Section (Expandable) - Moved to top
          if (!isSidebarCollapsed) buildExpandableProfileMenu(context),
          if (isSidebarCollapsed)
            buildSidebarItem(
              icon: Icons.account_circle,
              title: 'Profile',
              onTap: () {
                updateState(() {
                  isSidebarCollapsed = false;
                  isProfileMenuExpanded = true;
                });
              },
            ),
          if (!isSidebarCollapsed) const Divider(height: 1),
          if (isSidebarCollapsed) const Divider(height: 1),
          // Navigation Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                buildSidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: true,
                  onTap: () {},
                ),
                buildSidebarItem(
                  icon: Icons.class_,
                  title: 'Kelas',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KelasListScreen(),
                      ),
                    );
                  },
                ),
                buildSidebarItem(
                  icon: Icons.star,
                  title: 'Nilai Siswa',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KelasNilaiListScreen(),
                      ),
                    );
                  },
                ),
                buildSidebarItem(
                  icon: Icons.assignment,
                  title: 'Tugas',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TugasListScreen(),
                      ),
                    );
                  },
                ),
                buildSidebarItemWithCount(
                  icon: Icons.book,
                  title: 'Materi Pembelajaran',
                  countStream: _getMateriCountStream(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MateriGuruScreen(),
                      ),
                    );
                  },
                ),
                buildSidebarItemWithCount(
                  icon: Icons.fact_check,
                  title: 'Absensi',
                  countStream: _getAbsensiCountStream(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AbsensiGuruScreen(),
                      ),
                    );
                  },
                ),
                buildSidebarItem(
                  icon: Icons.quiz,
                  title: 'Quiz',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizGuruScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
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
                buildDrawerProfileSection(context),
                const Divider(),
                buildDrawerItem(
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
                buildDrawerItem(
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
                buildDrawerItem(
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
                buildDrawerItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreenLive(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
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
                // Navigation Menu
                buildDrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: true,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                buildDrawerItem(
                  icon: Icons.class_,
                  title: 'Kelas',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KelasListScreen(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
                  icon: Icons.star,
                  title: 'Nilai Siswa',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KelasNilaiListScreen(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
                  icon: Icons.assignment,
                  title: 'Tugas',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TugasListScreen(),
                      ),
                    );
                  },
                ),
                buildDrawerItemWithCount(
                  icon: Icons.book,
                  title: 'Materi Pembelajaran',
                  countStream: _getMateriCountStream(),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MateriGuruScreen(),
                      ),
                    );
                  },
                ),
                buildDrawerItemWithCount(
                  icon: Icons.fact_check,
                  title: 'Absensi',
                  countStream: _getAbsensiCountStream(),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AbsensiGuruScreen(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
                  icon: Icons.quiz,
                  title: 'Quiz',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizGuruScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem({
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
              // Handle navigation
            },
      ),
    );
  }

  Widget buildSidebarItem({
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
      message: isSidebarCollapsed ? title : '',
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
            color:
                iconColor ??
                (isActive
                    ? AppTheme.primaryPurple
                    : (isDark ? Colors.grey[400] : Colors.grey[600])),
            size: 22,
          ),
          title: isSidebarCollapsed
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
          trailing: isSidebarCollapsed ? null : trailing,
          dense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isSidebarCollapsed ? 20 : 16,
            vertical: 4,
          ),
          onTap:
              onTap ??
              () {
                // Handle navigation
              },
        ),
      ),
    );
  }

  Widget buildExpandableProfileMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ambil data langsung dari userProvider singleton yang sudah di-set saat login
    final user = userProvider; // Global singleton instance
    final userName = user.namaLengkap ?? 'Guru';
    final userEmail = user.email ?? 'email@example.com';

    return Column(
      children: [
        // Profile Header - Clickable to expand/collapse
        InkWell(
          onTap: () {
            updateState(() {
              isProfileMenuExpanded = !isProfileMenuExpanded;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isProfileMenuExpanded
                  ? AppTheme.primaryPurple.withOpacity(0.1)
                  : (isDark ? Colors.grey[850] : Colors.grey[100]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isProfileMenuExpanded
                    ? AppTheme.primaryPurple.withOpacity(0.3)
                    : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryPurple,
                  radius: 20,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'G',
                    style: const TextStyle(
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
                  isProfileMenuExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        // Expanded Menu Items
        if (isProfileMenuExpanded) ...[
          buildSidebarItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          buildSidebarItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          buildSidebarItem(
            icon: Icons.light_mode,
            title: 'Light Mode',
            trailing: Switch(
              value: !isDark,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
              activeColor: AppTheme.primaryPurple,
            ),
          ),
          buildSidebarItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreenLive(),
                ),
              );
            },
          ),
          buildSidebarItem(
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
          const Divider(height: 1),
          buildSidebarItem(
            icon: Icons.logout,
            title: 'Logout',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ],
    );
  }

  Widget buildDrawerProfileSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ambil data langsung dari userProvider singleton yang sudah di-set saat login
    final user = userProvider; // Global singleton instance
    final userName = user.namaLengkap ?? 'Guru';
    final userEmail = user.email ?? 'email@example.com';

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
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
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'G',
              style: const TextStyle(
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 13,
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

  // Helper methods untuk Firestore Streams
  Stream<int> _getMateriCountStream() {
    final guruId = userProvider.userId;
    if (guruId == null) return Stream.value(0);

    return FirebaseFirestore.instance
        .collection('materi')
        .where('id_guru', isEqualTo: guruId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> _getAbsensiCountStream() {
    final guruId = userProvider.userId;
    if (guruId == null) return Stream.value(0);

    // Hitung jumlah absensi yang dibuat oleh guru ini hari ini
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return FirebaseFirestore.instance
        .collection('absensi')
        .where('diabsen_oleh', isEqualTo: guruId)
        .where(
          'tanggal',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Widget buildSidebarItemWithCount({
    required IconData icon,
    required String title,
    required Stream<int> countStream,
    bool isActive = false,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: isSidebarCollapsed ? title : '',
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
            color:
                iconColor ??
                (isActive
                    ? AppTheme.primaryPurple
                    : (isDark ? Colors.grey[400] : Colors.grey[600])),
            size: 22,
          ),
          title: isSidebarCollapsed
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
          trailing: isSidebarCollapsed
              ? null
              : StreamBuilder<int>(
                  stream: countStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == 0) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${snapshot.data}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
          dense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isSidebarCollapsed ? 20 : 16,
            vertical: 4,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget buildDrawerItemWithCount({
    required IconData icon,
    required String title,
    required Stream<int> countStream,
    bool isActive = false,
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
        trailing: StreamBuilder<int>(
          stream: countStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == 0) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${snapshot.data}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        onTap: onTap,
      ),
    );
  }
}
