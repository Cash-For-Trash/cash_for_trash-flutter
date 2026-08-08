import 'package:equatable/equatable.dart';

/// Garbage type (GET /api/garbage-types, GET /api/garbage-types/{id})
class GarbageTypeAdminModel extends Equatable {
  final String id;
  final String name;
  final double pricePerKg;
  final String? image;

  const GarbageTypeAdminModel({
    required this.id,
    required this.name,
    required this.pricePerKg,
    this.image,
  });

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  factory GarbageTypeAdminModel.fromJson(Map<String, dynamic> json) {
    return GarbageTypeAdminModel(
      id: (json['garbage_type_id'] ?? json['id'] ?? '').toString(),
      name: (json['garbage_type_name'] ?? json['name'] ?? '').toString(),
      pricePerKg: _toDouble(json['price_per_kg']),
      image: json['garbage_type_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'garbage_type_id': id,
        'garbage_type_name': name,
        'price_per_kg': pricePerKg,
        'image': image,
      };

  @override
  List<Object?> get props => [id, name, pricePerKg, image];
}
