// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class UserModel {
  final String? user_id;
  final String first_name;
  final String last_name;
  final String email;
  final String role;
  final bool? is_verified;

  UserModel({
    this.user_id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.role,
    this.is_verified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static const jsonSchema = _$UserModelJsonSchema;
}
