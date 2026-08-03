import 'package:cash_for_trash/features/admin/customers_admin/data/model/customer_admin_model.dart';
import 'package:dartz/dartz.dart';

abstract class CustomersAdminRepository {
  Future<Either<String, List<CustomerAdminModel>>> getCustomers({
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<String, CustomerAdminModel>> getCustomerDetail(String userId);
}
