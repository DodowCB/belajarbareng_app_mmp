import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../../core/config/theme.dart';
import '../../widgets/guru_app_scaffold.dart';

class QuizDetailScreen extends StatefulWidget {
  final String quizId;
  final String judul;

  const QuizDetailScreen({
    super.key,
    required this.quizId,
    required this.judul,
  });

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _geminiApiKey;
  bool _isLoadingApiKey = true;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    try {
      final doc = await _firestore
          .collection('settings')
          .doc('gemini_api')
          .get();
      if (doc.exists) {
        setState(() {
          _geminiApiKey = doc.data()?['api_key'];
          _isLoadingApiKey = false;
        });
      } else {
        setState(() {
          _isLoadingApiKey = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingApiKey = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GuruAppScaffold(
      title: widget.judul,
      icon: Icons.quiz,
      currentRoute: '/quiz/detail',
      additionalActions: [
        if (_isLoadingApiKey)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_geminiApiKey == null)
          IconButton(
            icon: const Icon(Icons.key, color: Colors.orange),
            onPressed: () => _showApiKeyDialog(context),
            tooltip: 'Setup Gemini API Key',
          )
        else
          IconButton(
            icon: const Icon(Icons.key, color: Colors.green),
            onPressed: () => _showApiKeyDialog(context),
            tooltip: 'Gemini API Key Active',
          ),
      ],
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('quiz_soal')
            .where('id_quiz', isEqualTo: int.parse(widget.quizId))
            .snapshots(),
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

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final soalDoc = snapshot.data!.docs[index];
              final soalData = soalDoc.data() as Map<String, dynamic>;
              return _buildSoalCard(soalDoc.id, soalData, index + 1);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada soal',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoalCard(
    String soalId,
    Map<String, dynamic> soalData,
    int nomor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                    'Soal $nomor',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: soalData['tipe'] == 'single'
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    soalData['tipe'] == 'single'
                        ? 'Single Answer'
                        : 'Multiple Answer',
                    style: TextStyle(
                      color: soalData['tipe'] == 'single'
                          ? Colors.blue[700]
                          : Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _editSoal(soalId, soalData),
                  icon: const Icon(Icons.edit, size: 20),
                  tooltip: 'Edit Soal',
                ),
                IconButton(
                  onPressed: () => _deleteSoal(soalId),
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  tooltip: 'Hapus Soal',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              soalData['pertanyaan'] ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('quiz_jawaban')
                  .where('id_soal', isEqualTo: int.parse(soalId))
                  .snapshots(),
              builder: (context, jawabanSnapshot) {
                if (!jawabanSnapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final jawabanDocs = jawabanSnapshot.data!.docs;

                return Column(
                  children: jawabanDocs.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final jawabanDoc = entry.value;
                    final jawabanData =
                        jawabanDoc.data() as Map<String, dynamic>;
                    final huruf = String.fromCharCode(97 + idx);
                    final isCorrect = jawabanData['is_correct'] ?? false;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? Colors.green.withOpacity(0.1)
                            : (isDark ? Colors.grey[850] : Colors.grey[50]),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCorrect
                              ? Colors.green
                              : (isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!),
                          width: isCorrect ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (soalData['tipe'] == 'single')
                            Icon(
                              isCorrect
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isCorrect ? Colors.green : Colors.grey,
                              size: 20,
                            )
                          else
                            Icon(
                              isCorrect
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isCorrect ? Colors.green : Colors.grey,
                              size: 20,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            '$huruf. ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              jawabanData['jawaban'] ?? '',
                              style: TextStyle(
                                fontWeight: isCorrect
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isCorrect)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            if (_geminiApiKey != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _checkWithAI(soalData['pertanyaan'], soalId),
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Periksa dengan AI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController(text: _geminiApiKey);
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.key, color: Colors.orange),
            SizedBox(width: 12),
            Text('Gemini API Key'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dapatkan API key gratis dari:',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            const Text(
              'https://aistudio.google.com/app/apikey',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
                hintText: 'Masukkan Gemini API Key',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firestore.collection('settings').doc('gemini_api').set({
                  'api_key': controller.text.trim(),
                });
                setState(() {
                  _geminiApiKey = controller.text.trim();
                });
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('API Key berhasil disimpan'),
                      backgroundColor: Colors.green,
                    ),
                  );
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkWithAI(String pertanyaan, String soalId) async {
    if (_geminiApiKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Setup Gemini API Key terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('AI sedang memeriksa...'),
          ],
        ),
      ),
    );

    try {
      // Get jawaban
      final jawabanSnap = await _firestore
          .collection('quiz_jawaban')
          .where('id_soal', isEqualTo: int.parse(soalId))
          .get();

      final jawabanList = jawabanSnap.docs.map((doc) {
        final data = doc.data();
        return {'text': data['jawaban'], 'is_correct': data['is_correct']};
      }).toList();

      // Build prompt
      final prompt =
          '''
Saya memiliki soal quiz berikut:

Pertanyaan: $pertanyaan

Opsi Jawaban:
${jawabanList.asMap().entries.map((e) {
            final huruf = String.fromCharCode(97 + e.key);
            final marked = e.value['is_correct'] ? ' [DITANDAI BENAR]' : '';
            return '$huruf. ${e.value['text']}$marked';
          }).join('\n')}

Tolong analisis soal di atas dan berikan penilaian dengan format berikut:

1. STATUS: (tuliskan "Benar" atau "Perlu Perbaikan")

2. ANALISIS:
(jelaskan apakah jawaban yang ditandai benar sudah tepat)

3. SARAN:
(jika ada kesalahan, berikan saran perbaikan yang jelas)

Gunakan bahasa Indonesia yang sederhana dan mudah dipahami. Jangan gunakan simbol markdown seperti asterisk atau tanda bintang.
''';

      // Call Gemini API using GenerativeModel
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _geminiApiKey!,
      );

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
      }

      if (response.text != null && response.text!.isNotEmpty) {
        if (context.mounted) {
          _showAIResultDialog(response.text!);
        }
      } else {
        throw Exception('No response from AI');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        // Show detailed error
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 12),
                Text('Error'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Terjadi kesalahan saat menghubungi API Gemini:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(e.toString()),
                  const SizedBox(height: 16),
                  const Text(
                    'Pastikan:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('1. API Key sudah benar'),
                  const Text('2. API Key sudah aktif di Google AI Studio'),
                  const Text('3. Koneksi internet stabil'),
                  const SizedBox(height: 16),
                  const Text(
                    'Cara mendapatkan API Key:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'https://aistudio.google.com/app/apikey',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showApiKeyDialog(context);
                },
                child: const Text('Update API Key'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showAIResultDialog(String result) {
    // Clean up markdown symbols
    final cleanResult = result
        .replaceAll('**', '')
        .replaceAll('*', '')
        .replaceAll('###', '')
        .replaceAll('##', '')
        .replaceAll('#', '')
        .trim();

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.purple),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Hasil Pemeriksaan AI',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 500),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.withOpacity(0.3)),
                  ),
                  child: Text(
                    cleanResult,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.purple),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _editSoal(String soalId, Map<String, dynamic> soalData) async {
    // Get jawaban
    final jawabanSnap = await _firestore
        .collection('quiz_jawaban')
        .where('id_soal', isEqualTo: int.parse(soalId))
        .get();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (c) => EditSoalDialog(
          soalId: soalId,
          soalData: soalData,
          jawabanDocs: jawabanSnap.docs,
          onSave: () {
            setState(() {});
          },
        ),
      );
    }
  }

  void _deleteSoal(String soalId) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hapus Soal'),
        content: const Text('Yakin ingin menghapus soal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Delete jawaban
                final jawabanSnap = await _firestore
                    .collection('quiz_jawaban')
                    .where('id_soal', isEqualTo: int.parse(soalId))
                    .get();
                for (var doc in jawabanSnap.docs) {
                  await doc.reference.delete();
                }

                // Delete soal
                await _firestore.collection('quiz_soal').doc(soalId).delete();

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Soal berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class EditSoalDialog extends StatefulWidget {
  final String soalId;
  final Map<String, dynamic> soalData;
  final List<QueryDocumentSnapshot> jawabanDocs;
  final VoidCallback onSave;

  const EditSoalDialog({
    super.key,
    required this.soalId,
    required this.soalData,
    required this.jawabanDocs,
    required this.onSave,
  });

  @override
  State<EditSoalDialog> createState() => _EditSoalDialogState();
}

class _EditSoalDialogState extends State<EditSoalDialog> {
  late TextEditingController _pertanyaanController;
  late String _tipe;
  late List<JawabanEditItem> _jawaban;

  @override
  void initState() {
    super.initState();
    _pertanyaanController = TextEditingController(
      text: widget.soalData['pertanyaan'],
    );
    _tipe = widget.soalData['tipe'];
    _jawaban = widget.jawabanDocs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return JawabanEditItem(
        id: doc.id,
        controller: TextEditingController(text: data['jawaban']),
        isCorrect: data['is_correct'] ?? false,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.edit, color: AppTheme.primaryPurple),
                const SizedBox(width: 12),
                const Text(
                  'Edit Soal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _pertanyaanController,
                      decoration: const InputDecoration(
                        labelText: 'Pertanyaan',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _tipe,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Jawaban',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'single',
                          child: Text('Single Answer'),
                        ),
                        DropdownMenuItem(
                          value: 'multiple',
                          child: Text('Multiple Answer'),
                        ),
                      ],
                      onChanged: (v) {
                        setState(() {
                          _tipe = v!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Jawaban:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ..._jawaban.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final jawaban = entry.value;
                      final huruf = String.fromCharCode(97 + idx);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            if (_tipe == 'single')
                              Radio<int>(
                                value: idx,
                                groupValue: _jawaban.indexWhere(
                                  (j) => j.isCorrect,
                                ),
                                onChanged: (v) {
                                  setState(() {
                                    for (var j in _jawaban) {
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: jawaban.controller,
                                decoration: InputDecoration(
                                  hintText: 'Isi jawaban $huruf',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
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
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
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

  Future<void> _saveChanges() async {
    try {
      // Update soal
      await FirebaseFirestore.instance
          .collection('quiz_soal')
          .doc(widget.soalId)
          .update({'pertanyaan': _pertanyaanController.text, 'tipe': _tipe});

      // Update jawaban
      for (var jawaban in _jawaban) {
        await FirebaseFirestore.instance
            .collection('quiz_jawaban')
            .doc(jawaban.id)
            .update({
              'jawaban': jawaban.controller.text,
              'is_correct': jawaban.isCorrect,
            });
      }

      if (context.mounted) {
        Navigator.pop(context);
        widget.onSave();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Soal berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class JawabanEditItem {
  final String id;
  final TextEditingController controller;
  bool isCorrect;

  JawabanEditItem({
    required this.id,
    required this.controller,
    required this.isCorrect,
  });
}
