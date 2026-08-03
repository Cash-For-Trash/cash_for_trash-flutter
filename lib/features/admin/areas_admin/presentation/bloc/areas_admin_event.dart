import 'package:equatable/equatable.dart';

abstract class AreasAdminEvent extends Equatable {
  const AreasAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetAreasAdminEvent extends AreasAdminEvent {
  const GetAreasAdminEvent();
}

class CreateAreaAdminEvent extends AreasAdminEvent {
  final Map<String, dynamic> data;

  const CreateAreaAdminEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateAreaAdminEvent extends AreasAdminEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateAreaAdminEvent({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

class DeleteAreaAdminEvent extends AreasAdminEvent {
  final String id;

  const DeleteAreaAdminEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateAreaPriceAdminEvent extends AreasAdminEvent {
  final String id;
  final double price;

  const UpdateAreaPriceAdminEvent({required this.id, required this.price});

  @override
  List<Object?> get props => [id, price];
}
