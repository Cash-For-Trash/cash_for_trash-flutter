// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_resend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpResendDataModel _$OtpResendDataModelFromJson(Map<String, dynamic> json) =>
    OtpResendDataModel(email: json['email'] as String);

Map<String, dynamic> _$OtpResendDataModelToJson(OtpResendDataModel instance) =>
    <String, dynamic>{'email': instance.email};

OtpResendModel _$OtpResendModelFromJson(Map<String, dynamic> json) =>
    OtpResendModel(
      success: json['success'] as bool,
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
      data: OtpResendDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OtpResendModelToJson(OtpResendModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };
