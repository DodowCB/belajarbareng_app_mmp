import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/pengumuman_model.dart';
import 'pengumuman_event.dart';
import 'pengumuman_state.dart';

class PengumumanBloc extends Bloc<PengumumanEvent, PengumumanState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      await _firestore.collection('pengumuman').add({
        'judul': event.judul,
        'deskripsi': event.deskripsi,
        'guru_id': event.guruId,
        'nama_guru': event.namaGuru,
        'pembuat': event.pembuat,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
      });

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
      await _firestore.collection('pengumuman').doc(event.id).delete();

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'Pengumuman berhasil dihapus',
        ),
      );

      // Reload data
      add(LoadPengumuman());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error deleting pengumuman: ${e.toString()}',
        ),
      );
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
