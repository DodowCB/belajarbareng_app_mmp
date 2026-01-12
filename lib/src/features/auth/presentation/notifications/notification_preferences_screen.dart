import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../notifications/presentation/bloc/notification_preferences_bloc.dart';

class NotificationPreferencesScreen extends StatelessWidget {
  const NotificationPreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = UserProvider();
    final userId = userProvider.userId ?? '';
    final userType = userProvider.userType ?? '';

    return BlocProvider(
      create: (context) => NotificationPreferencesBloc()
        ..add(LoadNotificationPreferences(userId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text('Pengaturan Notifikasi'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        body: BlocBuilder<NotificationPreferencesBloc,
            NotificationPreferencesState>(
          builder: (context, state) {
            if (state is NotificationPreferencesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationPreferencesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NotificationPreferencesBloc>().add(
                              LoadNotificationPreferences(userId),
                            );
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state is NotificationPreferencesLoaded) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header
                  const _SectionHeader(
                    icon: Icons.notifications_active,
                    title: 'Kelola Notifikasi',
                    subtitle: 'Pilih jenis notifikasi yang ingin Anda terima',
                  ),
                  const SizedBox(height: 16),

                  // Tugas Notifications
                  _PreferenceCard(
                    icon: Icons.assignment,
                    iconColor: Colors.blue,
                    title: 'Notifikasi Tugas',
                    subtitle: 'Tugas baru dan pengumpulan tugas',
                    value: state.preferences.enableTugasNotif,
                    onChanged: (value) {
                      context.read<NotificationPreferencesBloc>().add(
                            UpdateTugasNotifPreference(userId, value),
                          );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Quiz Notifications
                  _PreferenceCard(
                    icon: Icons.quiz,
                    iconColor: Colors.purple,
                    title: 'Notifikasi Quiz',
                    subtitle: 'Quiz baru dan pengingat deadline',
                    value: state.preferences.enableQuizNotif,
                    onChanged: (value) {
                      context.read<NotificationPreferencesBloc>().add(
                            UpdateQuizNotifPreference(userId, value),
                          );
                    },
                  ),
                  const SizedBox(height: 12),

                  // QnA Notifications
                  _PreferenceCard(
                    icon: Icons.question_answer,
                    iconColor: Colors.orange,
                    title: 'Notifikasi QnA',
                    subtitle: 'Jawaban baru di pertanyaan Anda',
                    value: state.preferences.enableQnaNotif,
                    onChanged: (value) {
                      context.read<NotificationPreferencesBloc>().add(
                            UpdateQnaNotifPreference(userId, value),
                          );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Pengumuman Notifications
                  _PreferenceCard(
                    icon: Icons.campaign,
                    iconColor: Colors.red,
                    title: 'Notifikasi Pengumuman',
                    subtitle: 'Pengumuman penting dari sekolah',
                    value: state.preferences.enablePengumumanNotif,
                    onChanged: (value) {
                      context.read<NotificationPreferencesBloc>().add(
                            UpdatePengumumanNotifPreference(userId, value),
                          );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Nilai Notifications
                  if (userType == 'siswa')
                    _PreferenceCard(
                      icon: Icons.grade,
                      iconColor: Colors.green,
                      title: 'Notifikasi Nilai',
                      subtitle: 'Nilai baru dan update nilai',
                      value: state.preferences.enableNilaiNotif,
                      onChanged: (value) {
                        context.read<NotificationPreferencesBloc>().add(
                              UpdateNilaiNotifPreference(userId, value),
                            );
                      },
                    ),
                  if (userType == 'siswa') const SizedBox(height: 12),

                  // Deadline Reminders
                  _PreferenceCard(
                    icon: Icons.alarm,
                    iconColor: Colors.amber,
                    title: 'Pengingat Deadline',
                    subtitle: 'Notifikasi pengingat 1 hari sebelum deadline',
                    value: state.preferences.enableDeadlineReminder,
                    onChanged: (value) {
                      context.read<NotificationPreferencesBloc>().add(
                            UpdateDeadlineReminderPreference(userId, value),
                          );
                    },
                  ),
                  const SizedBox(height: 12),

                  // User Management (Admin only)
                  if (userType == 'admin')
                    _PreferenceCard(
                      icon: Icons.people,
                      iconColor: Colors.indigo,
                      title: 'Notifikasi Manajemen User',
                      subtitle: 'Registrasi guru/siswa baru',
                      value: state.preferences.enableUserManagementNotif,
                      onChanged: (value) {
                        context.read<NotificationPreferencesBloc>().add(
                              UpdateUserManagementNotifPreference(userId, value),
                            );
                      },
                    ),
                  if (userType == 'admin') const SizedBox(height: 24),

                  // Reset Button
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {
                      _showResetDialog(context, userId);
                    },
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset ke Default'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pengaturan ini hanya berlaku untuk notifikasi in-app. Push notifications dapat diatur dari pengaturan sistem.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Pengaturan'),
        content: const Text(
          'Apakah Anda yakin ingin mereset semua pengaturan notifikasi ke default?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<NotificationPreferencesBloc>()
                  .add(ResetNotificationPreferences(userId));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Preference Card Widget
class _PreferenceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: iconColor,
      ),
    );
  }
}
