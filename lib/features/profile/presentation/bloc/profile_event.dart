import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileDataEvent extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}