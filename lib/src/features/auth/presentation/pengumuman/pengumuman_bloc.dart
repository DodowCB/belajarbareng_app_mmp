import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/pengumuman_model.dart';
import 'pengumuman_event.dart';
import 'pengumuman_state.dart';
import '../../../notifications/data/repositories/notification_repository.dart';
import '../../../notifications/data/models/notification_model.dart';

class PengumumanBloc extends Bloc<PengumumanEvent, PengumumanState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationRepository _notificationRepo = NotificationRepository();

  PengumumanBloc() : super(PengumumanState()) {
    on<LoadPengumuman>(_onLoadPengumuman);
    on<RefreshPengumuman>(_onRefreshPengumuman);
    on<AddPengumuman>(_onAddPengumuman);
    on<UpdatePengumuman>(_onUpdatePengumuman);
    on<DeletePengumuman>(_onDeletePengumuman);
  }

  Future<void> _onLoadPengumuman(
    LoadPengumuman event,
    Emitter<PengumumanState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final querySnapshot = await _firestore
          .collection('pengumuman')
          .orderBy('createdAt', descending: true) // Sorting descending
          .get();

      final pengumumanList = querySnapshot.docs
          .map((doc) => PengumumanModel.fromFirestore(doc))
          .toList();

      emit(state.copyWith(isLoading: false, pengumumanList: pengumumanList));
    } catch (e) {
      print('Error loading pengumuman: $e');
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error loading pengumuman: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefreshPengumuman(
    RefreshPengumuman event,
    Emitter<PengumumanState> emit,
  ) async {
    add(LoadPengumuman());
  }

  Future<void> _onAddPengumuman(
    AddPengumuman event,
    Emitter<PengumumanState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

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

      // Create pengumuman with numeric ID
      await _firestore.collection('pengumuman').doc(nextId.toString()).set({
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

      // Send notifications to target users
      await _sendPengumumanNotifications(
        nextId.toString(),
        event.judul,
        event.deskripsi,
        event.pembuat,
      );

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'Pengumuman berhasil ditambahkan',
        ),
      );

      // Reload data
      add(LoadPengumuman());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error adding pengumuman: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdatePengumuman(
    UpdatePengumuman event,
    Emitter<PengumumanState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      await _firestore.collection('pengumuman').doc(event.id).update({
        'judul': event.judul,
        'deskripsi': event.deskripsi,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'Pengumuman berhasil diperbarui',
        ),
      );

      // Reload data
      add(LoadPengumuman());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error updating pengumuman: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeletePengumuman(
    DeletePengumuman event,
    Emitter<PengumumanState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      print('🗑️ Attempting to delete pengumuman with ID: ${event.id}');

      final docRef = _firestore.collection('pengumuman').doc(event.id);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        print('❌ Document not found: ${event.id}');
        emit(
          state.copyWith(isLoading: false, error: 'Pengumuman tidak ditemukan'),
        );
        return;
      }

      print('✅ Document found, deleting...');
      await docRef.delete();
      print('✅ Successfully deleted pengumuman: ${event.id}');

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'Pengumuman berhasil dihapus',
        ),
      );

      // Reload data
      add(LoadPengumuman());
    } catch (e) {
      print('❌ Error deleting pengumuman: $e');
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error deleting pengumuman: ${e.toString()}',
        ),
      );
    }
  }

  /// Send PENGUMUMAN notifications to target users
  Future<void> _sendPengumumanNotifications(
    String pengumumanId,
    String judul,
    String deskripsi,
    String pembuat,
  ) async {
    try {
      final notifications = <Map<String, dynamic>>[];

      // Get all users based on target audience (admin, guru, siswa, all)
      // For Phase 1, we'll send to all users
      
      // Get all guru
      final guruSnapshot = await _firestore.collection('guru').get();
      for (final doc in guruSnapshot.docs) {
        notifications.add({
          'userId': doc.id,
          'role': 'guru',
          'type': NotificationType.pengumuman,
          'title': '📢 Pengumuman: $judul',
          'message': deskripsi.length > 100 
              ? '${deskripsi.substring(0, 100)}...' 
              : deskripsi,
          'priority': NotificationPriority.high,
          'actionUrl': '/pengumuman/$pengumumanId',
          'metadata': {
            'pengumumanId': pengumumanId,
            'pembuat': pembuat,
          },
        });
      }

      // Get all siswa
      final siswaSnapshot = await _firestore.collection('siswa').get();
      for (final doc in siswaSnapshot.docs) {
        notifications.add({
          'userId': doc.id,
          'role': 'siswa',
          'type': NotificationType.pengumuman,
          'title': '📢 Pengumuman: $judul',
          'message': deskripsi.length > 100 
              ? '${deskripsi.substring(0, 100)}...' 
              : deskripsi,
          'priority': NotificationPriority.high,
          'actionUrl': '/pengumuman/$pengumumanId',
          'metadata': {
            'pengumumanId': pengumumanId,
            'pembuat': pembuat,
          },
        });
      }

      if (notifications.isNotEmpty) {
        await _notificationRepo.createBatchNotifications(notifications);
        print('✅ Sent ${notifications.length} PENGUMUMAN notifications');
      }
    } catch (e) {
      print('❌ Failed to send PENGUMUMAN notifications: $e');
    }
  }

  // Stream untuk real-time updates
  Stream<PengumumanState> getPengumumanStream() {
    return _firestore
        .collection('pengumuman')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final pengumumanList = snapshot.docs
              .map((doc) => PengumumanModel.fromFirestore(doc))
              .toList();

          return state.copyWith(
            pengumumanList: pengumumanList,
            isLoading: false,
          );
        })
        .handleError((error) {
          return state.copyWith(
            isLoading: false,
            error: 'Error loading pengumuman: ${error.toString()}',
          );
        });
  }
}
