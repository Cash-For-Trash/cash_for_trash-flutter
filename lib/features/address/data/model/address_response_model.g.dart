// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressResponseModel _$AddressResponseModelFromJson(
  Map<String, dynamic> json,
) => AddressResponseModel(
  success: json['success'] as bool,
  statusCode: (json['statusCode'] as num).toInt(),
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AddressResponseModelToJson(
  AddressResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'statusCode': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};
