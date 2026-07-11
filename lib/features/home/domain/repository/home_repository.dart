import 'package:dartz/dartz.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';

abstract class HomeRepository {
  Future<Either<String, HomeDataModel>> getHome();
}