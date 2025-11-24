import 'package:equatable/equatable.dart';

abstract class GuruProfileEvent extends Equatable {
  const GuruProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadGuruProfile extends GuruProfileEvent {
  const LoadGuruProfile();
}

class RefreshGuruProfile extends GuruProfileEvent {
  const RefreshGuruProfile();
}

class UpdateGuruProfile extends GuruProfileEvent {
  final Map<String, dynamic> profileData;

  const UpdateGuruProfile(this.profileData);

  @override
  List<Object?> get props => [profileData];
}
