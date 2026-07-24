import 'package:cash_for_trash/features/request_collection/domain/repositories/request_collection_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'request_collection_event.dart';
import 'request_collection_state.dart';

class RequestCollectionBloc
    extends Bloc<RequestCollectionEvent, RequestCollectionState> {
  final RequestCollectionRepository repository;

  RequestCollectionBloc({required this.repository})
      : super(const RequestCollectionState()) {
    on<GetGarbageTypesEvent>(_onGetGarbageTypes);
    on<GetAddressesEvent>(_onGetAddresses);
    on<SelectAddressEvent>(_onSelectAddress);
    on<ToggleWasteTypeEvent>(_onToggleWasteType);
    on<SelectQuantityEvent>(_onSelectQuantity);
    on<SetExactWeightEvent>(_onSetExactWeight);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<PickWasteImageEvent>(_onPickWasteImage);
    on<RemoveWasteImageEvent>(_onRemoveWasteImage);
    on<ChangeLocationEvent>(_onChangeLocation);
  }

  Future<void> _onGetGarbageTypes(
    GetGarbageTypesEvent event,
    Emitter<RequestCollectionState> emit,
  ) async {
    emit(state.copyWith(
      isGarbageTypesLoading: true,
      clearGarbageTypesError: true,
    ));

    final result = await repository.getGarbageTypes();

    result.fold(
      (error) => emit(state.copyWith(
        isGarbageTypesLoading: false,
        garbageTypesErrorMessage: error,
      )),
      (response) => emit(state.copyWith(
        isGarbageTypesLoading: false,
        garbageTypes: response.data,
      )),
    );
  }

  Future<void> _onGetAddresses(
    GetAddressesEvent event,
    Emitter<RequestCollectionState> emit,
  ) async {
    emit(state.copyWith(
      isAddressesLoading: true,
      clearAddressesError: true,
    ));

    final result = await repository.getAddresses();

    result.fold(
      (error) => emit(state.copyWith(
        isAddressesLoading: false,
        addressesErrorMessage: error,
      )),
      (response) {
        final firstAddress =
            response.data.isNotEmpty ? response.data.first : null;
        emit(state.copyWith(
          isAddressesLoading: false,
          addresses: response.data,
          selectedAddress: state.selectedAddress ?? firstAddress,
        ));
      },
    );
  }

  void _onSelectAddress(
    SelectAddressEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    emit(state.copyWith(selectedAddress: event.address));
  }

  void _onToggleWasteType(
    ToggleWasteTypeEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    final currentList = List<String>.from(state.selectedWasteTypes);
    if (currentList.contains(event.wasteType)) {
      currentList.remove(event.wasteType);
    } else {
      currentList.add(event.wasteType);
    }
    emit(state.copyWith(selectedWasteTypes: currentList));
  }

  void _onSelectQuantity(
    SelectQuantityEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    if (state.selectedQuantity != event.quantityKey) {
      emit(
        state.copyWith(
          selectedQuantity: event.quantityKey,
          clearExactWeight: true,
        ),
      );
    }
  }

  void _onSetExactWeight(
    SetExactWeightEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    if (event.exactWeight == null) {
      emit(state.copyWith(clearExactWeight: true));
    } else {
      emit(state.copyWith(exactWeight: event.exactWeight));
    }
  }

  void _onSelectTimeSlot(
    SelectTimeSlotEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    emit(state.copyWith(selectedTimeSlot: event.timeSlotKey));
  }

  void _onPickWasteImage(
    PickWasteImageEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    emit(state.copyWith(imagePath: event.imagePath));
  }

  void _onRemoveWasteImage(
    RemoveWasteImageEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    emit(state.copyWith(clearImage: true));
  }

  void _onChangeLocation(
    ChangeLocationEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    emit(
      state.copyWith(
        streetKey: event.street,
        cityKey: event.city,
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );
  }
}
