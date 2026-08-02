import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/pricing_admin_repository.dart';
import 'pricing_admin_event.dart';
import 'pricing_admin_state.dart';

class PricingAdminBloc extends Bloc<PricingAdminEvent, PricingAdminState> {
  final PricingAdminRepository repository;

  PricingAdminBloc({required this.repository})
      : super(PricingAdminInitialState()) {
    on<GetPricingAdminEvent>(_onGetPricing);
    on<UpdatePricingAdminEvent>(_onUpdatePricing);
  }

  Future<void> _onGetPricing(
    GetPricingAdminEvent event,
    Emitter<PricingAdminState> emit,
  ) async {
    emit(PricingAdminLoadingState());
    final result = await repository.getPricing();
    result.fold(
      (error) => emit(PricingAdminErrorState(error)),
      (pricing) => emit(PricingAdminLoadedState(pricing: pricing)),
    );
  }

  Future<void> _onUpdatePricing(
    UpdatePricingAdminEvent event,
    Emitter<PricingAdminState> emit,
  ) async {
    final currentState = state;
    if (currentState is PricingAdminLoadedState) {
      emit(currentState.copyWith(isActionLoading: true));
    }
    final result = await repository.updatePricing(event.pricing);
    result.fold(
      (error) => emit(PricingAdminErrorState(error)),
      (pricing) => emit(PricingAdminLoadedState(pricing: pricing)),
    );
  }
}
