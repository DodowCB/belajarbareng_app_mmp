import 'package:equatable/equatable.dart';
import '../../data/models/mapel_model.dart';

abstract class MapelState extends Equatable {
  const MapelState();

  @override
  List<Object?> get props => [];
}

class MapelInitial extends MapelState {
  const MapelInitial();
}

class MapelLoading extends MapelState {
  const MapelLoading();
}

class MapelLoaded extends MapelState {
  final List<MapelModel> mapelList;
  final String? searchQuery;
  final String? activeFilter;

  const MapelLoaded({
    required this.mapelList,
    this.searchQuery,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [mapelList, searchQuery, activeFilter];
}

class MapelError extends MapelState {
  final String message;

  const MapelError(this.message);

  @override
  List<Object?> get props => [message];
}

class MapelActionSuccess extends MapelState {
  final String message;

  const MapelActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}