import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/user_provider.dart';
import 'detail_tugas_kelas_screen.dart';

class TugasSiswaScreen extends StatefulWidget {
  const TugasSiswaScreen({super.key});

  @override
  State<TugasSiswaScreen> createState() => _TugasSiswaScreenState();
}

class _TugasSiswaScreenState extends State<TugasSiswaScreen> {
  Color _getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'sudah dikumpulkan':
        return AppTheme.accentGreen;
      case 'terlambat':
        return Colors.red;
      default:
        return AppTheme.accentOrange;
    }
  }

  String _getStatusFromDeadline(Timestamp deadline, String? submissionId) {
    if (submissionId != null) return 'Sudah Dikumpulkan';

    final now = DateTime.now();
    final deadlineDate = deadline.toDate();

    if (now.isAfter(deadlineDate)) {
      return 'Terlambat';
    }
    return 'Belum Dikumpulkan';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final siswaId = userProvider.userId;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(title: const Text('Tugas Saya'), elevation: 0),
      body: siswaId == null
          ? const Center(child: Text('User ID tidak ditemukan'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('siswa_kelas')
                  .where('siswa_id', isEqualTo: siswaId)
                  .snapshots(),
              builder: (context, siswaKelasSnapshot) {
                if (siswaKelasSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryPurple,
                    ),
                  );
                }

                if (siswaKelasSnapshot.hasError ||
                    !siswaKelasSnapshot.hasData ||
                    siswaKelasSnapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada kelas',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final siswaKelasDocs = siswaKelasSnapshot.data!.docs;
                final kelasIds = siswaKelasDocs
                    .map((doc) => doc['kelas_id'] as String?)
                    .where((id) => id != null)
                    .toList();

                if (kelasIds.isEmpty) {
                  return const Center(child: Text('Tidak ada kelas'));
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchKelasData(kelasIds),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryPurple,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada data kelas'));
                    }

                    final kelasList = snapshot.data!;

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: kelasList.length,
                      itemBuilder: (context, index) {
                        final kelas = kelasList[index];
                        return _buildKelasCard(
                          context: context,
                          kelas: kelas,
                          isDark: isDark,
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchKelasData(
    List<String?> kelasIds,
  ) async {
    final kelasList = <Map<String, dynamic>>[];
    final colors = [
      AppTheme.primaryPurple,
      AppTheme.secondaryTeal,
      AppTheme.accentOrange,
      AppTheme.accentGreen,
      Colors.blue,
      Colors.pink,
    ];

    for (var i = 0; i < kelasIds.length; i++) {
      final kelasId = kelasIds[i];
      if (kelasId == null) continue;

      try {
        // Fetch kelas data
        final kelasDoc = await FirebaseFirestore.instance
            .collection('kelas')
            .doc(kelasId)
            .get();

        if (!kelasDoc.exists) continue;

        final kelasData = kelasDoc.data() as Map<String, dynamic>;
        final namaKelas = kelasData['nama_kelas'] ?? 'Kelas';
        final namaGuru = kelasData['nama_guru'] ?? 'Guru';

        // Count pending tugas
        final tugasQuery = await FirebaseFirestore.instance
            .collection('tugas')
            .where('id_kelas', isEqualTo: kelasId)
            .get();

        final totalTugas = tugasQuery.docs.length;

        kelasList.add({
          'kelasId': kelasId,
          'namaKelas': namaKelas,
          'namaGuru': namaGuru,
          'totalTugas': totalTugas,
          'color': colors[i % colors.length],
        });
      } catch (e) {
        debugPrint('Error fetching kelas $kelasId: $e');
      }
    }

    return kelasList;
  }

  Widget _buildKelasCard({
    required BuildContext context,
    required Map<String, dynamic> kelas,
    required bool isDark,
  }) {
    final color = kelas['color'] as Color;
    final namaKelas = kelas['namaKelas'];
    final namaGuru = kelas['namaGuru'];
    final totalTugas = kelas['totalTugas'];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTugasKelasScreen(
                kelasId: kelas['kelasId'],
                namaKelas: namaKelas,
                namaGuru: namaGuru,
                color: color,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.assignment, color: color, size: 28),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaKelas,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            namaGuru,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$totalTugas Tugas',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
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
}
