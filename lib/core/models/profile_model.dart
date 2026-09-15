import 'package:equatable/equatable.dart';

class ProfileResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final ProfileModel data;

  const ProfileResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: ProfileModel.fromJson(json['data'] ?? {}),
    );
  }
}

class ProfileModel extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String mobile;
  final String? image;
  final String points;

  const ProfileModel(
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.mobile,
    this.image,
    this.points,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      json['user_id'] ?? '',
      json['first_name'] ?? 'Customer',
      json['last_name'] ?? '',
      json['email'] ?? '',
      json['role'] ?? '',
      json['mobile'] ?? '',
      json['image'],
      json['points'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    email,
    role,
    mobile,
    image,
    points,
  ];
}
