import 'package:cash_for_trash/features/address/data/model/address_model.dart';

class CustomerCollectionRequestResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final int page;
  final int pageSize;
  final int totalItems;
  final int total;
  final List<CustomerCollectionRequestModel?> customerCollectionRequests;

  const CustomerCollectionRequestResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.total,
    required this.customerCollectionRequests,
  });

  factory CustomerCollectionRequestResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerCollectionRequestResponseModel(
      success: json['success'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      totalItems: json['total_items'] as int,
      total: json['total'] as int,
      customerCollectionRequests: (json['data'] as List)
          .map(
            (e) => CustomerCollectionRequestModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class CustomerCollectionRequestModel {
  final String collectionRequestId;
  final String? userId;
  final String? addressId;
  final String requestDate;
  final String? quantity;
  final String? collectionImg;
  final String status;
  final String? paymentMethod;
  final String scheduledDay;
  final String scheduledFromTime;
  final String scheduledToTime;
  final String? servicePrice;
  final String? availabilityId;
  final AddressModel? addressModel;

  const CustomerCollectionRequestModel({
    required this.collectionRequestId,
    this.userId,
    this.addressId,
    required this.requestDate,
    this.quantity,
    this.collectionImg,
    required this.status,
    this.paymentMethod,
    required this.scheduledDay,
    required this.scheduledFromTime,
    required this.scheduledToTime,
    this.servicePrice,
    this.availabilityId,
    this.addressModel,
  });

  factory CustomerCollectionRequestModel.fromJson(Map<String, dynamic> json) {
    return CustomerCollectionRequestModel(
      collectionRequestId: json['collection_request_id'] as String,
      userId: json['user_id'] as String?,
      addressId: json['address_id'] as String?,
      requestDate: json['request_date'] as String,
      quantity: json['quantity']?.toString(),
      collectionImg: json['collection_img'] as String?,
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String?,
      scheduledDay: json['scheduled_day'] as String,
      scheduledFromTime: json['scheduled_from_time'] as String,
      scheduledToTime: json['scheduled_to_time'] as String,
      servicePrice: json['service_price']?.toString(),
      availabilityId: json['availability_id'] as String?,
      addressModel: json['address_model'] != null
          ? AddressModel.fromJson(json['address_model'] as Map<String, dynamic>)
          : null,
    );
  }
}

class HeaderDataModel {
  final String userName;
  final String points;

  HeaderDataModel({
    required this.userName,
    required this.points,
  });


  String get level {
    final pointsValue = double.tryParse(points) ?? 0;

    if (pointsValue < 1000) {
      return "bronze_level";
    } else if (pointsValue < 10000) {
      return "silver_level";
    } else if (pointsValue < 50000) {
      return "gold_level";
    } else {
      return "platinum_level";
    }
  }

  int get nextLevelPoints {
    final pointsValue = double.tryParse(points) ?? 0;

    if (pointsValue < 1000) {
      return 1000;
    } else if (pointsValue < 10000) {
      return 10000;
    } else if (pointsValue < 50000) {
      return 50000;
    } else {
      return 500000;
    }
  }

  double get levelProgress {
    final pointsValue = double.tryParse(points) ?? 0;

    if (pointsValue < 1000) {
      return 1000 / pointsValue;
    } else if (pointsValue < 10000) {
      return 10000 / pointsValue;
    } else if (pointsValue < 50000) {
      return 50000 / pointsValue;
    } else {
      return 1.0;
    }
  }

}
