import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/config/theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.deepPurple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.analytics,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Analytics',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Insights and statistics',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Absensi Chart
            _buildAbsensiChart(),
            const SizedBox(height: 24),

            // Pengumpulan Tugas Stats
            _buildPengumpulanStats(),
            const SizedBox(height: 24),

            // Quiz Statistics
            _buildQuizStats(),
            const SizedBox(height: 24),

            // Materi Distribution
            _buildMateriDistribution(),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsensiChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('absensi').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('Belum ada data absensi');
        }

        final absensiDocs = snapshot.data!.docs;
        final hadir = absensiDocs
            .where((doc) => doc['status'] == 'Hadir')
            .length
            .toDouble();
        final sakit = absensiDocs
            .where((doc) => doc['status'] == 'Sakit')
            .length
            .toDouble();
        final izin = absensiDocs
            .where((doc) => doc['status'] == 'Izin')
            .length
            .toDouble();
        final alpha = absensiDocs
            .where((doc) => doc['status'] == 'Alpha')
            .length
            .toDouble();

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Statistik Kehadiran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        if (hadir > 0)
                          PieChartSectionData(
                            value: hadir,
                            title: '${hadir.toInt()}',
                            color: Colors.green,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            radius: 80,
                          ),
                        if (sakit > 0)
                          PieChartSectionData(
                            value: sakit,
                            title: '${sakit.toInt()}',
                            color: Colors.orange,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            radius: 80,
                          ),
                        if (izin > 0)
                          PieChartSectionData(
                            value: izin,
                            title: '${izin.toInt()}',
                            color: Colors.purple,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            radius: 80,
                          ),
                        if (alpha > 0)
                          PieChartSectionData(
                            value: alpha,
                            title: '${alpha.toInt()}',
                            color: Colors.red,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            radius: 80,
                          ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildLegendItem('Hadir', Colors.green, hadir.toInt()),
                    _buildLegendItem('Sakit', Colors.orange, sakit.toInt()),
                    _buildLegendItem('Izin', Colors.purple, izin.toInt()),
                    _buildLegendItem('Alpha', Colors.red, alpha.toInt()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPengumpulanStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('pengumpulan').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('Belum ada pengumpulan tugas');
        }

        final pengumpulanDocs = snapshot.data!.docs;
        final total = pengumpulanDocs.length;
        final terkumpul = pengumpulanDocs
            .where((doc) => doc['status'] == 'Terkumpul')
            .length;
        final persentase = total > 0 ? ((terkumpul / total) * 100).toInt() : 0;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.assignment, color: Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Statistik Pengumpulan Tugas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatBox(
                        'Total Tugas',
                        total.toString(),
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                        'Terkumpul',
                        terkumpul.toString(),
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                        'Tingkat',
                        '$persentase%',
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('quiz').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('Belum ada quiz');
        }

        final quizDocs = snapshot.data!.docs;
        final totalQuiz = quizDocs.length;
        final totalSoalFuture = _getTotalQuizSoal();

        return FutureBuilder<int>(
          future: totalSoalFuture,
          builder: (context, soalSnapshot) {
            final totalSoal = soalSnapshot.data ?? 0;

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.quiz, color: Colors.teal),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Statistik Quiz',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatBox(
                            'Total Quiz',
                            totalQuiz.toString(),
                            Colors.teal,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatBox(
                            'Total Soal',
                            totalSoal.toString(),
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMateriDistribution() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('materi').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('Belum ada materi');
        }

        final materiDocs = snapshot.data!.docs;
        final totalMateri = materiDocs.length;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.library_books,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Distribusi Materi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildStatBox(
                  'Total Materi',
                  totalMateri.toString(),
                  Colors.purple,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int> _getTotalQuizSoal() async {
    try {
      final snapshot = await _firestore.collection('quiz_soal').get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text('$label: $count', style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildEmptyCard(String message) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
