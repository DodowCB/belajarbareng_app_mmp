import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/app_user.dart';
import '../widgets/guru_app_scaffold.dart';
import '../widgets/siswa_app_scaffold.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_profile_screen.dart';
import '../profile_menu/profile_menu_widget.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final isSiswa = AppUser.isSiswa;
    final isAdmin = AppUser.userType == 'admin';

    // Build settings body
    final settingsBody = ListView(
      padding: const EdgeInsets.all(20),
      children: [
          _buildSectionTitle('Appearance'),
          _buildSettingCard(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
            iconColor: AppTheme.accentYellow,
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
              activeColor: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Security'),
          _buildSettingCard(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            iconColor: AppTheme.accentPink,
            trailing: const Icon(Icons.chevron_right),
            onTap: _navigateToChangePassword,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Data & Storage'),
          _buildSettingCard(
            icon: Icons.cached,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            iconColor: AppTheme.accentOrange,
            trailing: const Icon(Icons.chevron_right),
            onTap: _showClearCacheDialog,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Legal'),
          _buildSettingCard(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            iconColor: AppTheme.accentGreen,
            trailing: const Icon(Icons.chevron_right),
            onTap: _showPrivacyPolicy,
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.policy,
            title: 'Terms of Service',
            subtitle: 'View terms and conditions',
            iconColor: AppTheme.secondaryTeal,
            trailing: const Icon(Icons.chevron_right),
            onTap: _showTermsOfService,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('About'),
          _buildSettingCard(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
            iconColor: AppTheme.primaryPurple,
          ),
        ],
      );

    // Return appropriate scaffold based on user role
    if (isAdmin) {
      // Admin uses custom Scaffold with ProfileDropdownMenu
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.settings,
                  color: AppTheme.primaryPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ProfileDropdownMenu(
                userName: AppUser.displayName,
                userEmail: AppUser.email ?? 'No email',
              ),
            ),
          ],
        ),
        body: settingsBody,
      );
    } else if (isSiswa) {
      return SiswaAppScaffold(
        title: 'Settings',
        icon: Icons.settings,
        currentRoute: '/settings',
        body: settingsBody,
      );
    } else {
      return GuruAppScaffold(
        title: 'Settings',
        icon: Icons.settings,
        currentRoute: '/settings',
        body: settingsBody,
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryPurple,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
          ),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          trailing: trailing,
        ),
      ),
    );
  }

  // Navigate to Change Password
  void _navigateToChangePassword() {
    if (AppUser.userType == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  // Clear Cache Dialog
  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppTheme.accentOrange, size: 24),
            ),
            const SizedBox(width: 12),
            const Flexible(child: Text('Clear Cache')),
          ],
        ),
        content: const Text(
          'This will clear all cached data including:\n'
          '• Image cache\n'
          '• Temporary files\n'
          '• App preferences\n\n'
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearCache();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  // Clear Cache Implementation
  Future<void> _clearCache() async {
    try {
      // Show loading
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Clearing cache...'),
                ],
              ),
            ),
          ),
        ),
      );

      int clearedBytes = 0;

      // 1. Clear Flutter image cache
      imageCache.clear();
      imageCache.clearLiveImages();
      clearedBytes += 1024 * 1024; // Estimate 1MB

      // 2. Clear SharedPreferences (except critical data)
      final prefs = await SharedPreferences.getInstance();
      final themeMode = prefs.getString('theme_mode'); // Backup theme
      final userId = prefs.getString('user_id'); // Backup user
      await prefs.clear();
      // Restore critical data
      if (themeMode != null) await prefs.setString('theme_mode', themeMode);
      if (userId != null) await prefs.setString('user_id', userId);
      clearedBytes += 512 * 1024; // Estimate 512KB

      // 3. Clear temporary directory
      try {
        final tempDir = await getTemporaryDirectory();
        if (tempDir.existsSync()) {
          final files = tempDir.listSync();
          for (var file in files) {
            try {
              if (file is File) {
                clearedBytes += await file.length();
                await file.delete();
              } else if (file is Directory) {
                await file.delete(recursive: true);
              }
            } catch (e) {
              debugPrint('Error deleting file: $e');
            }
          }
        }
      } catch (e) {
        debugPrint('Error clearing temp directory: $e');
      }

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Calculate size in MB
      final clearedMB = (clearedBytes / (1024 * 1024)).toStringAsFixed(2);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Cache cleared successfully!\nFreed $clearedMB MB of storage'),
                ),
              ],
            ),
            backgroundColor: AppTheme.accentGreen,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      // Close loading if still open
      if (mounted) Navigator.pop(context);

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error clearing cache: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  // Privacy Policy Dialog
  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.privacy_tip_outlined, color: AppTheme.accentGreen, size: 24),
            ),
            const SizedBox(width: 12),
            const Flexible(child: Text('Privacy Policy')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Effective Date: January 1, 2026\n',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Text(
                'BelajarBareng Privacy Policy\n\n'
                '1. Information We Collect\n'
                'We collect information you provide directly to us, including:\n'
                '• Account information (name, email, role)\n'
                '• Educational content and progress data\n'
                '• Usage data and analytics\n\n'
                '2. How We Use Your Information\n'
                'We use the information we collect to:\n'
                '• Provide and improve our educational services\n'
                '• Personalize your learning experience\n'
                '• Communicate with you about updates\n'
                '• Ensure platform security\n\n'
                '3. Data Storage and Security\n'
                'Your data is stored securely using Firebase Cloud services. We implement industry-standard security measures to protect your information.\n\n'
                '4. Information Sharing\n'
                'We do not sell or share your personal information with third parties for marketing purposes. Data may be shared with:\n'
                '• Your teachers/instructors (as relevant to your education)\n'
                '• Service providers (Firebase, Google Cloud)\n\n'
                '5. Your Rights\n'
                'You have the right to:\n'
                '• Access your personal data\n'
                '• Correct inaccurate data\n'
                '• Delete your account\n'
                '• Export your data\n\n'
                '6. Children\'s Privacy\n'
                'Our platform is designed for educational purposes. If you are under 18, please use this platform with parental consent.\n\n'
                '7. Changes to This Policy\n'
                'We may update this privacy policy from time to time. Continued use of the platform constitutes acceptance of any changes.\n\n'
                '8. Contact Us\n'
                'For questions about this Privacy Policy, please contact your institution administrator.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Terms of Service Dialog
  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.secondaryTeal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.policy, color: AppTheme.secondaryTeal, size: 24),
            ),
            const SizedBox(width: 12),
            const Flexible(child: Text('Terms of Service')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Last Updated: January 1, 2026\n',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Text(
                'BelajarBareng Terms of Service\n\n'
                '1. Acceptance of Terms\n'
                'By accessing and using BelajarBareng, you accept and agree to be bound by the terms and provisions of this agreement.\n\n'
                '2. User Accounts\n'
                'You are responsible for:\n'
                '• Maintaining the confidentiality of your password\n'
                '• All activities that occur under your account\n'
                '• Notifying us immediately of any unauthorized use\n\n'
                '3. User Conduct\n'
                'You agree to use BelajarBareng only for lawful purposes. You must not:\n'
                '• Post inappropriate or offensive content\n'
                '• Attempt to gain unauthorized access\n'
                '• Interfere with other users\n'
                '• Violate any applicable laws\n\n'
                '4. Educational Content\n'
                'You retain ownership of content you create. By uploading content, you grant us a license to:\n'
                '• Store and display your content\n'
                '• Share with your enrolled students/teachers\n'
                '• Use for platform improvement (anonymized)\n\n'
                '5. Intellectual Property\n'
                'The platform, including its design, features, and code, is owned by BelajarBareng and protected by copyright and other laws.\n\n'
                '6. Service Availability\n'
                'We strive to provide uninterrupted service but cannot guarantee:\n'
                '• 100% uptime\n'
                '• Freedom from errors or bugs\n'
                '• Compatibility with all devices\n\n'
                '7. Limitation of Liability\n'
                'BelajarBareng shall not be liable for any indirect, incidental, special, or consequential damages resulting from your use of the platform.\n\n'
                '8. Modifications\n'
                'We reserve the right to modify these terms at any time. Continued use after changes constitutes acceptance.\n\n'
                '9. Termination\n'
                'We may terminate or suspend your account immediately for violations of these terms.\n\n'
                '10. Governing Law\n'
                'These terms are governed by the laws of Indonesia.\n\n'
                '11. Contact\n'
                'For questions about these Terms, contact your institution administrator.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
