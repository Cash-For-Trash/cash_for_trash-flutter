import 'package:equatable/equatable.dart';
import '../../data/model/create_worker_request_model.dart';

abstract class SupervisorEvent extends Equatable {
  const SupervisorEvent();

  @override
  List<Object?> get props => [];
}

class GetSupervisorWorkersEvent extends SupervisorEvent {
  const GetSupervisorWorkersEvent();
}

class FetchMoreSupervisorWorkersEvent extends SupervisorEvent {
  const FetchMoreSupervisorWorkersEvent();
}

class SearchSupervisorWorkersEvent extends SupervisorEvent {
  final String query;
  const SearchSupervisorWorkersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class CreateSupervisorWorkerEvent extends SupervisorEvent {
  final CreateWorkerRequestModel request;
  const CreateSupervisorWorkerEvent(this.request);

  @override
  List<Object?> get props => [request];
}
