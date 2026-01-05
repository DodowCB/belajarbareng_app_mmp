import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import 'input_nilai_siswa_screen.dart';
import '../../widgets/guru_app_scaffold.dart';

class KelasNilaiListScreen extends StatefulWidget {
  const KelasNilaiListScreen({super.key});

  @override
  State<KelasNilaiListScreen> createState() => _KelasNilaiListScreenState();
}

class _KelasNilaiListScreenState extends State<KelasNilaiListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _kelasList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKelas();
  }

  Future<void> _loadKelas() async {
    setState(() => _isLoading = true);

    try {
      final guruId = userProvider.userId ?? '';

      // Get kelas ngajar
      final kelasNgajarSnapshot = await _firestore
          .collection('kelas_ngajar')
          .where('id_guru', isEqualTo: guruId)
          .get();

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

          // Skip if kelas status is not true
          if (kelasData?['status'] != true) continue;

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

          // Count nilai yang sudah diinput
          final nilaiSnapshot = await _firestore
              .collection('nilai_siswa')
              .where('id_kelas', isEqualTo: kelasId)
              .where('id_guru', isEqualTo: guruId)
              .get();

          kelasList.add({
            'kelasId': kelasId,
            'namaKelas': kelasData?['nama_kelas'] ?? 'Kelas $kelasId',
            'namaMapel': mapelData?['namaMapel'] ?? 'Mata Pelajaran',
            'jumlahSiswa': siswaKelasSnapshot.docs.length,
            'jumlahNilai': nilaiSnapshot.docs.length,
          });
        }
      }

      setState(() {
        _kelasList = kelasList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GuruAppScaffold(
      title: 'Input Nilai Siswa',
      icon: Icons.grade,
      currentRoute: '/nilai-siswa',
      additionalActions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadKelas,
          tooltip: 'Refresh',
        ),
      ],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kelasList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.class_, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada kelas yang diajar',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hubungi admin untuk menambahkan jadwal mengajar',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Header info
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.grade,
                              color: AppTheme.primaryPurple,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Kelas: ${_kelasList.length}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Pilih kelas untuk input atau edit nilai',
                                  style: TextStyle(
                                    fontSize: 13,
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
                    const Divider(height: 1),

                    // List kelas
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _kelasList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final kelas = _kelasList[index];
                          return _buildKelasCard(kelas);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildKelasCard(Map<String, dynamic> kelas) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final jumlahSiswa = kelas['jumlahSiswa'] as int;
    final jumlahNilai = kelas['jumlahNilai'] as int;
    final isComplete = jumlahSiswa > 0 && jumlahNilai == jumlahSiswa;
    final progress = jumlahSiswa > 0 ? jumlahNilai / jumlahSiswa : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputNilaiSiswaScreen(kelas: kelas),
            ),
          ).then((_) => _loadKelas()); // Refresh after returning
        },
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
                      color: isComplete
                          ? Colors.green.withOpacity(0.1)
                          : AppTheme.accentOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isComplete ? Icons.check_circle : Icons.school,
                      color: isComplete ? Colors.green : AppTheme.accentOrange,
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
                  Icon(
                    Icons.arrow_forward_ios,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      Icons.people,
                      'Jumlah Siswa',
                      jumlahSiswa.toString(),
                      AppTheme.secondaryTeal,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildStatItem(
                      Icons.done_all,
                      'Nilai Terinput',
                      jumlahNilai.toString(),
                      isComplete ? Colors.green : AppTheme.accentOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isComplete
                              ? Colors.green
                              : AppTheme.accentOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: isDark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isComplete ? Colors.green : AppTheme.accentOrange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isComplete
                      ? Colors.green.withOpacity(0.1)
                      : AppTheme.accentOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isComplete
                        ? Colors.green.withOpacity(0.3)
                        : AppTheme.accentOrange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isComplete ? Icons.check_circle : Icons.pending,
                      size: 16,
                      color: isComplete ? Colors.green : AppTheme.accentOrange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isComplete ? 'Nilai Lengkap' : 'Perlu Dilengkapi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isComplete
                            ? Colors.green
                            : AppTheme.accentOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
