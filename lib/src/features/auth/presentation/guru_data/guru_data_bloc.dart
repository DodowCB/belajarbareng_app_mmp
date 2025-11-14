import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'guru_data_event.dart';
import 'guru_data_state.dart';

class GuruDataBloc extends Bloc<GuruDataEvent, GuruDataState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GuruDataBloc() : super(const GuruDataInitial()) {
    on<LoadGuruData>(_onLoadGuruData);
    on<DeleteGuru>(_onDeleteGuru);
    on<DisableGuru>(_onDisableGuru);
    on<ImportGuruFromExcel>(_onImportGuruFromExcel);
  }

  Future<void> _onLoadGuruData(
    LoadGuruData event,
    Emitter<GuruDataState> emit,
  ) async {
    try {
      emit(const GuruDataLoading());

      final QuerySnapshot snapshot = await _firestore.collection('guru').get();

      final List<Map<String, dynamic>> guruList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'nama': data['nama_lengkap'] ?? 'Unknown',
          'email': data['email'] ?? 'No Email',
          'nig': data['nig']?.toString() ?? 'No NIG',
          'mataPelajaran': data['mata_pelajaran'] ?? 'No Subject',
          'sekolah': data['sekolah'] ?? 'No School',
          'jenisKelamin': data['jenis_kelamin'] ?? 'Unknown',
          'tanggalLahir': data['tanggal_lahir'] ?? 'Unknown',
          'photoUrl': data['photo_url'] ?? '',
          'status': data['status'] ?? 'active',
          'isDisabled': data['status'] == 'disabled',
          'createdAt': data['createdAt'],
        };
      }).toList();

      guruList.sort(
        (a, b) => (a['nama'] as String).compareTo(b['nama'] as String),
      );
      emit(GuruDataLoaded(guruList));
    } catch (e) {
      emit(GuruDataError('Failed to load guru data: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteGuru(
    DeleteGuru event,
    Emitter<GuruDataState> emit,
  ) async {
    try {
      await _firestore.collection('guru').doc(event.guruId).delete();
      emit(const GuruDataActionSuccess('Guru deleted successfully'));
      add(const LoadGuruData());
    } catch (e) {
      emit(GuruDataError('Failed to delete guru: ${e.toString()}'));
    }
  }

  Future<void> _onDisableGuru(
    DisableGuru event,
    Emitter<GuruDataState> emit,
  ) async {
    try {
      final newStatus = event.isDisabled ? 'disabled' : 'active';
      await _firestore.collection('guru').doc(event.guruId).update({
        'status': newStatus,
      });

      final action = event.isDisabled ? 'disabled' : 'enabled';
      emit(GuruDataActionSuccess('Guru $action successfully'));
      add(const LoadGuruData());
    } catch (e) {
      emit(GuruDataError('Failed to update guru status: ${e.toString()}'));
    }
  }

  Future<void> _onImportGuruFromExcel(
    ImportGuruFromExcel event,
    Emitter<GuruDataState> emit,
  ) async {
    try {
      emit(const GuruDataLoading());

      // TODO: Implement Excel parsing when packages are available
      // For now, just show success message
      emit(
        const GuruDataActionSuccess(
          'Excel import functionality will be implemented when packages are added',
        ),
      );
      add(const LoadGuruData());
    } catch (e) {
      emit(GuruDataError('Failed to import from Excel: ${e.toString()}'));
    }
  }
}
