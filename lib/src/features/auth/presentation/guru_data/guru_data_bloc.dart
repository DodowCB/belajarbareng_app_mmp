import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/excel_import_service.dart';
import '../../../../core/services/id_generator_service.dart';
import 'guru_data_event.dart';
import 'guru_data_state.dart';

class GuruDataBloc extends Bloc<GuruDataEvent, GuruDataState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GuruDataBloc() : super(const GuruDataInitial()) {
    on<LoadGuruData>(_onLoadGuruData);
    on<DeleteGuru>(_onDeleteGuru);
    on<DisableGuru>(_onDisableGuru);
    on<ImportGuruFromExcel>(_onImportGuruFromExcel);
    on<AddGuru>(_onAddGuru);
    on<UpdateGuru>(_onUpdateGuru);
  }

  // Stream untuk real-time data
  Stream<List<Map<String, dynamic>>> getGuruStream() {
    return _firestore.collection('guru').snapshots().map((snapshot) {
      final List<Map<String, dynamic>> guruList = snapshot.docs.map((doc) {
        final data = doc.data();
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
          'isDisabled': data['status'] == 'active',
          'createdAt': data['createdAt'],
        };
      }).toList();

      guruList.sort(
        (a, b) => (a['nama'] as String).compareTo(b['nama'] as String),
      );
      return guruList;
    });
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
          'isDisabled': data['status'] == 'active',
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
      print(" Updating guru ${event.guruId} status to $newStatus"); // Debug log
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

      // Import data from Excel
      List<Map<String, dynamic>>? importedData =
          await ExcelImportService.importGuruFromExcel();

      if (importedData != null && importedData.isNotEmpty) {
        // Batch write to Firestore
        final batch = _firestore.batch();
        int successCount = 0;

        // Get sequential IDs for all guru data
        final ids = await IdGeneratorService.getNextIds(
          'guru',
          importedData.length,
        );

        for (int i = 0; i < importedData.length; i++) {
          try {
            final guruData = importedData[i];
            final docRef = _firestore.collection('guru').doc(ids[i]);
            batch.set(docRef, guruData);
            successCount++;
          } catch (e) {
            debugPrint('Error adding guru: $e');
          }
        }

        await batch.commit();
        emit(
          GuruDataActionSuccess(
            'Successfully imported $successCount guru records',
          ),
        );

        // Reload data
        add(const LoadGuruData());
      } else {
        emit(
          const GuruDataActionSuccess(
            'No data found in Excel file or import was cancelled',
          ),
        );
      }
    } catch (e) {
      emit(GuruDataError('Failed to import from Excel: ${e.toString()}'));
    }
  }

  Future<void> _onAddGuru(
    AddGuru event,
    Emitter<GuruDataState> emit,
  ) async {
    try {
      final id = await IdGeneratorService.getNextId('guru');
      await _firestore.collection('guru').doc(id).set(event.guruData);
      emit(const GuruDataActionSuccess('Guru berhasil ditambahkan'));
    } catch (e) {
      emit(GuruDataError('Failed to add guru: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateGuru(
    UpdateGuru event,
    Emitter<GuruDataState> emit,
  ) async {
    try {
      await _firestore.collection('guru').doc(event.guruId).update(event.guruData);
      emit(const GuruDataActionSuccess('Guru berhasil diupdate'));
    } catch (e) {
      emit(GuruDataError('Failed to update guru: ${e.toString()}'));
    }
  }
}
