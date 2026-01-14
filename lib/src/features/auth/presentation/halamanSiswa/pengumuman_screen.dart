import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../widgets/siswa_app_scaffold.dart';

class PengumumanScreen extends ConsumerWidget {
  const PengumumanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SiswaAppScaffold(
      title: 'Pengumuman',
      icon: Icons.campaign,
      currentRoute: '/pengumuman-siswa',
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pengumuman')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryPurple),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada pengumuman',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final pengumumanList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pengumumanList.length,
            itemBuilder: (context, index) {
              final data = pengumumanList[index].data() as Map<String, dynamic>;
              final judul = data['judul'] ?? 'Pengumuman';
              final konten = data['deskripsi'] ?? '';
              final kategori = data['kategori'] ?? 'Umum';
              final createdAt = data['createdAt'] as Timestamp?;

              return _buildPengumumanCard(
                judul: judul,
                konten: konten,
                kategori: kategori,
                createdAt: createdAt,
                isDark: isDark,
                onTap: () => _showPengumumanDetail(
                  context,
                  judul,
                  konten,
                  kategori,
                  createdAt,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPengumumanCard({
    required String judul,
    required String konten,
    required String kategori,
    required Timestamp? createdAt,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    Color getCategoryColor(String category) {
      switch (category.toLowerCase()) {
        case 'penting':
          return Colors.red;
        case 'akademik':
          return AppTheme.primaryPurple;
        case 'kegiatan':
          return AppTheme.secondaryTeal;
        case 'informasi':
          return AppTheme.accentGreen;
        default:
          return Colors.orange;
      }
    }

    IconData getCategoryIcon(String category) {
      switch (category.toLowerCase()) {
        case 'penting':
          return Icons.priority_high;
        case 'akademik':
          return Icons.school;
        case 'kegiatan':
          return Icons.event;
        case 'informasi':
          return Icons.info;
        default:
          return Icons.campaign;
      }
    }

    String formatDate(Timestamp? timestamp) {
      if (timestamp == null) return '';
      final date = timestamp.toDate();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} menit yang lalu';
        }
        return '${difference.inHours} jam yang lalu';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} hari yang lalu';
      }
      final monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
    }

    final categoryColor = getCategoryColor(kategori);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border(left: BorderSide(color: categoryColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getCategoryIcon(kategori),
                            size: 14,
                            color: categoryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            kategori,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: categoryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatDate(createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  judul,
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
                  konten,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Baca selengkapnya',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppTheme.primaryPurple,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPengumumanDetail(
    BuildContext context,
    String judul,
    String konten,
    String kategori,
    Timestamp? createdAt,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color getCategoryColor(String category) {
      switch (category.toLowerCase()) {
        case 'penting':
          return Colors.red;
        case 'akademik':
          return AppTheme.primaryPurple;
        case 'kegiatan':
          return AppTheme.secondaryTeal;
        case 'informasi':
          return AppTheme.accentGreen;
        default:
          return Colors.orange;
      }
    }

    String formatFullDate(Timestamp? timestamp) {
      if (timestamp == null) return '';
      final date = timestamp.toDate();
      final dayNames = [
        'Minggu',
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
      ];
      final monthNames = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      final dayName = dayNames[date.weekday % 7];
      final monthName = monthNames[date.month - 1];
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$dayName, ${date.day} $monthName ${date.year} $hour:$minute';
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: getCategoryColor(kategori),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        judul,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: getCategoryColor(
                                kategori,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              kategori,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: getCategoryColor(kategori),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatFullDate(createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),
                      Text(
                        konten,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: isDark ? Colors.grey[300] : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
