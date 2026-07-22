part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  const RegisterButtonPressed({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phone,
        email,
        password,
        confirmPassword,
        role,
      ];
}
