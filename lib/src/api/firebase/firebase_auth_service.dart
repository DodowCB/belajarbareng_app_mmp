import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service class untuk mengelola autentikasi Firebase
/// Menyediakan berbagai metode login dan registrasi
class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Mendapatkan current user
  User? get currentUser => _auth.currentUser;

  /// Stream untuk mendengarkan perubahan auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ===== EMAIL & PASSWORD AUTHENTICATION =====

  /// Registrasi dengan email dan password
  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }

  /// Login dengan email dan password
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error during sign in: $e');
    }
  }

  // ===== GOOGLE SIGN IN =====

  /// Login dengan Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Validate auth tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to obtain Google authentication tokens');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors including handleThenable issues
      if (e.code.contains('web-context-cancelled') ||
          e.message?.contains('handleThenable') == true) {
        throw Exception('Web authentication context was cancelled or corrupted. Please try again.');
      }
      throw _handleAuthException(e);
    } catch (e) {
      // Handle handleThenable and other JS interop errors
      final errorMessage = e.toString();
      if (errorMessage.contains('handleThenable')) {
        throw Exception('Web authentication error. Please refresh the page and try again.');
      }
      throw Exception('Error during Google sign in: $e');
    }
  }

  // ===== PASSWORD RESET =====

  /// Mengirim email reset password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error sending password reset email: $e');
    }
  }

  // ===== PROFILE MANAGEMENT =====

  /// Update display name user
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.reload();
    } catch (e) {
      throw Exception('Error updating display name: $e');
    }
  }

  /// Update photo URL user
  Future<void> updatePhotoURL(String photoURL) async {
    try {
      await _auth.currentUser?.updatePhotoURL(photoURL);
      await _auth.currentUser?.reload();
    } catch (e) {
      throw Exception('Error updating photo URL: $e');
    }
  }

  /// Update email user (sends verification email first)
  Future<void> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error updating email: $e');
    }
  }

  /// Update password user
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }

  // ===== EMAIL VERIFICATION =====

  /// Mengirim email verifikasi
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw Exception('Error sending email verification: $e');
    }
  }

  /// Reload user untuk mendapatkan status verifikasi terbaru
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      throw Exception('Error reloading user: $e');
    }
  }

  // ===== SIGN OUT =====

  /// Logout user
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Error during sign out: $e');
    }
  }

  // ===== DELETE ACCOUNT =====

  /// Hapus akun user
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error deleting account: $e');
    }
  }

  // ===== REAUTHENTICATION =====

  /// Re-authenticate dengan email password
  Future<void> reauthenticateWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error during reauthentication: $e');
    }
  }

  /// Re-authenticate dengan Google
  Future<void> reauthenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.currentUser?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error during Google reauthentication: $e');
    }
  }

  // ===== ERROR HANDLING =====

  /// Handle Firebase Auth exceptions dan convert ke pesan yang user-friendly
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Tidak ada user yang terdaftar dengan email ini.';
      case 'wrong-password':
        return 'Password yang dimasukkan salah.';
      case 'email-already-in-use':
        return 'Email ini sudah digunakan oleh akun lain.';
      case 'weak-password':
        return 'Password terlalu lemah. Minimal 6 karakter.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'requires-recent-login':
        return 'Untuk keamanan, silakan login ulang sebelum melakukan aksi ini.';
      case 'network-request-failed':
        return 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }
}
