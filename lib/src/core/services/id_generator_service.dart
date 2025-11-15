import 'package:cloud_firestore/cloud_firestore.dart';

class IdGeneratorService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Mendapatkan ID selanjutnya untuk collection tertentu
  static Future<String> getNextId(String collectionName) async {
    try {
      // Get counter document
      final counterDoc = _firestore.collection('counters').doc(collectionName);

      // Run transaction to get and increment counter
      return await _firestore.runTransaction<String>((transaction) async {
        final snapshot = await transaction.get(counterDoc);

        int currentId = 1; // Default starting ID
        if (snapshot.exists) {
          currentId = (snapshot.data()?['current_id'] ?? 0) + 1;
        }

        // Update counter
        transaction.set(counterDoc, {
          'current_id': currentId,
        }, SetOptions(merge: true));

        return currentId.toString();
      });
    } catch (e) {
      // Fallback to timestamp-based ID if transaction fails
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  /// Mendapatkan multiple IDs untuk batch operations
  static Future<List<String>> getNextIds(
    String collectionName,
    int count,
  ) async {
    try {
      final counterDoc = _firestore.collection('counters').doc(collectionName);

      return await _firestore.runTransaction<List<String>>((transaction) async {
        final snapshot = await transaction.get(counterDoc);

        int currentId = 0;
        if (snapshot.exists) {
          currentId = snapshot.data()?['current_id'] ?? 0;
        }

        // Generate list of IDs
        List<String> ids = [];
        for (int i = 1; i <= count; i++) {
          ids.add((currentId + i).toString());
        }

        // Update counter with the new highest ID
        transaction.set(counterDoc, {
          'current_id': currentId + count,
        }, SetOptions(merge: true));

        return ids;
      });
    } catch (e) {
      // Fallback to timestamp-based IDs
      List<String> ids = [];
      int baseTime = DateTime.now().millisecondsSinceEpoch;
      for (int i = 0; i < count; i++) {
        ids.add((baseTime + i).toString());
      }
      return ids;
    }
  }

  /// Reset counter untuk collection tertentu (hanya untuk testing)
  static Future<void> resetCounter(String collectionName) async {
    await _firestore.collection('counters').doc(collectionName).set({
      'current_id': 0,
    });
  }
}
