import 'package:equatable/equatable.dart';

class WorkerSupervisorModel extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String? image;
  final String role;
  final bool isVerified;
  final bool isActive;
  final String? nationalId;
  final bool isApproved;
  final String? approvedAt;
  final String? createdAt;
  final String? updatedAt;

  const WorkerSupervisorModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    this.image,
    required this.role,
    required this.isVerified,
    required this.isActive,
    this.nationalId,
    required this.isApproved,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory WorkerSupervisorModel.fromJson(Map<String, dynamic> json) {
    return WorkerSupervisorModel(
      userId: json['user_id'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      image: json['image'] as String?,
      role: json['role'] as String? ?? 'worker',
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? false,
      nationalId: json['national_id'] as String?,
      isApproved: json['is_approved'] as bool? ?? false,
      approvedAt: json['approved_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'image': image,
      'role': role,
      'is_verified': isVerified,
      'is_active': isActive,
      'national_id': nationalId,
      'is_approved': isApproved,
      'approved_at': approvedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        email,
        mobile,
        image,
        role,
        isVerified,
        isActive,
        nationalId,
        isApproved,
        approvedAt,
        createdAt,
        updatedAt,
      ];
}

class SupervisorWorkersResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final String message;
  final int page;
  final int pageSize;
  final int totalItems;
  final int total;
  final List<WorkerSupervisorModel> data;

  const SupervisorWorkersResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.total,
    required this.data,
  });

  factory SupervisorWorkersResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<WorkerSupervisorModel> workersList = [];
    if (rawData is List) {
      workersList = rawData
          .map((item) => WorkerSupervisorModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return SupervisorWorkersResponseModel(
      success: json['success'] as bool? ?? true,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 10,
      totalItems: json['total_items'] as int? ?? workersList.length,
      total: json['total'] as int? ?? 1,
      data: workersList,
    );
  }

  @override
  List<Object?> get props => [
        success,
        statusCode,
        message,
        page,
        pageSize,
        totalItems,
        total,
        data,
      ];
}
