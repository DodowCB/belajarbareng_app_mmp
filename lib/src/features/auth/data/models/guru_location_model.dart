import 'package:cloud_firestore/cloud_firestore.dart';

/// Model untuk menyimpan lokasi guru
class GuruLocation {
  final String guruId;
  final String guruName;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? accuracy; // Akurasi GPS (high, medium, low)
  final bool isOnline; // Status online/offline

  GuruLocation({
    required this.guruId,
    required this.guruName,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.isOnline = true,
  });

  // Convert dari Firestore
  factory GuruLocation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GuruLocation(
      guruId: doc.id,
      guruName: data['guruName'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      accuracy: data['accuracy'],
      isOnline: data['isOnline'] ?? true,
    );
  }

  // Convert ke Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'guruName': guruName,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': Timestamp.fromDate(timestamp),
      'accuracy': accuracy,
      'isOnline': isOnline,
    };
  }

  // Copy with
  GuruLocation copyWith({
    String? guruId,
    String? guruName,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    String? accuracy,
    bool? isOnline,
  }) {
    return GuruLocation(
      guruId: guruId ?? this.guruId,
      guruName: guruName ?? this.guruName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  // Format koordinat untuk display
  String get coordinatesString {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  // Format timestamp
  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
