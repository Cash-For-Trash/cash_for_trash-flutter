part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitialState extends AddressState {
  const AddressInitialState();
}

class AddressLoadingState extends AddressState {
  const AddressLoadingState();
}

class AddressLoadedState extends AddressState {
  final List<AddressModel> addresses;

  const AddressLoadedState(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressErrorState extends AddressState {
  final String message;

  const AddressErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressDeletingState extends AddressState {
  final List<AddressModel> addresses;
  final String deletingId;

  const AddressDeletingState({
    required this.addresses,
    required this.deletingId,
  });

  @override
  List<Object?> get props => [addresses, deletingId];
}