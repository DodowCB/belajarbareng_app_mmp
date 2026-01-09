import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../services/connectivity_service.dart';

/// Provider untuk ConnectivityService instance
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Provider untuk stream status online/offline
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);

  // Create a StreamController to listen to ConnectivityService changes
  final controller = StreamController<bool>();

  // Add listener to connectivity service
  void listener() {
    if (!controller.isClosed) {
      controller.add(service.isOnline);
    }
  }

  service.addListener(listener);

  // Add initial value
  controller.add(service.isOnline);

  // Cleanup when provider is disposed
  ref.onDispose(() {
    service.removeListener(listener);
    controller.close();
  });

  return controller.stream.distinct(); // Hanya emit jika value berubah
});

/// Provider untuk state online/offline saat ini
final isOnlineProvider = Provider<bool>((ref) {
  final asyncValue = ref.watch(connectivityStreamProvider);
  return asyncValue.maybeWhen(
    data: (isOnline) => isOnline,
    orElse: () => false, // Default to offline until connectivity is verified
  );
});
