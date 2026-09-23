import 'package:equatable/equatable.dart';

class CreateWorkerRequestModel extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String mobile;
  final String nationalId;

  const CreateWorkerRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.mobile,
    required this.nationalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'mobile': mobile,
      'national_id': nationalId,
    };
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        password,
        mobile,
        nationalId,
      ];
}
