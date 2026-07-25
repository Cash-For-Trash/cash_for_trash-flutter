// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_save_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressSaveResponseModel _$AddressSaveResponseModelFromJson(
  Map<String, dynamic> json,
) => AddressSaveResponseModel(
  success: json['success'] as bool,
  statusCode: (json['statusCode'] as num).toInt(),
  message: json['message'] as String,
  data: AddressModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AddressSaveResponseModelToJson(
  AddressSaveResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};
