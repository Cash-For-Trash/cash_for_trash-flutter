import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/worker/home_worker/data/model/home_worker_model.dart';
import 'package:cash_for_trash/features/worker/home_worker/domain/repository/home_worker_repository.dart';
import 'package:dartz/dartz.dart';

class HomeWorkerRepositoryImpl implements HomeWorkerRepository {
  final ApiConsumer apiConsumer;

  HomeWorkerRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, HomeWorkerModel>> getHomeWorkerData() async {
    return await apiConsumer.get<HomeWorkerModel>(
      EndPoint.userProfile,
      fromJson: (json) {
        final dataMap = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return HomeWorkerModel.fromJson(dataMap);
      },
    );
  }
}
