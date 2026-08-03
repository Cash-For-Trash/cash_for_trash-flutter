import 'package:equatable/equatable.dart';

class EarningsWorkerModel extends Equatable {
  final double totalEarnings;
  final int totalFulfilledPickups;
  final double workerSharePercentage;
  final List<Map<String, dynamic>> payoutHistory;

  const EarningsWorkerModel({
    required this.totalEarnings,
    required this.totalFulfilledPickups,
    required this.workerSharePercentage,
    required this.payoutHistory,
  });

  factory EarningsWorkerModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['payout_history'] as List<dynamic>? ?? [];
    return EarningsWorkerModel(
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0.0,
      totalFulfilledPickups: json['fulfilled_pickups'] as int? ?? 0,
      workerSharePercentage: (json['worker_percentage'] as num?)?.toDouble() ?? 70.0,
      payoutHistory: rawList.map((item) => item as Map<String, dynamic>).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_earnings': totalEarnings,
      'fulfilled_pickups': totalFulfilledPickups,
      'worker_percentage': workerSharePercentage,
      'payout_history': payoutHistory,
    };
  }

  @override
  List<Object?> get props => [
        totalEarnings,
        totalFulfilledPickups,
        workerSharePercentage,
        payoutHistory,
      ];
}
