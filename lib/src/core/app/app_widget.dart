import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../config/theme.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';

// Sesuai dokumentasi folder, file ini berisi
// konfigurasi MaterialApp/CupertinoApp
class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    // Di proyek nyata, 'home' akan dikelola oleh Go_Router
    // Tapi untuk preview ini, kita langsung arahkan ke DashboardScreen.

    return MaterialApp(
      title: 'BelajarBareng',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
