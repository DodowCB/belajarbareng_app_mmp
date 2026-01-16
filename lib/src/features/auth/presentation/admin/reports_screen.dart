import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme.dart';
import '../widgets/admin_header.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Search and filter controllers
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _filterSiswaId;
  String? _filterKelasId;

  // Sorting
  String _sortBy = 'id'; // 'id', 'nama', 'kelas'
  bool _sortAscending = true;

  // Cache for student and class data
  Map<String, Map<String, dynamic>> _siswaCache = {};
  Map<String, Map<String, dynamic>> _kelasCache = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCacheData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCacheData() async {
    // Load siswa data
    final siswaSnapshot = await _firestore.collection('siswa').get();
    for (var doc in siswaSnapshot.docs) {
      _siswaCache[doc.id] = doc.data();
    }

    // Load kelas data
    final kelasSnapshot = await _firestore.collection('kelas').get();
    for (var doc in kelasSnapshot.docs) {
      _kelasCache[doc.id] = doc.data();
    }

    if (mounted) setState(() {});
  }

  String _getSiswaName(dynamic siswaId) {
    final id = siswaId.toString();
    return _siswaCache[id]?['nama'] ?? 'Unknown';
  }

  String _getKelasName(dynamic kelasId) {
    final id = kelasId.toString();
    return _kelasCache[id]?['nama_kelas'] ?? 'Kelas ID: $id';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AdminHeader(title: 'Reports', icon: Icons.assessment),
      body: Column(
        children: [
          // Tab bar container matching admin styles
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    Theme.of(context).brightness == Brightness.dark
                        ? 0.3
                        : 0.05,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor:
                  Theme.of(context).textTheme.titleMedium?.color ??
                  AppTheme.textPrimary,
              unselectedLabelColor:
                  (Theme.of(context).textTheme.titleMedium?.color ??
                          AppTheme.textPrimary)
                      .withOpacity(0.7),
              indicatorColor: AppTheme.primaryPurple,
              isScrollable: false,
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: const [
                Tab(icon: Icon(Icons.check_circle), text: 'Absensi'),
                Tab(icon: Icon(Icons.assignment), text: 'Tugas'),
                Tab(icon: Icon(Icons.library_books), text: 'Materi'),
                Tab(icon: Icon(Icons.quiz), text: 'Quiz'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAbsensiReport(),
                _buildTugasReport(),
                _buildMateriReport(),
                _buildQuizReport(),
              ],
            ),
          ),
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

        var absensiDocs = snapshot.data!.docs;

        // Apply filters
        if (_filterSiswaId != null && _filterSiswaId!.isNotEmpty) {
          absensiDocs = absensiDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['siswa_id'].toString() == _filterSiswaId;
          }).toList();
        }

        if (_filterKelasId != null && _filterKelasId!.isNotEmpty) {
          absensiDocs = absensiDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['kelas_id'].toString() == _filterKelasId;
          }).toList();
        }

        // Apply search
        if (_searchQuery.isNotEmpty) {
          absensiDocs = absensiDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final siswaName = _getSiswaName(data['siswa_id']).toLowerCase();
            final kelasName = _getKelasName(data['kelas_id']).toLowerCase();
            final status = (data['status'] ?? '').toString().toLowerCase();
            return siswaName.contains(_searchQuery.toLowerCase()) ||
                kelasName.contains(_searchQuery.toLowerCase()) ||
                status.contains(_searchQuery.toLowerCase());
          }).toList();
        }

        // Apply sorting
        absensiDocs.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;

          int comparison = 0;

          switch (_sortBy) {
            case 'id':
              // Try to parse as numbers first for proper numeric sorting
              final idAStr = dataA['siswa_id']?.toString() ?? '0';
              final idBStr = dataB['siswa_id']?.toString() ?? '0';
              final idANum = int.tryParse(idAStr);
              final idBNum = int.tryParse(idBStr);

              if (idANum != null && idBNum != null) {
                // Both are numbers, compare numerically
                comparison = idANum.compareTo(idBNum);
              } else {
                // Fall back to string comparison
                comparison = idAStr.compareTo(idBStr);
              }
              break;
            case 'nama':
              final namaA = _getSiswaName(dataA['siswa_id']).toLowerCase();
              final namaB = _getSiswaName(dataB['siswa_id']).toLowerCase();
              comparison = namaA.compareTo(namaB);
              break;
            case 'kelas':
              final kelasA = _getKelasName(dataA['kelas_id']).toLowerCase();
              final kelasB = _getKelasName(dataB['kelas_id']).toLowerCase();
              comparison = kelasA.compareTo(kelasB);
              break;
          }

          return _sortAscending ? comparison : -comparison;
        });

        final totalAbsensi = absensiDocs.length;
        final hadir = absensiDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null &&
              data['status']?.toString().toLowerCase() == 'hadir';
        }).length;
        final sakit = absensiDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null &&
              data['status']?.toString().toLowerCase() == 'sakit';
        }).length;
        final izin = absensiDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null &&
              data['status']?.toString().toLowerCase() == 'izin';
        }).length;
        final alpha = absensiDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return data != null &&
              data['status']?.toString().toLowerCase() == 'alpa';
        }).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(
                title: 'Ringkasan Absensi',
                icon: Icons.summarize,
                color: AppTheme.accentGreen,
                items: [
                  _buildSummaryItem(
                    'Total Absensi',
                    totalAbsensi.toString(),
                    AppTheme.primaryPurple,
                  ),
                  _buildSummaryItem(
                    'Hadir',
                    hadir.toString(),
                    AppTheme.accentGreen,
                  ),
                  _buildSummaryItem(
                    'Sakit',
                    sakit.toString(),
                    AppTheme.accentOrange,
                  ),
                  _buildSummaryItem(
                    'Izin',
                    izin.toString(),
                    AppTheme.primaryPurple,
                  ),
                  _buildSummaryItem('Alpha', alpha.toString(), Colors.red),
                ],
              ),
              const SizedBox(height: 16),

              // Sorting Section
              _buildSortingSection(),

              const SizedBox(height: 12),

              // Search and Filter Section
              _buildSearchAndFilter(),

              const SizedBox(height: 16),
              Text(
                'Detail Absensi',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (absensiDocs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Tidak ada data yang sesuai',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else
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

        var pengumpulanDocs = snapshot.data!.docs;

        // Apply filters
        if (_filterSiswaId != null && _filterSiswaId!.isNotEmpty) {
          pengumpulanDocs = pengumpulanDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['siswa_id'].toString() == _filterSiswaId;
          }).toList();
        }

        // Apply search
        if (_searchQuery.isNotEmpty) {
          pengumpulanDocs = pengumpulanDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final siswaName = _getSiswaName(data['siswa_id']).toLowerCase();
            final status = (data['status'] ?? '').toString().toLowerCase();
            return siswaName.contains(_searchQuery.toLowerCase()) ||
                status.contains(_searchQuery.toLowerCase());
          }).toList();
        }

        // Apply sorting
        pengumpulanDocs.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;

          int comparison = 0;

          switch (_sortBy) {
            case 'id':
              final idAStr = dataA['siswa_id']?.toString() ?? '0';
              final idBStr = dataB['siswa_id']?.toString() ?? '0';
              final idANum = int.tryParse(idAStr);
              final idBNum = int.tryParse(idBStr);

              if (idANum != null && idBNum != null) {
                comparison = idANum.compareTo(idBNum);
              } else {
                comparison = idAStr.compareTo(idBStr);
              }
              break;
            case 'nama':
              final namaA = _getSiswaName(dataA['siswa_id']).toLowerCase();
              final namaB = _getSiswaName(dataB['siswa_id']).toLowerCase();
              comparison = namaA.compareTo(namaB);
              break;
            case 'kelas':
              // Tugas tidak ada kelas_id langsung, skip sorting by kelas
              comparison = 0;
              break;
          }

          return _sortAscending ? comparison : -comparison;
        });

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
                color: AppTheme.accentOrange,
                items: [
                  _buildSummaryItem(
                    'Total Pengumpulan',
                    totalPengumpulan.toString(),
                    AppTheme.primaryPurple,
                  ),
                  _buildSummaryItem(
                    'Terkumpul',
                    terkumpul.toString(),
                    AppTheme.accentGreen,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sorting Section
              _buildSortingSection(),

              const SizedBox(height: 12),

              // Search and Filter Section
              _buildSearchAndFilter(),

              const SizedBox(height: 16),
              Text(
                'Detail Pengumpulan',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (pengumpulanDocs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Tidak ada data yang sesuai',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else
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

        var materiDocs = snapshot.data!.docs;

        // Apply filters
        if (_filterKelasId != null && _filterKelasId!.isNotEmpty) {
          materiDocs = materiDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['id_kelas'].toString() == _filterKelasId;
          }).toList();
        }

        // Apply search
        if (_searchQuery.isNotEmpty) {
          materiDocs = materiDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final judul = (data['judul'] ?? '').toString().toLowerCase();
            final kelasName = _getKelasName(data['id_kelas']).toLowerCase();
            return judul.contains(_searchQuery.toLowerCase()) ||
                kelasName.contains(_searchQuery.toLowerCase());
          }).toList();
        }

        // Apply sorting
        materiDocs.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;

          int comparison = 0;

          switch (_sortBy) {
            case 'id':
            case 'nama':
              // Sort by judul for materi
              final judulA = (dataA['judul'] ?? '').toString().toLowerCase();
              final judulB = (dataB['judul'] ?? '').toString().toLowerCase();
              comparison = judulA.compareTo(judulB);
              break;
            case 'kelas':
              final kelasA = _getKelasName(dataA['id_kelas']).toLowerCase();
              final kelasB = _getKelasName(dataB['id_kelas']).toLowerCase();
              comparison = kelasA.compareTo(kelasB);
              break;
          }

          return _sortAscending ? comparison : -comparison;
        });

        final totalMateri = materiDocs.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(
                title: 'Ringkasan Materi',
                icon: Icons.library_books,
                color: AppTheme.primaryPurple,
                items: [
                  _buildSummaryItem(
                    'Total Materi',
                    totalMateri.toString(),
                    AppTheme.primaryPurple,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sorting Section
              _buildSortingSection(),

              const SizedBox(height: 12),

              // Search and Filter Section (only kelas filter for materi)
              _buildSearchAndFilterMateri(),

              const SizedBox(height: 16),
              Text(
                'Daftar Materi',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (materiDocs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Tidak ada data yang sesuai',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else
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

        var quizDocs = snapshot.data!.docs;

        // Apply filters
        if (_filterKelasId != null && _filterKelasId!.isNotEmpty) {
          quizDocs = quizDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['id_kelas'].toString() == _filterKelasId;
          }).toList();
        }

        // Apply search
        if (_searchQuery.isNotEmpty) {
          quizDocs = quizDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final judul = (data['judul'] ?? '').toString().toLowerCase();
            final kelasName = _getKelasName(data['id_kelas']).toLowerCase();
            return judul.contains(_searchQuery.toLowerCase()) ||
                kelasName.contains(_searchQuery.toLowerCase());
          }).toList();
        }

        // Apply sorting
        quizDocs.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;

          int comparison = 0;

          switch (_sortBy) {
            case 'id':
            case 'nama':
              // Sort by judul for quiz
              final judulA = (dataA['judul'] ?? '').toString().toLowerCase();
              final judulB = (dataB['judul'] ?? '').toString().toLowerCase();
              comparison = judulA.compareTo(judulB);
              break;
            case 'kelas':
              final kelasA = _getKelasName(dataA['id_kelas']).toLowerCase();
              final kelasB = _getKelasName(dataB['id_kelas']).toLowerCase();
              comparison = kelasA.compareTo(kelasB);
              break;
          }

          return _sortAscending ? comparison : -comparison;
        });

        final totalQuiz = quizDocs.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(
                title: 'Ringkasan Quiz',
                icon: Icons.quiz,
                color: AppTheme.secondaryTeal,
                items: [
                  _buildSummaryItem(
                    'Total Quiz',
                    totalQuiz.toString(),
                    AppTheme.secondaryTeal,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sorting Section
              _buildSortingSection(),

              const SizedBox(height: 12),

              // Search and Filter Section (only kelas filter for quiz)
              _buildSearchAndFilterMateri(),

              Text(
                'Daftar Quiz',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (quizDocs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Tidak ada data yang sesuai',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 12, children: items),
        ],
      ),
    );
  }

  Widget _buildSortingSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.sort, color: AppTheme.primaryPurple, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Urutkan:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 12),

          // Sort by dropdown
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'id', child: Text('ID Siswa')),
                DropdownMenuItem(value: 'nama', child: Text('Nama')),
                DropdownMenuItem(value: 'kelas', child: Text('Kelas')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _sortBy = value;
                  });
                }
              },
            ),
          ),

          const SizedBox(width: 12),

          // Sort direction button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _sortAscending = !_sortAscending;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.primaryPurple.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: AppTheme.primaryPurple,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _sortAscending ? 'A-Z' : 'Z-A',
                      style: TextStyle(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
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

  Widget _buildSearchAndFilter() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari nama siswa, kelas, atau status...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // Filter dropdowns
          Row(
            children: [
              // Siswa filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterSiswaId,
                  decoration: InputDecoration(
                    labelText: 'Filter Siswa',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Semua Siswa'),
                    ),
                    ..._siswaCache.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(
                          '${entry.key} - ${entry.value['nama'] ?? 'Unknown'}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filterSiswaId = value;
                    });
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Kelas filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterKelasId,
                  decoration: InputDecoration(
                    labelText: 'Filter Kelas',
                    prefixIcon: const Icon(Icons.class_),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Semua Kelas'),
                    ),
                    ..._kelasCache.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(
                          entry.value['nama_kelas'] ?? 'ID: ${entry.key}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filterKelasId = value;
                    });
                  },
                ),
              ),
            ],
          ),

          // Clear filters button
          if (_filterSiswaId != null ||
              _filterKelasId != null ||
              _searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _filterSiswaId = null;
                    _filterKelasId = null;
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('Hapus Semua Filter'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterMateri() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari judul atau kelas...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // Kelas filter only
          DropdownButtonFormField<String>(
            value: _filterKelasId,
            decoration: InputDecoration(
              labelText: 'Filter Kelas',
              prefixIcon: const Icon(Icons.class_),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Semua Kelas'),
              ),
              ..._kelasCache.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value['nama_kelas'] ?? 'ID: ${entry.key}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ],
            onChanged: (value) {
              setState(() {
                _filterKelasId = value;
              });
            },
          ),

          // Clear filters button
          if (_filterKelasId != null || _searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _filterKelasId = null;
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('Hapus Semua Filter'),
              ),
            ),
        ],
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAbsensiItem(Map<String, dynamic> data) {
    final status = data['status'] ?? 'Unknown';
    Color statusColor;
    String displayStatus;
    IconData statusIcon;

    switch (status.toString().toLowerCase()) {
      case 'hadir':
        statusColor = Colors.green;
        displayStatus = 'Hadir';
        statusIcon = Icons.check_circle;
        break;
      case 'sakit':
        statusColor = Colors.orange;
        displayStatus = 'Sakit';
        statusIcon = Icons.medical_services;
        break;
      case 'izin':
        statusColor = Colors.purple;
        displayStatus = 'Izin';
        statusIcon = Icons.info;
        break;
      case 'alpha':
        statusColor = Colors.red;
        displayStatus = 'Alpha';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        displayStatus = status.toString();
        statusIcon = Icons.help;
    }

    final timestamp = data['tanggal'] as Timestamp?;
    final dateStr = timestamp != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(timestamp.toDate())
        : '-';

    final siswaId = data['siswa_id']?.toString() ?? '-';
    final siswaName = _getSiswaName(data['siswa_id']);
    final kelasName = _getKelasName(data['kelas_id']);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(statusIcon, color: statusColor, size: 28),
            ),

            const SizedBox(width: 16),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student ID and name
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: $siswaId',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              siswaName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Class name
                  Row(
                    children: [
                      Icon(Icons.class_, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          kelasName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateStr,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.5)),
              ),
              child: Text(
                displayStatus,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPengumpulanItem(Map<String, dynamic> data) {
    final timestamp = data['createdAt'] as Timestamp?;
    final dateStr = timestamp != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(timestamp.toDate())
        : '-';

    final siswaId = data['siswa_id']?.toString() ?? '-';
    final siswaName = _getSiswaName(data['siswa_id']);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.assignment,
                color: Colors.orange,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student ID and name
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: $siswaId',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              siswaName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Tugas ID
                  Row(
                    children: [
                      Icon(Icons.folder, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Tugas ID: ${data['tugas_id'] ?? '-'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateStr,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.5)),
              ),
              child: const Text(
                'Terkumpul',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriItem(Map<String, dynamic> data) {
    final timestamp = data['createdAt'] as Timestamp?;
    final dateStr = timestamp != null
        ? DateFormat('dd MMM yyyy').format(timestamp.toDate())
        : '-';

    final kelasName = _getKelasName(data['id_kelas']);
    final judul = data['judul'] ?? 'Materi';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.library_books,
                color: Colors.purple,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Class name
                  Row(
                    children: [
                      Icon(Icons.class_, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          kelasName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Upload: $dateStr',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizItem(Map<String, dynamic> data) {
    final timestamp = data['createdAt'] as Timestamp?;
    final dateStr = timestamp != null
        ? DateFormat('dd MMM yyyy').format(timestamp.toDate())
        : '-';

    final kelasName = _getKelasName(data['id_kelas']);
    final judul = data['judul'] ?? 'Quiz';
    final waktu = data['waktu'] ?? 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.quiz, color: Colors.teal, size: 28),
            ),

            const SizedBox(width: 16),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Class name
                  Row(
                    children: [
                      Icon(Icons.class_, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          kelasName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Time and date
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        '$waktu menit',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateStr,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
