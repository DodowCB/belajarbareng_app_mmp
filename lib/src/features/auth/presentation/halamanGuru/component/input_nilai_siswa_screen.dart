import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../widgets/guru_app_scaffold.dart';
import '../../../../notifications/presentation/services/notification_service.dart';

class InputNilaiSiswaScreen extends StatefulWidget {
  final Map<String, dynamic> kelas;

  const InputNilaiSiswaScreen({super.key, required this.kelas});

  @override
  State<InputNilaiSiswaScreen> createState() => _InputNilaiSiswaScreenState();
}

class _InputNilaiSiswaScreenState extends State<InputNilaiSiswaScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, TextEditingController> _utsControllers = {};
  final Map<String, TextEditingController> _uasControllers = {};
  final Map<String, TextEditingController> _tugasControllers = {};
  final Map<String, double> _rataRata = {};

  List<Map<String, dynamic>> _siswaList = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSiswaAndNilai();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _utsControllers.values) {
      controller.dispose();
    }
    for (var controller in _uasControllers.values) {
      controller.dispose();
    }
    for (var controller in _tugasControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSiswaAndNilai() async {
    setState(() => _isLoading = true);

    try {
      final kelasId = widget.kelas['kelasId'] ?? '';

      // Get siswa from siswa_kelas
      final siswaKelasSnapshot = await _firestore
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: kelasId)
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
            final siswaData = siswaDoc.data()!;
            siswaList.add({
              'siswaId': siswaDoc.id,
              'nama': siswaData['nama'] ?? '',
              'nis': siswaData['nis'] ?? '',
            });

            // Initialize controllers
            _utsControllers[siswaDoc.id] = TextEditingController();
            _uasControllers[siswaDoc.id] = TextEditingController();
            _tugasControllers[siswaDoc.id] = TextEditingController();
            _rataRata[siswaDoc.id] = 0.0;

            // Load existing nilai if any
            await _loadExistingNilai(siswaDoc.id, kelasId);
          }
        }
      }

      setState(() {
        _siswaList = siswaList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadExistingNilai(String siswaId, String kelasId) async {
    try {
      final guruId = userProvider.userId ?? '';

      // Query nilai_siswa
      final nilaiSnapshot = await _firestore
          .collection('nilai_siswa')
          .where('id_siswa', isEqualTo: siswaId)
          .where('id_kelas', isEqualTo: kelasId)
          .where('id_guru', isEqualTo: guruId)
          .get();

      if (nilaiSnapshot.docs.isNotEmpty) {
        final nilaiData = nilaiSnapshot.docs.first.data();

        _utsControllers[siswaId]?.text = nilaiData['uts']?.toString() ?? '';
        _uasControllers[siswaId]?.text = nilaiData['uas']?.toString() ?? '';
        _tugasControllers[siswaId]?.text = nilaiData['tugas']?.toString() ?? '';
        _rataRata[siswaId] = (nilaiData['rata_rata'] ?? 0.0).toDouble();
      }
    } catch (e) {
      debugPrint('Error loading existing nilai: $e');
    }
  }

  void _calculateRataRata(String siswaId) {
    final uts = double.tryParse(_utsControllers[siswaId]?.text ?? '') ?? 0.0;
    final uas = double.tryParse(_uasControllers[siswaId]?.text ?? '') ?? 0.0;
    final tugas =
        double.tryParse(_tugasControllers[siswaId]?.text ?? '') ?? 0.0;

    // Calculate average
    final rataRata = (uts + uas + tugas) / 3;

    setState(() {
      _rataRata[siswaId] = rataRata;
    });
  }

  Future<void> _saveNilai() async {
    // Validate all inputs
    bool hasEmptyFields = false;
    for (final siswa in _siswaList) {
      final siswaId = siswa['siswaId'];
      if ((_utsControllers[siswaId]?.text.isEmpty ?? true) ||
          (_uasControllers[siswaId]?.text.isEmpty ?? true) ||
          (_tugasControllers[siswaId]?.text.isEmpty ?? true)) {
        hasEmptyFields = true;
        break;
      }
    }

    if (hasEmptyFields) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua nilai untuk semua siswa'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final guruId = userProvider.userId ?? '';
      final kelasId = widget.kelas['kelasId'] ?? '';

      // Get max ID
      final allNilaiDocs = await _firestore.collection('nilai_siswa').get();
      int maxId = 0;
      for (final doc in allNilaiDocs.docs) {
        final docId = int.tryParse(doc.id);
        if (docId != null && docId > maxId) {
          maxId = docId;
        }
      }

      // Use batch write
      final batch = _firestore.batch();

      for (final siswa in _siswaList) {
        final siswaId = siswa['siswaId'];
        final uts =
            double.tryParse(_utsControllers[siswaId]?.text ?? '') ?? 0.0;
        final uas =
            double.tryParse(_uasControllers[siswaId]?.text ?? '') ?? 0.0;
        final tugas =
            double.tryParse(_tugasControllers[siswaId]?.text ?? '') ?? 0.0;
        final rataRata = _rataRata[siswaId] ?? 0.0;

        // Check if nilai already exists
        final existingNilai = await _firestore
            .collection('nilai_siswa')
            .where('id_siswa', isEqualTo: siswaId)
            .where('id_kelas', isEqualTo: kelasId)
            .where('id_guru', isEqualTo: guruId)
            .get();

        if (existingNilai.docs.isNotEmpty) {
          // Update existing
          final docRef = _firestore
              .collection('nilai_siswa')
              .doc(existingNilai.docs.first.id);
          batch.update(docRef, {
            'uts': uts,
            'uas': uas,
            'tugas': tugas,
            'rata_rata': rataRata,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Create new
          maxId++;
          final docRef = _firestore
              .collection('nilai_siswa')
              .doc(maxId.toString());
          batch.set(docRef, {
            'id_guru': guruId,
            'id_kelas': kelasId,
            'id_siswa': siswaId,
            'uts': uts,
            'uas': uas,
            'tugas': tugas,
            'rata_rata': rataRata,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      await batch.commit();

      // 🔔 TRIGGER NOTIFIKASI: NILAI_KELUAR untuk setiap siswa
      final notificationService = NotificationService();
      final mapelName = widget.kelas['namaMapel'] ?? 'Mata Pelajaran';
      
      for (final siswa in _siswaList) {
        final siswaId = siswa['siswaId'];
        final rataRata = _rataRata[siswaId] ?? 0.0;
        
        await notificationService.sendNilaiKeluar(
          siswaId: siswaId,
          mapelName: mapelName,
          jenisNilai: 'Rata-rata',
          nilai: rataRata,
          mapelId: widget.kelas['mapelId'] ?? '',
        );
      }

      setState(() => _isSaving = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text('Berhasil menyimpan nilai ${_siswaList.length} siswa'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Go back
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isSaving = false);
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
      icon: Icons.edit_note,
      currentRoute: '/input-nilai',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _siswaList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada siswa di kelas ini',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Class info
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryTeal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.school,
                              color: AppTheme.secondaryTeal,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.kelas['namaKelas'] ?? 'Kelas',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.kelas['namaMapel'] ?? 'Mata Pelajaran',
                                  style: TextStyle(
                                    fontSize: 14,
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
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      // Stats
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.primaryPurple.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: AppTheme.primaryPurple,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_siswaList.length}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryPurple,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Siswa',
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // List siswa
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _siswaList.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final siswa = _siswaList[index];
                      return _buildSiswaRow(siswa);
                    },
                  ),
                ),

                // Save button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _saveNilai,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(
                            _isSaving ? 'Menyimpan...' : 'Simpan Semua Nilai',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSiswaRow(Map<String, dynamic> siswa) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final siswaId = siswa['siswaId'];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama dan NIS
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppTheme.accentOrange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        siswa['nama'] ?? 'Siswa',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'NIS: ${siswa['nis'] ?? '-'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Input fields
            Row(
              children: [
                Expanded(
                  child: _buildNilaiField(
                    'UTS',
                    _utsControllers[siswaId]!,
                    siswaId,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNilaiField(
                    'UAS',
                    _uasControllers[siswaId]!,
                    siswaId,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNilaiField(
                    'Tugas',
                    _tugasControllers[siswaId]!,
                    siswaId,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rata-rata
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentGreen.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calculate,
                        color: AppTheme.accentGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Rata-rata',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    (_rataRata[siswaId] ?? 0.0).toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNilaiField(
    String label,
    TextEditingController controller,
    String siswaId,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: '0',
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryPurple, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: (_) => _calculateRataRata(siswaId),
        ),
      ],
    );
  }
}
