import 'package:cash_for_trash/features/request_collection/data/model/address_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/availability_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/collection_request_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/collection_request_response_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/garbage_type_model.dart';
import 'package:dartz/dartz.dart';

abstract class RequestCollectionRepository {
  Future<Either<String, GarbageTypeResponseModel>> getGarbageTypes();
  Future<Either<String, AddressResponseModel>> getAddresses();
  Future<Either<String, AvailabilityResponseModel>> getAvailabilities(
    String addressId,
  );
  Future<Either<String, CollectionRequestResponseModel>>
  createCollectionRequest(CollectionRequestModel request);
}
