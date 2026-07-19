// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpVerifyDataModel _$OtpVerifyDataModelFromJson(Map<String, dynamic> json) =>
    OtpVerifyDataModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OtpVerifyDataModelToJson(OtpVerifyDataModel instance) =>
    <String, dynamic>{'user': instance.user};

OtpVerifyModel _$OtpVerifyModelFromJson(Map<String, dynamic> json) =>
    OtpVerifyModel(
      success: json['success'] as bool,
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
      data: OtpVerifyDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OtpVerifyModelToJson(OtpVerifyModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };
