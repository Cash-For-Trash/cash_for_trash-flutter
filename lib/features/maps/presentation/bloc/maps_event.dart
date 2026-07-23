part of 'maps_bloc.dart';

abstract class MapsEvent extends Equatable {
  const MapsEvent();

  @override
  List<Object?> get props => [];
}

class MapsInitializedEvent extends MapsEvent {
  const MapsInitializedEvent();
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