import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../widgets/guru_app_scaffold.dart';
import 'quiz_detail_screen.dart';
import 'create_quiz_screen.dart';

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
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Mobile: Stack vertically
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
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
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
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
                  ],
                );
              }
              // Desktop: Row
              return Row(
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
              );
            },
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getQuizStream(String? guruId) {
    if (guruId == null) return const Stream.empty();

    return _firestore
        .collection('quiz')
        .where('id_guru', isEqualTo: int.parse(guruId))
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
        if (kelasId != null && idKelas != int.parse(kelasId.toString()))
          continue;
      }

      if (_selectedMapel != 'Semua Mapel') {
        final mapelId = _mapelList.firstWhere(
          (m) => m['nama'] == _selectedMapel,
          orElse: () => {},
        )['id'];
        if (mapelId != null && idMapel != int.parse(mapelId.toString()))
          continue;
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => QuizDetailScreen(
                    quizId: quiz['id'],
                    judul: quiz['judul'] ?? '',
                  ),
                ),
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
                        onSelected: (v) async {
                          if (v == 'edit') {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateQuizScreen(
                                  kelasList: _kelasList,
                                  mapelList: _mapelList,
                                  quizData: {
                                    'id': quiz['id'],
                                    'judul': details['judul'],
                                    'id_kelas': quiz['id_kelas'],
                                    'id_mapel': quiz['id_mapel'],
                                    'waktu': details['waktu'],
                                  },
                                ),
                              ),
                            );
                            if (result == true) {
                              setState(() {});
                            }
                          }
                          if (v == 'delete') {
                            _showDeleteConfirmation(quiz['id'].toString());
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
          .doc(quiz['id_kelas'].toString())
          .get();
      if (kelasDoc.exists)
        kelasName = kelasDoc.data()?['nama_kelas'] ?? 'Kelas';
    }

    String mapelName = 'Mapel';
    if (quiz['id_mapel'] != null) {
      final mapelDoc = await _firestore
          .collection('mapel')
          .doc(quiz['id_mapel'].toString())
          .get();
      if (mapelDoc.exists) mapelName = mapelDoc.data()?['namaMapel'] ?? 'Mapel';
    }

    final soalSnap = await _firestore
        .collection('quiz_soal')
        .where('id_quiz', isEqualTo: int.parse(quiz['id']))
        .get();
    final soalCount = soalSnap.docs.length;

    String tanggal = '';
    ;
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

  void _showCreateQuizDialog(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateQuizScreen(
          kelasList: _kelasList,
          mapelList: _mapelList,
        ),
      ),
    );

    // Refresh list if quiz was created
    if (result == true) {
      setState(() {});
    }
  }

  void _showDeleteConfirmation(String quizId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 12),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: const Text(
          'Apakah kamu yakin ingin menghapus quiz ini? Semua data soal dan jawaban akan terhapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteQuiz(quizId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteQuiz(String quizId) async {
    try {
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Menghapus quiz...'),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }

      final firestore = FirebaseFirestore.instance;

      // 1. Get all soal for this quiz
      final soalSnapshot = await firestore
          .collection('quiz_soal')
          .where('id_quiz', isEqualTo: int.parse(quizId))
          .get();

      // 2. Delete all jawaban for each soal
      for (var soalDoc in soalSnapshot.docs) {
        final jawabanSnapshot = await firestore
            .collection('quiz_jawaban')
            .where('id_soal', isEqualTo: int.parse(soalDoc.id))
            .get();

        for (var jawabanDoc in jawabanSnapshot.docs) {
          await jawabanDoc.reference.delete();
        }

        // 3. Delete soal
        await soalDoc.reference.delete();
      }

      // 4. Delete quiz
      await firestore.collection('quiz').doc(quizId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Quiz berhasil dihapus'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: $e')),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      '$huruf. ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
