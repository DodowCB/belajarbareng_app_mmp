import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/core/app/app_widget.dart';
import 'src/core/services/connectivity_service.dart';
import 'src/core/services/local_storage_service.dart';
import 'src/services/notification_service.dart';

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
    debugPrint('Connectivity service initialized successfully');
  } catch (e) {
    debugPrint('Connectivity service initialization error: $e');
  }

  // Initialize local storage (with error handling for web)
  try {
    await LocalStorageService().initialize();
    debugPrint('Local storage service initialized successfully');
  } catch (e) {
    debugPrint('Local storage service initialization warning (web platform may have limited support): $e');
    // Continue execution even if local storage fails on web
  }

  // Initialize notification service
  try {
    final notificationService = NotificationService();
    await notificationService.initialize();
    debugPrint('Notification service initialized successfully');
  } catch (e) {
    debugPrint('Notification service initialization error: $e');
    // Continue execution even if notifications fail
  }

  debugPrint('All offline support services initialized');

  runApp(const ProviderScope(child: AppWidget()));
}
