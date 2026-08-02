import 'package:equatable/equatable.dart';
import '../../data/model/pricing_admin_model.dart';

abstract class PricingAdminEvent extends Equatable {
  const PricingAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetPricingAdminEvent extends PricingAdminEvent {
  const GetPricingAdminEvent();
}

class UpdatePricingAdminEvent extends PricingAdminEvent {
  final PricingAdminModel pricing;

  const UpdatePricingAdminEvent(this.pricing);

  @override
  List<Object?> get props => [pricing];
}
