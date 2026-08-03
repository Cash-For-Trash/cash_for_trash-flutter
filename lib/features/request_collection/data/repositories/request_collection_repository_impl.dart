import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/request_collection/data/model/address_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/availability_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/collection_request_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/collection_request_response_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/garbage_type_model.dart';
import 'package:cash_for_trash/features/request_collection/domain/repositories/request_collection_repository.dart';
import 'package:dartz/dartz.dart';

class RequestCollectionRepositoryImpl implements RequestCollectionRepository {
  final ApiConsumer apiConsumer;

  RequestCollectionRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, GarbageTypeResponseModel>> getGarbageTypes() async {
    return await apiConsumer.get<GarbageTypeResponseModel>(
      EndPoint.garbageTypes,
      fromJson: (json) => GarbageTypeResponseModel.fromJson(json),
    );
  }

  @override
  Future<Either<String, AddressResponseModel>> getAddresses() async {
    return await apiConsumer.get<AddressResponseModel>(
      EndPoint.addresses,
      fromJson: (json) => AddressResponseModel.fromJson(json),
    );
  }

  @override
  Future<Either<String, AvailabilityResponseModel>> getAvailabilities(
    String addressId,
  ) async {
    return await apiConsumer.get<AvailabilityResponseModel>(
      EndPoint.collectionAvailabilities(addressId),
      fromJson: (json) => AvailabilityResponseModel.fromJson(json),
    );
  }

  @override
  Future<Either<String, CollectionRequestResponseModel>>
  createCollectionRequest(CollectionRequestModel request) async {
    return await apiConsumer.post(
      EndPoint.collectionRequests,
      data: request.toJson(),
      fromJson: (json) => CollectionRequestResponseModel.fromJson(json),
    );
  }
}
