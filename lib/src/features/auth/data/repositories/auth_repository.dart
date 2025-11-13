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
      // Validasi input sebelum mengirim ke Firebase
      if (email.trim().isEmpty || password.isEmpty) {
        throw Exception('Email dan password tidak boleh kosong');
      }

      // Validasi format email
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
        throw Exception('Format email tidak valid');
      }

      // Trim whitespace dari email dan convert ke lowercase
      final cleanEmail = email.trim().toLowerCase();

      print('Attempting login with email: $cleanEmail'); // Debug log

      final UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: cleanEmail, password: password);

      print('Login successful for: ${result.user?.email}'); // Debug log
      return result;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}'); // Debug log
      throw _handleAuthException(e);
    } catch (e) {
      print('General Error: $e'); // Debug log
      throw Exception('Login failed: $e');
    }
  }

  // Register new user
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      print('User signed out successfully'); // Debug log
    } catch (e) {
      print('Sign out error: $e'); // Debug log
      throw Exception('Failed to sign out: $e');
    }
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
      print('Fetching guru profile for userId: $userId'); // Debug log

      final DocumentSnapshot doc = await _firestore
          .collection('guru')
          .doc(userId)
          .get();

      if (doc.exists) {
        print('Guru profile found'); // Debug log
        return GuruModel.fromFirestore(doc);
      }

      print('No guru profile found for userId: $userId'); // Debug log
      return null;
    } catch (e) {
      print('Error fetching guru profile: $e'); // Debug log
      throw Exception('Failed to get guru profile: $e');
    }
  }

  // Get all guru data for display
  Future<List<GuruModel>> getAllGuru() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('guru')
          .get();

      return querySnapshot.docs
          .map((doc) => GuruModel.fromFirestore(doc))
          .toList();
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
        return 'Password terlalu lemah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'user-not-found':
        return 'Email tidak terdaftar dalam sistem';
      case 'wrong-password':
        return 'Password salah';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun pengguna telah dinonaktifkan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Coba lagi nanti';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      case 'invalid-credential':
        return 'Email atau password salah';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet';
      case 'internal-error':
        return 'Terjadi kesalahan server. Coba lagi nanti';
      default:
        return 'Terjadi kesalahan: ${e.message ?? 'Unknown error'}';
    }
  }
}
