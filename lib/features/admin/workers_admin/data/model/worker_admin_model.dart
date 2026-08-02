import 'package:equatable/equatable.dart';

/// Worker list item (GET /api/admin/workers) and detail (GET /api/admin/workers/{user_id})
class WorkerAdminModel extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? image;
  final bool? isVerified;
  final bool? isActive;
  // Detail-only fields
  final String? nationalId;
  final bool? isApproved;
  final String? areaId;
  final String? createdAt;

  const WorkerAdminModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.isVerified,
    this.isActive,
    this.nationalId,
    this.isApproved,
    this.areaId,
    this.createdAt,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory WorkerAdminModel.fromJson(Map<String, dynamic> json) {
    return WorkerAdminModel(
      id: (json['id'] ?? json['user_id'] ?? json['worker_id'] ?? '').toString(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      isVerified: json['is_verified'] as bool?,
      isActive: json['is_active'] as bool?,
      nationalId: json['national_id'] as String?,
      isApproved: json['is_approved'] as bool?,
      areaId: json['area_id'] as String?,
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
        'national_id': nationalId,
        'is_approved': isApproved,
        'area_id': areaId,
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
        nationalId,
        isApproved,
        areaId,
        createdAt,
      ];
}
