import 'user_provider.dart';

/// Helper class untuk akses mudah ke data user global
class AppUser {
  // Singleton instance dari UserProvider
  static final UserProvider _provider = userProvider;

  /// Apakah user sudah login
  static bool get isLoggedIn => _provider.isLoggedIn;

  /// User ID
  static String? get id => _provider.userId;
  static String? get uid => _provider.userId; // alias

  /// Email user
  static String? get email => _provider.email;

  /// Nama lengkap user
  static String? get name => _provider.namaLengkap;
  static String? get namaLengkap => _provider.namaLengkap;

  /// Tipe user (guru/siswa)
  static String? get type => _provider.userType;
  static String? get userType => _provider.userType;

  /// Cek apakah user adalah guru
  static bool get isGuru => _provider.isGuru;

  /// Cek apakah user adalah siswa
  static bool get isSiswa => _provider.isSiswa;

  /// Get display name (nama atau email)
  static String get displayName => _provider.displayName;

  /// Get all user data
  static Map<String, dynamic>? get data => _provider.userData;

  /// Get specific field dari user data
  static T? getField<T>(String fieldName) => _provider.getField<T>(fieldName);

  /// Shorthand untuk fields yang sering digunakan
  static int? get nig => getField<int>('nig'); // Untuk guru
  static int? get nis => getField<int>('nis'); // Untuk siswa
  static String? get mataPelajaran =>
      getField<String>('mataPelajaran'); // Untuk guru
  static String? get kelas => getField<String>('kelas'); // Untuk siswa
  static String? get sekolah => getField<String>('sekolah');

  /// Update user data
  static void updateData(Map<String, dynamic> newData) {
    _provider.updateUserData(newData);
  }

  /// Clear user data (logout)
  static void logout() {
    _provider.clearUserData();
  }

  /// Check if user has specific role
  static bool hasRole(String role) => _provider.hasRole(role);

  /// Get user info untuk debugging
  static Map<String, dynamic> toMap() => _provider.toMap();

  /// Get greeting message berdasarkan tipe user
  static String get greetingMessage {
    if (isGuru) {
      return 'Selamat datang, Pak/Bu $displayName';
    } else if (isSiswa) {
      return 'Selamat datang, $displayName';
    }
    return 'Selamat datang, $displayName';
  }

  /// Get role display name
  static String get roleDisplayName {
    switch (userType) {
      case 'guru':
        return 'Guru';
      case 'siswa':
        return 'Siswa';
      case 'admin':
        return 'Administrator';
      default:
        return 'User';
    }
  }
}
