// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDataModel _$RegisterDataModelFromJson(Map<String, dynamic> json) =>
    RegisterDataModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      emailSent: json['emailSent'] as bool,
    );

Map<String, dynamic> _$RegisterDataModelToJson(RegisterDataModel instance) =>
    <String, dynamic>{'user': instance.user, 'emailSent': instance.emailSent};

RegisterModel _$RegisterModelFromJson(Map<String, dynamic> json) =>
    RegisterModel(
      success: json['success'] as bool,
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
      data: RegisterDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterModelToJson(RegisterModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };
