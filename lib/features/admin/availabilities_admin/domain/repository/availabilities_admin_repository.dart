import 'package:cash_for_trash/features/admin/availabilities_admin/data/model/availability_admin_model.dart';
import 'package:dartz/dartz.dart';

abstract class AvailabilitiesAdminRepository {
  Future<Either<String, List<AvailabilityAdminModel>>> getAvailabilities();

  Future<Either<String, AvailabilityAdminModel>> createAvailability(
      Map<String, dynamic> data);

  Future<Either<String, String>> deleteAvailability(String id);
}
