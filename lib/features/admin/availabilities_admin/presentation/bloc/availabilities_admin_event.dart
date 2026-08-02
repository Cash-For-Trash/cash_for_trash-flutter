import 'package:equatable/equatable.dart';

abstract class AvailabilitiesAdminEvent extends Equatable {
  const AvailabilitiesAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetAvailabilitiesAdminEvent extends AvailabilitiesAdminEvent {
  const GetAvailabilitiesAdminEvent();
}

class CreateAvailabilityAdminEvent extends AvailabilitiesAdminEvent {
  final Map<String, dynamic> data;

  const CreateAvailabilityAdminEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteAvailabilityAdminEvent extends AvailabilitiesAdminEvent {
  final String id;

  const DeleteAvailabilityAdminEvent(this.id);

  @override
  List<Object?> get props => [id];
}
