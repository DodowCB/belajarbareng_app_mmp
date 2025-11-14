import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'siswa_data_event.dart';
import 'siswa_data_state.dart';

class SiswaDataBloc extends Bloc<SiswaEvent, SiswaState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SiswaDataBloc() : super(SiswaDataInitial()) {
    on<LoadSiswaData>(_onLoadSiswaData);
    on<DeleteSiswa>(_onDeleteSiswa);
    on<DisableSiswa>(_onDisableSiswa);
    on<ImportSiswaFromExcel>(_onImportSiswaFromExcel);
  }

  Future<void> _onLoadSiswaData(
    LoadSiswaData event,
    Emitter<SiswaState> emit,
  ) async {
    try {
      emit(SiswaDataLoading());

      final QuerySnapshot snapshot = await _firestore.collection('siswa').get();

      final List<Map<String, dynamic>> siswaList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'nama': data['nama'] ?? 'Unknown',
          'email': data['email'] ?? 'No Email',
          'nis': data['nis']?.toString() ?? 'No NIS',
          'jenisKelamin': data['jenis_kelamin'] ?? 'Unknown',
          'tanggalLahir': data['tanggal_lahir'] ?? 'Unknown',
          'photoUrl': data['photo_url'] ?? '',
          'status': data['status'] ?? 'active',
          'isDisabled': data['status'] == 'disabled',
          'createdAt': data['createdAt'],
        };
      }).toList();

      // Sort by name
      siswaList.sort(
        (a, b) => (a['nama'] as String).compareTo(b['nama'] as String),
      );

      emit(SiswaDataLoaded(siswaList));
    } catch (e) {
      emit(SiswaDataError('Failed to load siswa data: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteSiswa(
    DeleteSiswa event,
    Emitter<SiswaState> emit,
  ) async {
    try {
      await _firestore.collection('siswa').doc(event.siswaId).delete();
      emit(SiswaDataActionSuccess('Siswa deleted successfully'));

      // Reload data
      add(const LoadSiswaData());
    } catch (e) {
      emit(SiswaDataError('Failed to delete siswa: ${e.toString()}'));
    }
  }

  Future<void> _onDisableSiswa(
    DisableSiswa event,
    Emitter<SiswaState> emit,
  ) async {
    try {
      final newStatus = event.isDisabled ? 'disabled' : 'active';
      await _firestore.collection('siswa').doc(event.siswaId).update({
        'status': newStatus,
      });

      final action = event.isDisabled ? 'disabled' : 'enabled';
      emit(SiswaDataActionSuccess('Siswa $action successfully'));

      // Reload data
      add(const LoadSiswaData());
    } catch (e) {
      emit(SiswaDataError('Failed to update siswa status: ${e.toString()}'));
    }
  }

  Future<void> _onImportSiswaFromExcel(
    ImportSiswaFromExcel event,
    Emitter<SiswaState> emit,
  ) async {
    try {
      // TODO: Implement Excel import functionality
      // This will be implemented when file_picker and excel packages are added
      emit(SiswaDataActionSuccess('Excel import functionality coming soon'));
    } catch (e) {
      emit(SiswaDataError('Failed to import from Excel: ${e.toString()}'));
    }
  }
}
