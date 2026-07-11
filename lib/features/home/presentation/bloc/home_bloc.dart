import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:cash_for_trash/features/home/domain/repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<GetHomeData>(_onGetHomeData);
  }

  Future<void> _onGetHomeData(GetHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await repository.getHome();
    result.fold(
      (error) => emit(HomeStateError(message: error)),
      (data) => emit(HomeLoaded(data)),
    );
  }
}