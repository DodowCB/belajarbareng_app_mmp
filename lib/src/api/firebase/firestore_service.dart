import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service class untuk berinteraksi dengan Firebase Firestore
/// Menyediakan operasi CRUD untuk data aplikasi BelajarBareng
class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mendapatkan instance current user
  User? get currentUser => _auth.currentUser;

  /// Koleksi Users
  static const String _usersCollection = 'users';
  /// Koleksi Study Groups
  static const String _studyGroupsCollection = 'study_groups';
  /// Koleksi Learning Materials
  static const String _materialsCollection = 'learning_materials';
  /// Koleksi Progress Tracking
  static const String _progressCollection = 'user_progress';

  // ===== USER OPERATIONS =====

  /// Membuat atau memperbarui data user
  Future<void> createOrUpdateUser({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .set(userData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error creating/updating user: $e');
    }
  }

  /// Mendapatkan data user berdasarkan ID
  Future<DocumentSnapshot> getUserData(String userId) async {
    try {
      return await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }

  /// Stream untuk mendengarkan perubahan data user
  Stream<DocumentSnapshot> getUserDataStream(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .snapshots();
  }

  // ===== STUDY GROUPS OPERATIONS =====

  /// Membuat study group baru
  Future<DocumentReference> createStudyGroup(Map<String, dynamic> groupData) async {
    try {
      return await _firestore
          .collection(_studyGroupsCollection)
          .add({
        ...groupData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error creating study group: $e');
    }
  }

  /// Mendapatkan daftar study groups
  Future<QuerySnapshot> getStudyGroups({
    int limit = 20,
    String? orderBy = 'createdAt',
    bool descending = true,
  }) async {
    try {
      Query query = _firestore.collection(_studyGroupsCollection);

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      return await query.limit(limit).get();
    } catch (e) {
      throw Exception('Error getting study groups: $e');
    }
  }

  /// Stream untuk mendengarkan perubahan study groups
  Stream<QuerySnapshot> getStudyGroupsStream({
    int limit = 20,
    String? orderBy = 'createdAt',
    bool descending = true,
  }) {
    Query query = _firestore.collection(_studyGroupsCollection);

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    return query.limit(limit).snapshots();
  }

  /// Join study group
  Future<void> joinStudyGroup(String groupId, String userId) async {
    try {
      await _firestore
          .collection(_studyGroupsCollection)
          .doc(groupId)
          .update({
        'members': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error joining study group: $e');
    }
  }

  /// Leave study group
  Future<void> leaveStudyGroup(String groupId, String userId) async {
    try {
      await _firestore
          .collection(_studyGroupsCollection)
          .doc(groupId)
          .update({
        'members': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error leaving study group: $e');
    }
  }

  // ===== LEARNING MATERIALS OPERATIONS =====

  /// Menambahkan learning material baru
  Future<DocumentReference> addLearningMaterial(Map<String, dynamic> materialData) async {
    try {
      return await _firestore
          .collection(_materialsCollection)
          .add({
        ...materialData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error adding learning material: $e');
    }
  }

  /// Mendapatkan learning materials berdasarkan kategori
  Future<QuerySnapshot> getLearningMaterials({
    String? category,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore.collection(_materialsCollection);

      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }

      return await query
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
    } catch (e) {
      throw Exception('Error getting learning materials: $e');
    }
  }

  // ===== USER PROGRESS OPERATIONS =====

  /// Memperbarui progress user
  Future<void> updateUserProgress({
    required String userId,
    required String materialId,
    required double progressPercentage,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final progressId = '${userId}_$materialId';
      await _firestore
          .collection(_progressCollection)
          .doc(progressId)
          .set({
        'userId': userId,
        'materialId': materialId,
        'progress': progressPercentage,
        'lastUpdated': FieldValue.serverTimestamp(),
        ...?additionalData,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error updating user progress: $e');
    }
  }

  /// Mendapatkan progress user
  Future<QuerySnapshot> getUserProgress(String userId) async {
    try {
      return await _firestore
          .collection(_progressCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('lastUpdated', descending: true)
          .get();
    } catch (e) {
      throw Exception('Error getting user progress: $e');
    }
  }

  // ===== UTILITY METHODS =====

  /// Menghapus dokumen berdasarkan collection dan document ID
  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Error deleting document: $e');
    }
  }

  /// Batch write operations
  WriteBatch get batch => _firestore.batch();

  /// Commit batch operations
  Future<void> commitBatch(WriteBatch batch) async {
    try {
      await batch.commit();
    } catch (e) {
      throw Exception('Error committing batch: $e');
    }
  }
}
