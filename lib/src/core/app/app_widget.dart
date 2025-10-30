import 'package:belajarbareng_app_mmp/src/features/dashboard/presentation/api_example_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter',
      ),
      themeMode: themeMode,
      home: const ApiExampleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
