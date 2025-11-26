import 'package:flutter/material.dart';
import '../../../../core/config/theme.dart';
import '../widgets/siswa_app_scaffold.dart';

class TugasSiswaScreen extends StatefulWidget {
  const TugasSiswaScreen({super.key});

  @override
  State<TugasSiswaScreen> createState() => _TugasSiswaScreenState();
}

class _TugasSiswaScreenState extends State<TugasSiswaScreen> {
  String _selectedFilter = 'Semua';

  final List<Map<String, dynamic>> _dummyTugas = [
    {
      'id': '1',
      'judul': 'Tugas Matematika: Integral',
      'mataPelajaran': 'Matematika',
      'deskripsi': 'Kerjakan soal integral halaman 45-48',
      'deadline': '2024-12-01',
      'status': 'Belum Dikerjakan',
      'guru': 'Bu Sarah',
      'color': AppTheme.primaryPurple,
    },
    {
      'id': '2',
      'judul': 'Esai Bahasa Indonesia',
      'mataPelajaran': 'Bahasa Indonesia',
      'deskripsi': 'Buat esai tentang teknologi minimal 500 kata',
      'deadline': '2024-11-28',
      'status': 'Sedang Dikerjakan',
      'guru': 'Pak Budi',
      'color': AppTheme.secondaryTeal,
    },
    {
      'id': '3',
      'judul': 'Praktikum Fisika',
      'mataPelajaran': 'Fisika',
      'deskripsi': 'Laporan praktikum gelombang bunyi',
      'deadline': '2024-11-25',
      'status': 'Sudah Dikumpulkan',
      'guru': 'Bu Ani',
      'nilai': 85,
      'color': AppTheme.accentGreen,
    },
    {
      'id': '4',
      'judul': 'Tugas Kimia: Larutan',
      'mataPelajaran': 'Kimia',
      'deskripsi': 'Jawab pertanyaan tentang larutan asam-basa',
      'deadline': '2024-11-30',
      'status': 'Belum Dikerjakan',
      'guru': 'Pak Andi',
      'color': AppTheme.accentOrange,
    },
  ];

  List<Map<String, dynamic>> get _filteredTugas {
    if (_selectedFilter == 'Semua') return _dummyTugas;
    return _dummyTugas.where((t) => t['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SiswaAppScaffold(
      title: 'Tugas Saya',
      icon: Icons.assignment,
      currentRoute: '/tugas-siswa',
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Belum Dikerjakan'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Sedang Dikerjakan'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Sudah Dikumpulkan'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredTugas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada tugas',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 1024;
                      final isTablet = constraints.maxWidth >= 768;
                      
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: isDesktop ? 1.2 : (isTablet ? 1.1 : 1.3),
                        ),
                        itemCount: _filteredTugas.length,
                        itemBuilder: (context, index) {
                          return _buildTugasCard(_filteredTugas[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: Colors.transparent,
      selectedColor: AppTheme.primaryPurple.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryPurple,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryPurple : null,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildTugasCard(Map<String, dynamic> tugas) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = tugas['status'] as String;
    final color = tugas['color'] as Color;
    
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'Belum Dikerjakan':
        statusColor = AppTheme.accentOrange;
        statusIcon = Icons.pending;
        break;
      case 'Sedang Dikerjakan':
        statusColor = AppTheme.secondaryTeal;
        statusIcon = Icons.edit;
        break;
      case 'Sudah Dikumpulkan':
        statusColor = AppTheme.accentGreen;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _showTugasDetail(tugas),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.assignment, color: color, size: 24),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  tugas['judul'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  tugas['deskripsi'],
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tugas['guru'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tugas['deadline'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (tugas['nilai'] != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppTheme.accentGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Nilai: ${tugas['nilai']}',
                          style: const TextStyle(
                            color: AppTheme.accentGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTugasDetail(Map<String, dynamic> tugas) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (tugas['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: tugas['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tugas['mataPelajaran'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          tugas['judul'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _buildDetailRow('Guru', tugas['guru']),
              _buildDetailRow('Deadline', tugas['deadline']),
              _buildDetailRow('Status', tugas['status']),
              if (tugas['nilai'] != null)
                _buildDetailRow('Nilai', tugas['nilai'].toString()),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tugas['deskripsi'],
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              if (tugas['status'] != 'Sudah Dikumpulkan')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showUploadDialog(tugas);
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Kumpulkan Tugas'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog(Map<String, dynamic> tugas) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Kumpulkan Tugas'),
        content: const Text(
          'Apakah Anda yakin ingin mengumpulkan tugas ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tugas berhasil dikumpulkan!'),
                  backgroundColor: AppTheme.accentGreen,
                ),
              );
              setState(() {
                tugas['status'] = 'Sudah Dikumpulkan';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
            ),
            child: const Text('Kumpulkan'),
          ),
        ],
      ),
    );
  }
}
