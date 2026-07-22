import 'package:json_annotation/json_annotation.dart';

part 'verify_token_response_model.g.dart';

@JsonSerializable()
class VerifyTokenResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final VerifyTokenDataModel? data;

  VerifyTokenResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory VerifyTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyTokenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyTokenResponseModelToJson(this);
}

@JsonSerializable()
class VerifyTokenDataModel {
  final bool valid;
  @JsonKey(name: 'user_id')
  final String userId;
  final String role;

  VerifyTokenDataModel({
    required this.valid,
    required this.userId,
    required this.role,
  });

  factory VerifyTokenDataModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyTokenDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyTokenDataModelToJson(this);
}
