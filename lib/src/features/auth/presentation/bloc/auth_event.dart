import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String namaLengkap;
  final int nig;
  final String mataPelajaran;
  final String sekolah;
  final String jenisKelamin;
  final DateTime? tanggalLahir;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.namaLengkap,
    required this.nig,
    required this.mataPelajaran,
    required this.sekolah,
    required this.jenisKelamin,
    this.tanggalLahir,
  });

  @override
  List<Object?> get props => [email, password, namaLengkap, nig, mataPelajaran, sekolah, jenisKelamin, tanggalLahir];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class LoadGuruData extends AuthEvent {
  const LoadGuruData();
}
