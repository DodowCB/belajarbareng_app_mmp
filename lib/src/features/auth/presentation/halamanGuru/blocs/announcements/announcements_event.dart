import 'package:equatable/equatable.dart';

abstract class AnnouncementsEvent extends Equatable {
  const AnnouncementsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnnouncements extends AnnouncementsEvent {
  const LoadAnnouncements();
}

class RefreshAnnouncements extends AnnouncementsEvent {
  const RefreshAnnouncements();
}

class LoadAnnouncementsByType extends AnnouncementsEvent {
  final String type; // 'all', 'admin', 'guru'

  const LoadAnnouncementsByType(this.type);

  @override
  List<Object?> get props => [type];
}

class CreateAnnouncement extends AnnouncementsEvent {
  final String judul;
  final String deskripsi;
  final String guruId;
  final String namaGuru;
  final String pembuat;

  const CreateAnnouncement({
    required this.judul,
    required this.deskripsi,
    required this.guruId,
    required this.namaGuru,
    required this.pembuat,
  });

  @override
  List<Object?> get props => [judul, deskripsi, guruId, namaGuru, pembuat];
}
