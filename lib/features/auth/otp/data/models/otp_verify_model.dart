import 'package:cash_for_trash/features/auth/register/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_verify_model.g.dart';

@JsonSerializable()
class OtpVerifyDataModel {
  final UserModel user;

  OtpVerifyDataModel({required this.user});

  factory OtpVerifyDataModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerifyDataModelToJson(this);
}

@JsonSerializable()
class OtpVerifyModel {
  final bool success;
  final int statusCode;
  final String message;
  final OtpVerifyDataModel data;

  OtpVerifyModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OtpVerifyModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerifyModelToJson(this);
}
