import 'package:cash_for_trash/core/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:cash_for_trash/features/home/domain/repository/home_repository.dart';
import 'package:cash_for_trash/features/rewards/domain/repository/rewards_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  final RewardsRepository rewardsRepository;

  HomeBloc({required this.repository, required this.rewardsRepository})
    : super(const HomeState(currentOrdersStatus: HomeStatus.initial)) {
    on<GetCustomerCollectionRecentRequests>(
      _onGetCustomerCollectionRecentRequests,
    );
    on<GetCustomerCollectionRequests>(_onGetCustomerCollectionRequests);
    on<GetCustomerProfile>(_onGetCustomerProfile);
  }

  Future<void> _onGetCustomerCollectionRecentRequests(
    GetCustomerCollectionRecentRequests event,
    Emitter<HomeState> emit,
  ) async {
    if (event.isLoadMore) {
      if (state.isFetchingMoreCurrentOrders || !state.hasMoreCurrentOrders)
        return;
      emit(state.copyWith(isFetchingMoreCurrentOrders: true));
    } else {
      emit(
        state.copyWith(
          currentOrdersStatus: HomeStatus.loading,
          currentOrdersPage: 1,
          hasMoreCurrentOrders: true,
        ),
      );
    }

    final result = await repository.getCustomerCollectionRequests(
      event.page,
      event.pageSize,
      event.status,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          currentOrdersStatus: event.isLoadMore
              ? state.currentOrdersStatus
              : HomeStatus.error,
          isFetchingMoreCurrentOrders: false,
          errorMessage: error,
        ),
      ),
      (data) {
        final newItems = data.customerCollectionRequests;
        final existingItems = event.isLoadMore
            ? (state.currentCollectionRequest?.customerCollectionRequests ?? [])
            : <CustomerCollectionRequestModel?>[];

        final updatedList = [...existingItems, ...newItems];

        final totalItems = data.totalItems > 0 ? data.totalItems : data.total;
        final bool hasMore =
            newItems.length >= event.pageSize &&
            (totalItems == 0 || updatedList.length < totalItems);

        final mergedResponse = CustomerCollectionRequestResponseModel(
          success: data.success,
          statusCode: data.statusCode,
          message: data.message,
          page: event.page,
          pageSize: data.pageSize,
          totalItems: totalItems,
          total: data.total,
          customerCollectionRequests: updatedList,
        );

        emit(
          state.copyWith(
            currentOrdersStatus: HomeStatus.success,
            currentCollectionRequest: mergedResponse,
            currentOrdersPage: event.page,
            hasMoreCurrentOrders: hasMore,
            isFetchingMoreCurrentOrders: false,
          ),
        );
      },
    );
  }

  Future<void> _onGetCustomerCollectionRequests(
    GetCustomerCollectionRequests event,
    Emitter<HomeState> emit,
  ) async {
    if (event.isLoadMore) {
      if (state.isFetchingMoreRecentOrders || !state.hasMoreRecentOrders)
        return;
      emit(state.copyWith(isFetchingMoreRecentOrders: true));
    } else {
      emit(
        state.copyWith(
          recentCollectionRequestsStatus: HomeStatus.loading,
          recentOrdersPage: 1,
          hasMoreRecentOrders: true,
        ),
      );
    }

    final result = await repository.getCustomerCollectionRequests(
      event.page,
      event.pageSize,
      event.status,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          recentCollectionRequestsStatus: event.isLoadMore
              ? state.recentCollectionRequestsStatus
              : HomeStatus.error,
          isFetchingMoreRecentOrders: false,
          errorMessage: error,
        ),
      ),
      (data) {
        final newItems = data.customerCollectionRequests;
        final existingItems = event.isLoadMore
            ? (state.recentCollectionRequests?.customerCollectionRequests ?? [])
            : <CustomerCollectionRequestModel?>[];

        final updatedList = [...existingItems, ...newItems];

        final totalItems = data.totalItems > 0 ? data.totalItems : data.total;
        final bool hasMore =
            newItems.length >= event.pageSize &&
            (totalItems == 0 || updatedList.length < totalItems);

        final mergedResponse = CustomerCollectionRequestResponseModel(
          success: data.success,
          statusCode: data.statusCode,
          message: data.message,
          page: event.page,
          pageSize: data.pageSize,
          totalItems: totalItems,
          total: data.total,
          customerCollectionRequests: updatedList,
        );

        emit(
          state.copyWith(
            recentCollectionRequestsStatus: HomeStatus.success,
            recentCollectionRequest: mergedResponse,
            recentOrdersPage: event.page,
            hasMoreRecentOrders: hasMore,
            isFetchingMoreRecentOrders: false,
          ),
        );
      },
    );
  }

  Future<void> _onGetCustomerProfile(
    GetCustomerProfile event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(profileStatus: HomeStatus.loading));
    final result = await repository.getCustomerProfile();
    await result.fold(
      (error) async => emit(
        state.copyWith(profileStatus: HomeStatus.error, errorMessage: error),
      ),
      (data) async {
        final profileData = data.data;
        final pointsResult = await rewardsRepository.getCustomerPointsSummary();
        final pointsSummary = pointsResult.fold(
          (_) => null,
          (summary) => summary,
        );
        final HeaderDataModel headerDataModel = HeaderDataModel(
          userName: "${profileData.firstName} ${profileData.lastName}",
          points: pointsSummary?.points.toString() ?? profileData.points,
          pointsValueInEgp: pointsSummary?.valueInEgp,
        );

        emit(
          state.copyWith(
            profileStatus: HomeStatus.success,
            headerData: headerDataModel,
          ),
        );
      },
    );
  }
}
