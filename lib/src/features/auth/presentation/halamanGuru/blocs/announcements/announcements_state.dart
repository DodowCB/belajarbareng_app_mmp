import 'package:equatable/equatable.dart';
import '../../../../data/models/pengumuman_model.dart';

abstract class AnnouncementsState extends Equatable {
  const AnnouncementsState();

  @override
  List<Object?> get props => [];
}

class AnnouncementsInitial extends AnnouncementsState {
  const AnnouncementsInitial();
}

class AnnouncementsLoading extends AnnouncementsState {
  const AnnouncementsLoading();
}

class AnnouncementsLoaded extends AnnouncementsState {
  final List<PengumumanModel> announcements;
  final List<PengumumanModel> selectedAnnouncements;

  const AnnouncementsLoaded({
    required this.announcements,
    required this.selectedAnnouncements,
  });

  @override
  List<Object?> get props => [announcements, selectedAnnouncements];
}

class AnnouncementsError extends AnnouncementsState {
  final String message;

  const AnnouncementsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AnnouncementCreated extends AnnouncementsState {
  final String message;

  const AnnouncementCreated(this.message);

  @override
  List<Object?> get props => [message];
}
