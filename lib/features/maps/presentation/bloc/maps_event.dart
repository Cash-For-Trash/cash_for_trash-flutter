part of 'maps_bloc.dart';

abstract class MapsEvent extends Equatable {
  const MapsEvent();

  @override
  List<Object?> get props => [];
}

class MapsInitializedEvent extends MapsEvent {
  final LatLng? initialLatLng;

  const MapsInitializedEvent({this.initialLatLng});

  @override
  List<Object?> get props => [initialLatLng];
}

class MapsCameraMovedEvent extends MapsEvent {
  final LatLng newPosition;

  const MapsCameraMovedEvent(this.newPosition);

  @override
  List<Object?> get props => [newPosition];
}

class MapsConfirmLocationEvent extends MapsEvent {
  const MapsConfirmLocationEvent();
}

class MapsSaveAddressEvent extends MapsEvent {
  final CreateAddressRequestModel request;
  final String? existingAddressId;

  const MapsSaveAddressEvent({
    required this.request,
    this.existingAddressId,
  });

  @override
  List<Object?> get props => [request, existingAddressId];
}