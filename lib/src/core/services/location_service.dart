import 'package:geolocator/geolocator.dart';

/// Service untuk mengelola lokasi GPS guru
class LocationService {
  /// Cek apakah location service aktif
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Cek permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request permission lokasi
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current location guru
  Future<Position?> getCurrentLocation() async {
    try {
      // Cek apakah location service enabled
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location service disabled');
        return null;
      }

      // Cek permission
      LocationPermission permission = await checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission denied forever');
        return null;
      }

      // Get location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Get location dengan timeout
  Future<Position?> getCurrentLocationWithTimeout({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      return await getCurrentLocation().timeout(timeout);
    } catch (e) {
      print('Location timeout: $e');
      return null;
    }
  }

  /// Calculate distance between two coordinates (in meters)
  double getDistanceBetween({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Format distance untuk display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(2)} km';
    }
  }

  /// Check if guru is within school radius (misalnya 500m dari sekolah)
  bool isWithinSchoolRadius({
    required double guruLat,
    required double guruLon,
    required double schoolLat,
    required double schoolLon,
    double radiusInMeters = 500,
  }) {
    final distance = getDistanceBetween(
      lat1: guruLat,
      lon1: guruLon,
      lat2: schoolLat,
      lon2: schoolLon,
    );
    return distance <= radiusInMeters;
  }

  /// Get location description dari koordinat (reverse geocoding)
  /// Membutuhkan geocoding package tambahan jika ingin implementasi penuh
  String getLocationDescription(double lat, double lon) {
    return 'Lat: ${lat.toStringAsFixed(6)}, Lon: ${lon.toStringAsFixed(6)}';
  }
}
