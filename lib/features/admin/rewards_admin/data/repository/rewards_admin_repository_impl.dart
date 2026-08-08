import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repository/rewards_admin_repository.dart';
import '../model/reward_admin_model.dart';

class RewardsAdminRepositoryImpl implements RewardsAdminRepository {
  final ApiConsumer apiConsumer;

  RewardsAdminRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<RewardAdminModel>>> getRewards() async {
    final result = await apiConsumer.get<Map<String, dynamic>>(
      EndPoint.rewardsAdmin,
    );
    return result.fold((error) => Left(error), (json) {
      final rawList = json['data'] is List ? json['data'] as List : [];
      final list = rawList
          .map(
            (item) => RewardAdminModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<String, RewardAdminModel>> createReward(
    Map<String, dynamic> fields,
    String? imagePath,
  ) async {
    final bool hasImage = imagePath != null;
    final Object data;
    if (hasImage) {
      final imageFile = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
      data = FormData.fromMap({...fields, 'image': imageFile});
    } else {
      data = fields;
    }
    return await apiConsumer.post<RewardAdminModel>(
      EndPoint.rewardsAdmin,
      data: data,
      isFromData: hasImage,
      fromJson: (json) {
        final dataObj = json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;
        return RewardAdminModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, RewardAdminModel>> updateReward(
    String id,
    Map<String, dynamic> fields,
    String? imagePath,
  ) async {
    final bool hasImage = imagePath != null;
    final Object data;
    if (hasImage) {
      final imageFile = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
      data = FormData.fromMap({...fields, 'image': imageFile});
    } else {
      data = fields;
    }
    return await apiConsumer.put<RewardAdminModel>(
      '${EndPoint.rewardsAdmin}/$id',
      data: data,
      isFromData: hasImage,
      fromJson: (json) {
        final dataObj = json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;
        return RewardAdminModel.fromJson(dataObj);
      },
    );
  }

  @override
  Future<Either<String, String>> deleteReward(String id) async {
    final result = await apiConsumer.delete<Map<String, dynamic>>(
      '${EndPoint.rewardsAdmin}/$id',
    );
    return result.fold(
      (error) => Left(error),
      (json) =>
          Right(json['message']?.toString() ?? 'Reward deleted successfully'),
    );
  }
}
