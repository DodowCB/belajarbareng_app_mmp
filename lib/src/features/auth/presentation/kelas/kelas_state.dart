import '../../data/models/kelas_model.dart';
import '../../data/models/guru_model.dart';
import '../../data/models/siswa_kelas_model.dart';

// Kelas State
class KelasState {
  final bool isLoading;
  final List<KelasModel> kelasList;
  final List<GuruModel> guruList;
  final List<SiswaKelasModel> siswaKelasList;
  final String? error;
  final String? successMessage;

  KelasState({
    this.isLoading = false,
    this.kelasList = const [],
    this.guruList = const [],
    this.siswaKelasList = const [],
    this.error,
    this.successMessage,
  });

  KelasState copyWith({
    bool? isLoading,
    List<KelasModel>? kelasList,
    List<GuruModel>? guruList,
    List<SiswaKelasModel>? siswaKelasList,
    String? error,
    String? successMessage,
  }) {
    return KelasState(
      isLoading: isLoading ?? this.isLoading,
      kelasList: kelasList ?? this.kelasList,
      guruList: guruList ?? this.guruList,
      siswaKelasList: siswaKelasList ?? this.siswaKelasList,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  String toString() {
    return 'KelasState(isLoading: $isLoading, kelasList: ${kelasList.length} items, guruList: ${guruList.length} items, siswaKelasList: ${siswaKelasList.length} items, error: $error, successMessage: $successMessage)';
  }
}
