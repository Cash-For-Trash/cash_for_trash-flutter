import 'package:json_annotation/json_annotation.dart';

part 'otp_resend_model.g.dart';

@JsonSerializable()
class OtpResendDataModel {
  final String email;

  OtpResendDataModel({required this.email});

  factory OtpResendDataModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResendDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpResendDataModelToJson(this);
}

@JsonSerializable()
class OtpResendModel {
  final bool success;
  final int statusCode;
  final String message;
  final OtpResendDataModel data;

  OtpResendModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OtpResendModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResendModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpResendModelToJson(this);
}
