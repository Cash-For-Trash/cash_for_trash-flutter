// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_token_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyTokenResponseModel _$VerifyTokenResponseModelFromJson(
  Map<String, dynamic> json,
) => VerifyTokenResponseModel(
  success: json['success'] as bool,
  statusCode: (json['statusCode'] as num).toInt(),
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : VerifyTokenDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VerifyTokenResponseModelToJson(
  VerifyTokenResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

VerifyTokenDataModel _$VerifyTokenDataModelFromJson(
  Map<String, dynamic> json,
) => VerifyTokenDataModel(
  valid: json['valid'] as bool,
  userId: json['user_id'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$VerifyTokenDataModelToJson(
  VerifyTokenDataModel instance,
) => <String, dynamic>{
  'valid': instance.valid,
  'user_id': instance.userId,
  'role': instance.role,
};
