import 'package:equatable/equatable.dart';

class CollectionRequestResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final CollectionRequestDataModel data;

  const CollectionRequestResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CollectionRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return CollectionRequestResponseModel(
      success: json['success'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: CollectionRequestDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }

  @override
  List<Object?> get props => [success, statusCode, message, data];
}

class CollectionRequestDataModel extends Equatable {
  final String collectionRequestId;
  final String userId;
  final String addressId;
  final String requestDate;
  final double quantity;
  final String? collectionImg;
  final String status;
  final String paymentMethod;
  final String scheduledDay;
  final String scheduledFromTime;
  final String scheduledToTime;
  final double servicePrice;
  final double workerShare;
  final String availabilityId;

  const CollectionRequestDataModel({
    required this.collectionRequestId,
    required this.userId,
    required this.addressId,
    required this.requestDate,
    required this.quantity,
    this.collectionImg,
    required this.status,
    required this.paymentMethod,
    required this.scheduledDay,
    required this.scheduledFromTime,
    required this.scheduledToTime,
    required this.servicePrice,
    required this.workerShare,
    required this.availabilityId,
  });

  factory CollectionRequestDataModel.fromJson(Map<String, dynamic> json) {
    return CollectionRequestDataModel(
      collectionRequestId: json['collection_request_id'] as String,
      userId: json['user_id'] as String,
      addressId: json['address_id'] as String,
      requestDate: json['request_date'] as String,
      quantity: double.tryParse(json['quantity']?.toString() ?? '0') ?? 0.0,
      collectionImg: json['collection_img'] as String?,
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      scheduledDay: json['scheduled_day'] as String,
      scheduledFromTime: json['scheduled_from_time'] as String,
      scheduledToTime: json['scheduled_to_time'] as String,
      servicePrice:
          double.tryParse(json['service_price']?.toString() ?? '0') ?? 0.0,
      workerShare:
          double.tryParse(json['worker_share']?.toString() ?? '0') ?? 0.0,
      availabilityId: json['availability_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collection_request_id': collectionRequestId,
      'user_id': userId,
      'address_id': addressId,
      'request_date': requestDate,
      'quantity': quantity.toString(),
      'collection_img': collectionImg,
      'status': status,
      'payment_method': paymentMethod,
      'scheduled_day': scheduledDay,
      'scheduled_from_time': scheduledFromTime,
      'scheduled_to_time': scheduledToTime,
      'service_price': servicePrice.toString(),
      'worker_share': workerShare.toString(),
      'availability_id': availabilityId,
    };
  }

  @override
  List<Object?> get props => [
    collectionRequestId,
    userId,
    addressId,
    requestDate,
    quantity,
    collectionImg,
    status,
    paymentMethod,
    scheduledDay,
    scheduledFromTime,
    scheduledToTime,
    servicePrice,
    workerShare,
    availabilityId,
  ];
}
