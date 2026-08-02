import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/redemptions_admin_repository.dart';
import 'redemptions_admin_event.dart';
import 'redemptions_admin_state.dart';

class RedemptionsAdminBloc
    extends Bloc<RedemptionsAdminEvent, RedemptionsAdminState> {
  final RedemptionsAdminRepository repository;

  RedemptionsAdminBloc({required this.repository})
      : super(RedemptionsAdminInitialState()) {
    on<GetRedemptionsAdminEvent>(_onGetRedemptions);
    on<ApproveRedemptionAdminEvent>(_onApproveRedemption);
    on<RejectRedemptionAdminEvent>(_onRejectRedemption);
  }

  Future<void> _onGetRedemptions(
    GetRedemptionsAdminEvent event,
    Emitter<RedemptionsAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is! RedemptionsAdminLoadedState) {
      emit(RedemptionsAdminLoadingState());
    }
    final result = await repository.getRedemptions();
    result.fold(
      (error) => emit(RedemptionsAdminErrorState(error)),
      (redemptions) =>
          emit(RedemptionsAdminLoadedState(redemptions: redemptions)),
    );
  }

  Future<void> _onApproveRedemption(
    ApproveRedemptionAdminEvent event,
    Emitter<RedemptionsAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is RedemptionsAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.approveRedemption(event.redemptionId);
    result.fold(
      (error) => emit(RedemptionsAdminErrorState(error)),
      (msg) {
        if (currentState is RedemptionsAdminLoadedState) {
          emit(currentState.copyWith(
            isActionLoading: false,
            successMessage: msg,
          ));
        }
        add(const GetRedemptionsAdminEvent());
      },
    );
  }

  Future<void> _onRejectRedemption(
    RejectRedemptionAdminEvent event,
    Emitter<RedemptionsAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is RedemptionsAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.rejectRedemption(event.redemptionId);
    result.fold(
      (error) => emit(RedemptionsAdminErrorState(error)),
      (msg) {
        if (currentState is RedemptionsAdminLoadedState) {
          emit(currentState.copyWith(
            isActionLoading: false,
            successMessage: msg,
          ));
        }
        add(const GetRedemptionsAdminEvent());
      },
    );
  }
}
