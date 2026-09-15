part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class GetHomeData extends HomeEvent {}

class GetCustomerCollectionRecentRequests extends HomeEvent {
  final int? page;
  final int? pageSize;
  final String? status;

  const GetCustomerCollectionRecentRequests({this.page, this.pageSize, this.status});
}

class GetCustomerCollectionRequests extends HomeEvent {
  final int? page;
  final int? pageSize;
  final String? status;

  const GetCustomerCollectionRequests({this.page, this.pageSize, this.status});
}


class GetCustomerProfile extends HomeEvent {}