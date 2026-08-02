import 'package:equatable/equatable.dart';
import '../../data/model/pricing_admin_model.dart';

abstract class PricingAdminState extends Equatable {
  const PricingAdminState();

  @override
  List<Object?> get props => [];
}

class PricingAdminInitialState extends PricingAdminState {}

class PricingAdminLoadingState extends PricingAdminState {}

class PricingAdminLoadedState extends PricingAdminState {
  final PricingAdminModel pricing;
  final bool isActionLoading;

  const PricingAdminLoadedState({
    required this.pricing,
    this.isActionLoading = false,
  });

  PricingAdminLoadedState copyWith({
    PricingAdminModel? pricing,
    bool? isActionLoading,
  }) {
    return PricingAdminLoadedState(
      pricing: pricing ?? this.pricing,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }

  @override
  List<Object?> get props => [pricing, isActionLoading];
}

class PricingAdminErrorState extends PricingAdminState {
  final String errorMessage;

  const PricingAdminErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
