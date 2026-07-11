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

  @override
  List<Object?> get props => [id, title, status, points, time];
}

class CurrentOrderModel extends Equatable {
  final String title;
  final String timeLeft;
  final String status;
  final double progress;

  const CurrentOrderModel({
    required this.title,
    required this.timeLeft,
    required this.status,
    required this.progress,
  });

  @override
  List<Object?> get props => [title, timeLeft, status, progress];
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
  final CurrentOrderModel? currentOrder;
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
    required this.currentOrder,
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
        currentOrder,
        recentOrders,
      ];
}