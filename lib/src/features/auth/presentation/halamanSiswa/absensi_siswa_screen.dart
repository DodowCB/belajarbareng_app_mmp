import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/providers/connectivity_provider.dart';
import 'detail_absensi_screen.dart';

class AbsensiSiswaScreen extends ConsumerWidget {
  const AbsensiSiswaScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final siswaId = userProvider.userId;
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi Saya'),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOnline ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOnline ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOnline ? Icons.wifi : Icons.wifi_off,
                  color: isOnline ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: isOnline ? Colors.green[700] : Colors.red[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada kelas',
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
                      return const Center(child: Text('Tidak ada kelas'));
                    }

                    final kelasNgajarDocs = kelasNgajarSnapshot.data!.docs;

                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchKelasData(kelasNgajarDocs, siswaId!),
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
                          return const Center(child: Text('Tidak ada kelas'));
                        }

                        final kelasList = snapshot.data!;

                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryPurple,
                                    AppTheme.primaryPurple.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.event_available,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Pilih Mata Pelajaran',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Lihat riwayat absensi ${kelasList.length} mata pelajaran',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
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
                                    namaMapel:
                                        kelas['namaMapel'] ?? 'Mata Pelajaran',
                                    namaGuru: kelas['namaGuru'] ?? 'Guru',
                                    kelasId: kelas['kelasId'] ?? '',
                                    totalHadir: kelas['totalHadir'] ?? 0,
                                    totalPertemuan:
                                        kelas['totalPertemuan'] ?? 0,
                                    index: index,
                                    isDark: isDark,
                                  );
                                },
                              ),
                            ),
                          ],
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
    List<QueryDocumentSnapshot> kelasNgajarDocs,
    String siswaId,
  ) async {
    final kelasList = <Map<String, dynamic>>[];

    for (var kelasNgajarDoc in kelasNgajarDocs) {
      final kelasNgajarData = kelasNgajarDoc.data() as Map<String, dynamic>;

      // Ambil id_mapel dan id_kelas untuk query ke collection masing-masing
      final idMapel = kelasNgajarData['id_mapel'];
      final idKelas = kelasNgajarData['id_kelas'];

      // Convert ke string untuk document ID
      final mapelId = idMapel?.toString();
      final kelasId = idKelas?.toString();

      String namaMapel = 'Mata Pelajaran';
      String namaGuru = 'Guru';

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
          print('Error fetching mapel: $e');
        }
      }

      // Query ke collection kelas untuk ambil nama_guru
      if (kelasId != null && kelasId.isNotEmpty) {
        try {
          final kelasDoc = await FirebaseFirestore.instance
              .collection('kelas')
              .doc(kelasId)
              .get();
          if (kelasDoc.exists) {
            final kelasData = kelasDoc.data();
            namaGuru = kelasData?['nama_guru'] ?? 'Guru';
          }
        } catch (e) {
          print('Error fetching kelas: $e');
        }
      }

      // Hitung total hadir dan total pertemuan
      int totalHadir = 0;
      int totalPertemuan = 0;

      if (kelasId != null) {
        try {
          final absensiQuery = await FirebaseFirestore.instance
              .collection('absensi')
              .where('siswa_id', isEqualTo: siswaId)
              .where('kelas_id', isEqualTo: kelasId)
              .get();

          totalPertemuan = absensiQuery.docs.length;
          totalHadir = absensiQuery.docs
              .where(
                (doc) =>
                    (doc.data()['status'] as String?)?.toLowerCase() == 'hadir',
              )
              .length;
        } catch (e) {
          // Skip if error
        }
      }

      kelasList.add({
        'namaMapel': namaMapel,
        'namaGuru': namaGuru,
        'kelasId': kelasId ?? '',
        'totalHadir': totalHadir,
        'totalPertemuan': totalPertemuan,
      });
    }

    return kelasList;
  }

  Widget _buildKelasCard({
    required BuildContext context,
    required String namaMapel,
    required String namaGuru,
    required String kelasId,
    required int totalHadir,
    required int totalPertemuan,
    required int index,
    required bool isDark,
  }) {
    final color = _getColorForIndex(index);
    final icon = _getIconForMapel(namaMapel);
    final persentase = totalPertemuan > 0
        ? ((totalHadir / totalPertemuan) * 100).toStringAsFixed(0)
        : '0';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailAbsensiScreen(
                namaMapel: namaMapel,
                namaGuru: namaGuru,
                kelasId: kelasId,
                color: color,
                icon: icon,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  namaMapel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        namaGuru,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 16, color: color),
                          const SizedBox(width: 4),
                          Text(
                            '$totalHadir/$totalPertemuan',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kehadiran $persentase%',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
