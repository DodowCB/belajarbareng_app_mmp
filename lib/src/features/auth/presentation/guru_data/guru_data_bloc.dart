import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'guru_data_event.dart';
import 'guru_data_state.dart';

class GuruDataBloc extends Bloc<GuruDataEvent, GuruDataState> {
  final AuthRepository _authRepository;

  GuruDataBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const GuruDataInitial()) {
    on<LoadGuruData>(_onLoadGuruData);
  }

  Future<void> _onLoadGuruData(
    LoadGuruData event,
    Emitter<GuruDataState> emit,
  ) async {
    emit(const GuruDataLoading());

    try {
      final guruList = await _authRepository.getAllGuru();
      emit(GuruDataLoaded(guruList: guruList));
    } catch (e) {
      emit(GuruDataError(message: e.toString()));
    }
  }
}
