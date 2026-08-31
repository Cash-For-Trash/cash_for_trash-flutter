import 'package:cash_for_trash/core/utils/date_formatter.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String id;
  final String title;
  final String status;
  final String points;
  final String time;

  const OrderModel({
    required this.id,
    required this.title,
    required this.status,
    required this.points,
    required this.time,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawId = (json['collection_request_id'] ?? json['request_id'] ?? json['id'] ?? '').toString();
    final shortId = rawId.length > 6 ? rawId.substring(0, 6) : rawId;

    final garbageList = json['requestGarbages'] is List ? json['requestGarbages'] as List : [];
    String wasteTypesText = garbageList
        .map((g) {
          final gt = g['garbageType'];
          return gt != null ? (gt['garbage_type_name'] ?? '').toString() : '';
        })
        .where((name) => name.isNotEmpty)
        .join(', ');

    if (wasteTypesText.isEmpty) {
      final qty = json['quantity'] ?? json['total_weight'];
      wasteTypesText = qty != null ? '$qty kg' : 'Waste Collection';
    }

    int totalPoints = 0;
    for (final g in garbageList) {
      final pts = g['earned_points'];
      if (pts is num) {
        totalPoints += pts.toInt();
      }
    }
    final formattedPoints = totalPoints > 0 ? '+$totalPoints' : '$totalPoints';

    final rawTime = (json['request_date'] ?? json['scheduled_day'] ?? json['created_at'] ?? '').toString();
    final formattedTime = AppDateFormatter.format(rawTime);

    return OrderModel(
      id: shortId.isNotEmpty ? '#$shortId' : '#---',
      title: wasteTypesText,
      status: (json['status'] ?? 'PENDING').toString(),
      points: formattedPoints,
      time: formattedTime,
    );
  }

  @override
  List<Object?> get props => [id, title, status, points, time];
}

class CurrentOrderModel extends Equatable {
  final String id;
  final String title;
  final String timeLeft;
  final String status;
  final double progress;

  const CurrentOrderModel({
    required this.id,
    required this.title,
    required this.timeLeft,
    required this.status,
    required this.progress,
  });

  factory CurrentOrderModel.fromJson(Map<String, dynamic> json) {
    final rawId = (json['collection_request_id'] ?? json['request_id'] ?? json['id'] ?? '').toString();

    final garbageList = json['requestGarbages'] is List ? json['requestGarbages'] as List : [];
    String wasteTypesText = garbageList
        .map((g) {
          final gt = g['garbageType'];
          return gt != null ? (gt['garbage_type_name'] ?? '').toString() : '';
        })
        .where((name) => name.isNotEmpty)
        .join(', ');

    if (wasteTypesText.isEmpty) {
      final qty = json['quantity'] ?? json['total_weight'];
      wasteTypesText = qty != null ? '$qty kg' : 'Waste Collection';
    }

    final rawDay = (json['scheduled_day'] ?? '').toString().trim();
    final rawFrom = (json['scheduled_from_time'] ?? '').toString().trim();
    final rawTo = (json['scheduled_to_time'] ?? '').toString().trim();

    String timeInfo = AppDateFormatter.formatScheduledSlot(
      day: rawDay,
      fromTime: rawFrom,
      toTime: rawTo,
    );

    if (timeInfo.isEmpty) {
      final rawFallback = (json['request_date'] ?? json['created_at'] ?? '').toString();
      timeInfo = AppDateFormatter.format(rawFallback);
    }

    final statusStr = (json['status'] ?? 'PENDING').toString();
    double progressVal = 0.15;
    switch (statusStr.toUpperCase()) {
      case 'COLLECTED':
        progressVal = 1.0;
        break;
      case 'ON_THE_WAY':
        progressVal = 0.75;
        break;
      case 'ACCEPTED':
        progressVal = 0.5;
        break;
      case 'ASSIGNED':
        progressVal = 0.3;
        break;
      case 'PENDING':
      default:
        progressVal = 0.15;
        break;
    }

    return CurrentOrderModel(
      id: rawId,
      title: wasteTypesText,
      timeLeft: timeInfo,
      status: statusStr,
      progress: progressVal,
    );
  }

  @override
  List<Object?> get props => [id, title, timeLeft, status, progress];
}

class HomeDataModel extends Equatable {
  final String userName;
  final int points;
  final double levelProgress;
  final int nextLevelCurrent;
  final int nextLevelTotal;
  final int monthlyImpactTrees;
  final double monthlyImpactRecycledKg;
  final double monthlyImpactCollectedKg;
  final List<CurrentOrderModel?> currentOrders;
  final List<OrderModel> recentOrders;

  const HomeDataModel({
    required this.userName,
    required this.points,
    required this.levelProgress,
    required this.nextLevelCurrent,
    required this.nextLevelTotal,
    required this.monthlyImpactTrees,
    required this.monthlyImpactRecycledKg,
    required this.monthlyImpactCollectedKg,
    required this.currentOrders,
    required this.recentOrders,
  });

  @override
  List<Object?> get props => [
        userName,
        points,
        levelProgress,
        nextLevelCurrent,
        nextLevelTotal,
        monthlyImpactTrees,
        monthlyImpactRecycledKg,
        monthlyImpactCollectedKg,
        currentOrders,
        recentOrders,
      ];
}