import 'package:cash_for_trash/features/address/data/model/address_model.dart';
import 'package:cash_for_trash/features/address/domain/repository/address_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository repository;

  AddressBloc({required this.repository}) : super(const AddressInitialState()) {
    on<GetAddressesEvent>(_onGetAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressLocallyEvent>(_onUpdateAddressLocally);
    on<DeleteAddressEvent>(_onDeleteAddress);
  }

  Future<void> _onGetAddresses(
    GetAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressLoadingState());
    final result = await repository.getAddresses();
    result.fold(
      (error) => emit(AddressErrorState(error)),
      (list) => emit(AddressLoadedState(list)),
    );
  }

  void _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) {
    final current = state is AddressLoadedState
        ? (state as AddressLoadedState).addresses
        : <AddressModel>[];
    emit(AddressLoadedState([event.address, ...current]));
  }

  void _onUpdateAddressLocally(
    UpdateAddressLocallyEvent event,
    Emitter<AddressState> emit,
  ) {
    if (state is! AddressLoadedState) return;
    final updated = (state as AddressLoadedState)
        .addresses
        .map((a) => a.addressId == event.address.addressId ? event.address : a)
        .toList();
    emit(AddressLoadedState(updated));
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    if (state is! AddressLoadedState) return;
    final current = (state as AddressLoadedState).addresses;
    emit(AddressDeletingState(addresses: current, deletingId: event.addressId));
    final result = await repository.deleteAddress(event.addressId);
    result.fold(
      (error) => emit(AddressLoadedState(current)),
      (_) => emit(AddressLoadedState(
        current.where((a) => a.addressId != event.addressId).toList(),
      )),
    );
  }
}