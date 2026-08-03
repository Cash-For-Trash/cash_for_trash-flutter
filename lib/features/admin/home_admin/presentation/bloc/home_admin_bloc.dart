import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeAdminEvent extends Equatable {
  const HomeAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetHomeAdminDataEvent extends HomeAdminEvent {
  const GetHomeAdminDataEvent();
}

abstract class HomeAdminState extends Equatable {
  const HomeAdminState();

  @override
  List<Object?> get props => [];
}

class HomeAdminInitialState extends HomeAdminState {}

class HomeAdminLoadingState extends HomeAdminState {}

class HomeAdminLoadedState extends HomeAdminState {
  final int totalWorkers;
  final int pendingWorkers;
  final int totalCustomers;
  final int totalAreas;

  const HomeAdminLoadedState({
    this.totalWorkers = 0,
    this.pendingWorkers = 0,
    this.totalCustomers = 0,
    this.totalAreas = 0,
  });

  @override
  List<Object?> get props =>
      [totalWorkers, pendingWorkers, totalCustomers, totalAreas];
}

class HomeAdminErrorState extends HomeAdminState {
  final String errorMessage;

  const HomeAdminErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class HomeAdminBloc extends Bloc<HomeAdminEvent, HomeAdminState> {
  HomeAdminBloc() : super(HomeAdminInitialState()) {
    on<GetHomeAdminDataEvent>(_onGetHomeAdminData);
  }

  Future<void> _onGetHomeAdminData(
    GetHomeAdminDataEvent event,
    Emitter<HomeAdminState> emit,
  ) async {
    emit(HomeAdminLoadingState());
    emit(const HomeAdminLoadedState());
  }
}
