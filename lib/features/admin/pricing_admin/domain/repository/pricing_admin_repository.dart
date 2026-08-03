import 'package:cash_for_trash/features/admin/pricing_admin/data/model/pricing_admin_model.dart';
import 'package:dartz/dartz.dart';

abstract class PricingAdminRepository {
  Future<Either<String, PricingAdminModel>> getPricing();

  Future<Either<String, PricingAdminModel>> updatePricing(
      PricingAdminModel pricing);
}
