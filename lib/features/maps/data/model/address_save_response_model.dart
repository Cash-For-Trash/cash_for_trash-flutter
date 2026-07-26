import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cash_for_trash/features/address/data/model/address_model.dart';

part 'address_save_response_model.g.dart';

@JsonSerializable()
class AddressSaveResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final AddressModel data;

  const AddressSaveResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AddressSaveResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddressSaveResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressSaveResponseModelToJson(this);

  @override
  List<Object?> get props => [success, statusCode, message, data];
}
