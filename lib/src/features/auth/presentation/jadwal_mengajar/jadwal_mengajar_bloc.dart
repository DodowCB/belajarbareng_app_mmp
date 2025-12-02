import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'jadwal_mengajar_event.dart';
import 'jadwal_mengajar_state.dart';

class JadwalMengajarBloc
    extends Bloc<JadwalMengajarEvent, JadwalMengajarState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  JadwalMengajarBloc() : super(JadwalMengajarInitial()) {
    on<LoadJadwalMengajar>((event, emit) async {
      emit(JadwalMengajarLoading());
      try {
        final jadwalSnapshot = await _firestore
            .collection('kelas_ngajar')
            .orderBy('createdAt', descending: true)
            .get();

        final guruSnapshot = await _firestore.collection('guru').get();
        final kelasSnapshot = await _firestore.collection('kelas').get();
        final mapelSnapshot = await _firestore.collection('mapel').get();

        final jadwalList = jadwalSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        final guruList = guruSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        final kelasList = kelasSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        final mapelList = mapelSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        emit(
          JadwalMengajarLoaded(
            jadwalList: jadwalList,
            filteredJadwalList: jadwalList,
            guruList: guruList,
            kelasList: kelasList,
            mapelList: mapelList,
          ),
        );
      } catch (e) {
        emit(JadwalMengajarError('Failed to load data: ${e.toString()}'));
      }
    });

    on<AddJadwalMengajar>((event, emit) async {
      emit(JadwalMengajarActionInProgress('Adding teaching schedule...'));
      try {
        // Generate next integer ID
        final querySnapshot = await _firestore.collection('kelas_ngajar').get();

        int maxId = 0;
        for (var doc in querySnapshot.docs) {
          final id = int.tryParse(doc.id) ?? 0;
          if (id > maxId) maxId = id;
        }
        String nextId = (maxId + 1).toString();

        // Create document with specific integer ID
        await _firestore.collection('kelas_ngajar').doc(nextId).set({
          'id_guru': event.idGuru,
          'id_kelas': event.idKelas,
          'id_mapel': event.idMapel,
          'jam': event.jam,
          'hari': event.hari,
          'tanggal': Timestamp.fromDate(event.tanggal),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        emit(
          JadwalMengajarActionSuccess('Teaching schedule added successfully'),
        );
        add(LoadJadwalMengajar());
      } catch (e) {
        emit(JadwalMengajarError('Failed to add: ${e.toString()}'));
      }
    });

    on<UpdateJadwalMengajar>((event, emit) async {
      emit(JadwalMengajarActionInProgress('Updating teaching schedule...'));
      try {
        await _firestore.collection('kelas_ngajar').doc(event.jadwalId).update({
          'id_guru': event.idGuru,
          'id_kelas': event.idKelas,
          'id_mapel': event.idMapel,
          'jam': event.jam,
          'hari': event.hari,
          'tanggal': Timestamp.fromDate(event.tanggal),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        emit(
          JadwalMengajarActionSuccess('Teaching schedule updated successfully'),
        );
        add(LoadJadwalMengajar());
      } catch (e) {
        emit(JadwalMengajarError('Failed to update: ${e.toString()}'));
      }
    });

    on<DeleteJadwalMengajar>((event, emit) async {
      emit(JadwalMengajarActionInProgress('Deleting teaching schedule...'));
      try {
        await _firestore
            .collection('kelas_ngajar')
            .doc(event.jadwalId)
            .delete();
        emit(
          JadwalMengajarActionSuccess('Teaching schedule deleted successfully'),
        );
        add(LoadJadwalMengajar());
      } catch (e) {
        emit(JadwalMengajarError('Failed to delete: ${e.toString()}'));
      }
    });

    on<SearchJadwal>((event, emit) {
      if (state is JadwalMengajarLoaded) {
        final currentState = state as JadwalMengajarLoaded;
        final filteredList = currentState.jadwalList.where((jadwal) {
          final query = event.query.toLowerCase();

          // Get teacher name from ID
          String getGuruName(String? guruId) {
            if (guruId == null) return '';
            final guru = currentState.guruList.firstWhere(
              (g) => g['id'] == guruId,
              orElse: () => {'nama_lengkap': ''},
            );
            return guru['nama_lengkap']?.toString().toLowerCase() ?? '';
          }

          // Get class name from ID
          String getKelasName(String? kelasId) {
            if (kelasId == null) return '';
            final kelas = currentState.kelasList.firstWhere(
              (k) => k['id'] == kelasId,
              orElse: () => {'nama_kelas': ''},
            );
            return kelas['nama_kelas']?.toString().toLowerCase() ?? '';
          }

          // Get subject name from ID
          String getMapelName(String? mapelId) {
            if (mapelId == null) return '';
            final mapel = currentState.mapelList.firstWhere(
              (m) => m['id'] == mapelId,
              orElse: () => {'namaMapel': ''},
            );
            return mapel['namaMapel']?.toString().toLowerCase() ?? '';
          }

          return jadwal['jam']?.toString().toLowerCase().contains(query) ==
                  true ||
              jadwal['hari']?.toString().toLowerCase().contains(query) ==
                  true ||
              getGuruName(jadwal['id_guru']).contains(query) ||
              getKelasName(jadwal['id_kelas']).contains(query) ||
              getMapelName(jadwal['id_mapel']).contains(query);
        }).toList();

        emit(
          currentState.copyWith(
            searchQuery: event.query,
            filteredJadwalList: filteredList,
          ),
        );
      }
    });
  }

  Stream<QuerySnapshot> getJadwalStream() {
    return _firestore
        .collection('kelas_ngajar')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
