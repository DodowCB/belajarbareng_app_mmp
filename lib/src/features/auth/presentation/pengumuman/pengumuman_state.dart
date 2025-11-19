import '../../data/models/pengumuman_model.dart';

// Pengumuman State
class PengumumanState {
  final bool isLoading;
  final List<PengumumanModel> pengumumanList;
  final String? error;
  final String? successMessage;

  PengumumanState({
    this.isLoading = false,
    this.pengumumanList = const [],
    this.error,
    this.successMessage,
  });

  PengumumanState copyWith({
    bool? isLoading,
    List<PengumumanModel>? pengumumanList,
    String? error,
    String? successMessage,
  }) {
    return PengumumanState(
      isLoading: isLoading ?? this.isLoading,
      pengumumanList: pengumumanList ?? this.pengumumanList,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  String toString() {
    return 'PengumumanState(isLoading: $isLoading, pengumumanList: ${pengumumanList.length} items, error: $error, successMessage: $successMessage)';
  }
}
