import 'package:equatable/equatable.dart';

class AddressItemModel extends Equatable {
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

  const AddressItemModel({
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

  factory AddressItemModel.fromJson(Map<String, dynamic> json) {
    return AddressItemModel(
      addressId: json['address_id'] as String? ?? '',
      buildingNum: (json['building_num'] as num?)?.toInt() ?? 0,
      floor: json['floor'] as String? ?? '',
      location: json['location'] as String? ?? '',
      latitude: json['latitude'] as String? ?? '',
      longitude: json['longitude'] as String? ?? '',
      additionalNote: json['additional_note'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'building_num': buildingNum,
      'floor': floor,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'additional_note': additionalNote,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

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

class AddressResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final List<AddressItemModel> data;

  const AddressResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) {
    return AddressResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => AddressItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [success, statusCode, message, data];
}
