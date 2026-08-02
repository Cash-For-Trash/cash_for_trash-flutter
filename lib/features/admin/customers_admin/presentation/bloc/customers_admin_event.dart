import 'package:equatable/equatable.dart';

abstract class CustomersAdminEvent extends Equatable {
  const CustomersAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetCustomersAdminEvent extends CustomersAdminEvent {
  final int page;
  final int pageSize;

  const GetCustomersAdminEvent({
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [page, pageSize];
}

class GetCustomerDetailAdminEvent extends CustomersAdminEvent {
  final String userId;

  const GetCustomerDetailAdminEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
