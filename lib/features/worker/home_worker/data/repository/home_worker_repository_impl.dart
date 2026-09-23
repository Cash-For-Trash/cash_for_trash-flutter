import 'package:cash_for_trash/core/services/local/cache_helper.dart';
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
    final workerId = CacheHelper.getDataString(key: 'selected_worker_id');
    final String path = (workerId != null && workerId.isNotEmpty)
        ? EndPoint.supervisorWorkerDetails(workerId)
        : EndPoint.userProfile;

    return await apiConsumer.get<HomeWorkerModel>(
      path,
      fromJson: (json) {
        final dataMap = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
        return HomeWorkerModel.fromJson(dataMap);
      },
    );
  }
}
