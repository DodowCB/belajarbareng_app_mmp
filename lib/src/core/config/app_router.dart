import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/admin/admin_screen.dart';
import '../../features/auth/presentation/admin/admin_bloc.dart';
import '../../features/auth/presentation/halamanGuru/halaman_guru_screen.dart';
import '../../features/auth/presentation/halamanSiswa/halaman_siswa_screen.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/auth/presentation/profile/profile_screen.dart';
import '../../features/auth/presentation/materials/create_material_screen.dart';
import '../../features/auth/presentation/guru_data/teachers_screen.dart';
import '../../features/auth/presentation/siswa/students_screen.dart';
import '../../features/auth/presentation/mapel/subjects_screen.dart';
import '../../features/auth/presentation/kelas/classes_screen.dart';
import '../../features/auth/presentation/pengumuman/pengumuman_screen.dart';
import '../../features/auth/presentation/jadwal_mengajar/jadwal_mengajar_screen.dart';
import '../../features/auth/presentation/location/guru_location_screen.dart';
import '../../features/auth/presentation/admin/reports_screen.dart';
import '../../features/auth/presentation/admin/analytics_screen.dart';
import '../../features/auth/presentation/admin/settings_screen.dart';
import '../../features/auth/presentation/notifications/notifications_screen.dart';
import '../../features/auth/presentation/settings/settings_screen.dart' as user_settings;
import '../providers/user_provider.dart';

/// App Router untuk menangani semua navigasi
/// Mendukung static routes dan dynamic routes dengan parameter
class AppRouter {
  /// Generate route berdasarkan settings
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final pathSegments = uri.pathSegments;

    debugPrint('🔀 Navigating to: ${settings.name}');
    debugPrint('   Path segments: $pathSegments');
    debugPrint('   Current user role: ${userProvider.userType}');

    // Handle root route
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (_) => _getHomeScreen());
    }

    // Handle login
    if (settings.name == '/login') {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    }

    // Handle profile
    if (settings.name == '/profile') {
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    }

    // Handle role-based dashboard routes
    if (settings.name == '/admin' || settings.name == '/dashboard/admin') {
      return _checkRoleAndNavigate(
        'admin',
        () => const AdminScreen(),
        settings,
      );
    }

    if (settings.name == '/halaman-guru' || settings.name == '/dashboard/guru') {
      return _checkRoleAndNavigate(
        'guru',
        () => const HalamanGuruScreen(),
        settings,
      );
    }

    if (settings.name == '/halaman-siswa' ||
        settings.name == '/dashboard/siswa' ||
        settings.name == '/dashboard') {
      return _checkRoleAndNavigate(
        'siswa',
        () => const HalamanSiswaScreen(),
        settings,
      );
    }

    // Handle notifications
    if (settings.name == '/notifications') {
      return MaterialPageRoute(builder: (_) => const NotificationsScreen());
    }

    // Handle settings
    if (settings.name == '/settings') {
      return MaterialPageRoute(builder: (_) => const user_settings.SettingsScreen());
    }

    // Handle pengumuman routes (accessible by all)
    if (pathSegments.isNotEmpty && pathSegments[0] == 'pengumuman') {
      return _handlePengumumanRoutes(pathSegments, settings);
    }

    // Handle admin routes
    if (pathSegments.isNotEmpty && pathSegments[0] == 'admin') {
      return _handleAdminRoutes(pathSegments, settings);
    }

    // Handle guru routes
    if (pathSegments.isNotEmpty && pathSegments[0] == 'guru') {
      return _handleGuruRoutes(pathSegments, settings);
    }

    // Handle siswa routes
    if (pathSegments.isNotEmpty && pathSegments[0] == 'siswa') {
      return _handleSiswaRoutes(pathSegments, settings);
    }

    // Handle kelas routes (accessible by admin and guru)
    if (pathSegments.isNotEmpty && pathSegments[0] == 'kelas') {
      return _handleKelasRoutes(pathSegments, settings);
    }

    // Handle qna routes (accessible by all)
    if (pathSegments.isNotEmpty && pathSegments[0] == 'qna') {
      return _handleQnaRoutes(pathSegments, settings);
    }

    // Handle quiz routes (accessible by all)
    if (pathSegments.isNotEmpty && pathSegments[0] == 'quiz') {
      return _handleQuizRoutes(pathSegments, settings);
    }

    // Handle tugas routes (accessible by guru and siswa)
    if (pathSegments.isNotEmpty && pathSegments[0] == 'tugas') {
      return _handleTugasRoutes(pathSegments, settings);
    }

    // Handle nilai routes (accessible by guru and siswa)
    if (pathSegments.isNotEmpty && pathSegments[0] == 'nilai') {
      return _handleNilaiRoutes(pathSegments, settings);
    }

    // Handle materi routes (accessible by guru and siswa)
    if (pathSegments.isNotEmpty && pathSegments[0] == 'materi') {
      return _handleMateriRoutes(pathSegments, settings);
    }

    // Route not found - return null untuk trigger onUnknownRoute
    return null;
  }

  /// Handle unknown routes
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    debugPrint('❌ Unknown route: ${settings.name}');
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Route: ${settings.name}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Navigate back or to home
                  Navigator.of(context).pop();
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get home screen berdasarkan role user
  static Widget _getHomeScreen() {
    final userType = userProvider.userType;
    debugPrint('🏠 Getting home screen for role: $userType');

    switch (userType) {
      case 'admin':
        return const AdminScreen();
      case 'guru':
        return const HalamanGuruScreen();
      case 'siswa':
        return const HalamanSiswaScreen();
      default:
        return const LoginScreen();
    }
  }

  /// Check role dan navigate jika sesuai
  static MaterialPageRoute? _checkRoleAndNavigate(
    String requiredRole,
    Widget Function() builder,
    RouteSettings settings,
  ) {
    final userType = userProvider.userType;

    if (userType == requiredRole) {
      return MaterialPageRoute(builder: (_) => builder());
    } else {
      debugPrint(
        '⚠️ Access denied: User role "$userType" cannot access "$requiredRole" route',
      );
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Access Denied')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.block, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Access Denied',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'You don\'t have permission to access this page.\nRequired role: $requiredRole\nYour role: $userType',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text('Go to Dashboard'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  /// Handle admin-specific routes
  static Route<dynamic>? _handleAdminRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    // Check if user is admin
    if (userProvider.userType != 'admin') {
      return _checkRoleAndNavigate('admin', () => const AdminScreen(), settings);
    }

    // /admin/guru
    if (pathSegments.length >= 2 && pathSegments[1] == 'guru') {
      // /admin/guru/approve/:id
      if (pathSegments.length >= 4 && pathSegments[2] == 'approve') {
        final guruId = pathSegments[3];
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AdminBloc()..add(LoadAdminData()),
            child: TeachersScreen(highlightId: guruId),
          ),
          settings: settings,
        );
      }
      // /admin/guru
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const TeachersScreen(),
        ),
      );
    }

    // /admin/siswa
    if (pathSegments.length >= 2 && pathSegments[1] == 'siswa') {
      // /admin/siswa/approve/:id
      if (pathSegments.length >= 4 && pathSegments[2] == 'approve') {
        final siswaId = pathSegments[3];
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AdminBloc()..add(LoadAdminData()),
            child: StudentsScreen(highlightId: siswaId),
          ),
          settings: settings,
        );
      }
      // /admin/siswa
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const StudentsScreen(),
        ),
      );
    }

    // /admin/mapel
    if (pathSegments.length >= 2 && pathSegments[1] == 'mapel') {
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const SubjectsScreen(),
        ),
      );
    }

    // /admin/kelas
    if (pathSegments.length >= 2 && pathSegments[1] == 'kelas') {
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const ClassesScreen(),
        ),
      );
    }

    // /admin/pengumuman
    if (pathSegments.length >= 2 && pathSegments[1] == 'pengumuman') {
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const PengumumanScreen(),
        ),
      );
    }

    // /admin/jadwal
    if (pathSegments.length >= 2 && pathSegments[1] == 'jadwal') {
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const JadwalMengajarScreen(),
        ),
      );
    }

    // /admin/location
    if (pathSegments.length >= 2 && pathSegments[1] == 'location') {
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const GuruLocationScreen(),
        ),
      );
    }

    // /admin/reports
    if (pathSegments.length >= 2 && pathSegments[1] == 'reports') {
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const ReportsScreen(),
        ),
      );
    }

    // /admin/analytics
    if (pathSegments.length >= 2 && pathSegments[1] == 'analytics') {
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const AnalyticsScreen(),
        ),
      );
    }

    // /admin/settings
    if (pathSegments.length >= 2 && pathSegments[1] == 'settings') {
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const SettingsScreen(),
        ),
      );
    }

    // Default to admin dashboard
    return MaterialPageRoute(builder: (_) => const AdminScreen());
  }

  /// Handle guru-specific routes
  static Route<dynamic>? _handleGuruRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    // Check if user is guru
    if (userProvider.userType != 'guru') {
      return _checkRoleAndNavigate(
        'guru',
        () => const HalamanGuruScreen(),
        settings,
      );
    }

    // /guru/create-material
    if (pathSegments.length >= 2 && pathSegments[1] == 'create-material') {
      return MaterialPageRoute(builder: (_) => const CreateMaterialScreen());
    }

    // Default to guru dashboard
    return MaterialPageRoute(builder: (_) => const HalamanGuruScreen());
  }

  /// Handle siswa-specific routes
  static Route<dynamic>? _handleSiswaRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    // Check if user is siswa
    if (userProvider.userType != 'siswa') {
      return _checkRoleAndNavigate(
        'siswa',
        () => const HalamanSiswaScreen(),
        settings,
      );
    }

    // Add siswa-specific routes here if needed

    // Default to siswa dashboard
    return MaterialPageRoute(builder: (_) => const HalamanSiswaScreen());
  }

  /// Handle kelas routes (accessible by admin and guru)
  static Route<dynamic>? _handleKelasRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    // Check if user is admin or guru
    final userType = userProvider.userType;
    if (userType != 'admin' && userType != 'guru') {
      debugPrint('⚠️ Access denied: User role "$userType" cannot access kelas routes');
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const ClassesScreen(),
        ),
      );
    }

    // /kelas/detail/:id
    if (pathSegments.length >= 3 && pathSegments[1] == 'detail') {
      final kelasId = pathSegments[2];
      debugPrint('📚 Navigating to kelas detail: $kelasId');
      // For now, just show the classes screen with AdminBloc
      // TODO: Create KelasDetailScreen if needed
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const ClassesScreen(),
        ),
        settings: settings,
      );
    }

    // Default to classes screen with AdminBloc
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => AdminBloc()..add(LoadAdminData()),
        child: const ClassesScreen(),
      ),
    );
  }

  /// Handle QnA routes (accessible by all authenticated users)
  static Route<dynamic>? _handleQnaRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    // /qna/detail/:id
    if (pathSegments.length >= 3 && pathSegments[1] == 'detail') {
      final qnaId = pathSegments[2];
      debugPrint('💬 Navigating to QnA detail: $qnaId');
      // For now, navigate back to dashboard
      // TODO: Create QnADetailScreen if needed
      return MaterialPageRoute(
        builder: (_) => _getHomeScreen(),
        settings: settings,
      );
    }

    // Default to home screen
    return MaterialPageRoute(builder: (_) => _getHomeScreen());
  }

  /// Handle Quiz routes (accessible by all authenticated users)
  static Route<dynamic>? _handleQuizRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    // /quiz/detail/:id
    if (pathSegments.length >= 3 && pathSegments[1] == 'detail') {
      final quizId = pathSegments[2];
      debugPrint('📝 Navigating to Quiz detail: $quizId');
      // For now, navigate back to dashboard
      // TODO: Create QuizDetailScreen if needed
      return MaterialPageRoute(
        builder: (_) => _getHomeScreen(),
        settings: settings,
      );
    }

    // Default to home screen
    return MaterialPageRoute(builder: (_) => _getHomeScreen());
  }

  /// Handle Pengumuman routes (accessible by all authenticated users)
  static Route<dynamic>? _handlePengumumanRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    // /pengumuman or /pengumuman/:id
    if (pathSegments.length >= 2) {
      final pengumumanId = pathSegments[1];
      debugPrint('📢 Navigating to Pengumuman: $pengumumanId');
      // Navigate to pengumuman screen with AdminBloc (PengumumanScreen uses AdminHeader)
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminBloc()..add(LoadAdminData()),
          child: const PengumumanScreen(),
        ),
        settings: settings,
      );
    }

    // Default to pengumuman screen with AdminBloc
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => AdminBloc()..add(LoadAdminData()),
        child: const PengumumanScreen(),
      ),
    );
  }

  /// Handle Tugas routes (accessible by guru and siswa)
  static Route<dynamic>? _handleTugasRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    final userRole = userProvider.userType;

    // Check role access
    if (userRole != 'guru' && userRole != 'siswa') {
      debugPrint('❌ Access denied to /tugas/ for role: $userRole');
      return MaterialPageRoute(builder: (_) => _getHomeScreen());
    }

    // /tugas/detail/:id - View tugas detail
    if (pathSegments.length >= 3 && pathSegments[1] == 'detail') {
      final tugasId = pathSegments[2];
      debugPrint('📚 Navigating to Tugas detail: $tugasId (role: $userRole)');
      
      // Navigate to home dashboard where user can see their tugas list
      // DetailTugasKelasScreen requires kelasId, namaKelas, etc which we don't have from notification
      debugPrint('   ℹ️ Redirecting to dashboard - user can find tugas in their class list');
      return MaterialPageRoute(builder: (_) => _getHomeScreen());
    }

    // /tugas/grading/:id - Guru grading tugas
    if (pathSegments.length >= 3 && pathSegments[1] == 'grading') {
      final tugasId = pathSegments[2];
      debugPrint('✅ Navigating to Tugas grading: $tugasId (role: $userRole)');
      
      // Navigate to home dashboard where guru can see submitted tugas
      debugPrint('   ℹ️ Redirecting to dashboard - guru can find submitted tugas there');
      return MaterialPageRoute(builder: (_) => _getHomeScreen());
    }

    // Default: navigate to home
    return MaterialPageRoute(builder: (_) => _getHomeScreen());
  }

  /// Handle Nilai routes (accessible by guru and siswa)
  static Route<dynamic>? _handleNilaiRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    final userRole = userProvider.userType;

    // Check role access
    if (userRole != 'guru' && userRole != 'siswa') {
      debugPrint('❌ Access denied to /nilai/ for role: $userRole');
      return MaterialPageRoute(builder: (_) => _getHomeScreen());
    }

    // /nilai/detail - View nilai
    if (pathSegments.length >= 2 && pathSegments[1] == 'detail') {
      debugPrint('📊 Navigating to Nilai detail (role: $userRole)');
      
      // Navigate to home screen (nilai is shown in dashboard)
      return MaterialPageRoute(builder: (_) => _getHomeScreen());
    }

    // Default: navigate to home
    return MaterialPageRoute(builder: (_) => _getHomeScreen());
  }

  /// Handle Materi routes (accessible by guru and siswa)
  static Route<dynamic>? _handleMateriRoutes(
    List<String> pathSegments,
    RouteSettings settings,
  ) {
    final userRole = userProvider.userType;

    // Check role access
    if (userRole != 'guru' && userRole != 'siswa') {
      debugPrint('❌ Access denied to /materi/ for role: $userRole');
      return MaterialPageRoute(builder: (_) => _getHomeScreen());
    }

    // /materi/detail/:id - View materi detail
    if (pathSegments.length >= 3 && pathSegments[1] == 'detail') {
      final materiId = pathSegments[2];
      debugPrint('📖 Navigating to Materi detail: $materiId (role: $userRole)');
      
      // Navigate to home dashboard where user can see their materi list
      // DetailMateriKelasScreen requires namaMapel, namaGuru, kelasId, etc which we don't have from notification
      debugPrint('   ℹ️ Redirecting to dashboard - user can find materi in their class list');
      return MaterialPageRoute(builder: (_) => _getHomeScreen());
    }

    // Default: navigate to home
    return MaterialPageRoute(builder: (_) => _getHomeScreen());
  }
}
