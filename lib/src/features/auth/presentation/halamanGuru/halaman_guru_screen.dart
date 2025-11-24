import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../profile_menu/profile_menu_widget.dart';
import '../../data/models/pengumuman_model.dart';
import 'blocs/blocs.dart';

class HalamanGuruScreen extends StatefulWidget {
  const HalamanGuruScreen({super.key});

  @override
  State<HalamanGuruScreen> createState() => _HalamanGuruScreenState();
}

class _HalamanGuruScreenState extends State<HalamanGuruScreen> {
  bool _statsLoaded = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GuruProfileBloc>(
          create: (context) => GuruProfileBloc()..add(const LoadGuruProfile()),
        ),
        BlocProvider<GuruStatsBloc>(create: (context) => GuruStatsBloc()),
        BlocProvider<AnnouncementsBloc>(
          create: (context) =>
              AnnouncementsBloc()..add(const LoadAnnouncements()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocListener<GuruProfileBloc, GuruProfileState>(
          listener: (context, profileState) {
            if (profileState is GuruProfileLoaded && !_statsLoaded) {
              // Load stats only once when we have the guru ID
              context.read<GuruStatsBloc>().add(
                LoadGuruStats(profileState.guruId),
              );
              _statsLoaded = true;
            }
          },
          child: Row(
            children: [
              // Sidebar
              _buildSidebar(context),
              // Main Content
              Expanded(child: _buildMainContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          // Header with logo and title
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    Column(
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
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Navigation Menu
          Expanded(
            child: ListView(
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isActive: true,
                ),
                _buildSidebarItem(icon: Icons.star, title: 'Nilai Siswa'),
                _buildSidebarItem(icon: Icons.assignment, title: 'Tugas'),
                _buildSidebarItem(
                  icon: Icons.book,
                  title: 'Materi Pembelajaran',
                ),
                _buildSidebarItem(icon: Icons.settings, title: 'Pengaturan'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryPurple.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppTheme.primaryPurple : Colors.grey[600],
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? AppTheme.primaryPurple : Colors.grey[800],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        dense: true,
        onTap: () {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(context),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),
                  _buildStatsCards(),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildImportantNotifications()),
                      const SizedBox(width: 24),
                      Expanded(flex: 3, child: _buildUpcomingTasks()),
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
    return BlocBuilder<GuruProfileBloc, GuruProfileState>(
      builder: (context, state) {
        String userName = 'Guru';
        String userEmail = 'email@example.com';

        if (state is GuruProfileLoaded) {
          userName = state.guruData['nama_lengkap'] ?? 'Guru';
          userEmail = state.guruData['email'] ?? 'email@example.com';
        }

        return Row(
          children: [
            Text(
              'Dashboard',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            ProfileDropdownMenu(userName: userName, userEmail: userEmail),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return BlocBuilder<GuruProfileBloc, GuruProfileState>(
      builder: (context, state) {
        String guruName = 'Guru';

        if (state is GuruProfileLoaded) {
          guruName = state.guruData['nama_lengkap'] ?? 'Guru';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang, $guruName!',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Berikut adalah ringkasan aktivitas Anda hari ini.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildActionButton('Input Nilai Baru', Colors.blue, Icons.add),
                const SizedBox(width: 12),
                _buildActionButton(
                  'Buat Tugas Baru',
                  Colors.grey[300]!,
                  Icons.assignment_add,
                  textColor: Colors.grey[700]!,
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  'Unggah Materi Baru',
                  Colors.grey[300]!,
                  Icons.upload_file,
                  textColor: Colors.grey[700]!,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(
    String title,
    Color backgroundColor,
    IconData icon, {
    Color textColor = Colors.white,
  }) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16, color: textColor),
      label: Text(title, style: TextStyle(color: textColor, fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildStatsCards() {
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
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is GuruStatsError) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error loading stats: ${state.message}',
                    style: TextStyle(color: Colors.red[800]),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final profileState = context.read<GuruProfileBloc>().state;
                    if (profileState is GuruProfileLoaded) {
                      context.read<GuruStatsBloc>().add(
                        LoadGuruStats(profileState.guruId),
                      );
                    }
                  },
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
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Kelas',
                    value: totalClasses.toString(),
                    icon: Icons.class_,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Siswa',
                    value: totalStudents.toString(),
                    icon: Icons.people,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: 'Tugas Perlu Dinilai',
                    value: tugasPerluDinilai.toString(),
                    icon: Icons.assignment_turned_in,
                    color: Colors.orange,
                  ),
                ),
              ],
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
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNotifications() {
    return BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
      builder: (context, state) {
        List<PengumumanModel> announcements = [];

        if (state is AnnouncementsLoaded) {
          announcements = state.selectedAnnouncements;
        } else if (state is AnnouncementsLoading) {
          return Container(
            padding: const EdgeInsets.all(20),
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
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is AnnouncementsError) {
          return Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              children: [
                Icon(Icons.error, color: Colors.red[600], size: 48),
                const SizedBox(height: 12),
                Text(
                  'Error loading announcements',
                  style: TextStyle(
                    color: Colors.red[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(color: Colors.red[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AnnouncementsBloc>().add(
                      const LoadAnnouncements(),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pemberitahuan Penting',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingTasks() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Tugas Mendatang',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          // Header table
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Nama Tugas',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Kelas',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tanggal Tenggat',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
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
          ),
          _buildTaskItem('Ujian Praktik Biologi', '12 IPA 1', '30 Nov 2023'),
          _buildTaskItem('Esai Sastra Indonesia', '10 IPS 3', '02 Des 2023'),
          _buildTaskItem('Laporan Kimia', '11 IPA 1', '05 Des 2023'),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String taskName, String className, String dueDate) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              taskName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              className,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(dueDate, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
