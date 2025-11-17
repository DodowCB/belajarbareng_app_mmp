import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/mapel_model.dart';
import '../../data/repositories/mapel_repository.dart';
import 'mapel_event.dart';
import 'mapel_state.dart';

class MapelBloc extends Bloc<MapelEvent, MapelState> {
  final MapelRepository _repository = MapelRepository();
  StreamSubscription<List<MapelModel>>? _mapelSubscription;

  MapelBloc() : super(const MapelInitial()) {
    on<LoadMapel>(_onLoadMapel);
    on<AddMapel>(_onAddMapel);
  }

  @override
  Future<void> close() {
    _mapelSubscription?.cancel();
    return super.close();
  }

  // Stream untuk real-time data
  Stream<List<MapelModel>> getMapelStream() {
    return _repository.getMapelStream();
  }

  void _onLoadMapel(LoadMapel event, Emitter<MapelState> emit) {
    emit(const MapelLoading());

    try {
      _mapelSubscription?.cancel();
      _mapelSubscription = _repository.getMapelStream().listen(
        (mapelList) {
          if (!isClosed) {
            emit(MapelLoaded(mapelList: mapelList));
          }
        },
        onError: (error) {
          print('MapelBloc Stream Error: $error');
          if (!isClosed) {
            emit(MapelError('Gagal memuat data mapel: ${error.toString()}'));
          }
        },
      );
    } catch (e) {
      print('MapelBloc LoadMapel Error: $e');
      if (!isClosed) {
        emit(
          MapelError('Terjadi kesalahan saat memuat mapel: ${e.toString()}'),
        );
      }
    }
  }

  Future<void> _onAddMapel(AddMapel event, Emitter<MapelState> emit) async {
    try {
      await _repository.addMapel(event.namaMapel);
      if (!isClosed) {
        emit(const MapelActionSuccess('Mata pelajaran berhasil ditambahkan'));
      }
    } catch (e) {
      print('MapelBloc AddMapel Error: $e');
      if (!isClosed) {
        emit(MapelError('Gagal menambahkan mata pelajaran: ${e.toString()}'));
      }
    }
  }
}
