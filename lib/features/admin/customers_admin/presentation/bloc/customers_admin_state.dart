import 'package:equatable/equatable.dart';
import '../../data/model/customer_admin_model.dart';

abstract class CustomersAdminState extends Equatable {
  const CustomersAdminState();

  @override
  List<Object?> get props => [];
}

class CustomersAdminInitialState extends CustomersAdminState {}

class CustomersAdminLoadingState extends CustomersAdminState {}

class CustomersAdminLoadedState extends CustomersAdminState {
  final List<CustomerAdminModel> customers;
  final CustomerAdminModel? selectedCustomer;

  const CustomersAdminLoadedState({
    required this.customers,
    this.selectedCustomer,
  });

  CustomersAdminLoadedState copyWith({
    List<CustomerAdminModel>? customers,
    CustomerAdminModel? selectedCustomer,
  }) {
    return CustomersAdminLoadedState(
      customers: customers ?? this.customers,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
    );
  }

  @override
  List<Object?> get props => [customers, selectedCustomer];
}

class CustomersAdminErrorState extends CustomersAdminState {
  final String errorMessage;

  const CustomersAdminErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
