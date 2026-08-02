import 'package:cash_for_trash/features/admin/garbage_types_admin/data/model/garbage_type_admin_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class GarbageTypesAdminRepository {
  Future<Either<String, List<GarbageTypeAdminModel>>> getGarbageTypes();

  Future<Either<String, GarbageTypeAdminModel>> createGarbageType(
      FormData formData);

  Future<Either<String, GarbageTypeAdminModel>> updateGarbageType(
      String id, FormData formData);

  Future<Either<String, String>> deleteGarbageType(String id);
}
