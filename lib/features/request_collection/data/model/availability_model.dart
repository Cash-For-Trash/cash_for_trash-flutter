import 'package:equatable/equatable.dart';

import 'package:cash_for_trash/core/helpers/time_format_helper.dart';

class AvailabilityItemModel extends Equatable {
  final String availabilityId;
  final String day;
  final String from;
  final String to;
  final double servicePrice;

  const AvailabilityItemModel({
    required this.availabilityId,
    required this.day,
    required this.from,
    required this.to,
    required this.servicePrice
  });

  String get id => availabilityId;

  factory AvailabilityItemModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityItemModel(
      availabilityId: (json['availability_id'] ?? json['id'] ?? '').toString(),
      day: (json['day'] ?? '').toString(),
      from: (json['from'] ?? '').toString(),
      to: (json['to'] ?? '').toString(),
      servicePrice: (json['service_price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availability_id': availabilityId,
      'day': day,
      'from': from,
      'to': to,
      'service_price': servicePrice,
    };
  }

  String getDisplayLabel(bool isArabic) {
    return TimeFormatHelper.formatAvailabilityDisplayLabel(
      day: day,
      from: from,
      to: to,
      isArabic: isArabic,
    );
  }

  @override
  List<Object?> get props => [availabilityId, day, from, to];
}

class AvailabilityResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final List<AvailabilityItemModel> data;

  const AvailabilityResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AvailabilityResponseModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) =>
                    AvailabilityItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [success, statusCode, message, data];
}
