import 'package:equatable/equatable.dart';

/// Pricing settings (GET /api/pricing, PATCH /api/pricing)
/// swagger fields: worker_percentage, monthly_subscription_price
class PricingAdminModel extends Equatable {
  final double workerPercentage;
  final double monthlySubscriptionPrice;

  const PricingAdminModel({
    required this.workerPercentage,
    required this.monthlySubscriptionPrice,
  });

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  factory PricingAdminModel.fromJson(Map<String, dynamic> json) {
    return PricingAdminModel(
      workerPercentage: _toDouble(json['worker_percentage']),
      monthlySubscriptionPrice: _toDouble(json['monthly_subscription_price']),
    );
  }

  Map<String, dynamic> toJson() => {
        'worker_percentage': workerPercentage,
        'monthly_subscription_price': monthlySubscriptionPrice,
      };

  @override
  List<Object?> get props => [workerPercentage, monthlySubscriptionPrice];
}
