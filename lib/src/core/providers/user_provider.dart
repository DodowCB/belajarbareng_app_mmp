import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  // Singleton pattern
  static final UserProvider _instance = UserProvider._internal();
  factory UserProvider() => _instance;
  UserProvider._internal();

  // User data
  String? _userId;
  String? _email;
  String? _namaLengkap;
  String? _userType; // 'guru' atau 'siswa'
  Map<String, dynamic>? _userData;

  // Getters
  String? get userId => _userId;
  String? get email => _email;
  String? get namaLengkap => _namaLengkap;
  String? get userType => _userType;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoggedIn => _userId != null;
  bool get isGuru => _userType == 'guru';
  bool get isSiswa => _userType == 'siswa';

  // Set user data
  void setUserData({
    required String userId,
    required String email,
    required String namaLengkap,
    required String userType,
    Map<String, dynamic>? additionalData,
  }) {
    _userId = userId;
    _email = email;
    _namaLengkap = namaLengkap;
    _userType = userType;
    _userData = {
      'uid': userId,
      'email': email,
      'namaLengkap': namaLengkap,
      'userType': userType,
      ...?additionalData,
    };
    notifyListeners();
  }

  // Update user data
  void updateUserData(Map<String, dynamic> newData) {
    if (_userData != null) {
      _userData!.addAll(newData);

      // Update individual fields if they exist in newData
      if (newData.containsKey('email')) _email = newData['email'];
      if (newData.containsKey('namaLengkap'))
        _namaLengkap = newData['namaLengkap'];
      if (newData.containsKey('userType')) _userType = newData['userType'];

      notifyListeners();
    }
  }

  // Clear user data (logout)
  void clearUserData() {
    _userId = null;
    _email = null;
    _namaLengkap = null;
    _userType = null;
    _userData = null;
    notifyListeners();
  }

  // Get specific field from userData
  T? getField<T>(String fieldName) {
    if (_userData != null && _userData!.containsKey(fieldName)) {
      return _userData![fieldName] as T?;
    }
    return null;
  }

  // Check if user has specific role/permission
  bool hasRole(String role) {
    return _userType == role;
  }

  // Get user display name (prioritize namaLengkap, fallback to email)
  String get displayName {
    if (_namaLengkap != null && _namaLengkap!.isNotEmpty) {
      return _namaLengkap!;
    }
    return _email ?? 'User';
  }

  // Get user info for debugging
  Map<String, dynamic> toMap() {
    return {
      'userId': _userId,
      'email': _email,
      'namaLengkap': _namaLengkap,
      'userType': _userType,
      'userData': _userData,
    };
  }

  @override
  String toString() {
    return 'UserProvider(userId: $_userId, email: $_email, namaLengkap: $_namaLengkap, userType: $_userType)';
  }
}

// Global instance untuk akses mudah
final userProvider = UserProvider();
