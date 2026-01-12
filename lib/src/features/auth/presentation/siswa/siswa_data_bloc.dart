import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/excel_import_service.dart';
import '../../../../core/services/id_generator_service.dart';
import '../../../notifications/presentation/services/notification_service_extended.dart';
import 'siswa_data_event.dart';
import 'siswa_data_state.dart';

class SiswaDataBloc extends Bloc<SiswaEvent, SiswaState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationServiceExtended _notificationService = NotificationServiceExtended();

  SiswaDataBloc() : super(SiswaDataInitial()) {
    on<LoadSiswaData>(_onLoadSiswaData);
    on<DeleteSiswa>(_onDeleteSiswa);
    on<DisableSiswa>(_onDisableSiswa);
    on<ImportSiswaFromExcel>(_onImportSiswaFromExcel);
    on<AddSiswa>(_onAddSiswa);
    on<UpdateSiswa>(_onUpdateSiswa);
  }

  // Stream untuk real-time data
  Stream<List<Map<String, dynamic>>> getSiswaStream() {
    return _firestore.collection('siswa').snapshots().map((snapshot) {
      final List<Map<String, dynamic>> siswaList = snapshot.docs.map((doc) {
        final data = doc.data();

        return {
          'id': doc.id,
          'nama': data['nama'] ?? 'Unknown',
          'email': data['email'] ?? 'No Email',
          'password': data['password'] ?? 'No Password',
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

      return siswaList;
    });
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
          'password': data['password'] ?? 'No Password',
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
      emit(SiswaDataLoading());

      // Import data from Excel
      List<Map<String, dynamic>>? importedData =
          await ExcelImportService.importSiswaFromExcel();

      if (importedData != null && importedData.isNotEmpty) {
        // Batch write to Firestore
        final batch = _firestore.batch();
        int successCount = 0;

        // Get sequential IDs for all siswa data
        final ids = await IdGeneratorService.getNextIds(
          'siswa',
          importedData.length,
        );

        for (int i = 0; i < importedData.length; i++) {
          try {
            final siswaData = importedData[i];
            final docRef = _firestore.collection('siswa').doc(ids[i]);
            batch.set(docRef, siswaData);
            successCount++;
          } catch (e) {
            debugPrint('Error adding siswa: $e');
          }
        }

        await batch.commit();
        emit(
          SiswaDataActionSuccess(
            'Successfully imported $successCount siswa records',
          ),
        );

        // Reload data
        add(const LoadSiswaData());
      } else {
        emit(
          SiswaDataActionSuccess(
            'No data found in Excel file or import was cancelled',
          ),
        );
      }
    } catch (e) {
      emit(SiswaDataError('Failed to import from Excel: ${e.toString()}'));
    }
  }

  Future<void> _onAddSiswa(AddSiswa event, Emitter<SiswaState> emit) async {
    try {
      final id = await IdGeneratorService.getNextId('siswa');
      await _firestore.collection('siswa').doc(id).set(event.siswaData);
      emit(SiswaDataActionSuccess('Siswa berhasil ditambahkan'));
      
      // Send notification to all admins about new siswa registration
      try {
        await _notificationService.sendSiswaRegistered(
          siswaId: id,
          siswaName: event.siswaData['nama'] ?? 'Unknown',
          siswaEmail: event.siswaData['email'] ?? 'No Email',
        );
        debugPrint('✅ Notification sent: Siswa registered (ID: $id)');
      } catch (e) {
        debugPrint('❌ Failed to send siswa registered notification: $e');
      }
    } catch (e) {
      emit(SiswaDataError('Failed to add siswa: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSiswa(
    UpdateSiswa event,
    Emitter<SiswaState> emit,
  ) async {
    try {
      await _firestore
          .collection('siswa')
          .doc(event.siswaId)
          .update(event.siswaData);
      emit(SiswaDataActionSuccess('Siswa berhasil diupdate'));
    } catch (e) {
      emit(SiswaDataError('Failed to update siswa: ${e.toString()}'));
    }
  }
}
