import 'package:equatable/equatable.dart';

class HomeWorkerModel extends Equatable {
  final String workerName;
  final String nationalId;
  final bool isApproved;
  final int todayPickupsCount;
  final int fulfilledPickupsCount;
  final double totalEarnings;
  final double workerPercentage;

  const HomeWorkerModel({
    required this.workerName,
    required this.nationalId,
    required this.isApproved,
    required this.todayPickupsCount,
    required this.fulfilledPickupsCount,
    required this.totalEarnings,
    required this.workerPercentage,
  });

  factory HomeWorkerModel.fromJson(Map<String, dynamic> json) {
    return HomeWorkerModel(
      workerName: '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim(),
      nationalId: json['national_id'] as String? ?? '',
      isApproved: json['is_approved'] as bool? ?? true,
      todayPickupsCount: json['today_pickups_count'] as int? ?? 0,
      fulfilledPickupsCount: json['fulfilled_pickups_count'] as int? ?? 0,
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0.0,
      workerPercentage: (json['worker_percentage'] as num?)?.toDouble() ?? 70.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'worker_name': workerName,
      'national_id': nationalId,
      'is_approved': isApproved,
      'today_pickups_count': todayPickupsCount,
      'fulfilled_pickups_count': fulfilledPickupsCount,
      'total_earnings': totalEarnings,
      'worker_percentage': workerPercentage,
    };
  }

  @override
  List<Object?> get props => [
        workerName,
        nationalId,
        isApproved,
        todayPickupsCount,
        fulfilledPickupsCount,
        totalEarnings,
        workerPercentage,
      ];
}
