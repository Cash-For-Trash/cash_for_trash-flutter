import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String paymentId;
  final String paymentMethod;
  final String paymentStatus;
  final String paymentAmount;
  final String paymobIntentionId;
  final String clientSecret;
  final String checkoutUrl;

  const PaymentModel({
    required this.paymentId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentAmount,
    required this.paymobIntentionId,
    required this.clientSecret,
    required this.checkoutUrl,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['payment_id']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      paymentAmount: json['payment_amount']?.toString() ?? '0',
      paymobIntentionId: json['paymob_intention_id']?.toString() ?? '',
      clientSecret: json['client_secret']?.toString() ?? '',
      checkoutUrl: json['checkout_url']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
    paymentId,
    paymobIntentionId,
    clientSecret,
    checkoutUrl,
    paymentMethod,
    paymentStatus,
    paymentAmount,
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
      collectionRequestId: json['collection_request_id']?.toString() ?? '',
      requestDate: json['request_date']?.toString() ?? '',
      servicePrice: json['service_price']?.toString() ?? '0',
      status: json['status']?.toString() ?? '',
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
      success: json['success'] as bool? ?? true,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [success, statusCode, message, data];
}
