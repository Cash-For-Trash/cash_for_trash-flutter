import 'package:equatable/equatable.dart';

class RewardModel extends Equatable {
  final String rewardId;
  final String name;
  final String requiredPoints;
  final String? image;
  final String createdAt;
  final String updatedAt;

  const RewardModel({
    required this.rewardId,
    required this.name,
    required this.requiredPoints,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      rewardId: json['reward_id'] as String,
      name: json['name'] as String,
      requiredPoints: json['required_points'] as String,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  @override
  List<Object?> get props => [rewardId, name, requiredPoints, image];
}
