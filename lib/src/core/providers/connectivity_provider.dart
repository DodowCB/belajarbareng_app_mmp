import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/connectivity_service.dart';

/// Provider untuk ConnectivityService instance
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Provider untuk stream status online/offline
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  
  // Return stream yang emit status online/offline dari service
  return Stream.periodic(const Duration(milliseconds: 500), (_) {
    return service.isOnline;
  }).distinct(); // Hanya emit jika value berubah
});

/// Provider untuk state online/offline saat ini
final isOnlineProvider = Provider<bool>((ref) {
  final asyncValue = ref.watch(connectivityStreamProvider);
  return asyncValue.maybeWhen(
    data: (isOnline) => isOnline,
    orElse: () => true, // Default to online
  );
});
