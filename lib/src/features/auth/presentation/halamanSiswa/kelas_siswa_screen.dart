import 'package:flutter/material.dart';
import '../../../../core/config/theme.dart';
import '../widgets/siswa_app_scaffold.dart';

class KelasSiswaScreen extends StatefulWidget {
  const KelasSiswaScreen({super.key});

  @override
  State<KelasSiswaScreen> createState() => _KelasSiswaScreenState();
}

class _KelasSiswaScreenState extends State<KelasSiswaScreen> {
  final List<Map<String, dynamic>> _dummyKelas = [
    {
      'id': '1',
      'nama': 'Matematika XII IPA 1',
      'guru': 'Bu Sarah',
      'jumlahSiswa': 32,
      'jadwal': 'Senin, Rabu, Jumat - 07:30',
      'ruangan': 'Lab. Komputer 1',
      'color': AppTheme.primaryPurple,
      'daftarSiswa': [
        {'nama': 'Ahmad Zulfikar', 'nis': '12001'},
        {'nama': 'Budi Santoso', 'nis': '12002'},
        {'nama': 'Citra Dewi', 'nis': '12003'},
        {'nama': 'Dian Pratiwi', 'nis': '12004'},
        {'nama': 'Eko Prasetyo', 'nis': '12005'},
      ],
    },
    {
      'id': '2',
      'nama': 'Fisika XII IPA 1',
      'guru': 'Bu Ani',
      'jumlahSiswa': 32,
      'jadwal': 'Selasa, Kamis - 09:00',
      'ruangan': 'Lab. Fisika',
      'color': AppTheme.secondaryTeal,
      'daftarSiswa': [
        {'nama': 'Ahmad Zulfikar', 'nis': '12001'},
        {'nama': 'Budi Santoso', 'nis': '12002'},
        {'nama': 'Citra Dewi', 'nis': '12003'},
      ],
    },
    {
      'id': '3',
      'nama': 'Bahasa Indonesia XII IPA 1',
      'guru': 'Pak Budi',
      'jumlahSiswa': 32,
      'jadwal': 'Rabu - 10:30',
      'ruangan': 'Ruang 201',
      'color': AppTheme.accentGreen,
      'daftarSiswa': [
        {'nama': 'Ahmad Zulfikar', 'nis': '12001'},
        {'nama': 'Budi Santoso', 'nis': '12002'},
      ],
    },
    {
      'id': '4',
      'nama': 'Kimia XII IPA 1',
      'guru': 'Pak Andi',
      'jumlahSiswa': 32,
      'jadwal': 'Kamis - 13:00',
      'ruangan': 'Lab. Kimia',
      'color': AppTheme.accentOrange,
      'daftarSiswa': [
        {'nama': 'Ahmad Zulfikar', 'nis': '12001'},
        {'nama': 'Budi Santoso', 'nis': '12002'},
        {'nama': 'Citra Dewi', 'nis': '12003'},
        {'nama': 'Dian Pratiwi', 'nis': '12004'},
      ],
    },
    {
      'id': '5',
      'nama': 'Bahasa Inggris XII IPA 1',
      'guru': 'Mrs. Linda',
      'jumlahSiswa': 32,
      'jadwal': 'Jumat - 08:00',
      'ruangan': 'Ruang 305',
      'color': AppTheme.accentPink,
      'daftarSiswa': [
        {'nama': 'Ahmad Zulfikar', 'nis': '12001'},
        {'nama': 'Budi Santoso', 'nis': '12002'},
        {'nama': 'Citra Dewi', 'nis': '12003'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SiswaAppScaffold(
      title: 'Kelas Saya',
      icon: Icons.class_,
      currentRoute: '/kelas-siswa',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Kelas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_dummyKelas.length} Kelas',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1024;
                final isTablet = constraints.maxWidth >= 768;
                
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isDesktop ? 1.3 : (isTablet ? 1.2 : 1.4),
                  ),
                  itemCount: _dummyKelas.length,
                  itemBuilder: (context, index) {
                    return _buildKelasCard(_dummyKelas[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKelasCard(Map<String, dynamic> kelas) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = kelas['color'] as Color;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _showKelasDetail(kelas),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.class_, color: color, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kelas['nama'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              kelas['guru'],
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${kelas['jumlahSiswa']} Siswa',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              kelas['jadwal'],
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.room,
                            size: 16,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            kelas['ruangan'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
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

  void _showKelasDetail(Map<String, dynamic> kelas) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = kelas['color'] as Color;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.class_, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kelas['nama'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kelas ${kelas['id']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
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
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Kelas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.person, 'Guru Pengajar', kelas['guru']),
                      _buildInfoRow(Icons.people, 'Jumlah Siswa', '${kelas['jumlahSiswa']} siswa'),
                      _buildInfoRow(Icons.schedule, 'Jadwal', kelas['jadwal']),
                      _buildInfoRow(Icons.room, 'Ruangan', kelas['ruangan']),
                      const SizedBox(height: 24),
                      const Text(
                        'Daftar Anggota Kelas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (kelas['daftarSiswa'] as List).length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: isDark ? Colors.grey[800] : Colors.grey[300],
                          ),
                          itemBuilder: (context, index) {
                            final siswa = (kelas['daftarSiswa'] as List)[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: color.withOpacity(0.2),
                                child: Text(
                                  siswa['nama'][0],
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                siswa['nama'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'NIS: ${siswa['nis']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            );
                          },
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
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
}
