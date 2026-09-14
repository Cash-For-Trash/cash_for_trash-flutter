import 'dart:io';

import 'package:cash_for_trash/core/services/cloudinary_service.dart';
import 'package:cash_for_trash/features/address/data/model/address_model.dart'
    as address_feature;
import 'package:cash_for_trash/features/request_collection/data/model/address_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/collection_request_model.dart';
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
    on<GetAvailabilitiesEvent>(_onGetAvailabilities);
    on<SelectAddressEvent>(_onSelectAddress);
    on<ToggleWasteTypeEvent>(_onToggleWasteType);
    on<SelectQuantityEvent>(_onSelectQuantity);
    on<SetExactWeightEvent>(_onSetExactWeight);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<SelectAvailabilityEvent>(_onSelectAvailability);
    on<PickWasteImageEvent>(_onPickWasteImage);
    on<RemoveWasteImageEvent>(_onRemoveWasteImage);
    on<ChangeLocationEvent>(_onChangeLocation);
    on<AddAddressToCollectionEvent>(_onAddAddressToCollection);
    on<UpdateAddressInCollectionEvent>(_onUpdateAddressInCollection);
    on<SubmitCollectionRequestEvent>(_onSubmitCollectionRequest);
  }

  Future<void> _onGetGarbageTypes(
    GetGarbageTypesEvent event,
    Emitter<RequestCollectionState> emit,
  ) async {
    emit(
      state.copyWith(isGarbageTypesLoading: true, clearGarbageTypesError: true),
    );

    final result = await repository.getGarbageTypes();

    result.fold(
      (error) => emit(
        state.copyWith(
          isGarbageTypesLoading: false,
          garbageTypesErrorMessage: error,
        ),
      ),
      (response) => emit(
        state.copyWith(
          isGarbageTypesLoading: false,
          garbageTypes: response.data,
        ),
      ),
    );
  }

  Future<void> _onGetAddresses(
    GetAddressesEvent event,
    Emitter<RequestCollectionState> emit,
  ) async {
    emit(state.copyWith(isAddressesLoading: true, clearAddressesError: true));

    final result = await repository.getAddresses();

    result.fold(
      (error) => emit(
        state.copyWith(isAddressesLoading: false, addressesErrorMessage: error),
      ),
      (response) {
        final selected =
            state.selectedAddress ??
            (response.data.isNotEmpty ? response.data.first : null);
        emit(
          state.copyWith(
            isAddressesLoading: false,
            addresses: response.data,
            selectedAddress: selected,
          ),
        );
        if (selected != null) {
          add(GetAvailabilitiesEvent(selected.addressId));
        }
      },
    );
  }

  Future<void> _onGetAvailabilities(
    GetAvailabilitiesEvent event,
    Emitter<RequestCollectionState> emit,
  ) async {
    emit(
      state.copyWith(
        isAvailabilitiesLoading: true,
        clearAvailabilitiesError: true,
      ),
    );

    final result = await repository.getAvailabilities(event.addressId);

    result.fold(
      (error) => emit(
        state.copyWith(
          isAvailabilitiesLoading: false,
          availabilitiesErrorMessage: error,
        ),
      ),
      (response) {
        final firstAvailability = response.data.isNotEmpty
            ? response.data.first
            : null;
        emit(
          state.copyWith(
            isAvailabilitiesLoading: false,
            availabilities: response.data,
            selectedAvailability: firstAvailability,
            selectedTimeSlot: firstAvailability?.id ?? '',
            cost: firstAvailability?.servicePrice,
          ),
        );
      },
    );
  }

  void _onSelectAddress(
    SelectAddressEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    emit(state.copyWith(selectedAddress: event.address));
    add(GetAvailabilitiesEvent(event.address.addressId));
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

  void _onSelectAvailability(
    SelectAvailabilityEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    emit(
      state.copyWith(
        selectedAvailability: event.availability,
        selectedTimeSlot: event.availability.id,
        cost: event.availability.servicePrice,
      ),
    );
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

  AddressItemModel _toAddressItem(address_feature.AddressModel address) {
    return AddressItemModel(
      addressId: address.addressId,
      buildingNum: address.buildingNum,
      floor: address.floor,
      location: address.location,
      latitude: address.latitude,
      longitude: address.longitude,
      additionalNote: address.additionalNote,
      userId: address.userId,
      createdAt: address.createdAt,
      updatedAt: address.updatedAt,
    );
  }

  void _onAddAddressToCollection(
    AddAddressToCollectionEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    final newItem = _toAddressItem(event.address);
    final updated = [newItem, ...state.addresses];
    emit(state.copyWith(addresses: updated, selectedAddress: newItem));
    add(GetAvailabilitiesEvent(newItem.addressId));
  }

  void _onUpdateAddressInCollection(
    UpdateAddressInCollectionEvent event,
    Emitter<RequestCollectionState> emit,
  ) {
    final updatedItem = _toAddressItem(event.address);
    final updatedList = state.addresses
        .map((a) => a.addressId == updatedItem.addressId ? updatedItem : a)
        .toList();
    final currentSelected = state.selectedAddress;
    final newSelected = currentSelected?.addressId == updatedItem.addressId
        ? updatedItem
        : currentSelected;
    emit(state.copyWith(addresses: updatedList, selectedAddress: newSelected));
    if (newSelected != null) {
      add(GetAvailabilitiesEvent(newSelected.addressId));
    }
  }

  Future<void> _onSubmitCollectionRequest(
    SubmitCollectionRequestEvent event,
    Emitter<RequestCollectionState> emit,
  ) async {
    if (state.selectedWasteTypes.isEmpty) {
      emit(
        state.copyWith(
          submitErrorMessage: 'waste_type_required',
          clearSubmitError: false,
        ),
      );
      return;
    }
    if (state.selectedAddress == null) {
      emit(state.copyWith(submitErrorMessage: 'address_required'));
      return;
    }
    if (state.selectedAvailability == null) {
      emit(state.copyWith(submitErrorMessage: 'availability_required'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    String? uploadedImageUrl;
    if (state.imagePath != null && state.imagePath!.isNotEmpty) {
      final cloudinaryService = CloudinaryService();
      uploadedImageUrl = await cloudinaryService.uploadImage(
        File(state.imagePath!),
        folderName: 'requests',
      );
    }

    final double quantityValue;
    switch (state.selectedQuantity) {
      case 'small_qty':
        quantityValue = 5.0;
        break;
      case 'large_qty':
        quantityValue = 75.0;
        break;
      default:
        quantityValue = 25.0;
    }
    final effectiveQuantity = state.exactWeight ?? quantityValue;

    final perTypeWeight = effectiveQuantity / state.selectedWasteTypes.length;
    final garbageTypes = state.selectedWasteTypes
        .map(
          (id) => CollectionGarbageTypeModel(
            garbageTypeId: id,
            estimatedWeight: perTypeWeight,
          ),
        )
        .toList();

    final request = CollectionRequestModel(
      addressId: state.selectedAddress!.addressId,
      availabilityId: state.selectedAvailability!.availabilityId,
      paymentMethod: event.paymentMethod,
      quantity: effectiveQuantity,
      collectionImg: uploadedImageUrl,
      garbageTypes: garbageTypes,
    );

    final result = await repository.createCollectionRequest(request);

    result.fold(
      (error) =>
          emit(state.copyWith(isSubmitting: false, submitErrorMessage: error)),
      (response) => emit(
        state.copyWith(
          isSubmitting: false,
          submitSuccess: true,
          collectionRequestResponse: response,
        ),
      ),
    );
  }
}
