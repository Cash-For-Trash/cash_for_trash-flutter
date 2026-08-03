import 'package:cash_for_trash/features/worker/earnings_worker/domain/repository/earnings_worker_repository.dart';
import 'package:cash_for_trash/features/worker/earnings_worker/presentation/bloc/earnings_worker_event.dart';
import 'package:cash_for_trash/features/worker/earnings_worker/presentation/bloc/earnings_worker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EarningsWorkerBloc extends Bloc<EarningsWorkerEvent, EarningsWorkerState> {
  final EarningsWorkerRepository repository;

  EarningsWorkerBloc({required this.repository})
      : super(EarningsWorkerInitialState()) {
    on<GetWorkerEarningsEvent>(_onGetWorkerEarnings);
  }

  Future<void> _onGetWorkerEarnings(
    GetWorkerEarningsEvent event,
    Emitter<EarningsWorkerState> emit,
  ) async {
    emit(EarningsWorkerLoadingState());
    final result = await repository.getWorkerEarnings();
    result.fold(
      (error) => emit(EarningsWorkerErrorState(error)),
      (data) => emit(EarningsWorkerLoadedState(data)),
    );
  }
}
