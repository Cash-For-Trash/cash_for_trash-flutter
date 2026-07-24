import 'package:cash_for_trash/features/request_collection/data/model/address_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/garbage_type_model.dart';
import 'package:dartz/dartz.dart';

abstract class RequestCollectionRepository {
  Future<Either<String, GarbageTypeResponseModel>> getGarbageTypes();
  Future<Either<String, AddressResponseModel>> getAddresses();
}
