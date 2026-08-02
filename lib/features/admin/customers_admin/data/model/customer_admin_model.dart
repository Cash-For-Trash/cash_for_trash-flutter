import 'package:equatable/equatable.dart';

/// Customer list item (GET /api/admin/customers) and detail (GET /api/admin/customers/{user_id})
class CustomerAdminModel extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? image;
  final bool? isVerified;
  final bool? isActive;
  final int? points;
  final String? createdAt;

  const CustomerAdminModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.isVerified,
    this.isActive,
    this.points,
    this.createdAt,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory CustomerAdminModel.fromJson(Map<String, dynamic> json) {
    return CustomerAdminModel(
      id: (json['id'] ?? json['user_id'] ?? json['customer_id'] ?? '').toString(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      isVerified: json['is_verified'] as bool?,
      isActive: json['is_active'] as bool?,
      points: (json['points'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'image': image,
        'is_verified': isVerified,
        'is_active': isActive,
        'points': points,
        'created_at': createdAt,
      };

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        image,
        isVerified,
        isActive,
        points,
        createdAt,
      ];
}
