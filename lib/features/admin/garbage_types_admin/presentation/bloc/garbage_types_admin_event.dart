import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

abstract class GarbageTypesAdminEvent extends Equatable {
  const GarbageTypesAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetGarbageTypesAdminEvent extends GarbageTypesAdminEvent {
  const GetGarbageTypesAdminEvent();
}

class CreateGarbageTypeAdminEvent extends GarbageTypesAdminEvent {
  final FormData formData;

  const CreateGarbageTypeAdminEvent(this.formData);

  @override
  List<Object?> get props => [formData];
}

class UpdateGarbageTypeAdminEvent extends GarbageTypesAdminEvent {
  final String id;
  final FormData formData;

  const UpdateGarbageTypeAdminEvent({required this.id, required this.formData});

  @override
  List<Object?> get props => [id, formData];
}

class DeleteGarbageTypeAdminEvent extends GarbageTypesAdminEvent {
  final String id;

  const DeleteGarbageTypeAdminEvent(this.id);

  @override
  List<Object?> get props => [id];
}
