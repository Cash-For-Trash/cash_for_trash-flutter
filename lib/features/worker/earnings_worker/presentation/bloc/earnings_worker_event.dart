import 'package:equatable/equatable.dart';

abstract class EarningsWorkerEvent extends Equatable {
  const EarningsWorkerEvent();

  @override
  List<Object?> get props => [];
}

class GetWorkerEarningsEvent extends EarningsWorkerEvent {
  const GetWorkerEarningsEvent();
}
