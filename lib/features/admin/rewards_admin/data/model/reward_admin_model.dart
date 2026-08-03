import 'package:equatable/equatable.dart';

/// Reward (GET /api/rewards, GET /api/rewards/{id})
class RewardAdminModel extends Equatable {
  final String id;
  final String name;
  final int requiredPoints;
  final String? image;

  const RewardAdminModel({
    required this.id,
    required this.name,
    required this.requiredPoints,
    this.image,
  });

  factory RewardAdminModel.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['required_points'] ?? json['points_required'] ?? 0;
    return RewardAdminModel(
      id: (json['reward_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      requiredPoints: rawPoints is num ? rawPoints.toInt() : int.tryParse(rawPoints.toString()) ?? 0,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'reward_id': id,
        'name': name,
        'required_points': requiredPoints,
        'image': image,
      };

  @override
  List<Object?> get props => [id, name, requiredPoints, image];
}
