import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/app_database.dart';

/// Provider untuk AppDatabase instance
/// Singleton pattern - hanya ada satu instance database
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  // Cleanup when provider is disposed
  ref.onDispose(() {
    database.close();
  });

  return database;
});

/// Provider untuk mengecek apakah database sudah diinisialisasi
final databaseInitializedProvider = FutureProvider<bool>((ref) async {
  final database = ref.watch(appDatabaseProvider);

  try {
    // Test database connection
    await database.getAllKelas();
    return true;
  } catch (e) {
    return false;
  }
});
