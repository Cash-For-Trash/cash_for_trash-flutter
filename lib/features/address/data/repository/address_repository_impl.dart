import 'package:dartz/dartz.dart';
import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/address/data/model/address_model.dart';
import 'package:cash_for_trash/features/address/data/model/address_response_model.dart';
import 'package:cash_for_trash/features/address/domain/repository/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final ApiConsumer apiConsumer;

  AddressRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<AddressModel>>> getAddresses() async {
    return await apiConsumer.get<List<AddressModel>>(
      EndPoint.addresses,
      fromJson: (json) => AddressResponseModel.fromJson(json).data,
    );
  }

  @override
  Future<Either<String, void>> deleteAddress(String addressId) async {
    return await apiConsumer.delete<void>(
      '${EndPoint.addresses}/$addressId',
      fromJson: (_) {},
    );
  }
}