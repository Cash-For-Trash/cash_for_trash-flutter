import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repository/customers_admin_repository.dart';
import '../model/customer_admin_model.dart';

class CustomersAdminRepositoryImpl implements CustomersAdminRepository {
  final ApiConsumer apiConsumer;

  CustomersAdminRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, List<CustomerAdminModel>>> getCustomers({
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await apiConsumer.get<Map<String, dynamic>>(
      EndPoint.adminCustomers,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    return result.fold((error) => Left(error), (json) {
      List rawList = [];
      if (json['data'] is Map && (json['data'] as Map)['data'] is List) {
        rawList = (json['data'] as Map)['data'] as List;
      } else if (json['data'] is List) {
        rawList = json['data'] as List;
      } else if (json['customers'] is List) {
        rawList = json['customers'] as List;
      }

      final list = rawList
          .map(
            (item) => CustomerAdminModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<String, CustomerAdminModel>> getCustomerDetail(
    String userId,
  ) async {
    return await apiConsumer.get<CustomerAdminModel>(
      '${EndPoint.adminCustomers}/$userId',
      fromJson: (json) {
        final dataObj = json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;
        return CustomerAdminModel.fromJson(dataObj);
      },
    );
  }
}
