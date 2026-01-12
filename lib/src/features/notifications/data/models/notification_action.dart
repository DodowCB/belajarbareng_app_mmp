import 'package:equatable/equatable.dart';

class NotificationAction extends Equatable {
  final String id;
  final String label;
  final String route;
  final Map<String, dynamic>? params;

  const NotificationAction({
    required this.id,
    required this.label,
    required this.route,
    this.params,
  });

  @override
  List<Object?> get props => [id, label, route, params];

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'route': route,
      'params': params,
    };
  }

  // From Map
  factory NotificationAction.fromMap(Map<String, dynamic> map) {
    return NotificationAction(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      route: map['route'] ?? '',
      params: map['params'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() => toMap();

  // From JSON
  factory NotificationAction.fromJson(Map<String, dynamic> json) =>
      NotificationAction.fromMap(json);
}
