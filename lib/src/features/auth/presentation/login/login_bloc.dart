import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/providers/user_provider.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LoginCheckRequested>(_onLoginCheckRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      print('Starting login process for: ${event.email}'); // Debug log

      // Validasi input
      if (event.email.trim().isEmpty) {
        emit(LoginError(message: 'Email tidak boleh kosong'));
        return;
      }

      if (event.password.isEmpty) {
        emit(LoginError(message: 'Password tidak boleh kosong'));
        return;
      }

      // Declare variables first
      Map<String, dynamic>? authenticatedUser;
      String userType = '';

      // Cek hardcoded dummy credentials terlebih dahulu
      print('Checking credentials: ${event.email}'); // Debug log
      print('Checking password: ${event.password}'); // Debug log

      // Admin dummy login
      if (event.email.trim().toLowerCase() == 'admin@gmail.com' &&
          event.password == '123') {
        authenticatedUser = {
          'uid': 'admin_001',
          'email': 'admin@gmail.com',
          'namaLengkap': 'Administrator',
          'userType': 'admin',
          'role': 'admin',
        };
        userType = 'admin';
      }
      // Guru dummy login
      else if (event.email.trim().toLowerCase() == 'guru@gmail.com' &&
          event.password == '123') {
        authenticatedUser = {
          'uid': 'guru_001',
          'email': 'guru@gmail.com',
          'namaLengkap': 'Guru Demo',
          'userType': 'guru',
          'nig': 'NIG001',
          'mataPelajaran': 'Matematika',
          'sekolah': 'SMA Negeri 1',
        };
        userType = 'guru';
      }
      // Siswa dummy login
      else if (event.email.trim().toLowerCase() == 'siswa@gmail.com' &&
          event.password == '123') {
        authenticatedUser = {
          'uid': 'siswa_001',
          'email': 'siswa@gmail.com',
          'namaLengkap': 'Siswa Demo',
          'userType': 'siswa',
          'nis': 'NIS001',
          'kelas': '12 IPA 1',
          'sekolah': 'SMA Negeri 1',
        };
        userType = 'siswa';
      } else {
        // Cek user dari kedua collection: guru dan siswa
        // Cek di collection 'guru' dulu
        final guruQuerySnapshot = await FirebaseFirestore.instance
            .collection('guru')
            .where('email', isEqualTo: event.email.trim())
            .where('password', isEqualTo: event.password)
            .get();

        if (guruQuerySnapshot.docs.isNotEmpty) {
          final userDoc = guruQuerySnapshot.docs.first;
          final userData = userDoc.data();
          userType = 'guru';
          print('Guru user found: ${userData['namaLengkap']}');
          authenticatedUser = {
            'uid': userDoc.id,
            'email': userData['email'],
            'namaLengkap':
                userData['namaLengkap'] ?? userData['nama_lengkap'] ?? '',
            'userType': userType,
            'nig': userData['nig'],
            'mataPelajaran': userData['mataPelajaran'] ?? '',
            'sekolah': userData['sekolah'] ?? '',
          };
        } else {
          // Jika tidak ditemukan di guru, cek di collection 'siswa'
          final siswaQuerySnapshot = await FirebaseFirestore.instance
              .collection('siswa')
              .where('email', isEqualTo: event.email.trim().toLowerCase())
              .where('password', isEqualTo: event.password)
              .get();

          if (siswaQuerySnapshot.docs.isNotEmpty) {
            final userDoc = siswaQuerySnapshot.docs.first;
            final userData = siswaQuerySnapshot.docs.first.data();
            userType = 'siswa';

            authenticatedUser = {
              'uid': userDoc.id,
              'email': userData['email'],
              'namaLengkap': userData['namaLengkap'] ?? userData['nama'] ?? '',
              'userType': userType,
              'nis': userData['nis'],
              'kelas': userData['kelas'] ?? '',
              'sekolah': userData['sekolah'] ?? '',
            };
          }
        }
      } // Close the else block for admin check

      if (authenticatedUser == null) {
        throw Exception('Login gagal: Email atau password salah');
      }

      print('Login successful as $userType'); // Debug log
      print('User ID: ${authenticatedUser['uid']}'); // Debug log
      print('User Email: ${authenticatedUser['email']}'); // Debug log
      print('User Name: ${authenticatedUser['namaLengkap']}'); // Debug log

      // Set user data ke global provider
      userProvider.setUserData(
        userId: authenticatedUser['uid']!,
        email: authenticatedUser['email']!,
        namaLengkap: authenticatedUser['namaLengkap']!,
        userType: authenticatedUser['userType']!,
        additionalData: authenticatedUser,
      );

      if (userType == 'admin') {
        // Untuk admin
        print('Admin login successful'); // Debug log
        emit(
          LoginSuccess(
            user: null,
            guruProfile: null,
            userData: authenticatedUser,
          ),
        );
      } else if (userType == 'guru') {
        // Untuk guru, coba ambil guru profile juga
        final guruProfile = await _authRepository.getGuruProfile(
          authenticatedUser['uid']!,
        );

        if (guruProfile != null) {
          print('Guru profile loaded: ${guruProfile.namaLengkap}'); // Debug log
          emit(
            LoginSuccess(
              user: null,
              guruProfile: guruProfile,
              userData: authenticatedUser,
            ),
          );
        } else {
          print('No guru profile found, using basic guru data'); // Debug log
          emit(
            LoginSuccess(
              user: null,
              guruProfile: null,
              userData: authenticatedUser,
            ),
          );
        }
      } else {
        // Untuk siswa
        print('Siswa login successful'); // Debug log
        emit(
          LoginSuccess(
            user: null,
            guruProfile: null, // Siswa tidak punya guru profile
            userData: authenticatedUser,
          ),
        );
      }
    } catch (e) {
      print('Login error caught: $e'); // Debug log
      emit(LoginError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoginCheckRequested(
    LoginCheckRequested event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final currentUser = _authRepository.currentUser;

      if (currentUser != null) {
        print('Current user found: ${currentUser.email}'); // Debug log

        final guruProfile = await _authRepository.getGuruProfile(
          currentUser.uid,
        );

        if (guruProfile != null) {
          emit(
            LoginSuccess(
              user: currentUser,
              guruProfile: guruProfile,
              userData: {
                'uid': currentUser.uid,
                'email': currentUser.email ?? '',
                'name': currentUser.displayName ?? '',
              },
            ),
          );
        } else {
          emit(
            LoginSuccess(
              user: currentUser,
              guruProfile: null,
              userData: {
                'uid': currentUser.uid,
                'email': currentUser.email ?? '',
                'name': currentUser.displayName ?? '',
              },
            ),
          );
        }
      } else {
        print('No current user found'); // Debug log
        emit(LoginInitial());
      }
    } catch (e) {
      print('Login check error: $e'); // Debug log
      emit(LoginError(message: 'Gagal memeriksa status login'));
    }
  }
}
