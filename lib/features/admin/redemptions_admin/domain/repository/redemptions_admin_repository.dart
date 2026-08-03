import 'package:cash_for_trash/features/admin/redemptions_admin/data/model/redemption_admin_model.dart';
import 'package:dartz/dartz.dart';

abstract class RedemptionsAdminRepository {
  Future<Either<String, List<RedemptionAdminModel>>> getRedemptions();

  Future<Either<String, String>> approveRedemption(String redemptionId);

  Future<Either<String, String>> rejectRedemption(String redemptionId);
}
