import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response_model.g.dart';

@JsonSerializable()
class RefreshTokenResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final RefreshTokenDataModel data;

  RefreshTokenResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseModelToJson(this);
}

@JsonSerializable()
class RefreshTokenDataModel {
  final String accessToken;
  final String refreshToken;

  RefreshTokenDataModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenDataModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenDataModelToJson(this);
}
