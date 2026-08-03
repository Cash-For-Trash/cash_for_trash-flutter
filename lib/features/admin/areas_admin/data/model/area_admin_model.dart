import 'package:equatable/equatable.dart';

class AreaAdminModel extends Equatable {
  final String id;
  final String name;
  final double northLat;
  final double southLat;
  final double eastLng;
  final double westLng;
  final double servicePrice;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  const AreaAdminModel({
    required this.id,
    required this.name,
    required this.northLat,
    required this.southLat,
    required this.eastLng,
    required this.westLng,
    required this.servicePrice,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  factory AreaAdminModel.fromJson(Map<String, dynamic> json) {
    return AreaAdminModel(
      id: (json['area_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      northLat: _toDouble(json['north_lat']),
      southLat: _toDouble(json['south_lat']),
      eastLng: _toDouble(json['east_lng']),
      westLng: _toDouble(json['west_lng']),
      servicePrice: _toDouble(json['service_price']),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'area_id': id,
        'name': name,
        'north_lat': northLat,
        'south_lat': southLat,
        'east_lng': eastLng,
        'west_lng': westLng,
        'service_price': servicePrice,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        northLat,
        southLat,
        eastLng,
        westLng,
        servicePrice,
        isActive,
        createdAt,
        updatedAt,
      ];
}
