import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../providers/theme_provider.dart';

/// Profile Menu Item Model
class ProfileMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Widget? trailing;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.trailing,
  });
}

/// Profile Dropdown Menu
class ProfileDropdownMenu extends ConsumerWidget {
  final String userName;
  final String userEmail;
  final String? userPhotoUrl;

  const ProfileDropdownMenu({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return PopupMenuButton<String>(
      offset: const Offset(0, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      itemBuilder: (context) => [
        // User Info Header
        PopupMenuItem<String>(
          enabled: false,
          child: _buildUserHeader(context),
        ),
        const PopupMenuDivider(),

        // Profile
        _buildMenuItem(
          value: 'profile',
          icon: Icons.person_outline,
          title: 'Profile',
          subtitle: 'View and edit profile',
          iconColor: AppTheme.primaryPurple,
        ),

        // Settings
        _buildMenuItem(
          value: 'settings',
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'App preferences',
          iconColor: AppTheme.secondaryTeal,
        ),

        const PopupMenuDivider(),

        // Dark Mode Toggle
        PopupMenuItem<String>(
          value: 'theme',
          child: StatefulBuilder(
            builder: (context, setState) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentYellow.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: AppTheme.accentYellow,
                    size: 20,
                  ),
                ),
                title: Text(
                  isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Tap to switch',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                    setState(() {});
                  },
                  activeColor: AppTheme.primaryPurple,
                ),
                onTap: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                  setState(() {});
                },
              );
            },
          ),
        ),

        const PopupMenuDivider(),

        // Notifications
        _buildMenuItem(
          value: 'notifications',
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage notifications',
          iconColor: AppTheme.accentOrange,
        ),

        // Help & Support
        _buildMenuItem(
          value: 'help',
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get assistance',
          iconColor: AppTheme.accentGreen,
        ),

        const PopupMenuDivider(),

        // Logout
        _buildMenuItem(
          value: 'logout',
          icon: Icons.logout_rounded,
          title: 'Logout',
          iconColor: AppTheme.accentOrange,
        ),
      ],
      onSelected: (value) => _handleMenuSelection(context, value, ref),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
        backgroundImage: userPhotoUrl != null ? NetworkImage(userPhotoUrl!) : null,
        child: userPhotoUrl == null
            ? const Icon(
                Icons.person_outline,
                color: AppTheme.primaryPurple,
                size: 20,
              )
            : null,
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
            backgroundImage: userPhotoUrl != null ? NetworkImage(userPhotoUrl!) : null,
            child: userPhotoUrl == null
                ? const Icon(
                    Icons.person,
                    color: AppTheme.primaryPurple,
                    size: 28,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
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

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Widget? trailing,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppTheme.primaryPurple).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppTheme.primaryPurple,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              )
            : null,
        trailing: trailing,
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value, WidgetRef ref) {
    switch (value) {
      case 'profile':
        _showComingSoonSnackbar(context, 'Profile');
        break;
      case 'settings':
        _showComingSoonSnackbar(context, 'Settings');
        break;
      case 'notifications':
        _showComingSoonSnackbar(context, 'Notifications');
        break;
      case 'help':
        _showComingSoonSnackbar(context, 'Help & Support');
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
      case 'theme':
        // Theme toggle handled in the menu item itself
        break;
    }
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text('$feature feature coming soon!'),
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
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.accentOrange),
            SizedBox(width: 12),
            Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Logged out successfully'),
                    ],
                  ),
                  backgroundColor: AppTheme.accentGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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

/// Compact version for smaller spaces
class CompactProfileMenu extends ConsumerWidget {
  const CompactProfileMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      icon: const Icon(Icons.more_vert_rounded),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'theme',
          child: Row(
            children: [
              Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(isDarkMode ? 'Dark Mode' : 'Light Mode'),
              const Spacer(),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
                activeColor: AppTheme.primaryPurple,
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 20),
              SizedBox(width: 12),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'help',
          child: Row(
            children: [
              Icon(Icons.help_outline, size: 20),
              SizedBox(width: 12),
              Text('Help'),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'theme') {
          ref.read(themeModeProvider.notifier).toggleTheme();
        }
      },
    );
  }
}
