import 'package:cash_for_trash/features/auth/register/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginDataModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  LoginDataModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) =>
      _$LoginDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataModelToJson(this);
}

@JsonSerializable()
class LoginModel {
  final bool success;
  final int statusCode;
  final String message;
  final LoginDataModel data;

  LoginModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
