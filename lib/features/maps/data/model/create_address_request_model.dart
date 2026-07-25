import 'package:json_annotation/json_annotation.dart';

part 'create_address_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CreateAddressRequestModel {
  final String location;
  final String latitude;
  final String longitude;
  final int buildingNum;
  final String floor;
  final String additionalNote;

  const CreateAddressRequestModel({
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.buildingNum,
    required this.floor,
    required this.additionalNote,
  });

  factory CreateAddressRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateAddressRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAddressRequestModelToJson(this);
}
