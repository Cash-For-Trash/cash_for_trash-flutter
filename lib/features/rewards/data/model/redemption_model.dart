import 'package:equatable/equatable.dart';

class RedemptionModel extends Equatable {
  final String redemptionId;
  final String rewardName;
  final int requiredPoints;
  final String status;
  final String createdAt;
  final String? rewardImage;

  const RedemptionModel({
    required this.redemptionId,
    required this.rewardName,
    required this.requiredPoints,
    required this.status,
    required this.createdAt,
    this.rewardImage,
  });

  static int _toInt(dynamic v) {
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    final rewardObj = json['reward'] as Map<String, dynamic>? ?? {};
    return RedemptionModel(
      redemptionId: (json['redemption_id'] ?? json['id'] ?? '').toString(),
      rewardName: (rewardObj['name'] ?? json['reward_name'] ?? '').toString(),
      requiredPoints: _toInt(rewardObj['required_points'] ?? json['required_points']),
      status: (json['status'] ?? 'PENDING').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      rewardImage: (rewardObj['image'] ?? json['image']) as String?,
    );
  }

  @override
  List<Object?> get props => [redemptionId, rewardName, requiredPoints, status, createdAt];
}
