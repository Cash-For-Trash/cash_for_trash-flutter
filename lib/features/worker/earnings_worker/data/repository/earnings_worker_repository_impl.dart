import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/worker/earnings_worker/data/model/earnings_worker_model.dart';
import 'package:cash_for_trash/features/worker/earnings_worker/domain/repository/earnings_worker_repository.dart';
import 'package:dartz/dartz.dart';

class EarningsWorkerRepositoryImpl implements EarningsWorkerRepository {
  final ApiConsumer apiConsumer;

  EarningsWorkerRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, EarningsWorkerModel>> getWorkerEarnings() async {
    final pricingResult = await apiConsumer.get<Map<String, dynamic>>(EndPoint.pricing);
    final profileResult = await apiConsumer.get<Map<String, dynamic>>(EndPoint.userProfile);

    Map<String, dynamic> pricingData = {};
    pricingResult.fold((_) {}, (json) {
      pricingData = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
    });

    return profileResult.fold(
      (error) => Left(error),
      (json) {
        final profileData = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        final combined = <String, dynamic>{
          'total_earnings': profileData['total_earnings'] ?? 0.0,
          'fulfilled_pickups': profileData['fulfilled_pickups_count'] ?? 0,
          'worker_percentage': pricingData['worker_percentage'] ?? profileData['worker_percentage'] ?? 70.0,
          'payout_history': profileData['payout_history'] ?? [],
        };
        return Right(EarningsWorkerModel.fromJson(combined));
      },
    );
  }
}
