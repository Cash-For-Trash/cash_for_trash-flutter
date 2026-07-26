// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_address_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAddressRequestModel _$CreateAddressRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateAddressRequestModel(
  location: json['location'] as String,
  latitude: json['latitude'] as String,
  longitude: json['longitude'] as String,
  buildingNum: (json['building_num'] as num).toInt(),
  floor: json['floor'] as String,
  additionalNote: json['additional_note'] as String,
);

Map<String, dynamic> _$CreateAddressRequestModelToJson(
  CreateAddressRequestModel instance,
) => <String, dynamic>{
  'location': instance.location,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'building_num': instance.buildingNum,
  'floor': instance.floor,
  'additional_note': instance.additionalNote,
};
