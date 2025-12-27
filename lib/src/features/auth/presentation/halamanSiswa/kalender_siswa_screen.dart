import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/user_provider.dart';

class KalenderSiswaScreen extends StatelessWidget {
  const KalenderSiswaScreen({super.key});

  Color _getColorForIndex(int index) {
    final colors = [
      AppTheme.primaryPurple,
      AppTheme.secondaryTeal,
      AppTheme.accentGreen,
      AppTheme.accentOrange,
      AppTheme.accentPink,
    ];
    return colors[index % colors.length];
  }

  IconData _getIconForMapel(String namaMapel) {
    final lower = namaMapel.toLowerCase();
    if (lower.contains('matematika')) return Icons.calculate;
    if (lower.contains('fisika')) return Icons.science;
    if (lower.contains('kimia')) return Icons.biotech;
    if (lower.contains('biologi')) return Icons.nature;
    if (lower.contains('indonesia')) return Icons.menu_book;
    if (lower.contains('inggris')) return Icons.language;
    if (lower.contains('sejarah')) return Icons.history_edu;
    if (lower.contains('geografi')) return Icons.public;
    if (lower.contains('ekonomi')) return Icons.account_balance;
    if (lower.contains('seni')) return Icons.palette;
    if (lower.contains('olahraga') || lower.contains('penjaskes')) {
      return Icons.sports_soccer;
    }
    return Icons.school;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final siswaId = userProvider.userId;

    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Kelas'), elevation: 0),
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

                if (siswaKelasSnapshot.hasError) {
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
                          'Terjadi kesalahan',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!siswaKelasSnapshot.hasData ||
                    siswaKelasSnapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada jadwal kelas',
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

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('kelas_ngajar')
                      .where(FieldPath.documentId, whereIn: kelasIds)
                      .snapshots(),
                  builder: (context, kelasNgajarSnapshot) {
                    if (kelasNgajarSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryPurple,
                        ),
                      );
                    }

                    if (!kelasNgajarSnapshot.hasData ||
                        kelasNgajarSnapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada jadwal kelas'),
                      );
                    }

                    final kelasNgajarDocs = kelasNgajarSnapshot.data!.docs;

                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchJadwalData(kelasNgajarDocs),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryPurple,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Tidak ada jadwal'));
                        }

                        final jadwalList = snapshot.data!;
                        // Group by hari
                        final groupedJadwal =
                            <String, List<Map<String, dynamic>>>{};
                        for (var jadwal in jadwalList) {
                          final hari = jadwal['hari'] as String? ?? 'Unknown';
                          if (!groupedJadwal.containsKey(hari)) {
                            groupedJadwal[hari] = [];
                          }
                          groupedJadwal[hari]!.add(jadwal);
                        }

                        final hariOrder = [
                          'Senin',
                          'Selasa',
                          'Rabu',
                          'Kamis',
                          'Jumat',
                          'Sabtu',
                        ];
                        final sortedHari = hariOrder
                            .where((h) => groupedJadwal.containsKey(h))
                            .toList();

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: sortedHari.length,
                          itemBuilder: (context, index) {
                            final hari = sortedHari[index];
                            final jadwalHari = groupedJadwal[hari]!;

                            // Sort by jam
                            jadwalHari.sort((a, b) {
                              final jamA = a['jam'] as String? ?? '';
                              final jamB = b['jam'] as String? ?? '';
                              return jamA.compareTo(jamB);
                            });

                            return _buildHariSection(
                              hari: hari,
                              jadwalList: jadwalHari,
                              isDark: isDark,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchJadwalData(
    List<QueryDocumentSnapshot> kelasNgajarDocs,
  ) async {
    final jadwalList = <Map<String, dynamic>>[];

    for (int i = 0; i < kelasNgajarDocs.length; i++) {
      final kelasNgajarDoc = kelasNgajarDocs[i];
      final kelasNgajarData = kelasNgajarDoc.data() as Map<String, dynamic>;

      // Ambil id_mapel dan id_kelas untuk query ke collection masing-masing
      final idMapel = kelasNgajarData['id_mapel'];
      final idKelas = kelasNgajarData['id_kelas'];

      // Convert ke string untuk document ID
      final mapelId = idMapel?.toString();
      final kelasId = idKelas?.toString();

      final jam = kelasNgajarData['jam'] as String?;
      final hari = kelasNgajarData['hari'] as String?;

      String namaMapel = 'Mata Pelajaran';
      String namaGuru = 'Guru';
      String namaKelas = 'Kelas';

      // Query ke collection mapel
      if (mapelId != null && mapelId.isNotEmpty) {
        try {
          final mapelDoc = await FirebaseFirestore.instance
              .collection('mapel')
              .doc(mapelId)
              .get();
          if (mapelDoc.exists) {
            final mapelData = mapelDoc.data();
            namaMapel =
                mapelData?['namaMapel'] ??
                mapelData?['nama_mapel'] ??
                'Mata Pelajaran';
          }
        } catch (e) {
          // Skip if error
        }
      }

      // Query ke collection kelas untuk ambil nama_guru dan nama_kelas
      if (kelasId != null && kelasId.isNotEmpty) {
        try {
          final kelasDoc = await FirebaseFirestore.instance
              .collection('kelas')
              .doc(kelasId)
              .get();
          if (kelasDoc.exists) {
            final kelasData = kelasDoc.data();
            namaGuru = kelasData?['nama_guru'] ?? 'Guru';
            namaKelas =
                kelasData?['nama_kelas'] ??
                kelasData?['nomor_kelas'] ??
                'Kelas';
          }
        } catch (e) {
          // Skip if error
        }
      }

      jadwalList.add({
        'namaMapel': namaMapel,
        'namaGuru': namaGuru,
        'nomorKelas': namaKelas,
        'jam': jam ?? '-',
        'hari': hari ?? 'Unknown',
        'index': i,
      });
    }

    return jadwalList;
  }

  Widget _buildHariSection({
    required String hari,
    required List<Map<String, dynamic>> jadwalList,
    required bool isDark,
  }) {
    Color getHariColor(String hari) {
      switch (hari) {
        case 'Senin':
          return AppTheme.primaryPurple;
        case 'Selasa':
          return AppTheme.secondaryTeal;
        case 'Rabu':
          return AppTheme.accentGreen;
        case 'Kamis':
          return AppTheme.accentOrange;
        case 'Jumat':
          return AppTheme.accentPink;
        case 'Sabtu':
          return Colors.indigo;
        default:
          return Colors.grey;
      }
    }

    final hariColor = getHariColor(hari);

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header hari
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [hariColor, hariColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  hari,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${jadwalList.length} Pelajaran',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List jadwal
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: jadwalList.length,
            separatorBuilder: (context, index) => const Divider(height: 8),
            itemBuilder: (context, index) {
              final jadwal = jadwalList[index];
              return _buildJadwalItem(
                namaMapel: jadwal['namaMapel'] ?? 'Mata Pelajaran',
                namaGuru: jadwal['namaGuru'] ?? 'Guru',
                nomorKelas: jadwal['nomorKelas'] ?? 'Kelas',
                jam: jadwal['jam'] ?? '-',
                index: jadwal['index'] ?? 0,
                isDark: isDark,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalItem({
    required String namaMapel,
    required String namaGuru,
    required String nomorKelas,
    required String jam,
    required int index,
    required bool isDark,
  }) {
    final color = _getColorForIndex(index);
    final icon = _getIconForMapel(namaMapel);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          // Icon dan jam
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      jam,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          // Info pelajaran
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaMapel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        namaGuru,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.class_, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      nomorKelas,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
