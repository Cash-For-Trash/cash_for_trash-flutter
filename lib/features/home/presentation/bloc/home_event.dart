part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class GetHomeData extends HomeEvent {}

class GetCustomerCollectionRecentRequests extends HomeEvent {
  final int page;
  final int pageSize;
  final String? status;
  final bool isLoadMore;

  const GetCustomerCollectionRecentRequests({
    this.page = 1,
    this.pageSize = 4,
    this.status = "PENDING",
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [page, pageSize, status, isLoadMore];
}

class GetCustomerCollectionRequests extends HomeEvent {
  final int page;
  final int pageSize;
  final String? status;
  final bool isLoadMore;

  const GetCustomerCollectionRequests({
    this.page = 1,
    this.pageSize = 10,
    this.status,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [page, pageSize, status, isLoadMore];
}


class GetCustomerProfile extends HomeEvent {}