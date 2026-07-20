import 'package:cash_for_trash/features/auth/register/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_model.g.dart';

@JsonSerializable()
class RegisterDataModel {
  final UserModel user;
  final bool emailSent;

  RegisterDataModel({
    required this.user,
    required this.emailSent,
  });

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataModelToJson(this);
}

@JsonSerializable()
class RegisterModel {
  final bool success;
  final int statusCode;
  final String message;
  final RegisterDataModel data;

  RegisterModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
}
