import 'package:cash_for_trash/features/request_collection/data/model/address_model.dart';
import 'package:equatable/equatable.dart';

abstract class RequestCollectionEvent extends Equatable {
  const RequestCollectionEvent();

  @override
  List<Object?> get props => [];
}

class GetGarbageTypesEvent extends RequestCollectionEvent {
  const GetGarbageTypesEvent();
}

class GetAddressesEvent extends RequestCollectionEvent {
  const GetAddressesEvent();
}

class SelectAddressEvent extends RequestCollectionEvent {
  final AddressItemModel address;
  const SelectAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class ToggleWasteTypeEvent extends RequestCollectionEvent {
  final String wasteType;
  const ToggleWasteTypeEvent(this.wasteType);

  @override
  List<Object?> get props => [wasteType];
}

class SelectQuantityEvent extends RequestCollectionEvent {
  final String quantityKey;
  const SelectQuantityEvent(this.quantityKey);

  @override
  List<Object?> get props => [quantityKey];
}

class SetExactWeightEvent extends RequestCollectionEvent {
  final double? exactWeight;
  const SetExactWeightEvent(this.exactWeight);

  @override
  List<Object?> get props => [exactWeight];
}

class SelectTimeSlotEvent extends RequestCollectionEvent {
  final String timeSlotKey;
  const SelectTimeSlotEvent(this.timeSlotKey);

  @override
  List<Object?> get props => [timeSlotKey];
}

class PickWasteImageEvent extends RequestCollectionEvent {
  final String imagePath;
  const PickWasteImageEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class RemoveWasteImageEvent extends RequestCollectionEvent {
  const RemoveWasteImageEvent();
}

class ChangeLocationEvent extends RequestCollectionEvent {
  final String street;
  final String city;
  final double? latitude;
  final double? longitude;
  const ChangeLocationEvent({
    required this.street,
    required this.city,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [street, city, latitude, longitude];
}
