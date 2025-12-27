import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.check_circle), text: 'Absensi'),
            Tab(icon: Icon(Icons.assignment), text: 'Tugas'),
            Tab(icon: Icon(Icons.library_books), text: 'Materi'),
            Tab(icon: Icon(Icons.quiz), text: 'Quiz'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAbsensiReport(),
          _buildTugasReport(),
          _buildMateriReport(),
          _buildQuizReport(),
        ],
      ),
    );
  }

  Widget _buildAbsensiReport() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('absensi').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.check_circle_outline,
            message: 'Belum ada data absensi',
          );
        }

        final absensiDocs = snapshot.data!.docs;
        final totalAbsensi = absensiDocs.length;
        final hadir = absensiDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['status'] == 'hadir';
        }).length;
        final sakit = absensiDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['status'] == 'sakit';
        }).length;
        final izin = absensiDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['status'] == 'izin';
        }).length;
        final alpha = absensiDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['status'] == 'alpha';
        }).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(
                title: 'Ringkasan Absensi',
                icon: Icons.summarize,
                color: Colors.green,
                items: [
                  _buildSummaryItem(
                    'Total Absensi',
                    totalAbsensi.toString(),
                    Colors.blue,
                  ),
                  _buildSummaryItem('Hadir', hadir.toString(), Colors.green),
                  _buildSummaryItem('Sakit', sakit.toString(), Colors.orange),
                  _buildSummaryItem('Izin', izin.toString(), Colors.purple),
                  _buildSummaryItem('Alpha', alpha.toString(), Colors.red),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Detail Absensi',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: absensiDocs.length,
                itemBuilder: (context, index) {
                  final doc = absensiDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildAbsensiItem(data);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTugasReport() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('pengumpulan').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.assignment_outlined,
            message: 'Belum ada pengumpulan tugas',
          );
        }

        final pengumpulanDocs = snapshot.data!.docs;
        final totalPengumpulan = pengumpulanDocs.length;
        final terkumpul = pengumpulanDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['status'] == 'Terkumpul';
        }).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(
                title: 'Ringkasan Pengumpulan Tugas',
                icon: Icons.assignment,
                color: Colors.orange,
                items: [
                  _buildSummaryItem(
                    'Total Pengumpulan',
                    totalPengumpulan.toString(),
                    Colors.blue,
                  ),
                  _buildSummaryItem(
                    'Terkumpul',
                    terkumpul.toString(),
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Detail Pengumpulan',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pengumpulanDocs.length,
                itemBuilder: (context, index) {
                  final doc = pengumpulanDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildPengumpulanItem(data);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMateriReport() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('materi').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.library_books_outlined,
            message: 'Belum ada materi',
          );
        }

        final materiDocs = snapshot.data!.docs;
        final totalMateri = materiDocs.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(
                title: 'Ringkasan Materi',
                icon: Icons.library_books,
                color: Colors.purple,
                items: [
                  _buildSummaryItem(
                    'Total Materi',
                    totalMateri.toString(),
                    Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Daftar Materi',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: materiDocs.length,
                itemBuilder: (context, index) {
                  final doc = materiDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildMateriItem(data);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuizReport() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('quiz').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.quiz_outlined,
            message: 'Belum ada quiz',
          );
        }

        final quizDocs = snapshot.data!.docs;
        final totalQuiz = quizDocs.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(
                title: 'Ringkasan Quiz',
                icon: Icons.quiz,
                color: Colors.teal,
                items: [
                  _buildSummaryItem(
                    'Total Quiz',
                    totalQuiz.toString(),
                    Colors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Daftar Quiz',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quizDocs.length,
                itemBuilder: (context, index) {
                  final doc = quizDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildQuizItem(data);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> items,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 12, children: items),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsensiItem(Map<String, dynamic> data) {
    final status = data['status'] ?? 'Unknown';
    Color statusColor;
    String displayStatus;

    switch (status.toString().toLowerCase()) {
      case 'hadir':
        statusColor = Colors.green;
        displayStatus = 'Hadir';
        break;
      case 'sakit':
        statusColor = Colors.orange;
        displayStatus = 'Sakit';
        break;
      case 'izin':
        statusColor = Colors.purple;
        displayStatus = 'Izin';
        break;
      case 'alpha':
        statusColor = Colors.red;
        displayStatus = 'Alpha';
        break;
      default:
        statusColor = Colors.grey;
        displayStatus = status.toString();
    }

    final timestamp = data['tanggal'] as Timestamp?;
    final dateStr = timestamp != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(timestamp.toDate())
        : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.person, color: statusColor),
        ),
        title: Text('Siswa ID: ${data['siswa_id'] ?? '-'}'),
        subtitle: Text('Kelas ID: ${data['kelas_id'] ?? '-'}\n$dateStr'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            displayStatus,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPengumpulanItem(Map<String, dynamic> data) {
    final timestamp = data['createdAt'] as Timestamp?;
    final dateStr = timestamp != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(timestamp.toDate())
        : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.assignment, color: Colors.white),
        ),
        title: Text('Siswa ID: ${data['siswa_id'] ?? '-'}'),
        subtitle: Text('Tugas ID: ${data['tugas_id'] ?? '-'}\n$dateStr'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Terkumpul',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildMateriItem(Map<String, dynamic> data) {
    final timestamp = data['createdAt'] as Timestamp?;
    final dateStr = timestamp != null
        ? DateFormat('dd MMM yyyy').format(timestamp.toDate())
        : '-';

    final idGuru = data['id_guru'];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.purple,
          child: Icon(Icons.library_books, color: Colors.white),
        ),
        title: Text(data['judul'] ?? 'Materi'),
        subtitle: idGuru != null
            ? FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('guru').doc(idGuru).get(),
                builder: (context, guruSnapshot) {
                  String namaGuru = 'Loading...';

                  if (guruSnapshot.connectionState == ConnectionState.done) {
                    if (guruSnapshot.hasData && guruSnapshot.data!.exists) {
                      final guruData =
                          guruSnapshot.data!.data() as Map<String, dynamic>?;
                      namaGuru =
                          guruData?['nama_lengkap'] ?? 'Guru tidak ditemukan';
                    } else {
                      namaGuru = 'Guru tidak ditemukan';
                    }
                  }

                  return Text(
                    'Kelas ID: ${data['id_kelas'] ?? '-'}\n'
                    'Upload: $dateStr\n'
                    'Oleh: $namaGuru',
                  );
                },
              )
            : Text(
                'Kelas ID: ${data['id_kelas'] ?? '-'}\n'
                'Upload: $dateStr\n'
                'Oleh: -',
              ),
      ),
    );
  }

  Widget _buildQuizItem(Map<String, dynamic> data) {
    final timestamp = data['createdAt'] as Timestamp?;
    final dateStr = timestamp != null
        ? DateFormat('dd MMM yyyy').format(timestamp.toDate())
        : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.quiz, color: Colors.white),
        ),
        title: Text(data['judul'] ?? 'Quiz'),
        subtitle: Text(
          'Kelas ID: ${data['id_kelas'] ?? '-'}\n'
          'Waktu: ${data['waktu'] ?? 0} menit\n'
          'Dibuat: $dateStr',
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
