import 'dart:async';

import 'package:cash_for_trash/features/address/data/model/address_model.dart';
import 'package:cash_for_trash/features/maps/data/model/create_address_request_model.dart';
import 'package:cash_for_trash/features/maps/data/model/selected_location_model.dart';
import 'package:cash_for_trash/features/maps/domain/repository/maps_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'maps_event.dart';
part 'maps_state.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  final MapsRepository repository;

  Timer? _debounceTimer;

  MapsBloc({required this.repository}) : super(const MapsInitialState()) {
    on<MapsInitializedEvent>(_onInitialized);
    on<MapsCameraMovedEvent>(_onCameraMoved);
    on<MapsConfirmLocationEvent>(_onConfirmLocation);
    on<MapsSaveAddressEvent>(_onSaveAddress);
    on<_ResolveAddressInternalEvent>(_onResolveAddress);
  }

  Future<void> _onInitialized(
    MapsInitializedEvent event,
    Emitter<MapsState> emit,
  ) async {
    emit(const MapsLoadingState());

    final LatLng initialPos;
    if (event.initialLatLng != null) {
      initialPos = event.initialLatLng!;
    } else {
      final gpsPosition = await repository.getCurrentLocation();
      initialPos = gpsPosition ?? repository.getDefaultLocation();
    }

    final address = await repository.getAddressFromLatLng(initialPos);

    emit(MapsLocationActiveState(
      initialPosition: initialPos,
      currentPosition: initialPos,
      currentAddress: address,
    ));
  }

  Future<void> _onCameraMoved(
    MapsCameraMovedEvent event,
    Emitter<MapsState> emit,
  ) async {
    if (state is! MapsLocationActiveState) return;
    final current = state as MapsLocationActiveState;

    emit(current.copyWith(
      currentPosition: event.newPosition,
      isResolvingAddress: true,
    ));

    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 600),
      () => add(_ResolveAddressInternalEvent(event.newPosition)),
    );
  }

  Future<void> _onResolveAddress(
    _ResolveAddressInternalEvent event,
    Emitter<MapsState> emit,
  ) async {
    if (state is! MapsLocationActiveState) return;
    final current = state as MapsLocationActiveState;

    final address = await repository.getAddressFromLatLng(event.position);

    if (state is MapsLocationActiveState) {
      emit(current.copyWith(
        currentAddress: address,
        isResolvingAddress: false,
      ));
    }
  }

  Future<void> _onConfirmLocation(
    MapsConfirmLocationEvent event,
    Emitter<MapsState> emit,
  ) async {
    if (state is! MapsLocationActiveState) return;
    final current = state as MapsLocationActiveState;

    final model = SelectedLocationModel.fromLatLng(
      current.currentPosition,
      displayAddress: current.currentAddress,
    );

    emit(MapsLocationConfirmedState(selectedLocation: model));
  }

  Future<void> _onSaveAddress(
    MapsSaveAddressEvent event,
    Emitter<MapsState> emit,
  ) async {
    emit(const MapsAddressSavingState());

    final result = event.existingAddressId != null
        ? await repository.updateAddress(
            event.existingAddressId!,
            event.request,
          )
        : await repository.createAddress(event.request);

    result.fold(
      (error) => emit(MapsAddressSaveErrorState(error)),
      (address) => emit(MapsAddressSavedState(address)),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}

class _ResolveAddressInternalEvent extends MapsEvent {
  final LatLng position;

  const _ResolveAddressInternalEvent(this.position);

  @override
  List<Object?> get props => [position];
}