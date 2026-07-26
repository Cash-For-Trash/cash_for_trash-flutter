import 'package:cash_for_trash/features/request_collection/data/model/address_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/garbage_type_model.dart';
import 'package:equatable/equatable.dart';

class RequestCollectionState extends Equatable {
  final bool isGarbageTypesLoading;
  final List<GarbageTypeItemModel> garbageTypes;
  final String? garbageTypesErrorMessage;

  final bool isAddressesLoading;
  final List<AddressItemModel> addresses;
  final String? addressesErrorMessage;
  final AddressItemModel? selectedAddress;

  final List<String> selectedWasteTypes;
  final String selectedQuantity;
  final double? exactWeight;
  final String selectedTimeSlot;
  final String? imagePath;
  final String streetKey;
  final String cityKey;
  final double? latitude;
  final double? longitude;
  final double cost;

  const RequestCollectionState({
    this.isGarbageTypesLoading = false,
    this.garbageTypes = const [],
    this.garbageTypesErrorMessage,
    this.isAddressesLoading = false,
    this.addresses = const [],
    this.addressesErrorMessage,
    this.selectedAddress,
    this.selectedWasteTypes = const [],
    this.selectedQuantity = 'medium_qty',
    this.exactWeight,
    this.selectedTimeSlot = 'today_4pm',
    this.imagePath,
    this.streetKey = '',
    this.cityKey = '',
    this.latitude,
    this.longitude,
    this.cost = 5.0,
  });

  RequestCollectionState copyWith({
    bool? isGarbageTypesLoading,
    List<GarbageTypeItemModel>? garbageTypes,
    String? garbageTypesErrorMessage,
    bool clearGarbageTypesError = false,
    bool? isAddressesLoading,
    List<AddressItemModel>? addresses,
    String? addressesErrorMessage,
    bool clearAddressesError = false,
    AddressItemModel? selectedAddress,
    List<String>? selectedWasteTypes,
    String? selectedQuantity,
    double? exactWeight,
    bool clearExactWeight = false,
    String? selectedTimeSlot,
    String? imagePath,
    bool clearImage = false,
    String? streetKey,
    String? cityKey,
    double? latitude,
    double? longitude,
    double? cost,
  }) {
    return RequestCollectionState(
      isGarbageTypesLoading:
          isGarbageTypesLoading ?? this.isGarbageTypesLoading,
      garbageTypes: garbageTypes ?? this.garbageTypes,
      garbageTypesErrorMessage: clearGarbageTypesError
          ? null
          : (garbageTypesErrorMessage ?? this.garbageTypesErrorMessage),
      isAddressesLoading: isAddressesLoading ?? this.isAddressesLoading,
      addresses: addresses ?? this.addresses,
      addressesErrorMessage: clearAddressesError
          ? null
          : (addressesErrorMessage ?? this.addressesErrorMessage),
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedWasteTypes: selectedWasteTypes ?? this.selectedWasteTypes,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      exactWeight: clearExactWeight ? null : (exactWeight ?? this.exactWeight),
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      streetKey: streetKey ?? this.streetKey,
      cityKey: cityKey ?? this.cityKey,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cost: cost ?? this.cost,
    );
  }

  @override
  List<Object?> get props => [
    isGarbageTypesLoading,
    garbageTypes,
    garbageTypesErrorMessage,
    isAddressesLoading,
    addresses,
    addressesErrorMessage,
    selectedAddress,
    selectedWasteTypes,
    selectedQuantity,
    exactWeight,
    selectedTimeSlot,
    imagePath,
    streetKey,
    cityKey,
    latitude,
    longitude,
    cost,
  ];
}
