// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
  addressId: json['address_id'] as String,
  buildingNum: (json['building_num'] as num).toInt(),
  floor: json['floor'] as String,
  location: json['location'] as String,
  latitude: json['latitude'] as String,
  longitude: json['longitude'] as String,
  additionalNote: json['additional_note'] as String,
  userId: json['user_id'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'address_id': instance.addressId,
      'building_num': instance.buildingNum,
      'floor': instance.floor,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'additional_note': instance.additionalNote,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
