import 'package:equatable/equatable.dart';

abstract class MapelEvent extends Equatable {
  const MapelEvent();

  @override
  List<Object?> get props => [];
}

class LoadMapel extends MapelEvent {
  const LoadMapel();
}

class AddMapel extends MapelEvent {
  final String namaMapel;

  const AddMapel({required this.namaMapel});

  @override
  List<Object?> get props => [namaMapel];
}
