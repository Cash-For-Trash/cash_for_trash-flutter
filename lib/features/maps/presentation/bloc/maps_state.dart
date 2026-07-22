part of 'maps_bloc.dart';

abstract class MapsState {}

class MapsInitial extends MapsState {}

class MapsStateError extends MapsState {
  final String message;
  MapsStateError({required this.message});
}