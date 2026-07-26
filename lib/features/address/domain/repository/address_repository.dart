import 'package:dartz/dartz.dart';
import 'package:cash_for_trash/features/address/data/model/address_model.dart';

abstract class AddressRepository {
  Future<Either<String, List<AddressModel>>> getAddresses();
  Future<Either<String, void>> deleteAddress(String addressId);
}