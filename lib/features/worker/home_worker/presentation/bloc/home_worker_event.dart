import 'package:equatable/equatable.dart';

abstract class HomeWorkerEvent extends Equatable {
  const HomeWorkerEvent();

  @override
  List<Object?> get props => [];
}

class GetHomeWorkerDataEvent extends HomeWorkerEvent {
  const GetHomeWorkerDataEvent();
}
