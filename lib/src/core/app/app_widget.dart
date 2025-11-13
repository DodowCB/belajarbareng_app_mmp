import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/theme_provider.dart';
import '../config/theme.dart';
import '../../features/auth/presentation/dashboard/dashboard_screen.dart';
import '../../features/auth/presentation/profile/profile_screen.dart';
import '../../features/auth/presentation/materials/create_material_screen.dart';
import '../../features/auth/presentation/admin/admin_screen.dart';
import '../../features/auth/presentation/halamanGuru/halaman_guru_screen.dart';
import '../../features/auth/presentation/login/login_bloc.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/auth/presentation/guru_data/guru_data_bloc.dart';
import '../../features/auth/data/repositories/auth_repository.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(authRepository: AuthRepository()),
        ),
        BlocProvider(
          create: (context) => GuruDataBloc(authRepository: AuthRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'BelajarBareng',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/create-material': (context) => const CreateMaterialScreen(),
          '/admin': (context) => const AdminScreen(),
          '/halaman-guru': (context) => const HalamanGuruScreen(),
        },
      ),
    );
  }
}
