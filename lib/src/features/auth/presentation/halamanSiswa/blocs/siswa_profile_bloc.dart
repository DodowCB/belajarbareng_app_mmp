import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/providers/user_provider.dart';

// Events
abstract class SiswaProfileEvent extends Equatable {
  const SiswaProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadSiswaProfile extends SiswaProfileEvent {
  const LoadSiswaProfile();
}

// States
abstract class SiswaProfileState extends Equatable {
  const SiswaProfileState();

  @override
  List<Object> get props => [];
}

class SiswaProfileInitial extends SiswaProfileState {}

class SiswaProfileLoading extends SiswaProfileState {}

class SiswaProfileLoaded extends SiswaProfileState {
  final String siswaId;
  final Map<String, dynamic> siswaData;

  const SiswaProfileLoaded({
    required this.siswaId,
    required this.siswaData,
  });

  @override
  List<Object> get props => [siswaId, siswaData];
}

class SiswaProfileError extends SiswaProfileState {
  final String message;

  const SiswaProfileError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class SiswaProfileBloc extends Bloc<SiswaProfileEvent, SiswaProfileState> {
  SiswaProfileBloc() : super(SiswaProfileInitial()) {
    on<LoadSiswaProfile>(_onLoadSiswaProfile);
  }

  Future<void> _onLoadSiswaProfile(
    LoadSiswaProfile event,
    Emitter<SiswaProfileState> emit,
  ) async {
    emit(SiswaProfileLoading());

    try {
      final userId = userProvider.userId;
      final userType = userProvider.userType;

      if (userId == null) {
        emit(const SiswaProfileError('User ID tidak ditemukan'));
        return;
      }

      // Check if it's a dummy student
      if (userId == 'siswa_001') {
        emit(SiswaProfileLoaded(
          siswaId: userId,
          siswaData: {
            'nis': 'NIS001',
            'nama_lengkap': 'Siswa Demo',
            'email': 'siswa@gmail.com',
            'kelas': '12 IPA 1',
            'sekolah': 'SMA Negeri 1',
            'tanggal_lahir': '2007-01-01',
            'jenis_kelamin': 'Laki-laki',
            'alamat': 'Jl. Demo No. 123',
          },
        ));
        return;
      }

      // Load from Firestore
      final docSnapshot = await FirebaseFirestore.instance
          .collection('siswa')
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        emit(SiswaProfileLoaded(
          siswaId: userId,
          siswaData: data,
        ));
      } else {
        emit(const SiswaProfileError('Data siswa tidak ditemukan'));
      }
    } catch (e) {
      emit(SiswaProfileError('Gagal memuat profil: ${e.toString()}'));
    }
  }
}
