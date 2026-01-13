import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/location_service.dart';
import '../../data/repositories/location_repository.dart';

/// Helper untuk request location permission saat guru login
class LocationPermissionHelper {
  static final LocationService _locationService = LocationService();
  static final LocationRepository _locationRepository = LocationRepository();

  /// Show permission request dialog untuk guru
  static Future<bool> requestLocationPermission(BuildContext context) async {
    print('🔍 [LocationPermissionHelper] Checking permission...');

    // Check current permission status
    final permission = await _locationService.checkPermission();
    print('   Current permission: $permission');

    if (permission == LocationPermission.denied) {
      print('   ⚠️ Permission denied, showing explanation dialog');
      // Show custom dialog explaining why we need location
      final shouldRequest = await _showPermissionExplanationDialog(context);
      print('   User response: $shouldRequest');

      if (shouldRequest == true) {
        print('   📱 Requesting permission from system...');
        final newPermission = await _locationService.requestPermission();
        print('   New permission: $newPermission');
        return newPermission == LocationPermission.whileInUse ||
            newPermission == LocationPermission.always;
      }
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      print('   🚫 Permission permanently denied, showing settings dialog');
      // Show dialog to open settings
      await _showOpenSettingsDialog(context);
      return false;
    }

    // Permission already granted
    print('   ✅ Permission already granted');
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Show explanation dialog
  static Future<bool?> _showPermissionExplanationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.location_on, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Location Permission')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This app needs access to your location to:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            _buildBenefitItem('📍', 'Track your attendance location'),
            _buildBenefitItem(
              '👁️',
              'Allow admin to monitor teacher locations',
            ),
            _buildBenefitItem('🔒', 'Ensure security and accountability'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Your location will only be visible to admin.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  /// Show dialog to open settings
  static Future<void> _showOpenSettingsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Location Permission Denied'),
        content: const Text(
          'Location permission has been permanently denied. '
          'Please enable it from app settings to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await Geolocator.openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  static Widget _buildBenefitItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  /// Request permission dan update location sekaligus
  static Future<bool> requestAndUpdateLocation({
    required BuildContext context,
    required String guruId,
    required String guruName,
  }) async {
    print('🔔 [LocationPermissionHelper] requestAndUpdateLocation called');
    print('   GuruId: $guruId');
    print('   GuruName: $guruName');

    // Request permission first
    final hasPermission = await requestLocationPermission(context);
    print('   Permission granted: $hasPermission');

    if (!hasPermission) {
      print('   ❌ Permission denied, aborting');
      return false;
    }

    // Show loading
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Get and update location
    final success = await _locationRepository.requestAndUpdateCurrentLocation(
      guruId: guruId,
      guruName: guruName,
    );

    // Close loading
    if (context.mounted) {
      Navigator.pop(context);
    }

    // Show result
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? '✓ Location updated successfully'
                : '✗ Failed to get location',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return success;
  }
}
