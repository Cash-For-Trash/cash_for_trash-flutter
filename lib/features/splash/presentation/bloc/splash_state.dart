import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitialState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashAuthenticatedState extends SplashState {
  final String role;

  const SplashAuthenticatedState({required this.role});

  @override
  List<Object?> get props => [role];
}

class SplashUnauthenticatedState extends SplashState {}

class SplashErrorState extends SplashState {
  final String errorMessage;

  const SplashErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
