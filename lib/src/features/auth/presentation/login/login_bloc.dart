import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LoginCheckRequested>(_onLoginCheckRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        // Load user profile
        final guruProfile = await _authRepository.getGuruProfile(
          userCredential.user!.uid,
        );

        emit(
          LoginSuccess(user: userCredential.user!, guruProfile: guruProfile),
        );
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }

  Future<void> _onLoginCheckRequested(
    LoginCheckRequested event,
    Emitter<LoginState> emit,
  ) async {
    final currentUser = _authRepository.currentUser;

    if (currentUser != null) {
      final guruProfile = await _authRepository.getGuruProfile(currentUser.uid);
      emit(LoginSuccess(user: currentUser, guruProfile: guruProfile));
    } else {
      emit(const LoginInitial());
    }
  }
}
