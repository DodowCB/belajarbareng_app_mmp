import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/app/app_widget.dart';

// Sesuai dokumentasi folder, main.dart hanya untuk
// inisialisasi dan menjalankan app.
void main() {
  // Pastikan binding terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // (Di sini Anda akan menambahkan inisialisasi Firebase, Drift, dll)

  runApp(
    // ProviderScope wajib untuk Riverpod
    const ProviderScope(
      child: AppWidget(),
    ),
  );
}
