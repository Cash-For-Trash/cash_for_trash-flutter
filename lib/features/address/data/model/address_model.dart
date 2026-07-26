import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddressModel extends Equatable {
  final String addressId;
  final int buildingNum;
  final String floor;
  final String location;
  final String latitude;
  final String longitude;
  final String additionalNote;
  final String userId;
  final String createdAt;
  final String updatedAt;

  const AddressModel({
    required this.addressId,
    required this.buildingNum,
    required this.floor,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.additionalNote,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  @override
  List<Object?> get props => [
        addressId,
        buildingNum,
        floor,
        location,
        latitude,
        longitude,
        additionalNote,
        userId,
        createdAt,
        updatedAt,
      ];
}