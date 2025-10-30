import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/core/app/app_widget.dart';

// Sesuai dokumentasi folder, main.dart hanya untuk
// inisialisasi dan menjalankan app.
void main() async {
  // Pastikan binding terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase properly to prevent handleThenable errors
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Continue anyway for development purposes
  }

  runApp(
    // ProviderScope wajib untuk Riverpod
    const ProviderScope(
      child: AppWidget(),
    ),
  );
}
