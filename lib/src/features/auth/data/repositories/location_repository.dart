import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/location_service.dart';
import '../models/guru_location_model.dart';

/// Repository untuk mengelola lokasi guru di Firestore
class LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocationService _locationService = LocationService();

  /// Update lokasi guru ke Firestore
  Future<void> updateGuruLocation({
    required String guruId,
    required String guruName,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final location = GuruLocation(
        guruId: guruId,
        guruName: guruName,
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 'high',
        isOnline: true,
      );

      await _firestore
          .collection('guru_locations')
          .doc(guruId)
          .set(location.toMap(), SetOptions(merge: true));

      print('Location updated for guru: $guruId');
    } catch (e) {
      print('Error updating guru location: $e');
      rethrow;
    }
  }

  /// Update lokasi guru dengan Position object
  Future<void> updateGuruLocationFromPosition({
    required String guruId,
    required String guruName,
    required Position position,
  }) async {
    await updateGuruLocation(
      guruId: guruId,
      guruName: guruName,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  /// Set guru offline (saat logout)
  Future<void> setGuruOffline(String guruId) async {
    try {
      print('🔴 [LocationRepository] Setting guru offline: $guruId');

      // Use set with merge to handle if document doesn't exist
      await _firestore.collection('guru_locations').doc(guruId).set({
        'isOnline': false,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ [LocationRepository] Guru $guruId set to offline successfully');
    } catch (e) {
      print('❌ [LocationRepository] Error setting guru offline: $e');
      rethrow;
    }
  }

  /// Get lokasi guru tertentu
  Future<GuruLocation?> getGuruLocation(String guruId) async {
    try {
      final doc = await _firestore
          .collection('guru_locations')
          .doc(guruId)
          .get();
      if (doc.exists) {
        return GuruLocation.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting guru location: $e');
      return null;
    }
  }

  /// Get semua lokasi guru (untuk admin)
  Stream<List<GuruLocation>> getAllGuruLocations() {
    return _firestore.collection('guru_locations').snapshots().map((snapshot) {
      final locations = snapshot.docs
          .map((doc) => GuruLocation.fromFirestore(doc))
          .toList();
      // Sort by timestamp descending on client side
      locations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return locations;
    });
  }

  /// Get hanya guru yang online
  Stream<List<GuruLocation>> getOnlineGuruLocations() {
    return _firestore
        .collection('guru_locations')
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final locations = snapshot.docs
              .map((doc) => GuruLocation.fromFirestore(doc))
              .toList();
          // Sort by timestamp descending on client side
          locations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return locations;
        });
  }

  /// Request dan update lokasi guru saat ini
  Future<bool> requestAndUpdateCurrentLocation({
    required String guruId,
    required String guruName,
  }) async {
    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        await updateGuruLocationFromPosition(
          guruId: guruId,
          guruName: guruName,
          position: position,
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error requesting location: $e');
      return false;
    }
  }
}
