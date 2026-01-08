import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../../core/config/theme.dart';

class AbsensiDialogHelper {
  static Future<void> showAbsensiDialog({
    required BuildContext context,
    required String kelasId,
    required String namaKelas,
    required DateTime selectedDate,
    required String tipeAbsen,
    required String guruId,
    String? jadwalId,
    bool isEdit = false,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final firestore = FirebaseFirestore.instance;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppTheme.primaryPurple),
                const SizedBox(height: 16),
                Text(
                  isEdit ? 'Memuat data absensi...' : 'Memuat data siswa...',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Get siswa list
      final siswaKelasSnapshot = await firestore
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: kelasId)
          .get();

      List<Map<String, dynamic>> siswaList = [];
      Map<String, String> absensiStatus = {};

      for (final siswaKelasDoc in siswaKelasSnapshot.docs) {
        final siswaKelasData = siswaKelasDoc.data();
        final siswaId = siswaKelasData['siswa_id']?.toString() ?? '';

        if (siswaId.isEmpty) continue;

        final siswaDoc = await firestore.collection('siswa').doc(siswaId).get();

        if (siswaDoc.exists) {
          final data = siswaDoc.data();
          siswaList.add({
            'id': siswaDoc.id,
            'namaLengkap': data?['nama'] ?? 'Siswa',
            'nis': data?['nis'] ?? '-',
          });
          // Default status alpa
          absensiStatus[siswaDoc.id] = 'alpa';
        }
      }

      // If edit mode, load existing absensi
      if (isEdit) {
        final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
        Query query = firestore
            .collection('absensi')
            .where('kelas_id', isEqualTo: kelasId)
            .where('tipe_absen', isEqualTo: tipeAbsen);

        if (tipeAbsen == 'mapel' && jadwalId != null) {
          query = query.where('jadwal_id', isEqualTo: jadwalId);
        }

        final snapshot = await query.get();

        // Filter by date and update status
        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = data['tanggal'] as Timestamp?;
          if (timestamp != null) {
            final docDate = timestamp.toDate();
            final docDateString = DateFormat('yyyy-MM-dd').format(docDate);
            if (docDateString == dateString) {
              final siswaId = data['siswa_id'];
              final status = data['status'];
              absensiStatus[siswaId] = status ?? 'alpa';
            }
          }
        }
      }

      if (!context.mounted) return;
      Navigator.pop(context); // Close loading

      if (siswaList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada siswa dalam kelas ini'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Show dialog
      showDialog(
        context: context,
        builder: (dialogContext) => _AbsensiDialog(
          namaKelas: namaKelas,
          siswaList: siswaList,
          initialAbsensiStatus: absensiStatus,
          isDark: isDark,
          isEdit: isEdit,
          kelasId: kelasId,
          selectedDate: selectedDate,
          tipeAbsen: tipeAbsen,
          guruId: guruId,
          jadwalId: jadwalId,
          firestore: firestore,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

class _AbsensiDialog extends StatefulWidget {
  final String namaKelas;
  final List<Map<String, dynamic>> siswaList;
  final Map<String, String> initialAbsensiStatus;
  final bool isDark;
  final bool isEdit;
  final String kelasId;
  final DateTime selectedDate;
  final String tipeAbsen;
  final String guruId;
  final String? jadwalId;
  final FirebaseFirestore firestore;

  const _AbsensiDialog({
    required this.namaKelas,
    required this.siswaList,
    required this.initialAbsensiStatus,
    required this.isDark,
    required this.isEdit,
    required this.kelasId,
    required this.selectedDate,
    required this.tipeAbsen,
    required this.guruId,
    required this.jadwalId,
    required this.firestore,
  });

  @override
  State<_AbsensiDialog> createState() => _AbsensiDialogState();
}

class _AbsensiDialogState extends State<_AbsensiDialog> {
  late Map<String, String> absensiStatus;

  @override
  void initState() {
    super.initState();
    absensiStatus = Map.from(widget.initialAbsensiStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
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
                        widget.isEdit ? 'Edit Absensi' : 'Isi Absensi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.namaKelas} - ${DateFormat('dd MMM yyyy', 'id_ID').format(widget.selectedDate)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.isDark
                              ? Colors.grey[400]
                              : Colors.grey[600],
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
            // Student List with Status Buttons
            Expanded(
              child: ListView.builder(
                itemCount: widget.siswaList.length,
                itemBuilder: (context, index) {
                  final siswa = widget.siswaList[index];
                  final siswaId = siswa['id'];
                  final currentStatus = absensiStatus[siswaId] ?? 'alpa';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: widget.isDark
                        ? const Color(0xFF2A2A2A)
                        : Colors.grey[50],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: widget.isDark
                            ? Colors.grey[800]!
                            : Colors.grey[200]!,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppTheme.primaryPurple
                                    .withOpacity(0.1),
                                child: Text(
                                  siswa['namaLengkap']
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: AppTheme.primaryPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      siswa['namaLengkap'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'NIS: ${siswa['nis']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: widget.isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStatusButton(
                                context,
                                'Hadir',
                                'hadir',
                                currentStatus,
                                Colors.green,
                                Icons.check_circle,
                                () {
                                  setState(() {
                                    absensiStatus[siswaId] = 'hadir';
                                  });
                                },
                                widget.isDark,
                              ),
                              const SizedBox(width: 6),
                              _buildStatusButton(
                                context,
                                'Izin',
                                'izin',
                                currentStatus,
                                Colors.blue,
                                Icons.mail,
                                () {
                                  setState(() {
                                    absensiStatus[siswaId] = 'izin';
                                  });
                                },
                                widget.isDark,
                              ),
                              const SizedBox(width: 6),
                              _buildStatusButton(
                                context,
                                'Sakit',
                                'sakit',
                                currentStatus,
                                Colors.orange,
                                Icons.local_hospital,
                                () {
                                  setState(() {
                                    absensiStatus[siswaId] = 'sakit';
                                  });
                                },
                                widget.isDark,
                              ),
                              const SizedBox(width: 6),
                              _buildStatusButton(
                                context,
                                'Alpa',
                                'alpa',
                                currentStatus,
                                Colors.red,
                                Icons.cancel,
                                () {
                                  setState(() {
                                    absensiStatus[siswaId] = 'alpa';
                                  });
                                },
                                widget.isDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Actions
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  // Mobile: Stack buttons vertically
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Delete existing absensi for this date if in edit mode
                          if (widget.isEdit) {
                            final dateString = DateFormat(
                              'yyyy-MM-dd',
                            ).format(widget.selectedDate);
                            Query deleteQuery = widget.firestore
                                .collection('absensi')
                                .where('kelas_id', isEqualTo: widget.kelasId)
                                .where('tipe_absen', isEqualTo: widget.tipeAbsen);

                            if (widget.tipeAbsen == 'mapel' &&
                                widget.jadwalId != null) {
                              deleteQuery = deleteQuery.where(
                                'jadwal_id',
                                isEqualTo: widget.jadwalId,
                              );
                            }

                            final deleteSnapshot = await deleteQuery.get();
                            final batch = widget.firestore.batch();

                            for (final doc in deleteSnapshot.docs) {
                              final data = doc.data() as Map<String, dynamic>;
                              final timestamp = data['tanggal'] as Timestamp?;
                              if (timestamp != null) {
                                final docDate = timestamp.toDate();
                                final docDateString = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(docDate);
                                if (docDateString == dateString) {
                                  batch.delete(doc.reference);
                                }
                              }
                            }

                            await batch.commit();
                          }

                          // Get current max ID to generate next sequential ID
                          final allAbsensiSnapshot = await widget.firestore
                              .collection('absensi')
                              .get();

                          int maxId = 0;
                          for (final doc in allAbsensiSnapshot.docs) {
                            final docId = doc.id;
                            final numericId = int.tryParse(docId);
                            if (numericId != null && numericId > maxId) {
                              maxId = numericId;
                            }
                          }

                          // Save new absensi with sequential IDs
                          final batch = widget.firestore.batch();
                          int currentId = maxId;

                          for (final entry in absensiStatus.entries) {
                            currentId++;
                            final docRef = widget.firestore
                                .collection('absensi')
                                .doc(currentId.toString());
                            batch.set(docRef, {
                              'siswa_id': entry.key,
                              'kelas_id': widget.kelasId,
                              'jadwal_id': widget.tipeAbsen == 'mapel'
                                  ? widget.jadwalId
                                  : null,
                              'status': entry.value,
                              'tanggal': Timestamp.fromDate(widget.selectedDate),
                              'tipe_absen': widget.tipeAbsen,
                              'diabsen_oleh': widget.guruId,
                              'createdAt': FieldValue.serverTimestamp(),
                              'updatedAt': FieldValue.serverTimestamp(),
                            });
                          }

                          try {
                            await batch.commit();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.isEdit
                                      ? 'Absensi berhasil diperbarui'
                                      : 'Absensi berhasil disimpan',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          widget.isEdit ? 'Update Absensi' : 'Simpan Absensi',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: widget.isDark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
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
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: widget.isDark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          // Delete existing absensi for this date if in edit mode
                          if (widget.isEdit) {
                            final dateString = DateFormat(
                              'yyyy-MM-dd',
                            ).format(widget.selectedDate);
                            Query deleteQuery = widget.firestore
                                .collection('absensi')
                                .where('kelas_id', isEqualTo: widget.kelasId)
                                .where('tipe_absen', isEqualTo: widget.tipeAbsen);

                            if (widget.tipeAbsen == 'mapel' &&
                                widget.jadwalId != null) {
                              deleteQuery = deleteQuery.where(
                                'jadwal_id',
                                isEqualTo: widget.jadwalId,
                              );
                            }

                            final deleteSnapshot = await deleteQuery.get();
                            final batch = widget.firestore.batch();

                            for (final doc in deleteSnapshot.docs) {
                              final data = doc.data() as Map<String, dynamic>;
                              final timestamp = data['tanggal'] as Timestamp?;
                              if (timestamp != null) {
                                final docDate = timestamp.toDate();
                                final docDateString = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(docDate);
                                if (docDateString == dateString) {
                                  batch.delete(doc.reference);
                                }
                              }
                            }

                            await batch.commit();
                          }

                          // Get current max ID to generate next sequential ID
                          final allAbsensiSnapshot = await widget.firestore
                              .collection('absensi')
                              .get();

                          int maxId = 0;
                          for (final doc in allAbsensiSnapshot.docs) {
                            final docId = doc.id;
                            final numericId = int.tryParse(docId);
                            if (numericId != null && numericId > maxId) {
                              maxId = numericId;
                            }
                          }

                          // Save new absensi with sequential IDs
                          final batch = widget.firestore.batch();
                          int currentId = maxId;

                          for (final entry in absensiStatus.entries) {
                            currentId++;
                            final docRef = widget.firestore
                                .collection('absensi')
                                .doc(currentId.toString());
                            batch.set(docRef, {
                              'siswa_id': entry.key,
                              'kelas_id': widget.kelasId,
                              'jadwal_id': widget.tipeAbsen == 'mapel'
                                  ? widget.jadwalId
                                  : null,
                              'status': entry.value,
                              'tanggal': Timestamp.fromDate(widget.selectedDate),
                              'tipe_absen': widget.tipeAbsen,
                              'diabsen_oleh': widget.guruId,
                              'createdAt': FieldValue.serverTimestamp(),
                              'updatedAt': FieldValue.serverTimestamp(),
                            });
                          }

                          try {
                            await batch.commit();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.isEdit
                                      ? 'Absensi berhasil diperbarui'
                                      : 'Absensi berhasil disimpan',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          widget.isEdit ? 'Update Absensi' : 'Simpan Absensi',
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
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String label,
    String status,
    String currentStatus,
    Color color,
    IconData icon,
    VoidCallback onTap,
    bool isDark,
  ) {
    final isSelected = currentStatus == status;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withOpacity(0.2)
                : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: isSelected ? color : Colors.grey),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? color
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
