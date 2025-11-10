import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<User?> _authSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    // Listen to auth state changes
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        _loadUserProfile(user);
      } else {
        add(const AuthCheckRequested());
      }
    });

    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoadGuruData>(_onLoadGuruData);
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        await _loadUserProfile(userCredential.user!);
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final userCredential = await _authRepository.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        // Create guru profile
        await _authRepository.createGuruProfile(
          userId: userCredential.user!.uid,
          namaLengkap: event.namaLengkap,
          email: event.email,
          nig: event.nig,
          mataPelajaran: event.mataPelajaran,
          sekolah: event.sekolah,
          jenisKelamin: event.jenisKelamin,
          tanggalLahir: event.tanggalLahir,
        );

        await _loadUserProfile(userCredential.user!);
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authRepository.currentUser;

    if (user != null) {
      await _loadUserProfile(user);
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLoadGuruData(
    LoadGuruData event,
    Emitter<AuthState> emit,
  ) async {
    emit(const GuruDataLoading());

    try {
      final guruList = await _authRepository.getAllGuru();
      emit(GuruDataLoaded(guruList: guruList));
    } catch (e) {
      emit(GuruDataError(message: e.toString()));
    }
  }

  Future<void> _loadUserProfile(User user) async {
    try {
      final guruProfile = await _authRepository.getGuruProfile(user.uid);
      emit(AuthAuthenticated(user: user, guruProfile: guruProfile));
    } catch (e) {
      emit(AuthAuthenticated(user: user));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
