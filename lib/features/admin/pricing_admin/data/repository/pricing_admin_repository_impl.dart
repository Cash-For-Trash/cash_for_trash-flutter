import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repository/pricing_admin_repository.dart';
import '../model/pricing_admin_model.dart';

class PricingAdminRepositoryImpl implements PricingAdminRepository {
  final ApiConsumer apiConsumer;

  PricingAdminRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, PricingAdminModel>> getPricing() async {
    return await apiConsumer.get<PricingAdminModel>(
      EndPoint.pricing,
      fromJson: (json) {
        final dataObj =
            json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return PricingAdminModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, PricingAdminModel>> updatePricing(
      PricingAdminModel pricing) async {
    return await apiConsumer.patch<PricingAdminModel>(
      EndPoint.pricing,
      data: pricing.toJson(),
      fromJson: (json) {
        final dataObj =
            json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return PricingAdminModel.fromJson(dataObj);
      },
    );
  }
}
