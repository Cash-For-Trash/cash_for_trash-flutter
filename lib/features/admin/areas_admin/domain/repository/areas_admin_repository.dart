import 'package:cash_for_trash/features/admin/areas_admin/data/model/area_admin_model.dart';
import 'package:dartz/dartz.dart';

abstract class AreasAdminRepository {
  Future<Either<String, List<AreaAdminModel>>> getAreas();

  Future<Either<String, AreaAdminModel>> createArea(Map<String, dynamic> data);

  Future<Either<String, AreaAdminModel>> updateArea(
      String id, Map<String, dynamic> data);

  Future<Either<String, String>> deleteArea(String id);

  Future<Either<String, String>> updateAreaPrice(String id, double price);
}
