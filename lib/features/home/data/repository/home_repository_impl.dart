import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:cash_for_trash/features/home/domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiConsumer apiConsumer;

  HomeRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, HomeDataModel>> getHome() async {
    final reqResult = await apiConsumer.get<Map<String, dynamic>>(
      EndPoint.myCollectionRequests,
    );

    return reqResult.fold(
      (error) => Left(error),
      (json) async {
        final rawList = json['data'] is List
            ? json['data'] as List
            : (json['requests'] is List ? json['requests'] as List : []);

        final allOrders = rawList
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();

        Map<String, dynamic>? activeOrderJson;
        for (final item in allOrders) {
          final status = (item['status'] ?? '').toString().toUpperCase();
          if (status != 'COLLECTED' && status != 'CANCELLED') {
            activeOrderJson = item;
            break;
          }
        }

        final currentOrder = activeOrderJson != null
            ? CurrentOrderModel.fromJson(activeOrderJson)
            : null;

        final recentOrders = allOrders
            .map((item) => OrderModel.fromJson(item))
            .toList();

        String userName = 'Customer';
        int points = 0;
        final profileResult = await apiConsumer.get<Map<String, dynamic>>(
          EndPoint.userProfile,
        );

        profileResult.fold(
          (_) {},
          (profileJson) {
            final dataObj = profileJson['data'] is Map<String, dynamic>
                ? profileJson['data'] as Map<String, dynamic>
                : profileJson;
            final fName = (dataObj['first_name'] ?? '').toString();
            final lName = (dataObj['last_name'] ?? '').toString();
            if (fName.isNotEmpty) {
              userName = '$fName $lName'.trim();
            }
            final rawPts = dataObj['points'] ?? dataObj['green_points'] ?? 0;
            if (rawPts is num) {
              points = rawPts.toInt();
            } else if (rawPts is String) {
              points = int.tryParse(rawPts) ?? 0;
            }
          },
        );

        return Right(HomeDataModel(
          userName: userName,
          points: points,
          levelProgress: 0.75,
          nextLevelCurrent: points,
          nextLevelTotal: points > 0 ? (points + 200) : 500,
          monthlyImpactTrees: (points / 100).ceil(),
          monthlyImpactRecycledKg: (allOrders.length * 5.0),
          monthlyImpactCollectedKg: (allOrders.length * 7.5),
          currentOrder: currentOrder,
          recentOrders: recentOrders,
        ));
      },
    );
  }
}