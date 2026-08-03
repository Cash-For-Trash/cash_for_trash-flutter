import 'package:equatable/equatable.dart';

/// Reward redemption request (GET /api/reward-redeems)
class RedemptionAdminModel extends Equatable {
  final String id;
  final String? customerName;
  final String? rewardTitle;
  final int? pointsUsed;
  final String status;
  final String? createdAt;

  const RedemptionAdminModel({
    required this.id,
    this.customerName,
    this.rewardTitle,
    this.pointsUsed,
    required this.status,
    this.createdAt,
  });

  factory RedemptionAdminModel.fromJson(Map<String, dynamic> json) {
    final id = (json['redemption_id'] ?? json['id'] ?? json['_id'] ?? '').toString();

    // Parse Customer Name (direct key or nested inside customer -> user -> first_name / last_name)
    String? customerName;
    if (json['customer_name'] != null && json['customer_name'].toString().isNotEmpty) {
      customerName = json['customer_name'].toString();
    } else if (json['customer'] is Map) {
      final custMap = json['customer'] as Map<String, dynamic>;
      if (custMap['user'] is Map) {
        final userMap = custMap['user'] as Map<String, dynamic>;
        final fn = userMap['first_name'] ?? '';
        final ln = userMap['last_name'] ?? '';
        customerName = '$fn $ln'.trim();
      } else {
        final fn = custMap['first_name'] ?? '';
        final ln = custMap['last_name'] ?? '';
        customerName = '$fn $ln'.trim();
      }
    } else if (json['user'] is Map) {
      final userMap = json['user'] as Map<String, dynamic>;
      final fn = userMap['first_name'] ?? '';
      final ln = userMap['last_name'] ?? '';
      customerName = '$fn $ln'.trim();
    }

    // Parse Reward Title (direct key or nested inside reward -> name / title)
    String? rewardTitle;
    if (json['reward_title'] != null && json['reward_title'].toString().isNotEmpty) {
      rewardTitle = json['reward_title'].toString();
    } else if (json['reward'] is Map) {
      final rewardMap = json['reward'] as Map<String, dynamic>;
      rewardTitle = (rewardMap['name'] ?? rewardMap['title'] ?? '').toString();
    }

    // Parse Points Used (points_spent or points_used or reward -> required_points)
    int? pointsUsed;
    final rawPoints = json['points_spent'] ??
        json['points_used'] ??
        (json['reward'] is Map ? json['reward']['required_points'] : null);
    if (rawPoints is num) {
      pointsUsed = rawPoints.toInt();
    } else if (rawPoints is String) {
      pointsUsed = int.tryParse(rawPoints);
    }

    final status = (json['status'] ?? 'PENDING').toString();
    final createdAt = json['created_at']?.toString();

    return RedemptionAdminModel(
      id: id,
      customerName: (customerName != null && customerName.isNotEmpty) ? customerName : null,
      rewardTitle: (rewardTitle != null && rewardTitle.isNotEmpty) ? rewardTitle : null,
      pointsUsed: pointsUsed,
      status: status,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'redemption_id': id,
        'customer_name': customerName,
        'reward_title': rewardTitle,
        'points_used': pointsUsed,
        'status': status,
        'created_at': createdAt,
      };

  @override
  List<Object?> get props => [id, customerName, rewardTitle, pointsUsed, status, createdAt];
}
