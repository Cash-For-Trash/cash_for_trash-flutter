import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

abstract class RewardsAdminEvent extends Equatable {
  const RewardsAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetRewardsAdminEvent extends RewardsAdminEvent {
  const GetRewardsAdminEvent();
}

class CreateRewardAdminEvent extends RewardsAdminEvent {
  final FormData formData;

  const CreateRewardAdminEvent(this.formData);

  @override
  List<Object?> get props => [formData];
}

class UpdateRewardAdminEvent extends RewardsAdminEvent {
  final String id;
  final FormData formData;

  const UpdateRewardAdminEvent({required this.id, required this.formData});

  @override
  List<Object?> get props => [id, formData];
}

class DeleteRewardAdminEvent extends RewardsAdminEvent {
  final String id;

  const DeleteRewardAdminEvent(this.id);

  @override
  List<Object?> get props => [id];
}
