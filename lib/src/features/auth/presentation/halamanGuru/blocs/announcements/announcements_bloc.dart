import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/pengumuman_model.dart';
import 'announcements_event.dart';
import 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  AnnouncementsBloc() : super(const AnnouncementsInitial()) {
    on<LoadAnnouncements>(_onLoadAnnouncements);
    on<CreateAnnouncement>(_onCreateAnnouncement);
    on<LoadAnnouncementsByType>(_onLoadAnnouncementsByType);
  }

  Future<void> _onLoadAnnouncements(
    LoadAnnouncements event,
    Emitter<AnnouncementsState> emit,
  ) async {
    emit(const AnnouncementsLoading());

    try {
      // Dummy data untuk testing performance
      await Future.delayed(const Duration(milliseconds: 300));

      final announcements = [
        PengumumanModel(
          id: '1',
          judul: 'Informasi Ujian Tengah Semester',
          deskripsi:
              'Ujian tengah semester akan dilaksanakan mulai tanggal 15 November 2024.',
          guruId: 'guru1',
          namaGuru: 'Budi Santoso',
          pembuat: 'admin',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        PengumumanModel(
          id: '2',
          judul: 'Libur Nasional',
          deskripsi:
              'Sekolah akan libur pada tanggal 17 November dalam rangka memperingati Hari Guru.',
          guruId: 'guru2',
          namaGuru: 'Siti Aminah',
          pembuat: 'admin',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

      emit(
        AnnouncementsLoaded(
          announcements: announcements,
          selectedAnnouncements: announcements,
        ),
      );
    } catch (e) {
      emit(AnnouncementsError('Failed to load announcements: ${e.toString()}'));
    }
  }

  Future<void> _onCreateAnnouncement(
    CreateAnnouncement event,
    Emitter<AnnouncementsState> emit,
  ) async {
    // Dummy implementation
    add(LoadAnnouncements());
  }

  Future<void> _onLoadAnnouncementsByType(
    LoadAnnouncementsByType event,
    Emitter<AnnouncementsState> emit,
  ) async {
    // Dummy implementation
    add(LoadAnnouncements());
  }
}
