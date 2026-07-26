part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class GetAddressesEvent extends AddressEvent {
  const GetAddressesEvent();
}

class AddAddressEvent extends AddressEvent {
  final AddressModel address;

  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateAddressLocallyEvent extends AddressEvent {
  final AddressModel address;

  const UpdateAddressLocallyEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  final String addressId;

  const DeleteAddressEvent(this.addressId);

  @override
  List<Object?> get props => [addressId];
}