import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../../core/providers/user_provider.dart';
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
      print('🚀 [GuruProfileBloc] Starting to load guru profile...');
      emit(const GuruProfileLoading());

      // Get user data from userProvider (already set during login)
      final userId = userProvider.userId;
      final userEmail = userProvider.email;
      final userName = userProvider.namaLengkap;

      print('📋 [GuruProfileBloc] User from userProvider:');
      print('   - userId: $userId');
      print('   - userEmail: $userEmail');
      print('   - userName: $userName');

      if (userId == null || userEmail == null) {
        print('❌ [GuruProfileBloc] No user data in userProvider');

        // Try Firebase Auth as fallback
        final currentUser = _auth.currentUser;
        if (currentUser == null) {
          print('❌ [GuruProfileBloc] No Firebase Auth user either');
          emit(
            const GuruProfileError('User tidak ditemukan, silakan login ulang'),
          );
          return;
        }

        print('⚠️ [GuruProfileBloc] Using Firebase Auth fallback');
        // Use Firebase Auth data
        final fallbackData = {
          'nama_lengkap': currentUser.displayName ?? 'Guru',
          'email': currentUser.email ?? 'email@example.com',
          'photo_url': currentUser.photoURL ?? '',
        };
        emit(
          GuruProfileLoaded(guruData: fallbackData, guruId: currentUser.uid),
        );
        return;
      }

      // Use userId directly from userProvider for Firestore lookup
      print('🔍 [GuruProfileBloc] Loading profile with userId: $userId');

      // Try to get full guru data from Firestore
      final guruDoc = await _firestore.collection('guru').doc(userId).get();

      if (guruDoc.exists) {
        final guruData = guruDoc.data()!;
        print('✅ [GuruProfileBloc] Guru document found in Firestore');
        print(
          '📋 [GuruProfileBloc] All guru data keys: ${guruData.keys.toList()}',
        );

        // Enrich with data from userProvider if missing
        final enrichedGuruData = Map<String, dynamic>.from(guruData);

        if (enrichedGuruData['nama_lengkap'] == null ||
            enrichedGuruData['nama_lengkap'].toString().isEmpty) {
          enrichedGuruData['nama_lengkap'] = userName ?? 'Guru';
          print('✅ [GuruProfileBloc] Added nama_lengkap from userProvider');
        }

        if (enrichedGuruData['email'] == null ||
            enrichedGuruData['email'].toString().isEmpty) {
          enrichedGuruData['email'] = userEmail;
          print('✅ [GuruProfileBloc] Added email from userProvider');
        }

        print('🎉 [GuruProfileBloc] Emitting GuruProfileLoaded state');
        print(
          '📦 [GuruProfileBloc] Final data - nama_lengkap: ${enrichedGuruData['nama_lengkap']}, email: ${enrichedGuruData['email']}',
        );

        emit(GuruProfileLoaded(guruData: enrichedGuruData, guruId: userId));
        print('✅ [GuruProfileBloc] State emitted successfully');
        return;
      }

      // If no Firestore document, create minimal data from userProvider
      print(
        '⚠️ [GuruProfileBloc] No Firestore document, using userProvider data',
      );
      final minimalData = {
        'nama_lengkap': userName ?? 'Guru',
        'email': userEmail,
        'photo_url': '',
        // Include additional data from userProvider
        ...?userProvider.userData,
      };

      print('📦 [GuruProfileBloc] Using minimal data: $minimalData');
      emit(GuruProfileLoaded(guruData: minimalData, guruId: userId));
      print('✅ [GuruProfileBloc] State emitted successfully');
    } catch (e) {
      print('❌ [GuruProfileBloc] Error loading guru profile: $e');
      print('📍 [GuruProfileBloc] Stack trace: ${StackTrace.current}');
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
