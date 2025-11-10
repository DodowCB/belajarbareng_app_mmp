import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../data/models/guru_model.dart';

class GuruDataScreen extends StatefulWidget {
  const GuruDataScreen({super.key});

  @override
  State<GuruDataScreen> createState() => _GuruDataScreenState();
}

class _GuruDataScreenState extends State<GuruDataScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  List<GuruModel> _filteredGuruList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Load guru data
    context.read<AuthBloc>().add(const LoadGuruData());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterGuruList(List<GuruModel> guruList) {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredGuruList = guruList;
      } else {
        _filteredGuruList = guruList.where((guru) {
          return guru.namaLengkap.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                 guru.mataPelajaran.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                 guru.sekolah.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                 guru.nig.toString().contains(_searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.oceanGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildSearchBar(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is GuruDataLoaded) {
                              _filterGuruList(state.guruList);
                            }
                          },
                          builder: (context, state) {
                            if (state is GuruDataLoading) {
                              return _buildLoadingState();
                            } else if (state is GuruDataError) {
                              return _buildErrorState(state.message);
                            } else if (state is GuruDataLoaded) {
                              if (_filteredGuruList.isEmpty && _searchQuery.isEmpty) {
                                return _buildEmptyState();
                              } else if (_filteredGuruList.isEmpty && _searchQuery.isNotEmpty) {
                                return _buildNoResultsState();
                              }
                              return _buildGuruList();
                            }
                            return _buildInitialState();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Guru',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Informasi guru dari Firebase',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const LoadGuruData());
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari berdasarkan nama, mata pelajaran, atau sekolah...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    final currentState = context.read<AuthBloc>().state;
                    if (currentState is GuruDataLoaded) {
                      _filterGuruList(currentState.guruList);
                    }
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          final currentState = context.read<AuthBloc>().state;
          if (currentState is GuruDataLoaded) {
            _filterGuruList(currentState.guruList);
          }
        },
      ),
    );
  }

  Widget _buildGuruList() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _filteredGuruList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final guru = _filteredGuruList[index];
          return _buildGuruCard(guru, index);
        },
      ),
    );
  }

  Widget _buildGuruCard(GuruModel guru, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.oceanGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          guru.namaLengkap.isNotEmpty ? guru.namaLengkap[0].toUpperCase() : 'G',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guru.namaLengkap,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              guru.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          guru.nig.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoItem(
                        icon: Icons.subject_rounded,
                        label: guru.mataPelajaran,
                        color: AppTheme.secondaryTeal,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoItem(
                        icon: Icons.school_rounded,
                        label: guru.sekolah,
                        color: AppTheme.accentGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tanggal Lahir: ${_formatDate(guru.tanggalLahir)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textLight,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: guru.status == 'aktif' ? AppTheme.accentGreen.withOpacity(0.2) : AppTheme.accentOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          guru.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: guru.status == 'aktif' ? AppTheme.accentGreen : AppTheme.accentOrange,
                          ),
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data guru...',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppTheme.accentOrange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(const LoadGuruData());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 64,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Data Guru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Data guru belum tersedia.\nSilakan daftar sebagai guru untuk menambah data.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Hasil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tidak ditemukan guru dengan pencarian "$_searchQuery"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(const LoadGuruData());
              },
              icon: const Icon(Icons.download_rounded),
              label: const Text('Muat Data Guru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
