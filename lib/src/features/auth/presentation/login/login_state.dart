import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/guru_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final User? user;
  final GuruModel? guruProfile;
  final Map<String, dynamic>? userData; // Tambahan untuk data dari Firestore

  const LoginSuccess({this.user, this.guruProfile, this.userData});

  @override
  List<Object?> get props => [user, guruProfile, userData];
}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object?> get props => [message];
}
