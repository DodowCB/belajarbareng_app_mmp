import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/providers/app_user.dart';

// Events
abstract class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserInfo extends UserInfoEvent {}

class LogoutUser extends UserInfoEvent {}

// States
abstract class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object?> get props => [];
}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final bool isLoggedIn;
  final String? email;
  final String? roleDisplayName;
  final String? greetingMessage;
  final String? displayName;
  final String? sekolah;
  final int? nig;
  final String? mataPelajaran;
  final int? nis;
  final String? kelas;
  final bool isGuru;
  final bool isSiswa;

  const UserInfoLoaded({
    required this.isLoggedIn,
    this.email,
    this.roleDisplayName,
    this.greetingMessage,
    this.displayName,
    this.sekolah,
    this.nig,
    this.mataPelajaran,
    this.nis,
    this.kelas,
    required this.isGuru,
    required this.isSiswa,
  });

  @override
  List<Object?> get props => [
    isLoggedIn,
    email,
    roleDisplayName,
    greetingMessage,
    displayName,
    sekolah,
    nig,
    mataPelajaran,
    nis,
    kelas,
    isGuru,
    isSiswa,
  ];
}

class UserInfoError extends UserInfoState {
  final String message;

  const UserInfoError(this.message);

  @override
  List<Object?> get props => [message];
}

class LogoutSuccess extends UserInfoState {}

// BLoC
class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoBloc() : super(UserInfoInitial()) {
    on<LoadUserInfo>(_onLoadUserInfo);
    on<LogoutUser>(_onLogoutUser);
  }

  void _onLoadUserInfo(LoadUserInfo event, Emitter<UserInfoState> emit) {
    try {
      emit(UserInfoLoading());

      // Load user info from AppUser
      emit(
        UserInfoLoaded(
          isLoggedIn: AppUser.isLoggedIn,
          email: AppUser.email,
          roleDisplayName: AppUser.roleDisplayName,
          greetingMessage: AppUser.greetingMessage,
          displayName: AppUser.displayName,
          sekolah: AppUser.sekolah,
          nig: AppUser.nig,
          mataPelajaran: AppUser.mataPelajaran,
          nis: AppUser.nis,
          kelas: AppUser.kelas,
          isGuru: AppUser.isGuru,
          isSiswa: AppUser.isSiswa,
        ),
      );
    } catch (e) {
      emit(UserInfoError('Failed to load user info: ${e.toString()}'));
    }
  }

  void _onLogoutUser(LogoutUser event, Emitter<UserInfoState> emit) {
    try {
      AppUser.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(UserInfoError('Failed to logout: ${e.toString()}'));
    }
  }
}
