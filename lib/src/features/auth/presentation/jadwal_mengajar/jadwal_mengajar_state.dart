import 'package:equatable/equatable.dart';

abstract class JadwalMengajarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JadwalMengajarInitial extends JadwalMengajarState {}

class JadwalMengajarLoading extends JadwalMengajarState {}

class JadwalMengajarLoaded extends JadwalMengajarState {
  final List<Map<String, dynamic>> jadwalList;
  final List<Map<String, dynamic>> filteredJadwalList;
  final List<Map<String, dynamic>> guruList;
  final List<Map<String, dynamic>> kelasList;
  final List<Map<String, dynamic>> mapelList;
  final String? selectedGuruFilter;
  final String? selectedKelasFilter;
  final String searchQuery;

  JadwalMengajarLoaded({
    required this.jadwalList,
    required this.filteredJadwalList,
    required this.guruList,
    required this.kelasList,
    required this.mapelList,
    this.selectedGuruFilter,
    this.selectedKelasFilter,
    this.searchQuery = '',
  });

  JadwalMengajarLoaded copyWith({
    List<Map<String, dynamic>>? jadwalList,
    List<Map<String, dynamic>>? filteredJadwalList,
    List<Map<String, dynamic>>? guruList,
    List<Map<String, dynamic>>? kelasList,
    List<Map<String, dynamic>>? mapelList,
    String? selectedGuruFilter,
    String? selectedKelasFilter,
    String? searchQuery,
  }) {
    return JadwalMengajarLoaded(
      jadwalList: jadwalList ?? this.jadwalList,
      filteredJadwalList: filteredJadwalList ?? this.filteredJadwalList,
      guruList: guruList ?? this.guruList,
      kelasList: kelasList ?? this.kelasList,
      mapelList: mapelList ?? this.mapelList,
      selectedGuruFilter: selectedGuruFilter ?? this.selectedGuruFilter,
      selectedKelasFilter: selectedKelasFilter ?? this.selectedKelasFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    jadwalList,
    filteredJadwalList,
    guruList,
    kelasList,
    mapelList,
    selectedGuruFilter,
    selectedKelasFilter,
    searchQuery,
  ];
}

class JadwalMengajarError extends JadwalMengajarState {
  final String message;

  JadwalMengajarError(this.message);

  @override
  List<Object> get props => [message];
}

class JadwalMengajarActionInProgress extends JadwalMengajarState {
  final String action;

  JadwalMengajarActionInProgress(this.action);

  @override
  List<Object> get props => [action];
}

class JadwalMengajarActionSuccess extends JadwalMengajarState {
  final String message;

  JadwalMengajarActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class JadwalMengajarImportSuccess extends JadwalMengajarState {
  final String message;
  final int importedCount;

  JadwalMengajarImportSuccess(this.message, this.importedCount);

  @override
  List<Object> get props => [message, importedCount];
}
