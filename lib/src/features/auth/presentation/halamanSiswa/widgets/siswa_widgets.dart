import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';

class SiswaWidgets {
  // Widget untuk Kelas Semester Ini - fetch dari Firestore
  static Widget buildKelasSemesterIni({
    required BuildContext context,
    required bool isDesktop,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final siswaId = userProvider.userId ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kelas Semester Ini',
          style: TextStyle(
            fontSize: isDesktop ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('siswa_kelas')
              .where('siswa_id', isEqualTo: siswaId)
              .snapshots(),
          builder: (context, siswaKelasSnapshot) {
            if (siswaKelasSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryPurple,
                  ),
                ),
              );
            }

            if (siswaKelasSnapshot.hasError ||
                !siswaKelasSnapshot.hasData ||
                siswaKelasSnapshot.data!.docs.isEmpty) {
              return _buildEmptyState(
                'Anda belum terdaftar di kelas manapun',
                isDark,
              );
            }

            final kelasId = siswaKelasSnapshot.data!.docs.first.get('kelas_id');

            // Query kelas_ngajar untuk mendapatkan semua mapel di kelas ini
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('kelas_ngajar')
                  .where('id_kelas', isEqualTo: kelasId)
                  .snapshots(),
              builder: (context, kelasNgajarSnapshot) {
                if (kelasNgajarSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  );
                }

                if (kelasNgajarSnapshot.hasError ||
                    !kelasNgajarSnapshot.hasData ||
                    kelasNgajarSnapshot.data!.docs.isEmpty) {
                  return _buildEmptyState(
                    'Belum ada kelas semester ini',
                    isDark,
                  );
                }

                final kelasNgajarList = kelasNgajarSnapshot.data!.docs;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: kelasNgajarList.length,
                  itemBuilder: (context, index) {
                    final kelasNgajarData =
                        kelasNgajarList[index].data() as Map<String, dynamic>;
                    final mapelId = kelasNgajarData['id_mapel'] ?? '';
                    final guruId = kelasNgajarData['id_guru'] ?? '';

                    return FutureBuilder<List<DocumentSnapshot>>(
                      future: Future.wait([
                        FirebaseFirestore.instance
                            .collection('mapel')
                            .doc(mapelId)
                            .get(),
                        FirebaseFirestore.instance
                            .collection('guru')
                            .doc(guruId)
                            .get(),
                      ]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2A2A2A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey[200]!,
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryPurple,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }

                        final mapelData =
                            snapshot.data![0].data() as Map<String, dynamic>?;
                        final guruData =
                            snapshot.data![1].data() as Map<String, dynamic>?;

                        final namaMapel = mapelData?['namaMapel'] ?? 'Mapel';
                        final namaGuru = guruData?['nama_lengkap'] ?? 'Guru';

                        return _buildKelasCard(
                          namaMapel: namaMapel,
                          namaGuru: namaGuru,
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
      ],
    );
  }

  // Widget untuk Tugas Tertunda - fetch dari Firestore
  static Widget buildTugasTertunda({
    required BuildContext context,
    required bool isDesktop,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final siswaId = userProvider.userId ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tugas Tertunda',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('siswa_kelas')
              .where('siswa_id', isEqualTo: siswaId)
              .snapshots(),
          builder: (context, siswaKelasSnapshot) {
            if (siswaKelasSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryPurple,
                  ),
                ),
              );
            }

            if (siswaKelasSnapshot.hasError ||
                !siswaKelasSnapshot.hasData ||
                siswaKelasSnapshot.data!.docs.isEmpty) {
              return _buildEmptyState(
                'Anda belum terdaftar di kelas manapun',
                isDark,
              );
            }

            final kelasId = siswaKelasSnapshot.data!.docs.first.get('kelas_id');

            // Validasi kelasId tidak kosong
            if (kelasId == null || kelasId.toString().isEmpty) {
              return _buildEmptyState('Data kelas tidak valid', isDark);
            }

            // Query tugas berdasarkan id_kelas
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tugas')
                  .where('id_kelas', isEqualTo: kelasId)
                  .snapshots(),
              builder: (context, tugasSnapshot) {
                if (tugasSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  );
                }

                if (tugasSnapshot.hasError) {
                  return _buildEmptyState(
                    'Error: ${tugasSnapshot.error.toString()}',
                    isDark,
                  );
                }

                if (!tugasSnapshot.hasData ||
                    tugasSnapshot.data!.docs.isEmpty) {
                  return _buildEmptyState(
                    'Tidak ada tugas untuk kelas ini',
                    isDark,
                  );
                }

                // Filter tugas yang belum dikerjakan
                final now = DateTime.now();
                final tugasTertunda = tugasSnapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final deadline = (data['deadline'] as Timestamp?)?.toDate();

                  // Cek apakah tugas sudah dikerjakan oleh siswa ini
                  // Bisa ditambahkan logic untuk cek di collection pengumpulan_tugas

                  return deadline != null && deadline.isAfter(now);
                }).toList();

                if (tugasTertunda.isEmpty) {
                  return _buildEmptyState('Tidak ada tugas tertunda', isDark);
                }

                return Column(
                  children: tugasTertunda.take(5).map((tugasDoc) {
                    final tugasData = tugasDoc.data() as Map<String, dynamic>;
                    final judulTugas = tugasData['judul'] ?? 'Tugas';
                    final deadline = (tugasData['deadline'] as Timestamp?)
                        ?.toDate();
                    final tugasKelasId = tugasData['id_kelas'] ?? '';

                    // Format tanggal: 03 Jan 2026
                    String deadlineText = '';
                    String jam = '';
                    if (deadline != null) {
                      final months = [
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
                      final day = deadline.day.toString().padLeft(2, '0');
                      final month = months[deadline.month - 1];
                      final year = deadline.year;
                      deadlineText = '$day $month $year';

                      // Format jam dari deadline (HH:mm)
                      final hour = deadline.hour.toString().padLeft(2, '0');
                      final minute = deadline.minute.toString().padLeft(2, '0');
                      jam = '$hour:$minute';
                    }

                    // Ambil namaMapel dari kelas_ngajar
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('kelas_ngajar')
                          .where('id_kelas', isEqualTo: tugasKelasId)
                          .limit(1)
                          .get(),
                      builder: (context, kelasNgajarSnapshot) {
                        String namaMapel = 'Mata Pelajaran';

                        if (kelasNgajarSnapshot.hasData &&
                            kelasNgajarSnapshot.data!.docs.isNotEmpty) {
                          final kelasNgajarData =
                              kelasNgajarSnapshot.data!.docs.first.data()
                                  as Map<String, dynamic>;
                          final mapelId = kelasNgajarData['id_mapel'] ?? '';

                          // Ambil nama mapel dari collection mapel
                          if (mapelId.isNotEmpty) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('mapel')
                                  .doc(mapelId)
                                  .get(),
                              builder: (context, mapelSnapshot) {
                                if (mapelSnapshot.hasData &&
                                    mapelSnapshot.data!.exists) {
                                  final mapelData =
                                      mapelSnapshot.data!.data()
                                          as Map<String, dynamic>?;
                                  namaMapel =
                                      mapelData?['namaMapel'] ??
                                      'Mata Pelajaran';
                                }

                                return _buildTugasCard(
                                  judulTugas: judulTugas,
                                  kelas: namaMapel,
                                  jam: jam,
                                  deadlineText: deadlineText,
                                  isDark: isDark,
                                );
                              },
                            );
                          }
                        }

                        return _buildTugasCard(
                          judulTugas: judulTugas,
                          kelas: namaMapel,
                          jam: jam,
                          deadlineText: deadlineText,
                          isDark: isDark,
                        );
                      },
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }

  static Widget _buildKelasCard({
    required String namaMapel,
    required String namaGuru,
    required bool isDark,
  }) {
    // Pilih warna berdasarkan nama mapel
    List<Color> getColorsForMapel(String mapel) {
      final mapelLower = mapel.toLowerCase();
      if (mapelLower.contains('matemat')) {
        return [const Color(0xFF7FB3D5), const Color(0xFF5D9BB8)];
      }
      if (mapelLower.contains('fisika')) {
        return [const Color(0xFFA8E6CF), const Color(0xFF7FD4B3)];
      }
      if (mapelLower.contains('kimia')) {
        return [const Color(0xFFFFC09F), const Color(0xFFFFAA7F)];
      }
      if (mapelLower.contains('biologi')) {
        return [const Color(0xFFAED581), const Color(0xFF9CCC65)];
      }
      if (mapelLower.contains('inggris') || mapelLower.contains('bahasa')) {
        return [const Color(0xFFCE93D8), const Color(0xFFBA68C8)];
      }
      if (mapelLower.contains('indonesia')) {
        return [const Color(0xFFFF8A80), const Color(0xFFFF5252)];
      }
      return [const Color(0xFF90CAF9), const Color(0xFF64B5F6)];
    }

    // Pilih icon berdasarkan nama mapel
    IconData getIconForMapel(String mapel) {
      final mapelLower = mapel.toLowerCase();
      if (mapelLower.contains('matemat')) return Icons.calculate_outlined;
      if (mapelLower.contains('fisika')) return Icons.science_outlined;
      if (mapelLower.contains('kimia')) return Icons.biotech_outlined;
      if (mapelLower.contains('biologi')) return Icons.eco_outlined;
      if (mapelLower.contains('inggris') || mapelLower.contains('bahasa')) {
        return Icons.language_outlined;
      }
      if (mapelLower.contains('indonesia')) return Icons.menu_book_outlined;
      if (mapelLower.contains('sejarah')) return Icons.history_edu_outlined;
      if (mapelLower.contains('geografi')) return Icons.public_outlined;
      if (mapelLower.contains('ekonomi')) return Icons.account_balance_outlined;
      if (mapelLower.contains('seni')) return Icons.palette_outlined;
      if (mapelLower.contains('olahraga') || mapelLower.contains('penjaskes')) {
        return Icons.sports_soccer_outlined;
      }
      if (mapelLower.contains('agama')) return Icons.mosque_outlined;
      if (mapelLower.contains('pkn') || mapelLower.contains('pancasila')) {
        return Icons.gavel_outlined;
      }
      if (mapelLower.contains('tik') || mapelLower.contains('komputer')) {
        return Icons.computer_outlined;
      }
      return Icons.book_outlined;
    }

    final colors = getColorsForMapel(namaMapel);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bagian ilustrasi dengan gradient
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  getIconForMapel(namaMapel),
                  size: 60,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ),
          ),
          // Bagian informasi
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  namaMapel,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  namaGuru,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: isDark
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryPurple,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTugasCard({
    required String judulTugas,
    required String kelas,
    required String jam,
    required String deadlineText,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: AppTheme.primaryPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judulTugas,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryTeal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        kelas,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.secondaryTeal,
                        ),
                      ),
                    ),
                    if (jam.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            jam,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(height: 4),
              Text(
                deadlineText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildEmptyState(String message, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
