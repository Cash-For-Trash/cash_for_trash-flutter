import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/customers_admin_repository.dart';
import 'customers_admin_event.dart';
import 'customers_admin_state.dart';

class CustomersAdminBloc
    extends Bloc<CustomersAdminEvent, CustomersAdminState> {
  final CustomersAdminRepository repository;

  CustomersAdminBloc({required this.repository})
      : super(CustomersAdminInitialState()) {
    on<GetCustomersAdminEvent>(_onGetCustomers);
    on<GetCustomerDetailAdminEvent>(_onGetCustomerDetail);
  }

  Future<void> _onGetCustomers(
    GetCustomersAdminEvent event,
    Emitter<CustomersAdminState> emit,
  ) async {
    emit(CustomersAdminLoadingState());
    final result = await repository.getCustomers(
      page: event.page,
      pageSize: event.pageSize,
    );
    result.fold(
      (error) => emit(CustomersAdminErrorState(error)),
      (customers) => emit(CustomersAdminLoadedState(customers: customers)),
    );
  }

  Future<void> _onGetCustomerDetail(
    GetCustomerDetailAdminEvent event,
    Emitter<CustomersAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CustomersAdminLoadedState) {
      emit(CustomersAdminLoadingState());
    }
    final result = await repository.getCustomerDetail(event.userId);
    result.fold(
      (error) => emit(CustomersAdminErrorState(error)),
      (customer) {
        if (currentState is CustomersAdminLoadedState) {
          emit(currentState.copyWith(selectedCustomer: customer));
        } else {
          emit(CustomersAdminLoadedState(
            customers: const [],
            selectedCustomer: customer,
          ));
        }
      },
    );
  }
}
