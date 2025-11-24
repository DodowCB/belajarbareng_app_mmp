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
      final querySnapshot = await _firestore
          .collection('pengumuman')
          .orderBy('createdAt', descending: true)
          .limit(3)  // Reduce load dengan hanya ambil 3 announcements
          .get();

      final announcements = querySnapshot.docs
          .map((doc) => PengumumanModel.fromFirestore(doc))
          .toList();

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
    try {
      // Get next ID
      final counterDoc = await _firestore
          .collection('counters')
          .doc('pengumuman')
          .get();
      int nextId = 1;

      if (counterDoc.exists) {
        nextId = (counterDoc.data()?['count'] ?? 0) + 1;
      }

      // Create announcement
      await _firestore.collection('pengumuman').doc(nextId.toString()).set({
        'id': nextId,
        'judul': event.judul,
        'deskripsi': event.deskripsi,
        'guru_id': event.guruId,
        'nama_guru': event.namaGuru,
        'pembuat': event.pembuat,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
      });

      // Update counter
      await _firestore.collection('counters').doc('pengumuman').set({
        'count': nextId,
      }, SetOptions(merge: true));

      // Reload announcements
      add(LoadAnnouncements());
    } catch (e) {
      emit(
        AnnouncementsError('Failed to create announcement: ${e.toString()}'),
      );
    }
  }

  Future<void> _onLoadAnnouncementsByType(
    LoadAnnouncementsByType event,
    Emitter<AnnouncementsState> emit,
  ) async {
    emit(const AnnouncementsLoading());

    try {
      Query query = _firestore
          .collection('pengumuman')
          .orderBy('createdAt', descending: true);

      if (event.type == 'recent') {
        query = query.limit(5);
      } else if (event.type == 'important') {
        // Add filter for important announcements if needed
      }

      final querySnapshot = await query.get();

      final announcements = querySnapshot.docs
          .map((doc) => PengumumanModel.fromFirestore(doc))
          .toList();

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
}
