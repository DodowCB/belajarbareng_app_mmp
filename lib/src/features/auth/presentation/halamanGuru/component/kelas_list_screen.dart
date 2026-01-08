import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../widgets/guru_app_scaffold.dart';

class KelasListScreen extends StatefulWidget {
  const KelasListScreen({super.key});

  @override
  State<KelasListScreen> createState() => _KelasListScreenState();
}

class _KelasListScreenState extends State<KelasListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';

  // Helper function to get avatar color based on index
  Color _getAvatarColor(int index) {
    final colors = [
      AppTheme.primaryPurple,
      AppTheme.secondaryTeal,
      AppTheme.accentOrange,
      AppTheme.accentGreen,
      const Color(0xFF6366F1), // Indigo
      const Color(0xFFEC4899), // Pink
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFF14B8A6), // Teal-500
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF10B981), // Emerald
    ];
    return colors[index % colors.length];
  }

  Stream<List<Map<String, dynamic>>> _kelasStream() {
    final guruId = userProvider.userId ?? '';

    return _firestore
        .collection('kelas_ngajar')
        .where('id_guru', isEqualTo: guruId)
        .snapshots()
        .asyncMap((kelasNgajarSnapshot) async {
          final List<Map<String, dynamic>> kelasList = [];

          for (final doc in kelasNgajarSnapshot.docs) {
            final data = doc.data();
            final kelasId = data['id_kelas']?.toString() ?? '';
            final mapelId = data['id_mapel']?.toString() ?? '';

            // Get kelas detail
            final kelasDoc = await _firestore
                .collection('kelas')
                .doc(kelasId)
                .get();

            if (kelasDoc.exists) {
              final kelasData = kelasDoc.data();

              // Get mapel detail
              final mapelDoc = await _firestore
                  .collection('mapel')
                  .doc(mapelId)
                  .get();
              final mapelData = mapelDoc.data();

              // Get jumlah siswa
              final siswaKelasSnapshot = await _firestore
                  .collection('siswa_kelas')
                  .where('kelas_id', isEqualTo: kelasId)
                  .get();

              // Get wali kelas dari field nama_guru di collection kelas
              final waliKelasName =
                  kelasData?['nama_guru'] ?? 'Belum ada wali kelas';

              kelasList.add({
                'id': kelasId,
                'kelasId': kelasId,
                'namaKelas': kelasData?['nama_kelas'] ?? 'Kelas $kelasId',
                'namaMapel': mapelData?['namaMapel'] ?? 'Mata Pelajaran',
                'jumlahSiswa': siswaKelasSnapshot.docs.length,
                'status': kelasData?['status'] ?? false,
                'waliKelas': waliKelasName,
                'hari': data['hari'] ?? '',
                'jam': data['jam'] ?? '',
                'semester': kelasData?['semester'] ?? '',
              });
            }
          }

          return kelasList;
        });
  }

  List<Map<String, dynamic>> _filterKelasList(
    List<Map<String, dynamic>> kelasList,
  ) {
    if (_searchQuery.isEmpty) return kelasList;

    final q = _searchQuery.toLowerCase();
    return kelasList.where((kelas) {
      return '${kelas['namaKelas']} ${kelas['namaMapel']} ${kelas['waliKelas']}'
          .toLowerCase()
          .contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GuruAppScaffold(
      title: 'Daftar Kelas',
      icon: Icons.class_,
      currentRoute: '/kelas',
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari kelas, mata pelajaran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
              ),
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _kelasStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final kelasList = snapshot.data ?? [];
                final filteredList = _filterKelasList(kelasList);

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.class_, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Belum ada kelas yang diajar'
                              : 'Kelas tidak ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final kelas = filteredList[index];
                    return _buildKelasCard(kelas);
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
    final isActive = kelas['status'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () => _showKelasDetailDialog(kelas),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.secondaryTeal.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.class_,
                      color: isActive ? AppTheme.secondaryTeal : Colors.grey,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kelas['namaKelas'] ?? 'Kelas',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          kelas['namaMapel'] ?? 'Mata Pelajaran',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? Colors.green.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isActive ? 'Aktif' : 'Nonaktif',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Info Grid
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      Icons.people,
                      'Jumlah Siswa',
                      '${kelas['jumlahSiswa']} siswa',
                      AppTheme.accentGreen,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      Icons.person,
                      'Wali Kelas',
                      kelas['waliKelas'] ?? '-',
                      AppTheme.primaryPurple,
                    ),
                  ),
                ],
              ),
              if (kelas['hari'] != null &&
                  kelas['hari'].toString().isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.accentOrange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 18,
                        color: AppTheme.accentOrange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${kelas['hari']} - ${kelas['jam'] ?? ''}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentOrange,
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
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showKelasDetailDialog(Map<String, dynamic> kelas) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = kelas['status'] == true;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      color: AppTheme.secondaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.class_,
                      color: AppTheme.secondaryTeal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Detail Kelas',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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

              _buildDetailRow(
                Icons.class_,
                'Nama Kelas',
                kelas['namaKelas'] ?? '',
                isDark,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.book,
                'Mata Pelajaran',
                kelas['namaMapel'] ?? '',
                isDark,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.people,
                'Jumlah Siswa',
                '${kelas['jumlahSiswa']} siswa',
                isDark,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                Icons.person,
                'Wali Kelas',
                kelas['waliKelas'] ?? '',
                isDark,
              ),
              if (kelas['hari'] != null &&
                  kelas['hari'].toString().isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.schedule,
                  'Jadwal',
                  '${kelas['hari']} - ${kelas['jam'] ?? ''}',
                  isDark,
                ),
              ],
              if (kelas['semester'] != null &&
                  kelas['semester'].toString().isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.calendar_today,
                  'Semester',
                  kelas['semester'],
                  isDark,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.info, size: 20, color: AppTheme.secondaryTeal),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.green : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isActive ? 'Aktif' : 'Nonaktif',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.green : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 400) {
                    // Mobile: Stack buttons vertically
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showSiswaListDialog(kelas);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Lihat Daftar Siswa'),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    );
                  } else {
                    // Desktop/Tablet: Row layout
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSiswaListDialog(kelas);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryPurple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Lihat Daftar Siswa'),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.secondaryTeal),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showSiswaListDialog(Map<String, dynamic> kelas) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fetch siswa
    final siswaKelasSnapshot = await _firestore
        .collection('siswa_kelas')
        .where('kelas_id', isEqualTo: kelas['kelasId'])
        .get();

    final List<Map<String, dynamic>> siswaList = [];
    for (final doc in siswaKelasSnapshot.docs) {
      final siswaId = doc['siswa_id'];
      if (siswaId != null) {
        final siswaDoc = await _firestore
            .collection('siswa')
            .doc(siswaId)
            .get();
        if (siswaDoc.exists) {
          siswaList.add({
            'siswaId': siswaDoc.id,
            'nama': siswaDoc['nama'] ?? '',
            'nis': siswaDoc['nis'] ?? '',
          });
        }
      }
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.people,
                      color: AppTheme.accentGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daftar Siswa',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          kelas['namaKelas'] ?? '',
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
              const SizedBox(height: 20),
              
              // Summary info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryPurple.withOpacity(0.1),
                      AppTheme.secondaryTeal.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryPurple.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.groups,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Total Siswa: ${siswaList.length}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (siswaList.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada siswa di kelas ini',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Siswa akan muncul setelah ditambahkan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: siswaList.length,
                    itemBuilder: (context, index) {
                      final siswa = siswaList[index];
                      final nama = siswa['nama'] ?? '-';
                      final nis = siswa['nis'] ?? '-';
                      
                      // Get initials for avatar
                      String getInitials(String name) {
                        final words = name.trim().split(' ');
                        if (words.length >= 2) {
                          return '${words[0][0]}${words[1][0]}'.toUpperCase();
                        } else if (words.isNotEmpty && words[0].isNotEmpty) {
                          return words[0][0].toUpperCase();
                        }
                        return 'S';
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark 
                                ? Colors.grey[700]! 
                                : Colors.grey[200]!,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark 
                                  ? Colors.black26 
                                  : Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          onTap: () => _showSiswaDetailDialog(siswa['siswaId']),
                          leading: Hero(
                            tag: 'siswa_avatar_${siswa['siswaId']}',
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: _getAvatarColor(index),
                              child: Text(
                                getInitials(nama),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  nama,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDark 
                                        ? Colors.white 
                                        : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryTeal.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppTheme.secondaryTeal.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  '#${index + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.secondaryTeal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.badge_outlined,
                                  size: 16,
                                  color: isDark 
                                      ? Colors.grey[400] 
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'NIS: $nis',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark 
                                        ? Colors.grey[400] 
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }

  Future<void> _showSiswaDetailDialog(String siswaId) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fetch siswa detail
    final siswaDoc = await _firestore.collection('siswa').doc(siswaId).get();

    if (!siswaDoc.exists || !mounted) return;

    final siswaData = siswaDoc.data();
    final nama = siswaData?['nama'] ?? '-';
    final nis = siswaData?['nis'] ?? '-';
    final email = siswaData?['email'] ?? '-';
    final telepon = siswaData?['telepon'] ?? '-';
    final jenisKelamin = siswaData?['jenis_kelamin'] ?? '-';
    
    // Fix: Safe Timestamp parsing
    DateTime? tanggalLahir;
    if (siswaData?['tanggal_lahir'] != null) {
      final tanggalLahirData = siswaData!['tanggal_lahir'];
      if (tanggalLahirData is Timestamp) {
        tanggalLahir = tanggalLahirData.toDate();
      } else if (tanggalLahirData is String) {
        try {
          tanggalLahir = DateTime.parse(tanggalLahirData);
        } catch (e) {
          tanggalLahir = null;
        }
      }
    }

    // Get initials for avatar
    String getInitials(String name) {
      final words = name.trim().split(' ');
      if (words.length >= 2) {
        return '${words[0][0]}${words[1][0]}'.toUpperCase();
      } else if (words.isNotEmpty && words[0].isNotEmpty) {
        return words[0][0].toUpperCase();
      }
      return 'S';
    }

    // Format date
    String formatDate(DateTime? date) {
      if (date == null) return '-';
      final months = [
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
        'Desember'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 550, maxHeight: 700),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan avatar
                  Row(
                    children: [
                      Hero(
                        tag: 'siswa_avatar_$siswaId',
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: AppTheme.primaryPurple,
                          child: Text(
                            getInitials(nama),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryTeal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color:
                                      AppTheme.secondaryTeal.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'NIS: $nis',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.secondaryTeal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        tooltip: 'Tutup',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Informasi Pribadi
                  _buildSectionTitle(
                      Icons.person, 'Informasi Pribadi', isDark),
                  const SizedBox(height: 16),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.badge_outlined,
                      'NIS',
                      nis,
                      isDark,
                    ),
                    _buildInfoRow(
                      Icons.email_outlined,
                      'Email',
                      email,
                      isDark,
                    ),
                    _buildInfoRow(
                      Icons.phone_outlined,
                      'Telepon',
                      telepon,
                      isDark,
                    ),
                    _buildInfoRow(
                      Icons.wc_outlined,
                      'Jenis Kelamin',
                      jenisKelamin,
                      isDark,
                    ),
                    _buildInfoRow(
                      Icons.cake_outlined,
                      'Tanggal Lahir',
                      formatDate(tanggalLahir),
                      isDark,
                      isLast: true,
                    ),
                  ], isDark),

                  const SizedBox(height: 24),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryPurple,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    bool isDark, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
