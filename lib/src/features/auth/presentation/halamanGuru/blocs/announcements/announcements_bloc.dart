import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/pengumuman_model.dart';
import 'announcements_event.dart';
import 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      print('📢 [AnnouncementsBloc] Loading announcements from Firestore...');

      // Fetch from Firestore collection 'pengumuman'
      final querySnapshot = await _firestore
          .collection('pengumuman')
          .orderBy('createdAt', descending: true)
          .get();

      print(
        '📢 [AnnouncementsBloc] Found ${querySnapshot.docs.length} announcements',
      );

      final announcements = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return PengumumanModel(
          id: doc.id,
          judul: data['judul'] ?? '',
          deskripsi: data['deskripsi'] ?? '',
          guruId: data['guruId'] ?? data['guru_id'] ?? '',
          namaGuru: data['namaGuru'] ?? data['nama_guru'] ?? '',
          pembuat: data['pembuat'] ?? 'admin',
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();

      print(
        '✅ [AnnouncementsBloc] Successfully loaded ${announcements.length} announcements',
      );

      emit(
        AnnouncementsLoaded(
          announcements: announcements,
          selectedAnnouncements: announcements,
        ),
      );
    } catch (e) {
      print('❌ [AnnouncementsBloc] Error loading announcements: $e');
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
