import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/config/theme.dart';
import '../widgets/admin_header.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AdminHeader(
        title: 'Analytics',
        icon: Icons.analytics,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

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
            .where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['status'] == 'hadir';
        })
            .length
            .toDouble();
        final sakit = absensiDocs
            .where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['status'] == 'sakit';
        })
            .length
            .toDouble();
        final izin = absensiDocs
            .where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['status'] == 'izin';
        })
            .length
            .toDouble();
        final alpha = absensiDocs
            .where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null && data['status'] == 'alpha';
        })
            .length
            .toDouble();

        final totalStatus = hadir + sakit + izin + alpha;

        if (totalStatus == 0 && absensiDocs.isNotEmpty) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Statistik Kehadiran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Ada ${absensiDocs.length} dokumen, tapi status kosong.', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          );
        }

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
                // Fixed LayoutBuilder block
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 600;

                    // 1. Define the Pie Chart Widget
                    Widget pie = SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 3,
                          centerSpaceRadius: 50,
                          sections: [
                            if (hadir > 0)
                              _buildPieSection(hadir, totalStatus, AppTheme.accentGreen, Icons.check_circle),
                            if (sakit > 0)
                              _buildPieSection(sakit, totalStatus, AppTheme.accentOrange, Icons.medical_services),
                            if (izin > 0)
                              _buildPieSection(izin, totalStatus, AppTheme.primaryPurple, Icons.info_outline),
                            if (alpha > 0)
                              _buildPieSection(alpha, totalStatus, Colors.red.shade400, Icons.cancel),
                          ],
                        ),
                      ),
                    );

                    // 2. Define the Legend Widget
                    Widget legend = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildEnhancedLegendItem('Hadir', Colors.green, hadir.toInt(), totalStatus, Icons.check_circle),
                        const SizedBox(height: 12),
                        _buildEnhancedLegendItem('Sakit', Colors.orange, sakit.toInt(), totalStatus, Icons.medical_services),
                        const SizedBox(height: 12),
                        _buildEnhancedLegendItem('Izin', Colors.purple, izin.toInt(), totalStatus, Icons.info_outline),
                        const SizedBox(height: 12),
                        _buildEnhancedLegendItem('Alpha', Colors.red, alpha.toInt(), totalStatus, Icons.cancel),
                      ],
                    );

                    // 3. Return the layout based on constraints
                    if (isNarrow) {
                      return Column(
                        children: [
                          pie,
                          const SizedBox(height: 24),
                          legend,
                        ],
                      );
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: pie),
                          const SizedBox(width: 24),
                          Expanded(flex: 2, child: legend),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper to reduce code duplication in Pie Chart sections
  PieChartSectionData _buildPieSection(double value, double total, Color color, IconData icon) {
    return PieChartSectionData(
      value: value,
      title: '${((value / total) * 100).toStringAsFixed(1)}%',
      color: color,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
        shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
      ),
      radius: 100,
      titlePositionPercentageOffset: 0.55,
      badgeWidget: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 4, spreadRadius: 2),
          ],
        ),
        child: Icon(icon, color: color, size: 16),
      ),
      badgePositionPercentageOffset: 1.2,
    );
  }

  Widget _buildPengumpulanStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('tugas').snapshots(),
      builder: (context, tugasSnapshot) {
        if (tugasSnapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!tugasSnapshot.hasData || tugasSnapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('Belum ada tugas');
        }

        final totalTugas = tugasSnapshot.data!.docs.length;

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('pengumpulan').snapshots(),
          builder: (context, pengumpulanSnapshot) {
            int terkumpul = 0;

            if (pengumpulanSnapshot.hasData) {
              terkumpul = pengumpulanSnapshot.data!.docs.length;
            }

            final persentase = totalTugas > 0
                ? ((terkumpul / totalTugas) * 100).toInt()
                : 0;

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
                          child: const Icon(
                            Icons.assignment,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Statistik Pengumpulan Tugas',
                          style: TextStyle(
                            fontSize: 16,
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
                            totalTugas.toString(),
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatBox(
                            'Terkumpul',
                            terkumpul.toString(),
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
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
      padding: const EdgeInsets.all(12),
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedLegendItem(
    String label,
    Color color,
    int count,
    double total,
    IconData icon,
  ) {
    final percentage = total > 0 ? (count / total) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count siswa',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
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
