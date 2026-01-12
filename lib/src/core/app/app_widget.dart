import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../config/theme.dart';
import 'splash_screen.dart';
import '../../features/auth/presentation/dashboard/dashboard_screen.dart';
import '../../features/auth/presentation/profile/profile_screen.dart';
import '../../features/auth/presentation/materials/create_material_screen.dart';
import '../../features/auth/presentation/admin/admin_screen.dart';
import '../../features/auth/presentation/halamanGuru/halaman_guru_screen.dart';
import '../../features/auth/presentation/halamanSiswa/halaman_siswa_screen.dart';
import '../../features/auth/presentation/login/login_bloc.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/auth/presentation/guru_data/guru_data_bloc.dart';
import '../../features/auth/presentation/siswa/siswa_data_bloc.dart';
import '../../features/auth/data/repositories/auth_repository.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(
            authRepository: AuthRepository(),
            userProvider: UserProvider(),
            ref: ref,
          ),
        ),
        BlocProvider(create: (context) => GuruDataBloc()),
        BlocProvider(create: (context) => SiswaDataBloc()),
      ],
      child: MaterialApp(
        title: 'BelajarBareng',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const HalamanSiswaScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/create-material': (context) => const CreateMaterialScreen(),
          '/admin': (context) => const AdminScreen(),
          '/halaman-guru': (context) => const HalamanGuruScreen(),
          '/halaman-siswa': (context) => const HalamanSiswaScreen(),
        },
      ),
    );
  }
}
