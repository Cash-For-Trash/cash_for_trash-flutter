import 'package:equatable/equatable.dart';

class RequestCollectionState extends Equatable {
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
    this.selectedWasteTypes = const ['plastic'],
    this.selectedQuantity = 'medium_qty',
    this.exactWeight,
    this.selectedTimeSlot = 'today_4pm',
    this.imagePath,
    this.streetKey = 'default_address_street',
    this.cityKey = 'default_address_city',
    this.latitude,
    this.longitude,
    this.cost = 5.0,
  });

  RequestCollectionState copyWith({
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
