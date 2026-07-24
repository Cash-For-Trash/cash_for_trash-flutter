import 'package:equatable/equatable.dart';

class GarbageTypeItemModel extends Equatable {
  final String garbageTypeId;
  final String garbageTypeName;
  final String garbageTypeImage;
  final String pricePerKg;

  const GarbageTypeItemModel({
    required this.garbageTypeId,
    required this.garbageTypeName,
    required this.garbageTypeImage,
    required this.pricePerKg,
  });

  factory GarbageTypeItemModel.fromJson(Map<String, dynamic> json) {
    return GarbageTypeItemModel(
      garbageTypeId: json['garbage_type_id'] as String? ?? '',
      garbageTypeName: json['garbage_type_name'] as String? ?? '',
      garbageTypeImage: json['garbage_type_image'] as String? ?? '',
      pricePerKg: json['price_per_kg'] as String? ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'garbage_type_id': garbageTypeId,
      'garbage_type_name': garbageTypeName,
      'garbage_type_image': garbageTypeImage,
      'price_per_kg': pricePerKg,
    };
  }

  @override
  List<Object?> get props => [
        garbageTypeId,
        garbageTypeName,
        garbageTypeImage,
        pricePerKg,
      ];
}

class GarbageTypeResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final List<GarbageTypeItemModel> data;

  const GarbageTypeResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory GarbageTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return GarbageTypeResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => GarbageTypeItemModel.fromJson(e as Map<String, dynamic>))
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
