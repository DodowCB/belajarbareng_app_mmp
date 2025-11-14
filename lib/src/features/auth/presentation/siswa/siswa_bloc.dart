import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Events
abstract class SiswaEvent extends Equatable {
  const SiswaEvent();

  @override
  List<Object?> get props => [];
}

class LoadSiswaData extends SiswaEvent {}

class DeleteSiswa extends SiswaEvent {
  final String siswaId;

  const DeleteSiswa(this.siswaId);

  @override
  List<Object?> get props => [siswaId];
}

class DisableSiswa extends SiswaEvent {
  final String siswaId;
  final bool isDisabled;

  const DisableSiswa(this.siswaId, this.isDisabled);

  @override
  List<Object?> get props => [siswaId, isDisabled];
}

// States
abstract class SiswaState extends Equatable {
  const SiswaState();

  @override
  List<Object?> get props => [];
}

class SiswaInitial extends SiswaState {}

class SiswaLoading extends SiswaState {}

class SiswaLoaded extends SiswaState {
  final List<Map<String, dynamic>> siswaList;

  const SiswaLoaded(this.siswaList);

  @override
  List<Object?> get props => [siswaList];
}

class SiswaError extends SiswaState {
  final String message;

  const SiswaError(this.message);

  @override
  List<Object?> get props => [message];
}

class SiswaActionSuccess extends SiswaState {
  final String message;

  const SiswaActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class SiswaBloc extends Bloc<SiswaEvent, SiswaState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SiswaBloc() : super(SiswaInitial()) {
    on<LoadSiswaData>(_onLoadSiswaData);
    on<DeleteSiswa>(_onDeleteSiswa);
    on<DisableSiswa>(_onDisableSiswa);
  }

  Future<void> _onLoadSiswaData(
    LoadSiswaData event,
    Emitter<SiswaState> emit,
  ) async {
    try {
      emit(SiswaLoading());

      final QuerySnapshot snapshot = await _firestore.collection('siswa').get();

      final List<Map<String, dynamic>> siswaList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'nama': data['nama'] ?? 'Unknown',
          'email': data['email'] ?? 'No Email',
          'nis': data['nis']?.toString() ?? 'No NIS',
          'kelas': data['kelas'] ?? 'No Class',
          'sekolah': data['sekolah'] ?? 'No School',
          'isDisabled': data['isDisabled'] ?? false,
          'createdAt': data['createdAt'],
        };
      }).toList();

      // Sort by name
      siswaList.sort(
        (a, b) => (a['nama'] as String).compareTo(b['nama'] as String),
      );

      emit(SiswaLoaded(siswaList));
    } catch (e) {
      emit(SiswaError('Failed to load siswa data: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteSiswa(
    DeleteSiswa event,
    Emitter<SiswaState> emit,
  ) async {
    try {
      await _firestore.collection('siswa').doc(event.siswaId).delete();
      emit(SiswaActionSuccess('Siswa deleted successfully'));

      // Reload data
      add(LoadSiswaData());
    } catch (e) {
      emit(SiswaError('Failed to delete siswa: ${e.toString()}'));
    }
  }

  Future<void> _onDisableSiswa(
    DisableSiswa event,
    Emitter<SiswaState> emit,
  ) async {
    try {
      await _firestore.collection('siswa').doc(event.siswaId).update({
        'isDisabled': event.isDisabled,
      });

      final action = event.isDisabled ? 'disabled' : 'enabled';
      emit(SiswaActionSuccess('Siswa $action successfully'));

      // Reload data
      add(LoadSiswaData());
    } catch (e) {
      emit(SiswaError('Failed to update siswa status: ${e.toString()}'));
    }
  }
}
