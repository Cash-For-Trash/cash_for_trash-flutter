import 'package:cash_for_trash/core/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:cash_for_trash/features/home/domain/repository/home_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository})
    : super(const HomeState(currentOrdersStatus: HomeStatus.initial)) {
    on<GetCustomerCollectionRecentRequests>(_onGetCustomerCollectionRecentRequests);
    on<GetCustomerCollectionRequests>(_onGetCustomerCollectionRequests);
    on<GetCustomerProfile>(_onGetCustomerProfile);
  }

  Future<void> _onGetCustomerCollectionRecentRequests(
    GetCustomerCollectionRecentRequests event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(currentOrdersStatus: HomeStatus.loading));
    final result = await repository.getCustomerCollectionRequests(
      event.page,
      event.pageSize,
      event.status
    );
    result.fold(
      (error) => emit(state.copyWith(currentOrdersStatus: HomeStatus.error, errorMessage: error)),
      (data) => emit(
        state.copyWith(
          currentOrdersStatus: HomeStatus.success,
          currentCollectionRequest: data,
        ),
      ),
    );
  }

  Future<void> _onGetCustomerCollectionRequests(
      GetCustomerCollectionRequests event,
      Emitter<HomeState> emit
      ) async {
    emit(state.copyWith(recentCollectionRequestsStatus: HomeStatus.loading));
    final result = await repository.getCustomerCollectionRequests(
        event.page,
        event.pageSize,
        null
    );
    result.fold(
          (error) => emit(state.copyWith(recentCollectionRequestsStatus: HomeStatus.error, errorMessage: error)),
          (data) => emit(
        state.copyWith(
          recentCollectionRequestsStatus: HomeStatus.success,
          recentCollectionRequest: data,
        ),
      ),
    );
  }

  Future<void> _onGetCustomerProfile(
    GetCustomerProfile event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(profileStatus: HomeStatus.loading));
    final result = await repository.getCustomerProfile();
    result.fold(
      (error) => emit(state.copyWith(profileStatus: HomeStatus.error, errorMessage: error)),
      (data) {
        final profileData = data.data;
        final HeaderDataModel headerDataModel = HeaderDataModel(
            userName: "${profileData.firstName} ${profileData.lastName}",
            points: profileData.points,
        );

        emit(
          state.copyWith(
            profileStatus: HomeStatus.success,
            headerData: headerDataModel,
          ),
        );
      }
    );
  }
}