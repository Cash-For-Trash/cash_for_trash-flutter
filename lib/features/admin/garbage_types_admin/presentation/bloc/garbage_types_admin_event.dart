import 'package:equatable/equatable.dart';

abstract class GarbageTypesAdminEvent extends Equatable {
  const GarbageTypesAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetGarbageTypesAdminEvent extends GarbageTypesAdminEvent {
  const GetGarbageTypesAdminEvent();
}

class CreateGarbageTypeAdminEvent extends GarbageTypesAdminEvent {
  final Map<String, dynamic> fields;
  final String imagePath;

  const CreateGarbageTypeAdminEvent({
    required this.fields,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [fields, imagePath];
}

class UpdateGarbageTypeAdminEvent extends GarbageTypesAdminEvent {
  final String id;
  final Map<String, dynamic> fields;
  final String? imagePath;

  const UpdateGarbageTypeAdminEvent({
    required this.id,
    required this.fields,
    this.imagePath,
  });

  @override
  List<Object?> get props => [id, fields, imagePath];
}

class DeleteGarbageTypeAdminEvent extends GarbageTypesAdminEvent {
  final String id;

  const DeleteGarbageTypeAdminEvent(this.id);

  @override
  List<Object?> get props => [id];
}
