import 'package:equatable/equatable.dart';

class RewardsLeaderboardModel extends Equatable {
  final int rank;
  final String customerId;
  final String name;
  final int points;

  const RewardsLeaderboardModel({
    required this.rank,
    required this.customerId,
    required this.name,
    required this.points,
  });

  factory RewardsLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return RewardsLeaderboardModel(
      rank: json['rank'] is num
          ? (json['rank'] as num).toInt()
          : (int.tryParse(json['rank']?.toString() ?? '0') ?? 0),
      customerId: json['customer_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      points: json['points'] is num
          ? (json['points'] as num).toInt()
          : (int.tryParse(json['points']?.toString() ?? '0') ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'customer_id': customerId,
      'name': name,
      'points': points,
    };
  }

  @override
  List<Object?> get props => [rank, customerId, name, points];
}
