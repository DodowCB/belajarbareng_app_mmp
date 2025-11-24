import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/services/connectivity_service.dart';
import '../profile_menu/profile_menu_widget.dart';
import '../../data/models/pengumuman_model.dart';

// Guru Events
abstract class HalamanGuruEvent {}

class LoadGuruData extends HalamanGuruEvent {}

class RefreshGuruData extends HalamanGuruEvent {}

class LoadGuruClasses extends HalamanGuruEvent {
  final String guruId;
  LoadGuruClasses(this.guruId);
}

// Guru State
class HalamanGuruState {
  final bool isLoading;
  final List<Map<String, dynamic>> myClasses;
  final List<Map<String, dynamic>> kelasWali;
  final List<Map<String, dynamic>> jadwalMengajar;
  final List<PengumumanModel> recentAnnouncements;
  final Map<String, int> teachingStats;
  final bool isOnline;
  final DateTime selectedDay;
  final DateTime focusedDay;
  final Map<DateTime, List<Map<String, dynamic>>> calendarEvents;
  final String? error;
  final String? currentGuruId;

  HalamanGuruState({
    this.isLoading = false,
    this.myClasses = const [],
    this.kelasWali = const [],
    this.jadwalMengajar = const [],
    this.recentAnnouncements = const [],
    this.teachingStats = const {},
    this.isOnline = true,
    DateTime? selectedDay,
    DateTime? focusedDay,
    this.calendarEvents = const {},
    this.error,
    this.currentGuruId,
  }) : selectedDay = selectedDay ?? DateTime.now(),
       focusedDay = focusedDay ?? DateTime.now();

  HalamanGuruState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? myClasses,
    List<Map<String, dynamic>>? kelasWali,
    List<Map<String, dynamic>>? jadwalMengajar,
    List<PengumumanModel>? recentAnnouncements,
    Map<String, int>? teachingStats,
    bool? isOnline,
    DateTime? selectedDay,
    DateTime? focusedDay,
    Map<DateTime, List<Map<String, dynamic>>>? calendarEvents,
    String? error,
    String? currentGuruId,
  }) {
    return HalamanGuruState(
      isLoading: isLoading ?? this.isLoading,
      myClasses: myClasses ?? this.myClasses,
      kelasWali: kelasWali ?? this.kelasWali,
      jadwalMengajar: jadwalMengajar ?? this.jadwalMengajar,
      recentAnnouncements: recentAnnouncements ?? this.recentAnnouncements,
      teachingStats: teachingStats ?? this.teachingStats,
      isOnline: isOnline ?? this.isOnline,
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      calendarEvents: calendarEvents ?? this.calendarEvents,
      error: error,
      currentGuruId: currentGuruId ?? this.currentGuruId,
    );
  }
}

// Calendar Events
class SelectDayEvent extends HalamanGuruEvent {
  final DateTime selectedDay;
  final DateTime focusedDay;
  SelectDayEvent(this.selectedDay, this.focusedDay);
}

class LoadCalendarEvents extends HalamanGuruEvent {}

// Guru Bloc
class HalamanGuruBloc extends Bloc<HalamanGuruEvent, HalamanGuruState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivityService = ConnectivityService();

  HalamanGuruBloc() : super(HalamanGuruState()) {
    on<LoadGuruData>(_onLoadGuruData);
    on<RefreshGuruData>(_onRefreshGuruData);
    on<LoadGuruClasses>(_onLoadGuruClasses);
    on<SelectDayEvent>(_onSelectDay);
    on<LoadCalendarEvents>(_onLoadCalendarEvents);

    // Initialize connectivity service
    _initializeServices();
  }

  void _initializeServices() {
    // Initialize connectivity monitoring
    _connectivityService.initialize();
    _connectivityService.addListener(() {
      add(LoadGuruData());
    });
  }

  void _onSelectDay(SelectDayEvent event, Emitter<HalamanGuruState> emit) {
    emit(
      state.copyWith(
        selectedDay: event.selectedDay,
        focusedDay: event.focusedDay,
      ),
    );
    // Load events for selected day
    add(LoadCalendarEvents());
  }

  Future<void> _onLoadCalendarEvents(
    LoadCalendarEvents event,
    Emitter<HalamanGuruState> emit,
  ) async {
    try {
      final isOnline = _connectivityService.isOnline;

      if (state.currentGuruId == null) {
        emit(state.copyWith(isOnline: isOnline));
        return;
      }

      // Load real schedule data from kelas_ngajar collection
      final jadwalSnapshot = await _firestore
          .collection('kelas_ngajar')
          .where('id_guru', isEqualTo: state.currentGuruId)
          .get();

      Map<DateTime, List<Map<String, dynamic>>> events = {};

      for (var doc in jadwalSnapshot.docs) {
        final data = doc.data();
        final tanggal = (data['tanggal'] as Timestamp?)?.toDate();
        if (tanggal != null) {
          final dayKey = DateTime(tanggal.year, tanggal.month, tanggal.day);

          if (events[dayKey] == null) events[dayKey] = [];

          events[dayKey]!.add({
            'jam': data['jam'] ?? '',
            'hari': data['hari'] ?? '',
            'id_kelas': data['id_kelas'] ?? '',
            'id_mapel': data['id_mapel'] ?? '',
          });
        }
      }

      emit(state.copyWith(isOnline: isOnline, calendarEvents: events));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load calendar events: $e'));
    }
  }

  Future<void> _onLoadGuruData(
    LoadGuruData event,
    Emitter<HalamanGuruState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // For demo, use hardcoded guru ID. In real app, get from auth
      const currentGuruId = '1'; // You should get this from authentication

      // Load recent announcements
      final pengumumanSnapshot = await _firestore
          .collection('pengumuman')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      final recentAnnouncements = pengumumanSnapshot.docs
          .map((doc) => PengumumanModel.fromFirestore(doc))
          .toList();

      // Load kelas wali (classes where this guru is homeroom teacher)
      final kelasWaliSnapshot = await _firestore
          .collection('kelas')
          .where('id_wali', isEqualTo: currentGuruId)
          .get();

      final kelasWali = kelasWaliSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'namaKelas': data['namaKelas'] ?? '',
          'jumlahSiswa': data['jumlahSiswa'] ?? 0,
        };
      }).toList();

      // Load jadwal mengajar
      final jadwalSnapshot = await _firestore
          .collection('kelas_ngajar')
          .where('id_guru', isEqualTo: currentGuruId)
          .get();

      final jadwalMengajar = jadwalSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'id_kelas': data['id_kelas'] ?? '',
          'id_mapel': data['id_mapel'] ?? '',
          'jam': data['jam'] ?? '',
          'hari': data['hari'] ?? '',
          'tanggal': data['tanggal'],
        };
      }).toList();

      // Calculate teaching stats
      final uniqueClasses = jadwalMengajar
          .map((j) => j['id_kelas'])
          .toSet()
          .length;
      final teachingStats = {
        'kelasWali': kelasWali.length,
        'jadwalMengajar': jadwalMengajar.length,
        'totalKelas': uniqueClasses,
        'materi': 8, // Static for now
        'tugas': 12, // Static for now
      };

      emit(
        state.copyWith(
          isLoading: false,
          currentGuruId: currentGuruId,
          kelasWali: kelasWali,
          jadwalMengajar: jadwalMengajar,
          recentAnnouncements: recentAnnouncements,
          teachingStats: teachingStats,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error loading data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefreshGuruData(
    RefreshGuruData event,
    Emitter<HalamanGuruState> emit,
  ) async {
    add(LoadGuruData());
  }

  Future<void> _onLoadGuruClasses(
    LoadGuruClasses event,
    Emitter<HalamanGuruState> emit,
  ) async {
    try {
      // Load classes where this guru is the homeroom teacher
      final kelasSnapshot = await _firestore
          .collection('kelas')
          .where('guru_id', isEqualTo: event.guruId)
          .get();

      final myClasses = <Map<String, dynamic>>[];

      for (final doc in kelasSnapshot.docs) {
        final kelasData = doc.data();

        // Get student count for this class
        final siswaKelasSnapshot = await _firestore
            .collection('siswa_kelas')
            .where('kelas_id', isEqualTo: doc.id)
            .get();

        myClasses.add({
          'id': doc.id,
          'nama_kelas': kelasData['nama_kelas'] ?? '',
          'tingkat': kelasData['tingkat'] ?? '',
          'jurusan': kelasData['jurusan'] ?? '',
          'tahun_ajaran': kelasData['tahun_ajaran'] ?? '',
          'student_count': siswaKelasSnapshot.docs.length,
        });
      }

      emit(state.copyWith(myClasses: myClasses));
    } catch (e) {
      emit(state.copyWith(error: 'Error loading classes: ${e.toString()}'));
    }
  }
}

class HalamanGuruScreen extends StatefulWidget {
  const HalamanGuruScreen({super.key});

  @override
  State<HalamanGuruScreen> createState() => _HalamanGuruScreenState();
}

class _HalamanGuruScreenState extends State<HalamanGuruScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HalamanGuruBloc()
        ..add(LoadGuruData())
        ..add(LoadGuruClasses('current_guru_id')), // TODO: Get actual guru ID
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<HalamanGuruBloc, HalamanGuruState>(
          builder: (context, state) {
            if (state.isLoading && state.myClasses.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HalamanGuruBloc>().add(RefreshGuruData());
              },
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: _buildWelcomeCard()),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(child: _buildCalendarSection(state)),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(child: _buildStatsSection(state)),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(child: _buildRecentAnnouncements(state)),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(child: _buildQuickActions()),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(child: _buildMyClasses(state)),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isCollapsed = constraints.maxHeight <= 80;
            final screenWidth = MediaQuery.of(context).size.width;

            return Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isCollapsed ? 6 : 8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.oceanGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school,
                    color: Colors.white,
                    size: isCollapsed ? 20 : 24,
                  ),
                ),
                if (screenWidth >= 400) ...[
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Teacher Portal',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isCollapsed ? 18 : 24,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(child: Text('3 new notifications')),
                  ],
                ),
                backgroundColor: AppTheme.primaryPurple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 8),
          child: ProfileDropdownMenu(
            userName: 'Guru',
            userEmail: 'guru@gmail.com',
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [AppTheme.secondaryTeal, AppTheme.accentGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppTheme.oceanGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.secondaryTeal.withOpacity(isDark ? 0.3 : 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang kembali,',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pak/Bu Guru',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kelola kelas dan siswa dengan mudah',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection(HalamanGuruState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    'Jadwal Mengajar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: state.isOnline ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          state.isOnline ? Icons.wifi : Icons.wifi_off,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          state.isOnline ? 'Online' : 'Offline',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TableCalendar<String>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: state.focusedDay,
                calendarFormat: CalendarFormat.month,
                eventLoader: (day) {
                  final dayKey = DateTime(day.year, day.month, day.day);
                  final events = state.calendarEvents[dayKey] ?? [];
                  return events
                      .map<String>((e) => '${e['jam']} - ${e['hari']}')
                      .toList();
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Colors.red[400]),
                  holidayTextStyle: TextStyle(color: Colors.red[800]),
                  selectedDecoration: BoxDecoration(
                    color: AppTheme.primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppTheme.secondaryTeal,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: AppTheme.accentOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(state.selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  context.read<HalamanGuruBloc>().add(
                    SelectDayEvent(selectedDay, focusedDay),
                  );
                },
                onPageChanged: (focusedDay) {
                  context.read<HalamanGuruBloc>().add(
                    SelectDayEvent(state.selectedDay, focusedDay),
                  );
                },
              ),
            ),
            if (state
                    .calendarEvents[DateTime(
                      state.selectedDay.year,
                      state.selectedDay.month,
                      state.selectedDay.day,
                    )]
                    ?.isNotEmpty ==
                true)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jadwal Hari Ini',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...state
                        .calendarEvents[DateTime(
                          state.selectedDay.year,
                          state.selectedDay.month,
                          state.selectedDay.day,
                        )]!
                        .map(
                          (event) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryPurple,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${event['jam']} - ${event['hari']}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(HalamanGuruState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik Mengajar',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                title: 'Kelas Wali',
                value: state.teachingStats['kelasWali']?.toString() ?? '0',
                icon: Icons.home_work,
                color: AppTheme.primaryPurple,
              ),
              _buildStatCard(
                title: 'Jadwal Mengajar',
                value: state.teachingStats['jadwalMengajar']?.toString() ?? '0',
                icon: Icons.schedule,
                color: AppTheme.secondaryTeal,
              ),
              _buildStatCard(
                title: 'Materi',
                value: state.teachingStats['materi']?.toString() ?? '0',
                icon: Icons.library_books,
                color: AppTheme.accentOrange,
              ),
              _buildStatCard(
                title: 'Tugas',
                value: state.teachingStats['tugas']?.toString() ?? '0',
                icon: Icons.assignment,
                color: AppTheme.accentGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAnnouncements(HalamanGuruState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pengumuman Terbaru',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all announcements
                },
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.recentAnnouncements.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.announcement_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada pengumuman',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ...state.recentAnnouncements.take(3).map((announcement) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: announcement.pembuat == 'admin'
                                ? Colors.red[100]
                                : Colors.blue[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            announcement.pembuatDisplay,
                            style: TextStyle(
                              fontSize: 12,
                              color: announcement.pembuat == 'admin'
                                  ? Colors.red[800]
                                  : Colors.blue[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          announcement.formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      announcement.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      announcement.deskripsi,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Upload Materi',
        'icon': Icons.upload_file,
        'color': AppTheme.accentOrange,
        'action': () => _showComingSoon('Upload Materi'),
      },
      {
        'title': 'Buat Soal',
        'icon': Icons.quiz,
        'color': AppTheme.accentGreen,
        'action': () => _showComingSoon('Buat Soal'),
      },
      {
        'title': 'Buat Tugas',
        'icon': Icons.assignment_add,
        'color': AppTheme.primaryPurple,
        'action': () => _showComingSoon('Buat Tugas'),
      },
      {
        'title': 'Rekap Nilai',
        'icon': Icons.analytics,
        'color': AppTheme.secondaryTeal,
        'action': () => _showComingSoon('Rekap Nilai'),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aksi Cepat',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: actions.map((action) {
              return GestureDetector(
                onTap: action['action'] as VoidCallback,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (action['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    final schedule = [
      {
        'time': '07:30 - 08:15',
        'subject': 'Matematika',
        'class': 'X IPA 1',
        'room': 'Lab. Komputer',
      },
      {
        'time': '08:15 - 09:00',
        'subject': 'Matematika',
        'class': 'X IPA 2',
        'room': 'Ruang 12',
      },
      {
        'time': '10:15 - 11:00',
        'subject': 'Fisika',
        'class': 'XI IPA 1',
        'room': 'Lab. Fisika',
      },
      {
        'time': '13:00 - 13:45',
        'subject': 'Matematika',
        'class': 'XII IPA 1',
        'room': 'Ruang 15',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jadwal Mengajar Hari Ini',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: schedule.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == schedule.length - 1;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['time']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondaryTeal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['subject']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item['class']} • ${item['room']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard({
    required String namaKelas,
    required int jumlahSiswa,
    bool isWaliKelas = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isWaliKelas
            ? Border.all(
                color: AppTheme.primaryPurple.withOpacity(0.3),
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isWaliKelas
                  ? AppTheme.primaryPurple.withOpacity(0.1)
                  : AppTheme.secondaryTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isWaliKelas ? Icons.home_work : Icons.class_,
              color: isWaliKelas
                  ? AppTheme.primaryPurple
                  : AppTheme.secondaryTeal,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      namaKelas,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (isWaliKelas) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Wali Kelas',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '$jumlahSiswa siswa',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // Navigate to class details if needed
              _showComingSoon('Detail Kelas');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.accentOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachingScheduleCard({
    required String kelasId,
    required List<Map<String, dynamic>> jadwalList,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.schedule,
                  color: AppTheme.accentGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Kelas $kelasId',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '${jadwalList.length} jadwal',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...jadwalList
              .map(
                (jadwal) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${jadwal['hari']} • ${jadwal['jam']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildMyClasses(HalamanGuruState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kelas Saya',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Kelas Wali Section
          if (state.kelasWali.isNotEmpty) ...[
            Text(
              'Wali Kelas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...state.kelasWali.map(
              (kelas) => _buildClassCard(
                namaKelas: kelas['namaKelas'] ?? '',
                jumlahSiswa: kelas['jumlahSiswa'] ?? 0,
                isWaliKelas: true,
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Jadwal Mengajar Section
          if (state.jadwalMengajar.isNotEmpty) ...[
            Text(
              'Jadwal Mengajar',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            // Group by kelas
            ...state.jadwalMengajar
                .fold<Map<String, List<Map<String, dynamic>>>>({}, (
                  map,
                  jadwal,
                ) {
                  final kelasId = jadwal['id_kelas'] as String;
                  if (!map.containsKey(kelasId)) map[kelasId] = [];
                  map[kelasId]!.add(jadwal);
                  return map;
                })
                .entries
                .map(
                  (entry) => _buildTeachingScheduleCard(
                    kelasId: entry.key,
                    jadwalList: entry.value,
                  ),
                )
                .toList(),
          ],

          if (state.kelasWali.isEmpty && state.jadwalMengajar.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.class_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada kelas',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan segera hadir'),
        backgroundColor: AppTheme.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
