import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/core/app/app_widget.dart';
import 'src/core/services/connectivity_service.dart';
import 'src/core/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Initialize services for offline support
  try {
    await ConnectivityService().initialize();
    await LocalStorageService().initialize();
    debugPrint('Offline support services initialized successfully');
  } catch (e) {
    debugPrint('Offline services initialization error: $e');
  }

  runApp(const ProviderScope(child: AppWidget()));
}
