import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'address_model.dart';

part 'address_response_model.g.dart';

@JsonSerializable()
class AddressResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final List<AddressModel> data;

  const AddressResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressResponseModelToJson(this);

  @override
  List<Object?> get props => [success, statusCode, message, data];
}
