import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/kelas_model.dart';
import '../../data/models/guru_model.dart';
import '../../data/models/siswa_kelas_model.dart';
import 'kelas_event.dart';
import 'kelas_state.dart';

class KelasBloc extends Bloc<KelasEvent, KelasState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  KelasBloc() : super(KelasState()) {
    on<LoadKelas>(_onLoadKelas);
    on<RefreshKelas>(_onRefreshKelas);
    on<AddKelas>(_onAddKelas);
    on<UpdateKelas>(_onUpdateKelas);
    on<DeleteKelas>(_onDeleteKelas);
    on<LoadGuru>(_onLoadGuru);
    on<LoadSiswaByKelas>(_onLoadSiswaByKelas);
  }

  Future<void> _onLoadKelas(LoadKelas event, Emitter<KelasState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final querySnapshot = await _firestore.collection('kelas').get();

      final kelasList = querySnapshot.docs.map((doc) {
        return KelasModel.fromFirestore(doc);
      }).toList();
      emit(state.copyWith(isLoading: false, kelasList: kelasList));
    } catch (e) {
      print('Error loading kelas: $e');
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error loading kelas: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefreshKelas(
    RefreshKelas event,
    Emitter<KelasState> emit,
  ) async {
    add(LoadKelas());
  }

  Future<void> _onAddKelas(AddKelas event, Emitter<KelasState> emit) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      // Get all documents to find the highest numeric ID
      final allDocs = await _firestore.collection('kelas').get();

      int nextId = 1;

      if (allDocs.docs.isNotEmpty) {
        // Find the highest numeric ID
        int maxId = 0;
        for (var doc in allDocs.docs) {
          try {
            int currentId = int.parse(doc.id);
            if (currentId > maxId) {
              maxId = currentId;
            }
          } catch (e) {
            // Skip non-numeric IDs
            continue;
          }
        }
        nextId = maxId + 1;
      }

      await _firestore.collection('kelas').doc(nextId.toString()).set({
        'namaKelas': event.namaKelas,
        'jenjang_kelas': event.jenjangKelas,
        'nomor_kelas': event.nomorKelas,
        'tahun_ajaran': event.tahunAjaran,
        'guru_id': event.guruId,
        'nama_guru': event.namaGuru,
        'status': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'Kelas berhasil ditambahkan',
        ),
      );

      // Reload data
      add(LoadKelas());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error adding kelas: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateKelas(
    UpdateKelas event,
    Emitter<KelasState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      final updateData = {
        'namaKelas': event.namaKelas,
        'jenjang_kelas': event.jenjangKelas,
        'nomor_kelas': event.nomorKelas,
        'tahun_ajaran': event.tahunAjaran,
        'guru_id': event.guruId,
        'nama_guru': event.namaGuru,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('kelas').doc(event.id).update(updateData);

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'Kelas berhasil diperbarui',
        ),
      );

      // Reload data
      add(LoadKelas());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error updating kelas: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteKelas(
    DeleteKelas event,
    Emitter<KelasState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));

    try {
      // Check if there are students in this class
      final siswaKelasSnapshot = await _firestore
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: event.id)
          .get();

      if (siswaKelasSnapshot.docs.isNotEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            error:
                'Tidak dapat menghapus kelas yang masih memiliki siswa aktif',
          ),
        );
        return;
      }

      await _firestore.collection('kelas').doc(event.id).delete();

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'Kelas berhasil dihapus',
        ),
      );

      // Reload data
      add(LoadKelas());
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error deleting kelas: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onLoadGuru(LoadGuru event, Emitter<KelasState> emit) async {
    try {
      final querySnapshot = await _firestore.collection('guru').get();

      final guruList = querySnapshot.docs
          .map((doc) => GuruModel.fromFirestore(doc))
          .toList();

      emit(state.copyWith(guruList: guruList));
    } catch (e) {
      emit(state.copyWith(error: 'Error loading guru: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSiswaByKelas(
    LoadSiswaByKelas event,
    Emitter<KelasState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final querySnapshot = await _firestore
          .collection('siswa_kelas')
          .where('kelas_id', isEqualTo: event.kelasId)
          .get();

      final siswaKelasList = querySnapshot.docs
          .map((doc) => SiswaKelasModel.fromFirestore(doc))
          .toList();

      emit(state.copyWith(isLoading: false, siswaKelasList: siswaKelasList));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error loading siswa kelas: ${e.toString()}',
        ),
      );
    }
  }

  // Stream untuk real-time updates
  Stream<KelasState> getKelasStream() {
    return _firestore
        .collection('kelas')
        .snapshots()
        .map((snapshot) {
          final kelasList = snapshot.docs
              .map((doc) => KelasModel.fromFirestore(doc))
              .toList();

          return state.copyWith(kelasList: kelasList, isLoading: false);
        })
        .handleError((error) {
          return state.copyWith(
            isLoading: false,
            error: 'Error loading kelas: ${error.toString()}',
          );
        });
  }
}
