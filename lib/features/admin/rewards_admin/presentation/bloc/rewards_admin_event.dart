import 'package:equatable/equatable.dart';

abstract class RewardsAdminEvent extends Equatable {
  const RewardsAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetRewardsAdminEvent extends RewardsAdminEvent {
  const GetRewardsAdminEvent();
}

class CreateRewardAdminEvent extends RewardsAdminEvent {
  final Map<String, dynamic> fields;
  final String imagePath;

  const CreateRewardAdminEvent({
    required this.fields,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [fields, imagePath];
}

class UpdateRewardAdminEvent extends RewardsAdminEvent {
  final String id;
  final Map<String, dynamic> fields;
  final String? imagePath;

  const UpdateRewardAdminEvent({
    required this.id,
    required this.fields,
    this.imagePath,
  });

  @override
  List<Object?> get props => [id, fields, imagePath];
}

class DeleteRewardAdminEvent extends RewardsAdminEvent {
  final String id;

  const DeleteRewardAdminEvent(this.id);

  @override
  List<Object?> get props => [id];
}
