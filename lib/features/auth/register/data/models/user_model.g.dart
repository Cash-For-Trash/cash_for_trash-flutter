// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  user_id: json['user_id'] as String?,
  first_name: json['first_name'] as String,
  last_name: json['last_name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  is_verified: json['is_verified'] as bool?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'user_id': instance.user_id,
  'first_name': instance.first_name,
  'last_name': instance.last_name,
  'email': instance.email,
  'role': instance.role,
  'is_verified': instance.is_verified,
};

const _$UserModelJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'user_id': {'type': 'string'},
    'first_name': {'type': 'string'},
    'last_name': {'type': 'string'},
    'email': {'type': 'string'},
    'role': {'type': 'string'},
    'is_verified': {'type': 'boolean'},
  },
  'required': ['first_name', 'last_name', 'email', 'role'],
};
