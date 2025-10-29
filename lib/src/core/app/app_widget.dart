import 'package:flutter/material.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';

// Sesuai dokumentasi folder, file ini berisi
// konfigurasi MaterialApp/CupertinoApp
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
      themeMode: ThemeMode.system,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
