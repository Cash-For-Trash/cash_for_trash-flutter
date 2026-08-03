import 'package:equatable/equatable.dart';

abstract class WorkersAdminEvent extends Equatable {
  const WorkersAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetWorkersAdminEvent extends WorkersAdminEvent {
  final int page;
  final int pageSize;

  const GetWorkersAdminEvent({
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [page, pageSize];
}

class GetWorkerDetailAdminEvent extends WorkersAdminEvent {
  final String userId;

  const GetWorkerDetailAdminEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ApproveWorkerAdminEvent extends WorkersAdminEvent {
  final String workerId;

  const ApproveWorkerAdminEvent(this.workerId);

  @override
  List<Object?> get props => [workerId];
}
