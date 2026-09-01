import 'package:cash_for_trash/features/address/data/model/address_model.dart' as address_feature;
import 'package:cash_for_trash/features/request_collection/data/model/address_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/availability_model.dart';
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

class GetAvailabilitiesEvent extends RequestCollectionEvent {
  final String addressId;
  const GetAvailabilitiesEvent(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class SelectTimeSlotEvent extends RequestCollectionEvent {
  final String timeSlotKey;
  const SelectTimeSlotEvent(this.timeSlotKey);

  @override
  List<Object?> get props => [timeSlotKey];
}

class SelectAvailabilityEvent extends RequestCollectionEvent {
  final AvailabilityItemModel availability;
  const SelectAvailabilityEvent(this.availability);

  @override
  List<Object?> get props => [availability];
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

class AddAddressToCollectionEvent extends RequestCollectionEvent {
  final address_feature.AddressModel address;

  const AddAddressToCollectionEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateAddressInCollectionEvent extends RequestCollectionEvent {
  final address_feature.AddressModel address;

  const UpdateAddressInCollectionEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class SubmitCollectionRequestEvent extends RequestCollectionEvent {
  final String paymentMethod;

  const SubmitCollectionRequestEvent({this.paymentMethod = 'CASH'});

  @override
  List<Object?> get props => [paymentMethod];
}
