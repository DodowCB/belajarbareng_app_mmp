import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/app_user.dart';
import '../widgets/guru_app_scaffold.dart';
import '../widgets/siswa_app_scaffold.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoBackup = false;
  String _language = 'English';
  String _fontSize = 'Medium';

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final isSiswa = AppUser.isSiswa;

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
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.language,
            title: 'Language',
            subtitle: _language,
            iconColor: AppTheme.primaryPurple,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.text_fields,
            title: 'Font Size',
            subtitle: _fontSize,
            iconColor: AppTheme.secondaryTeal,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFontSizeDialog(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Notifications'),
          _buildSettingCard(
            icon: Icons.notifications_active,
            title: 'Enable Notifications',
            subtitle: 'Receive app notifications',
            iconColor: AppTheme.accentOrange,
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
              activeColor: AppTheme.primaryPurple,
            ),
          ),
          if (_notificationsEnabled) ...[
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: Icons.email_outlined,
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              iconColor: AppTheme.accentGreen,
              trailing: Switch(
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() => _emailNotifications = value);
                },
                activeColor: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: Icons.phone_android,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              iconColor: AppTheme.accentPink,
              trailing: Switch(
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() => _pushNotifications = value);
                },
                activeColor: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: Icons.volume_up,
              title: 'Sound',
              subtitle: 'Enable notification sounds',
              iconColor: AppTheme.accentOrange,
              trailing: Switch(
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() => _soundEnabled = value);
                },
                activeColor: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              icon: Icons.vibration,
              title: 'Vibration',
              subtitle: 'Enable vibration for notifications',
              iconColor: AppTheme.secondaryTeal,
              trailing: Switch(
                value: _vibrationEnabled,
                onChanged: (value) {
                  setState(() => _vibrationEnabled = value);
                },
                activeColor: AppTheme.primaryPurple,
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildSectionTitle('Data & Storage'),
          _buildSettingCard(
            icon: Icons.backup,
            title: 'Auto Backup',
            subtitle: 'Automatically backup your data',
            iconColor: AppTheme.accentGreen,
            trailing: Switch(
              value: _autoBackup,
              onChanged: (value) {
                setState(() => _autoBackup = value);
              },
              activeColor: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.storage,
            title: 'Storage',
            subtitle: 'Manage app storage',
            iconColor: AppTheme.primaryPurple,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showStorageInfo(),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.cached,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            iconColor: AppTheme.accentOrange,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showClearCacheDialog(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Security & Privacy'),
          _buildSettingCard(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            iconColor: AppTheme.accentPink,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showChangePasswordDialog(),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.fingerprint,
            title: 'Biometric Authentication',
            subtitle: 'Use fingerprint or face ID',
            iconColor: AppTheme.secondaryTeal,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showBiometricInfo(),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            iconColor: AppTheme.accentGreen,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('About'),
          _buildSettingCard(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
            iconColor: AppTheme.primaryPurple,
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.policy,
            title: 'Terms of Service',
            subtitle: 'View terms and conditions',
            iconColor: AppTheme.secondaryTeal,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsOfService(),
          ),
        ],
      );

    // Return appropriate scaffold based on user role
    if (isSiswa) {
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English'),
            _buildLanguageOption('Indonesian'),
            _buildLanguageOption('Spanish'),
            _buildLanguageOption('French'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return RadioListTile<String>(
      title: Text(language),
      value: language,
      groupValue: _language,
      onChanged: (value) {
        setState(() => _language = value!);
        Navigator.pop(context);
        _showSuccessSnackbar('Language changed to $value');
      },
      activeColor: AppTheme.primaryPurple,
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Select Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFontSizeOption('Small'),
            _buildFontSizeOption('Medium'),
            _buildFontSizeOption('Large'),
            _buildFontSizeOption('Extra Large'),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeOption(String size) {
    return RadioListTile<String>(
      title: Text(size),
      value: size,
      groupValue: _fontSize,
      onChanged: (value) {
        setState(() => _fontSize = value!);
        Navigator.pop(context);
        _showSuccessSnackbar('Font size changed to $value');
      },
      activeColor: AppTheme.primaryPurple,
    );
  }

  void _showStorageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.storage, color: AppTheme.primaryPurple),
            SizedBox(width: 12),
            Text('Storage Info'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStorageItem('Total Space', '128 GB'),
            _buildStorageItem('Used Space', '45.2 GB'),
            _buildStorageItem('Available Space', '82.8 GB'),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.35,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
            ),
          ],
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

  Widget _buildStorageItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppTheme.accentOrange),
            SizedBox(width: 12),
            Text('Clear Cache'),
          ],
        ),
        content: const Text(
          'This will clear all cached data. Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('Cache cleared successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('Password changed successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showBiometricInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.fingerprint, color: AppTheme.secondaryTeal),
            SizedBox(width: 12),
            Text('Biometric Authentication'),
          ],
        ),
        content: const Text(
          'Biometric authentication is not yet configured. Would you like to set it up now?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('Biometric authentication setup started');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryTeal,
            ),
            child: const Text('Set Up'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'BelajarBareng Privacy Policy\n\n'
            '1. Information Collection\n'
            'We collect information you provide directly to us, such as when you create an account.\n\n'
            '2. Use of Information\n'
            'We use the information we collect to provide, maintain, and improve our services.\n\n'
            '3. Information Sharing\n'
            'We do not share your personal information with third parties without your consent.\n\n'
            '4. Security\n'
            'We take reasonable measures to help protect your information from loss, theft, misuse.\n\n'
            '5. Changes to Policy\n'
            'We may update this policy from time to time.',
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

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'BelajarBareng Terms of Service\n\n'
            '1. Acceptance of Terms\n'
            'By accessing and using this application, you accept and agree to be bound by these terms.\n\n'
            '2. User Accounts\n'
            'You are responsible for safeguarding the password that you use to access the service.\n\n'
            '3. User Content\n'
            'You retain all rights to the content you submit, post or display on or through the service.\n\n'
            '4. Prohibited Uses\n'
            'You may not use our service for any illegal or unauthorized purpose.\n\n'
            '5. Termination\n'
            'We may terminate or suspend your account immediately, without prior notice.',
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

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
