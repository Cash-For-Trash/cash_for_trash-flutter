part of 'maps_bloc.dart';

abstract class MapsState extends Equatable {
  const MapsState();

  @override
  List<Object?> get props => [];
}

class MapsInitialState extends MapsState {
  const MapsInitialState();
}

class MapsLoadingState extends MapsState {
  const MapsLoadingState();
}

class MapsLocationActiveState extends MapsState {
  final LatLng initialPosition;
  final LatLng currentPosition;
  final String currentAddress;
  final bool isResolvingAddress;

  const MapsLocationActiveState({
    required this.initialPosition,
    required this.currentPosition,
    required this.currentAddress,
    this.isResolvingAddress = false,
  });

  MapsLocationActiveState copyWith({
    LatLng? initialPosition,
    LatLng? currentPosition,
    String? currentAddress,
    bool? isResolvingAddress,
  }) {
    return MapsLocationActiveState(
      initialPosition: initialPosition ?? this.initialPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      currentAddress: currentAddress ?? this.currentAddress,
      isResolvingAddress: isResolvingAddress ?? this.isResolvingAddress,
    );
  }

  @override
  List<Object?> get props => [
        initialPosition,
        currentPosition,
        currentAddress,
        isResolvingAddress,
      ];
}

class MapsLocationConfirmedState extends MapsState {
  final SelectedLocationModel selectedLocation;

  const MapsLocationConfirmedState({required this.selectedLocation});

  @override
  List<Object?> get props => [selectedLocation];
}

class MapsErrorState extends MapsState {
  final String message;

  const MapsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}