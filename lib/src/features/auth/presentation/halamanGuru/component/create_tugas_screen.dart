import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../widgets/guru_app_scaffold.dart';
import '../../../../notifications/data/repositories/notification_repository.dart';
import '../../../../notifications/data/models/notification_model.dart';

class CreateTugasScreen extends StatefulWidget {
  final Map<String, dynamic>? tugas; // For edit mode

  const CreateTugasScreen({super.key, this.tugas});

  @override
  State<CreateTugasScreen> createState() => _CreateTugasScreenState();
}

class _CreateTugasScreenState extends State<CreateTugasScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationRepository _notificationRepo = NotificationRepository();

  // Form controllers
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // Selected values
  String? _selectedKelasId;
  String? _selectedKelasName;
  DateTime? _selectedDeadline;
  String _selectedStatus = 'Aktif';

  // Data
  List<Map<String, dynamic>> _kelasList = [];
  bool _isLoading = false;
  bool _isLoadingKelas = true;

  @override
  void initState() {
    super.initState();
    _loadKelas();
    if (widget.tugas != null) {
      _populateFormForEdit();
    }
  }

  void _populateFormForEdit() {
    final tugas = widget.tugas!;
    _judulController.text = tugas['judul'] ?? '';
    _deskripsiController.text = tugas['deskripsi'] ?? '';
    _selectedKelasId = tugas['id_kelas']?.toString();
    _selectedKelasName = tugas['kelas'];
    _selectedStatus = tugas['status'] ?? 'Aktif';

    if (tugas['deadline'] is Timestamp) {
      _selectedDeadline = (tugas['deadline'] as Timestamp).toDate();
    } else if (tugas['deadline'] is DateTime) {
      _selectedDeadline = tugas['deadline'];
    }
  }

  Future<void> _loadKelas() async {
    setState(() => _isLoadingKelas = true);

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

        // Get kelas detail
        final kelasDoc = await _firestore
            .collection('kelas')
            .doc(kelasId)
            .get();

        if (kelasDoc.exists) {
          final kelasData = kelasDoc.data();

          // Skip if kelas status is not true
          if (kelasData?['status'] != true) continue;

          // Get jumlah siswa
          final siswaKelasSnapshot = await _firestore
              .collection('siswa_kelas')
              .where('kelas_id', isEqualTo: kelasId)
              .get();

          kelasList.add({
            'kelasId': kelasId,
            'namaKelas': kelasData?['nama_kelas'] ?? 'Kelas $kelasId',
            'jumlahSiswa': siswaKelasSnapshot.docs.length,
          });
        }
      }

      setState(() {
        _kelasList = kelasList;
        _isLoadingKelas = false;
      });
    } catch (e) {
      setState(() => _isLoadingKelas = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading kelas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          _selectedDeadline ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDeadline ?? DateTime.now(),
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppTheme.primaryPurple,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTugas() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedKelasId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kelas terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih tanggal deadline terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final guruId = userProvider.userId ?? '';
      final batch = _firestore.batch();

      // Get jumlah siswa
      final siswaSnapshot = await _firestore
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: _selectedKelasId)
          .get();
      final jumlahSiswa = siswaSnapshot.docs.length;

      String docId;
      DocumentReference docRef;

      if (widget.tugas != null && widget.tugas!['id'] != null) {
        // Edit mode - update existing tugas
        docId = widget.tugas!['id'].toString();
        docRef = _firestore.collection('tugas').doc(docId);

        batch.update(docRef, {
          'judul': _judulController.text.trim(),
          'deskripsi': _deskripsiController.text.trim(),
          'id_kelas': _selectedKelasId,
          'kelas': _selectedKelasName,
          'deadline': Timestamp.fromDate(_selectedDeadline!),
          'status': _selectedStatus,
          'jumlahSiswa': jumlahSiswa,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Create mode - generate new numeric ID
        final allDocs = await _firestore.collection('tugas').get();
        int maxId = 0;
        for (var doc in allDocs.docs) {
          final id = int.tryParse(doc.id) ?? 0;
          if (id > maxId) maxId = id;
        }
        docId = (maxId + 1).toString();
        docRef = _firestore.collection('tugas').doc(docId);

        batch.set(docRef, {
          'judul': _judulController.text.trim(),
          'deskripsi': _deskripsiController.text.trim(),
          'id_guru': guruId,
          'id_kelas': _selectedKelasId,
          'kelas': _selectedKelasName,
          'deadline': Timestamp.fromDate(_selectedDeadline!),
          'status': _selectedStatus,
          'jumlahSiswa': jumlahSiswa,
          'sudahMengumpulkan': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
// Send notification to all students in the class (only for new tugas)
      if (widget.tugas == null) {
        await _sendTugasBaruNotifications(docId, siswaSnapshot);
      }

      
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.tugas != null
                  ? 'Tugas berhasil diperbarui'
                  : 'Tugas berhasil dibuat',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
  /// Send TUGAS_BARU notifications to all students in the class
  Future<void> _sendTugasBaruNotifications(
    String tugasId,
    QuerySnapshot siswaKelasSnapshot,
  ) async {
    try {
      final notifications = <Map<String, dynamic>>[];
      final deadlineFormatted = DateFormat('dd MMMM yyyy', 'id_ID')
          .format(_selectedDeadline!);

      // Get all siswa user IDs from siswa_kelas
      for (final doc in siswaKelasSnapshot.docs) {
        final siswaId = doc['siswa_id']?.toString();
        if (siswaId != null && siswaId.isNotEmpty) {
          notifications.add({
            'userId': siswaId,
            'role': 'siswa',
            'type': NotificationType.tugasBaru,
            'title': 'Tugas Baru: ${_judulController.text.trim()}',
            'message': 'Deadline: $deadlineFormatted',
            'priority': NotificationPriority.high,
            'actionUrl': '/tugas/detail/$tugasId',
            'metadata': {
              'taskId': tugasId,
              'kelasId': _selectedKelasId,
              'kelasName': _selectedKelasName,
            },
          });
        }
      }

      if (notifications.isNotEmpty) {
        await _notificationRepo.createBatchNotifications(notifications);
        debugPrint('✅ Sent ${notifications.length} TUGAS_BARU notifications');
      }
    } catch (e) {
      debugPrint('❌ Failed to send TUGAS_BARU notifications: $e');
    }
  }

        );
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GuruAppScaffold(
      title: widget.tugas != null ? 'Edit Tugas' : 'Buat Tugas Baru',
      icon: widget.tugas != null ? Icons.edit_note : Icons.add_task,
      currentRoute: widget.tugas != null ? '/edit-tugas' : '/create-tugas',
      body: _isLoadingKelas
          ? const Center(child: CircularProgressIndicator())
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
                          widget.tugas != null ? Icons.edit_note : Icons.add_task,
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
                              widget.tugas != null ? 'Edit Tugas' : 'Buat Tugas Baru',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.tugas != null
                                  ? 'Perbarui informasi tugas untuk siswa'
                                  : 'Buat tugas baru untuk siswa di kelas yang Anda ajar',
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                    // Judul Tugas
                    Text(
                      'Judul Tugas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _judulController,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Latihan Trigonometri',
                        prefixIcon: Icon(
                          Icons.title,
                          color: AppTheme.primaryPurple,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Judul tugas tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Deskripsi
                    Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _deskripsiController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            'Contoh: Kerjakan soal halaman 45-50 buku paket',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: Icon(
                            Icons.description,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Deskripsi tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Kelas
                    Text(
                      'Kelas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isDark ? Colors.grey[850] : Colors.grey[50],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedKelasId,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.class_,
                            color: AppTheme.primaryPurple,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        hint: const Text('Pilih Kelas'),
                        items: _kelasList.map((kelas) {
                          return DropdownMenuItem<String>(
                            value: kelas['kelasId'],
                            child: Text(
                              '${kelas['namaKelas']} (${kelas['jumlahSiswa']} siswa)',
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKelasId = value;
                            final kelas = _kelasList.firstWhere(
                              (k) => k['kelasId'] == value,
                            );
                            _selectedKelasName = kelas['namaKelas'];
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Pilih kelas terlebih dahulu';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Deadline
                    Text(
                      'Deadline',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectDeadline,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isDark ? Colors.grey[850] : Colors.grey[50],
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
                              child: Text(
                                _selectedDeadline == null
                                    ? 'Pilih tanggal dan waktu deadline'
                                    : DateFormat(
                                        'EEEE, dd MMMM yyyy - HH:mm',
                                        'id_ID',
                                      ).format(_selectedDeadline!),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _selectedDeadline == null
                                      ? (isDark
                                            ? Colors.grey[500]
                                            : Colors.grey[600])
                                      : (isDark
                                            ? Colors.grey[200]
                                            : Colors.grey[800]),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isDark ? Colors.grey[850] : Colors.grey[50],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.info,
                            color: AppTheme.primaryPurple,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: ['Aktif', 'Selesai'].map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: status == 'Aktif'
                                        ? Colors.green
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(status),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedStatus = value!);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveTugas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  widget.tugas != null
                                      ? 'Update Tugas'
                                      : 'Simpan Tugas',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
