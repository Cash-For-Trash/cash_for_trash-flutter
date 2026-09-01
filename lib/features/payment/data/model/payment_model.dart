import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String paymentId;
  final String collectionRequestId;
  final String paymentMethod;
  final String paymentStatus;
  final String paymentDate;
  final String paymentAmount;
  final PaymentCollectionRequestModel? collectionRequest;

  const PaymentModel({
    required this.paymentId,
    required this.collectionRequestId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentDate,
    required this.paymentAmount,
    this.collectionRequest,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['payment_id'] as String,
      collectionRequestId: json['collection_request_id'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentDate: json['payment_date'] as String,
      paymentAmount: json['payment_amount']?.toString() ?? '0',
      collectionRequest: json['collectionRequest'] != null
          ? PaymentCollectionRequestModel.fromJson(
              json['collectionRequest'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    paymentId,
    collectionRequestId,
    paymentMethod,
    paymentStatus,
    paymentDate,
    paymentAmount,
    collectionRequest,
  ];
}

class PaymentCollectionRequestModel extends Equatable {
  final String collectionRequestId;
  final String requestDate;
  final String servicePrice;
  final String status;

  const PaymentCollectionRequestModel({
    required this.collectionRequestId,
    required this.requestDate,
    required this.servicePrice,
    required this.status,
  });

  factory PaymentCollectionRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentCollectionRequestModel(
      collectionRequestId: json['collection_request_id'] as String,
      requestDate: json['request_date'] as String,
      servicePrice: json['service_price']?.toString() ?? '0',
      status: json['status'] as String,
    );
  }

  @override
  List<Object?> get props => [
    collectionRequestId,
    requestDate,
    servicePrice,
    status,
  ];
}

class PaymentHistoryResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final List<PaymentModel> data;

  const PaymentHistoryResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PaymentHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryResponseModel(
      success: json['success'] as bool,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [success, statusCode, message, data];
}
