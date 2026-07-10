part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeDataModel data;
  const HomeLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class HomeStateError extends HomeState {
  final String message;
  const HomeStateError({required this.message});

  @override
  List<Object?> get props => [message];
}