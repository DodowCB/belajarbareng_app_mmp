import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/config/theme.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../widgets/guru_app_scaffold.dart';

class CreateQuizScreen extends StatefulWidget {
  final Map<String, dynamic>? quizData;
  final List<Map<String, String>> kelasList;
  final List<Map<String, String>> mapelList;

  const CreateQuizScreen({
    super.key,
    this.quizData,
    required this.kelasList,
    required this.mapelList,
  });

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final judulController = TextEditingController();
  int waktuMenit = 30;
  String? selectedKelasId;
  String? selectedMapelId;
  List<SoalItem> soalList = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.quizData != null) {
      judulController.text = widget.quizData!['judul'] ?? '';
      final waktuValue = widget.quizData!['waktu'];
      if (waktuValue != null) {
        if (waktuValue is int) {
          waktuMenit = waktuValue;
        } else if (waktuValue is String) {
          waktuMenit = int.tryParse(waktuValue) ?? 30;
        }
      }
      selectedKelasId = widget.quizData!['id_kelas']?.toString();
      selectedMapelId = widget.quizData!['id_mapel']?.toString();
      _loadQuizSoal();
    }
  }

  Future<void> _loadQuizSoal() async {
    try {
      final quizId = widget.quizData!['id']?.toString();
      if (quizId == null) return;

      // Load soal
      final soalSnapshot = await _firestore
          .collection('quiz_soal')
          .where('id_quiz', isEqualTo: int.parse(quizId))
          .get();

      for (var soalDoc in soalSnapshot.docs) {
        final soalData = soalDoc.data();
        final soalItem = SoalItem();
        soalItem.pertanyaanController.text = soalData['pertanyaan'] ?? '';
        soalItem.tipe = soalData['tipe'] ?? 'single';
        soalItem.idSoal = soalDoc.id;

        // Load jawaban untuk soal ini
        final jawabanSnapshot = await _firestore
            .collection('quiz_jawaban')
            .where('id_soal', isEqualTo: int.parse(soalDoc.id))
            .get();

        for (var jawabanDoc in jawabanSnapshot.docs) {
          final jawabanData = jawabanDoc.data();
          final jawabanItem = JawabanItem();
          jawabanItem.controller.text = jawabanData['jawaban'] ?? '';
          jawabanItem.isCorrect = jawabanData['is_correct'] ?? false;
          jawabanItem.idJawaban = jawabanDoc.id;
          soalItem.jawaban.add(jawabanItem);
        }

        soalList.add(soalItem);
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading quiz soal: $e');
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    for (var soal in soalList) {
      soal.pertanyaanController.dispose();
      for (var jawaban in soal.jawaban) {
        jawaban.controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GuruAppScaffold(
      title: widget.quizData == null ? 'Buat Quiz Baru' : 'Edit Quiz',
      icon: Icons.quiz,
      currentRoute: '/quiz/create',
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoCard(isDark),
                    const SizedBox(height: 24),
                    _buildTimerCard(isDark),
                    const SizedBox(height: 24),
                    _buildSoalSection(isDark),
                  ],
                ),
              ),
            ),
            _buildBottomBar(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.sunsetGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.info, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Informasi Dasar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: judulController,
            decoration: InputDecoration(
              labelText: 'Judul Quiz',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedKelasId,
            isExpanded: true,
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
            isExpanded: true,
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
        ],
      ),
    );
  }

  Widget _buildTimerCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.timer,
                  color: AppTheme.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Durasi Quiz',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 40,
                    color: AppTheme.primaryPurple,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Text(
                        '$waktuMenit',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPurple,
                          height: 1,
                        ),
                      ),
                      Text(
                        'menit',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryPurple,
              inactiveTrackColor: AppTheme.primaryPurple.withOpacity(0.2),
              thumbColor: AppTheme.primaryPurple,
              overlayColor: AppTheme.primaryPurple.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            ),
            child: Slider(
              value: waktuMenit.toDouble(),
              min: 5,
              max: 180,
              divisions: 35,
              label: '$waktuMenit menit',
              onChanged: (value) {
                setState(() {
                  waktuMenit = value.toInt();
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickTimeButton(15),
              _buildQuickTimeButton(30),
              _buildQuickTimeButton(45),
              _buildQuickTimeButton(60),
              _buildQuickTimeButton(90),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5 min',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                '180 min',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTimeButton(int minutes) {
    final isSelected = waktuMenit == minutes;

    return InkWell(
      onTap: () {
        setState(() {
          waktuMenit = minutes;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryPurple
              : AppTheme.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.primaryPurple.withOpacity(isSelected ? 1 : 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          '${minutes}m',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppTheme.primaryPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildSoalSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.question_answer,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Flexible(
                    child: Text(
                      'Soal-soal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
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
          if (soalList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada soal',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Klik "Tambah Soal" untuk mulai membuat soal',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
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
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 12,
        runSpacing: 12,
        children: [
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Batal'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveQuiz,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveQuiz() async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi informasi dasar quiz'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (soalList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon tambahkan minimal 1 soal'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate all soal
    for (int i = 0; i < soalList.length; i++) {
      final soal = soalList[i];
      if (soal.pertanyaanController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pertanyaan soal ${i + 1} tidak boleh kosong'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (soal.jawaban.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Soal ${i + 1} harus memiliki minimal 1 jawaban'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      bool hasCorrect = soal.jawaban.any((j) => j.isCorrect);
      if (!hasCorrect) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Soal ${i + 1} harus memiliki jawaban yang benar'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final userProv = UserProvider();
      final idGuru = userProv.userId;

      if (idGuru == null) {
        throw Exception('User tidak login');
      }

      final isEditing = widget.quizData != null;
      final quizId = isEditing
          ? widget.quizData!['id'].toString()
          : (await _firestore.collection('quiz').get()).docs.length + 1;

      // Simpan atau update quiz
      await _firestore.collection('quiz').doc(quizId.toString()).set({
        'id_guru': int.parse(idGuru),
        'id_kelas': int.parse(selectedKelasId!),
        'id_mapel': int.parse(selectedMapelId!),
        'judul': judulController.text.trim(),
        'waktu': waktuMenit,
        if (!isEditing) 'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Jika editing, hapus soal dan jawaban lama
      if (isEditing) {
        final oldSoalSnapshot = await _firestore
            .collection('quiz_soal')
            .where('id_quiz', isEqualTo: int.parse(quizId.toString()))
            .get();

        for (var soalDoc in oldSoalSnapshot.docs) {
          // Hapus jawaban lama
          final oldJawabanSnapshot = await _firestore
              .collection('quiz_jawaban')
              .where('id_soal', isEqualTo: int.parse(soalDoc.id))
              .get();

          for (var jawabanDoc in oldJawabanSnapshot.docs) {
            await jawabanDoc.reference.delete();
          }

          // Hapus soal
          await soalDoc.reference.delete();
        }
      }

      // Simpan soal-soal baru
      for (int i = 0; i < soalList.length; i++) {
        final soal = soalList[i];
        final soalSnapshot = await _firestore.collection('quiz_soal').get();
        final nextSoalId = (soalSnapshot.docs.length + 1).toString();

        await _firestore.collection('quiz_soal').doc(nextSoalId).set({
          'id_quiz': int.parse(quizId.toString()),
          'pertanyaan': soal.pertanyaanController.text.trim(),
          'tipe': soal.tipe,
        });

        // Simpan jawaban-jawaban
        for (final jawaban in soal.jawaban) {
          final jawabanSnapshot = await _firestore
              .collection('quiz_jawaban')
              .get();
          final nextJawabanId = (jawabanSnapshot.docs.length + 1).toString();

          await _firestore.collection('quiz_jawaban').doc(nextJawabanId).set({
            'id_soal': int.parse(nextSoalId),
            'jawaban': jawaban.controller.text.trim(),
            'is_correct': jawaban.isCorrect,
          });
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Quiz berhasil diperbarui'
                  : 'Quiz berhasil dibuat',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

class SoalItem {
  final TextEditingController pertanyaanController = TextEditingController();
  String tipe = 'single';
  List<JawabanItem> jawaban = [];
  String? idSoal;

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
  String? idJawaban;
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
            isExpanded: true,
            items: const [
              DropdownMenuItem(
                value: 'single',
                child: Flexible(
                  child: Text(
                    'Single Answer (Pilihan Ganda)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'multiple',
                child: Flexible(
                  child: Text(
                    'Multiple Answer (Pilihan Ganda Kompleks)',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
            final huruf = String.fromCharCode(97 + idx);

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
