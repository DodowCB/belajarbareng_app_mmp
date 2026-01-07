import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/providers/connectivity_provider.dart';

class SemuaJadwalScreen extends ConsumerWidget {
  const SemuaJadwalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final siswaId = userProvider.userId ?? '';
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Jadwal Pelajaran'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('siswa_kelas')
            .where('siswa_id', isEqualTo: siswaId)
            .snapshots(),
        builder: (context, siswaKelasSnapshot) {
          if (siswaKelasSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryPurple),
            );
          }

          if (siswaKelasSnapshot.hasError ||
              !siswaKelasSnapshot.hasData ||
              siswaKelasSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada jadwal',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final kelasId = siswaKelasSnapshot.data!.docs.first.get('kelas_id');

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('kelas_ngajar')
                .where('id_kelas', isEqualTo: kelasId)
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

              if (kelasNgajarSnapshot.hasError ||
                  !kelasNgajarSnapshot.hasData ||
                  kelasNgajarSnapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada jadwal pelajaran',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              final kelasNgajarList = kelasNgajarSnapshot.data!.docs;

              // Fetch kelas details untuk nama_kelas dan nama_guru
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('kelas')
                    .doc(kelasId)
                    .get(),
                builder: (context, kelasSnapshot) {
                  String namaKelas = '';
                  String namaGuruKelas = '';
                  if (kelasSnapshot.hasData && kelasSnapshot.data!.exists) {
                    final kelasData =
                        kelasSnapshot.data!.data() as Map<String, dynamic>?;
                    namaKelas =
                        kelasData?['nama_kelas'] ??
                        kelasData?['namaKelas'] ??
                        kelasData?['nomor_kelas'] ??
                        kelasData?['nomorKelas'] ??
                        '';
                    namaGuruKelas =
                        kelasData?['nama_guru'] ??
                        kelasData?['namaGuru'] ??
                        kelasData?['wali_kelas'] ??
                        kelasData?['waliKelas'] ??
                        '';
                    print('DEBUG Kelas Data: $kelasData');
                    print(
                      'DEBUG namaKelas: $namaKelas, namaGuruKelas: $namaGuruKelas',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: kelasNgajarList.length,
                    itemBuilder: (context, index) {
                      final kelasNgajarData =
                          kelasNgajarList[index].data() as Map<String, dynamic>;
                      final mapelId = kelasNgajarData['id_mapel'] ?? '';
                      final jam = kelasNgajarData['jam'] ?? '';

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('mapel')
                            .doc(mapelId)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                            );
                          }

                          final mapelData =
                              snapshot.data!.data() as Map<String, dynamic>?;

                          final namaMapel =
                              mapelData?['namaMapel'] ?? 'Mata Pelajaran';

                          return _buildJadwalCard(
                            jam: jam,
                            mataPelajaran: namaMapel,
                            guru: namaGuruKelas,
                            nomorKelas: namaKelas,
                            isDark: isDark,
                          );
                        },
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

  Widget _buildJadwalCard({
    required String jam,
    required String mataPelajaran,
    required String guru,
    required String nomorKelas,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Jam
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jam.isNotEmpty ? jam : '-',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Mata Pelajaran dan Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mataPelajaran,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          guru,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (nomorKelas.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.class_, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Kelas $nomorKelas',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
