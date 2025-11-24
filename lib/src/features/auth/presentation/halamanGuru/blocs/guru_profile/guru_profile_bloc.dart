import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'guru_profile_event.dart';
import 'guru_profile_state.dart';

class GuruProfileBloc extends Bloc<GuruProfileEvent, GuruProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GuruProfileBloc() : super(const GuruProfileInitial()) {
    on<LoadGuruProfile>(_onLoadGuruProfile);
    on<RefreshGuruProfile>(_onRefreshGuruProfile);
    on<UpdateGuruProfile>(_onUpdateGuruProfile);
  }

  Future<void> _onLoadGuruProfile(
    LoadGuruProfile event,
    Emitter<GuruProfileState> emit,
  ) async {
    try {
      emit(const GuruProfileLoading());

      // Get current user from Firebase Auth
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        emit(
          const GuruProfileError('User tidak ditemukan, silakan login ulang'),
        );
        return;
      }

      print('🔍 Loading profile for email: ${currentUser.email}');

      // Get guru data by email
      final guruSnapshot = await _firestore
          .collection('guru')
          .where('email', isEqualTo: currentUser.email?.toLowerCase())
          .limit(1)
          .get();

      if (guruSnapshot.docs.isEmpty) {
        print('❌ Guru data not found for email: ${currentUser.email}');
        emit(const GuruProfileError('Data guru tidak ditemukan'));
        return;
      }

      final guruDoc = guruSnapshot.docs.first;
      final guruData = guruDoc.data();

      print('✅ Guru data loaded: ${guruData['nama_lengkap']}');

      emit(GuruProfileLoaded(guruData: guruData, guruId: guruDoc.id));
    } catch (e) {
      print('❌ Error loading guru profile: $e');
      emit(GuruProfileError('Error loading profile: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshGuruProfile(
    RefreshGuruProfile event,
    Emitter<GuruProfileState> emit,
  ) async {
    // Prevent infinite loop by checking current state
    if (state is GuruProfileLoading) return;

    add(const LoadGuruProfile());
  }

  Future<void> _onUpdateGuruProfile(
    UpdateGuruProfile event,
    Emitter<GuruProfileState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is GuruProfileLoaded) {
        await _firestore
            .collection('guru')
            .doc(currentState.guruId)
            .update(event.profileData);

        // Reload profile after update
        add(const LoadGuruProfile());
      }
    } catch (e) {
      emit(GuruProfileError('Error updating profile: ${e.toString()}'));
    }
  }
}
