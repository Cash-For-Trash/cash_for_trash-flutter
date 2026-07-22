import 'package:dartz/dartz.dart';
import 'package:cash_for_trash/features/<FTName | snakecase>/data/model/<FTName | snakecase>_model.dart';

abstract class <FTName | pascalcase>Repository {
  Future<Either<String, List<<FTName | pascalcase>Model>>> get<FTName | pascalcase>();
}