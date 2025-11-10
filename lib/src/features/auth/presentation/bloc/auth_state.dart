import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/guru_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;
  final GuruModel? guruProfile;

  const AuthAuthenticated({
    required this.user,
    this.guruProfile,
  });

  @override
  List<Object?> get props => [user, guruProfile];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GuruDataLoaded extends AuthState {
  final List<GuruModel> guruList;

  const GuruDataLoaded({required this.guruList});

  @override
  List<Object?> get props => [guruList];
}

class GuruDataLoading extends AuthState {
  const GuruDataLoading();
}

class GuruDataError extends AuthState {
  final String message;

  const GuruDataError({required this.message});

  @override
  List<Object?> get props => [message];
}
