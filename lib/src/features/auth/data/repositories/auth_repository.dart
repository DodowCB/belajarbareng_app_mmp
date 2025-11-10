import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/guru_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register new user
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Create or update guru profile
  Future<void> createGuruProfile({
    required String userId,
    required String namaLengkap,
    required String email,
    required int nig,
    required String mataPelajaran,
    required String sekolah,
    required String jenisKelamin,
    String? photoUrl,
    DateTime? tanggalLahir,
  }) async {
    try {
      final guru = GuruModel(
        id: userId,
        namaLengkap: namaLengkap,
        email: email,
        nig: nig,
        mataPelajaran: mataPelajaran,
        sekolah: sekolah,
        jenisKelamin: jenisKelamin,
        status: 'aktif',
        photoUrl: photoUrl,
        tanggalLahir: tanggalLahir ?? DateTime.now(),
      );

      await _firestore.collection('guru').doc(userId).set(guru.toFirestore());
    } catch (e) {
      throw Exception('Failed to create guru profile: $e');
    }
  }

  // Get guru profile
  Future<GuruModel?> getGuruProfile(String userId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('guru').doc(userId).get();

      if (doc.exists) {
        return GuruModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get guru profile: $e');
    }
  }

  // Get all guru data for display
  Future<List<GuruModel>> getAllGuru() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore.collection('guru').get();

      return querySnapshot.docs.map((doc) => GuruModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get guru data: $e');
    }
  }

  // Update guru profile
  Future<void> updateGuruProfile(GuruModel guru) async {
    try {
      await _firestore.collection('guru').doc(guru.id).update({
        ...guru.toFirestore(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update guru profile: $e');
    }
  }

  // Delete guru profile
  Future<void> deleteGuruProfile(String userId) async {
    try {
      await _firestore.collection('guru').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete guru profile: $e');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
