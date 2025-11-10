import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/theme_provider.dart';
import '../config/theme.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/data/repositories/auth_repository.dart';

// Sesuai dokumentasi folder, file ini berisi
// konfigurasi MaterialApp/CupertinoApp
class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return BlocProvider(
      create: (context) => AuthBloc(
        authRepository: AuthRepository(),
      )..add(const AuthCheckRequested()),
      child: MaterialApp(
        title: 'BelajarBareng',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
