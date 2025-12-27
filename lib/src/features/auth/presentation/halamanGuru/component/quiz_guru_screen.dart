import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../widgets/guru_app_scaffold.dart';

class QuizGuruScreen extends ConsumerStatefulWidget {
  const QuizGuruScreen({super.key});

  @override
  ConsumerState<QuizGuruScreen> createState() => _QuizGuruScreenState();
}

class _QuizGuruScreenState extends ConsumerState<QuizGuruScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';
  String _selectedKelas = 'Semua Kelas';
  String _selectedMapel = 'Semua Mapel';

  List<Map<String, String>> _kelasList = [];
  List<Map<String, String>> _mapelList = [];

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final kelasSnap = await _firestore.collection('kelas').get();
    final mapelSnap = await _firestore.collection('mapel').get();

    setState(() {
      _kelasList = kelasSnap.docs
          .map((d) => {'id': d.id, 'nama': d.data()['nama_kelas'] as String})
          .toList();
      _mapelList = mapelSnap.docs
          .map((d) => {'id': d.id, 'nama': d.data()['namaMapel'] as String})
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProv = UserProvider();
    final guruId = userProv.userId;

    return GuruAppScaffold(
      title: 'Quiz & Ujian',
      icon: Icons.quiz,
      currentRoute: '/quiz',
      additionalActions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _showCreateQuizDialog(context),
          tooltip: 'Buat Quiz',
        ),
      ],
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getQuizStream(guruId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                final quizList = _buildQuizList(snapshot.data!.docs);

                if (quizList.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildQuizGrid(quizList);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kelasItems = ['Semua Kelas', ..._kelasList.map((k) => k['nama']!)];
    final mapelItems = ['Semua Mapel', ..._mapelList.map((m) => m['nama']!)];

    return Container(
      padding: const EdgeInsets.all(20),
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
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Cari quiz...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDark
                  ? AppTheme.backgroundDark
                  : AppTheme.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedKelas,
                  decoration: InputDecoration(
                    labelText: 'Filter Kelas',
                    prefixIcon: const Icon(Icons.class_),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: kelasItems
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedKelas = v!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedMapel,
                  decoration: InputDecoration(
                    labelText: 'Filter Mapel',
                    prefixIcon: const Icon(Icons.book),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: mapelItems
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedMapel = v!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getQuizStream(String? guruId) {
    if (guruId == null) return const Stream.empty();
    return _firestore
        .collection('quiz')
        .where('id_guru', isEqualTo: guruId)
        .snapshots();
  }

  List<Map<String, dynamic>> _buildQuizList(List<QueryDocumentSnapshot> docs) {
    List<Map<String, dynamic>> quizList = [];

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final judul = data['judul'] ?? 'Quiz';
      final idKelas = data['id_kelas'];
      final idMapel = data['id_mapel'];

      if (_selectedKelas != 'Semua Kelas') {
        final kelasId = _kelasList.firstWhere(
          (k) => k['nama'] == _selectedKelas,
          orElse: () => {},
        )['id'];
        if (kelasId != null && idKelas != kelasId) continue;
      }

      if (_selectedMapel != 'Semua Mapel') {
        final mapelId = _mapelList.firstWhere(
          (m) => m['nama'] == _selectedMapel,
          orElse: () => {},
        )['id'];
        if (mapelId != null && idMapel != mapelId) continue;
      }

      if (_searchQuery.isNotEmpty &&
          !judul.toLowerCase().contains(_searchQuery.toLowerCase())) {
        continue;
      }

      quizList.add({
        'id': doc.id,
        'judul': judul,
        'id_kelas': idKelas,
        'id_mapel': idMapel,
        'createdAt': data['createdAt'],
      });
    }

    return quizList;
  }

  Widget _buildQuizGrid(List<Map<String, dynamic>> quizList) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 1.3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: quizList.length,
      itemBuilder: (c, i) => _buildQuizCard(quizList[i], isDark),
    );
  }

  Widget _buildQuizCard(Map<String, dynamic> quiz, bool isDark) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getQuizDetails(quiz),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final details = snapshot.data!;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // TODO: Show quiz details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur detail quiz segera hadir')),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.quiz,
                          color: Colors.purple,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        itemBuilder: (c) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (v) {
                          if (v == 'edit') {
                            // TODO: Edit quiz
                          }
                          if (v == 'delete') {
                            // TODO: Delete quiz
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    details['judul'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.class_,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          details['kelas'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.book,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          details['mapel'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.question_answer,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${details['soalCount']} soal',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        details['tanggal'],
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getQuizDetails(
    Map<String, dynamic> quiz,
  ) async {
    String kelasName = 'Kelas';
    if (quiz['id_kelas'] != null) {
      final kelasDoc = await _firestore
          .collection('kelas')
          .doc(quiz['id_kelas'])
          .get();
      if (kelasDoc.exists)
        kelasName = kelasDoc.data()?['nama_kelas'] ?? 'Kelas';
    }

    String mapelName = 'Mapel';
    if (quiz['id_mapel'] != null) {
      final mapelDoc = await _firestore
          .collection('mapel')
          .doc(quiz['id_mapel'])
          .get();
      if (mapelDoc.exists) mapelName = mapelDoc.data()?['namaMapel'] ?? 'Mapel';
    }

    final soalSnap = await _firestore
        .collection('quiz_soal')
        .where('id_quiz', isEqualTo: int.parse(quiz['id']))
        .get();
    final soalCount = soalSnap.docs.length;

    String tanggal = '';
    if (quiz['createdAt'] != null) {
      final date = (quiz['createdAt'] as Timestamp).toDate();
      tanggal = DateFormat('dd MMM yyyy').format(date);
    }

    return {
      ...quiz,
      'kelas': kelasName,
      'mapel': mapelName,
      'soalCount': soalCount,
      'tanggal': tanggal,
    };
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada quiz',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Klik tombol + untuk membuat quiz baru',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showCreateQuizDialog(BuildContext context) {
    _showQuizFormDialog(context, 'Buat Quiz Baru', null);
  }

  void _showQuizFormDialog(
    BuildContext context,
    String title,
    Map<String, dynamic>? quizData,
  ) {
    showDialog(
      context: context,
      builder: (c) => QuizFormDialog(
        title: title,
        quizData: quizData,
        kelasList: _kelasList,
        mapelList: _mapelList,
        onSave: (data) async {
          try {
            final userProv = UserProvider();
            final idGuru = userProv.userId;

            if (idGuru == null) {
              throw Exception('User tidak login');
            }

            // Save quiz dan soal
            await _saveQuiz(idGuru, data);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quiz berhasil disimpan'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {});
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _saveQuiz(String idGuru, Map<String, dynamic> data) async {
    final quizSnapshot = await _firestore.collection('quiz').get();
    final nextQuizId = (quizSnapshot.docs.length + 1).toString();

    // Simpan quiz
    await _firestore.collection('quiz').doc(nextQuizId).set({
      'id_guru': idGuru,
      'id_kelas': data['id_kelas'],
      'id_mapel': data['id_mapel'],
      'judul': data['judul'],
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Simpan soal-soal
    final soalList = data['soalList'] as List<Map<String, dynamic>>;
    for (int i = 0; i < soalList.length; i++) {
      final soal = soalList[i];
      final soalSnapshot = await _firestore.collection('quiz_soal').get();
      final nextSoalId = (soalSnapshot.docs.length + 1).toString();

      await _firestore.collection('quiz_soal').doc(nextSoalId).set({
        'id_quiz': int.parse(nextQuizId),
        'pertanyaan': soal['pertanyaan'],
        'tipe': soal['tipe'], // 'single' or 'multiple'
      });

      // Simpan jawaban-jawaban
      final jawabanList = soal['jawaban'] as List<Map<String, dynamic>>;
      for (final jawaban in jawabanList) {
        final jawabanSnapshot = await _firestore
            .collection('quiz_jawaban')
            .get();
        final nextJawabanId = (jawabanSnapshot.docs.length + 1).toString();

        await _firestore.collection('quiz_jawaban').doc(nextJawabanId).set({
          'id_soal': int.parse(nextSoalId),
          'jawaban': jawaban['text'],
          'is_correct': jawaban['is_correct'],
        });
      }
    }
  }
}

class QuizFormDialog extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? quizData;
  final List<Map<String, String>> kelasList;
  final List<Map<String, String>> mapelList;
  final Function(Map<String, dynamic>) onSave;

  const QuizFormDialog({
    super.key,
    required this.title,
    this.quizData,
    required this.kelasList,
    required this.mapelList,
    required this.onSave,
  });

  @override
  State<QuizFormDialog> createState() => _QuizFormDialogState();
}

class _QuizFormDialogState extends State<QuizFormDialog> {
  final formKey = GlobalKey<FormState>();
  final judulController = TextEditingController();
  String? selectedKelasId;
  String? selectedMapelId;

  List<SoalItem> soalList = [];

  @override
  void initState() {
    super.initState();
    if (widget.quizData != null) {
      judulController.text = widget.quizData!['judul'];
      selectedKelasId = widget.quizData!['id_kelas'];
      selectedMapelId = widget.quizData!['id_mapel'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.sunsetGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.quiz, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: judulController,
                        decoration: InputDecoration(
                          labelText: 'Judul Quiz',
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedKelasId,
                        decoration: InputDecoration(
                          labelText: 'Kelas',
                          prefixIcon: const Icon(Icons.class_),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: widget.kelasList
                            .map(
                              (k) => DropdownMenuItem(
                                value: k['id'],
                                child: Text(k['nama'] ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedKelasId = v),
                        validator: (v) => v == null ? 'Wajib dipilih' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedMapelId,
                        decoration: InputDecoration(
                          labelText: 'Mata Pelajaran',
                          prefixIcon: const Icon(Icons.book),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: widget.mapelList
                            .map(
                              (m) => DropdownMenuItem(
                                value: m['id'],
                                child: Text(m['nama'] ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedMapelId = v),
                        validator: (v) => v == null ? 'Wajib dipilih' : null,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Soal-soal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                soalList.add(SoalItem());
                              });
                            },
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Tambah Soal'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryPurple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...soalList.asMap().entries.map((entry) {
                        final index = entry.key;
                        final soal = entry.value;
                        return SoalWidget(
                          key: ValueKey(soal),
                          soal: soal,
                          index: index,
                          onDelete: () {
                            setState(() {
                              soalList.removeAt(index);
                            });
                          },
                          onUpdate: () => setState(() {}),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (soalList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tambahkan minimal 1 soal'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Validasi setiap soal
                      for (final soal in soalList) {
                        if (soal.pertanyaanController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pertanyaan tidak boleh kosong'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (soal.jawaban.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tambahkan minimal 1 jawaban'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        final hasCorrect = soal.jawaban.any((j) => j.isCorrect);
                        if (!hasCorrect) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Pilih minimal 1 jawaban yang benar',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      }

                      final data = {
                        'judul': judulController.text,
                        'id_kelas': selectedKelasId,
                        'id_mapel': selectedMapelId,
                        'soalList': soalList.map((s) => s.toMap()).toList(),
                      };
                      widget.onSave(data);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SoalItem {
  final TextEditingController pertanyaanController = TextEditingController();
  String tipe = 'single'; // 'single' or 'multiple'
  List<JawabanItem> jawaban = [];

  Map<String, dynamic> toMap() {
    return {
      'pertanyaan': pertanyaanController.text,
      'tipe': tipe,
      'jawaban': jawaban
          .map((j) => {'text': j.controller.text, 'is_correct': j.isCorrect})
          .toList(),
    };
  }
}

class JawabanItem {
  final TextEditingController controller = TextEditingController();
  bool isCorrect = false;
}

class SoalWidget extends StatefulWidget {
  final SoalItem soal;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const SoalWidget({
    super.key,
    required this.soal,
    required this.index,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<SoalWidget> createState() => _SoalWidgetState();
}

class _SoalWidgetState extends State<SoalWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Soal ${widget.index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                tooltip: 'Hapus Soal',
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.soal.pertanyaanController,
            decoration: InputDecoration(
              labelText: 'Pertanyaan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: widget.soal.tipe,
            decoration: InputDecoration(
              labelText: 'Tipe Jawaban',
              prefixIcon: const Icon(Icons.check_circle_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'single',
                child: Text('Single Answer (Pilihan Ganda)'),
              ),
              DropdownMenuItem(
                value: 'multiple',
                child: Text('Multiple Answer (Pilihan Ganda Kompleks)'),
              ),
            ],
            onChanged: (v) {
              setState(() {
                widget.soal.tipe = v!;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jawaban:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    widget.soal.jawaban.add(JawabanItem());
                  });
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Tambah Jawaban'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.soal.jawaban.asMap().entries.map((entry) {
            final idx = entry.key;
            final jawaban = entry.value;
            final huruf = String.fromCharCode(97 + idx); // a, b, c, dst

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  if (widget.soal.tipe == 'single')
                    Radio<int>(
                      value: idx,
                      groupValue: widget.soal.jawaban.indexWhere(
                        (j) => j.isCorrect,
                      ),
                      onChanged: (v) {
                        setState(() {
                          for (var j in widget.soal.jawaban) {
                            j.isCorrect = false;
                          }
                          jawaban.isCorrect = true;
                        });
                      },
                    )
                  else
                    Checkbox(
                      value: jawaban.isCorrect,
                      onChanged: (v) {
                        setState(() {
                          jawaban.isCorrect = v ?? false;
                        });
                      },
                    ),
                  Text(
                    '$huruf. ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: jawaban.controller,
                      decoration: InputDecoration(
                        hintText: 'Isi jawaban $huruf',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.soal.jawaban.removeAt(idx);
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  ),
                ],
              ),
            );
          }).toList(),
          if (widget.soal.jawaban.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Klik "Tambah Jawaban" untuk menambahkan opsi jawaban',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
