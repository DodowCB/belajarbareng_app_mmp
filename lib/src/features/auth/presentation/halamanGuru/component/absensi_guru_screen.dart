import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart' as user_prov;
import '../../../../../core/providers/connectivity_provider.dart';
import 'absensi_dialog_helper.dart';
import '../../widgets/guru_app_scaffold.dart';

class AbsensiGuruScreen extends ConsumerStatefulWidget {
  const AbsensiGuruScreen({super.key});

  @override
  ConsumerState<AbsensiGuruScreen> createState() => _AbsensiGuruScreenState();
}

class _AbsensiGuruScreenState extends ConsumerState<AbsensiGuruScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();
  String _selectedTab = 'wali_kelas'; // 'wali_kelas' or 'kelas_diajar'
  int _refreshKey = 0; // Add refresh key

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch connectivity status for real-time updates
    final isOnline = ref.watch(isOnlineProvider);

    return GuruAppScaffold(
      title: 'Absensi',
      icon: Icons.fact_check,
      currentRoute: '/absensi',
      body: Column(
        children: [
          if (!isOnline) _buildOfflineBanner(),
          // Date Picker Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Date Selector
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryPurple.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppTheme.primaryPurple,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal Absensi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormat(
                                  'EEEE, dd MMMM yyyy',
                                  'id_ID',
                                ).format(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppTheme.primaryPurple,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Tab Selector
                Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        'Wali Kelas',
                        'wali_kelas',
                        Icons.class_,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTabButton(
                        'Kelas Diajar',
                        'kelas_diajar',
                        Icons.school,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _selectedTab == 'wali_kelas'
                ? _buildWaliKelasContent()
                : _buildKelasDiajarContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.orange.shade100,
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.orange.shade900, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mode Offline - Fitur simpan absensi tidak tersedia',
              style: TextStyle(
                color: Colors.orange.shade900,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, String tabValue, IconData icon) {
    final isSelected = _selectedTab == tabValue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => _selectedTab = tabValue),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryPurple
              : (isDark ? Colors.grey[850] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryPurple
                : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaliKelasContent() {
    final guruId = user_prov.userProvider.userId ?? '';

    return FutureBuilder<QuerySnapshot>(
      future: _firestore
          .collection('kelas')
          .where('guru_id', isEqualTo: guruId)
          .where('status', isEqualTo: true)
          .get(),
      builder: (context, kelasSnapshot) {
        if (kelasSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (kelasSnapshot.hasError) {
          return Center(child: Text('Error: ${kelasSnapshot.error}'));
        }

        final kelasList = kelasSnapshot.data?.docs ?? [];

        if (kelasList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.class_, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Anda belum menjadi wali kelas',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: kelasList.length,
          itemBuilder: (context, index) {
            final kelasDoc = kelasList[index];
            final kelasData = kelasDoc.data() as Map<String, dynamic>;
            final kelasId = kelasDoc.id;
            final namaKelas = kelasData['nama_kelas'] ?? 'Kelas ${kelasDoc.id}';

            return _buildKelasCard(
              namaKelas: namaKelas,
              kelasId: kelasId,
              tipeAbsen: 'wali_kelas',
            );
          },
        );
      },
    );
  }

  Widget _buildKelasDiajarContent() {
    final guruId = user_prov.userProvider.userId ?? '';

    return FutureBuilder<QuerySnapshot>(
      future: _firestore
          .collection('kelas_ngajar')
          .where('id_guru', isEqualTo: guruId)
          .get(),
      builder: (context, kelasNgajarSnapshot) {
        if (kelasNgajarSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (kelasNgajarSnapshot.hasError) {
          return Center(child: Text('Error: ${kelasNgajarSnapshot.error}'));
        }

        final kelasNgajarList = kelasNgajarSnapshot.data?.docs ?? [];

        if (kelasNgajarList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Anda belum mengajar kelas manapun',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: kelasNgajarList.length,
          itemBuilder: (context, index) {
            final kelasNgajarDoc = kelasNgajarList[index];
            final kelasNgajarData =
                kelasNgajarDoc.data() as Map<String, dynamic>;
            final kelasId = kelasNgajarData['id_kelas']?.toString() ?? '';
            final mapelId = kelasNgajarData['id_mapel']?.toString() ?? '';

            return FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('kelas').doc(kelasId).get(),
              builder: (context, kelasDocSnapshot) {
                if (!kelasDocSnapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final kelasData =
                    kelasDocSnapshot.data?.data() as Map<String, dynamic>?;

                // Skip if kelas status is not true
                if (kelasData == null || kelasData['status'] != true) {
                  return const SizedBox.shrink();
                }

                final namaKelas = kelasData['nama_kelas'] ?? 'Kelas $kelasId';

                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('mapel').doc(mapelId).get(),
                  builder: (context, mapelDocSnapshot) {
                    final mapelData =
                        mapelDocSnapshot.data?.data() as Map<String, dynamic>?;
                    final namaMapel =
                        mapelData?['namaMapel'] ?? 'Mata Pelajaran';

                    return _buildKelasCard(
                      namaKelas: namaKelas,
                      kelasId: kelasId,
                      tipeAbsen: 'mapel',
                      namaMapel: namaMapel,
                      jadwalId: kelasNgajarDoc.id,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildKelasCard({
    required String namaKelas,
    required String kelasId,
    required String tipeAbsen,
    String? namaMapel,
    String? jadwalId,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Generate unique key based on date, kelasId and refresh counter
    final cardKey = ValueKey(
      '${kelasId}_${DateFormat('yyyy-MM-dd').format(_selectedDate)}_$_refreshKey',
    );

    return FutureBuilder<bool>(
      key: cardKey,
      future: _checkAbsensiExists(kelasId, tipeAbsen, jadwalId),
      builder: (context, absensiSnapshot) {
        final sudahAbsen = absensiSnapshot.data ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
          ),
          child: InkWell(
            onTap: () {
              AbsensiDialogHelper.showAbsensiDialog(
                context: context,
                kelasId: kelasId,
                namaKelas: namaKelas,
                selectedDate: _selectedDate,
                tipeAbsen: tipeAbsen,
                guruId: user_prov.userProvider.userId ?? '',
                jadwalId: jadwalId,
                isEdit: sudahAbsen,
              ).then((_) {
                // Increment refresh key to trigger rebuild
                if (mounted) {
                  setState(() {
                    _refreshKey++;
                  });
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: sudahAbsen
                          ? Colors.green.withOpacity(0.1)
                          : AppTheme.accentOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      sudahAbsen ? Icons.check_circle : Icons.pending_actions,
                      color: sudahAbsen ? Colors.green : AppTheme.accentOrange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaKelas,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (namaMapel != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            namaMapel,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: sudahAbsen
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            sudahAbsen ? 'Sudah Diabsen' : 'Belum Diabsen',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sudahAbsen ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    sudahAbsen ? Icons.visibility : Icons.arrow_forward_ios,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _checkAbsensiExists(
    String kelasId,
    String tipeAbsen,
    String? jadwalId,
  ) async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);

      Query query = _firestore
          .collection('absensi')
          .where('kelas_id', isEqualTo: kelasId)
          .where('tipe_absen', isEqualTo: tipeAbsen);

      if (tipeAbsen == 'mapel' && jadwalId != null) {
        query = query.where('jadwal_id', isEqualTo: jadwalId);
      }

      final snapshot = await query.get();

      // Filter by date manually
      final todayAbsensi = snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = data['tanggal'] as Timestamp?;
        if (timestamp != null) {
          final docDate = timestamp.toDate();
          final docDateString = DateFormat('yyyy-MM-dd').format(docDate);
          return docDateString == dateString;
        }
        return false;
      }).toList();

      return todayAbsensi.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking absensi: $e');
      return false;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
