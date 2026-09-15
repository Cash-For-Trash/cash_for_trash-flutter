import 'package:cash_for_trash/core/models/profile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';

abstract class HomeRepository {
  // Future<Either<String, HomeDataModel>> getHome();

  Future<Either<String, CustomerCollectionRequestResponseModel>> getCustomerCollectionRequests(int? page, int? pageSize, String? status);

  Future<Either<String, ProfileResponseModel>> getCustomerProfile();
}