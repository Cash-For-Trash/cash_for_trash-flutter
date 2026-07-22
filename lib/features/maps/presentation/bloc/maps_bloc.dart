import 'package:flutter_bloc/flutter_bloc.dart';

part 'maps_event.dart';
part 'maps_state.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  MapsBloc() : super(MapsInitial()) {
    on<MapsEvent>(_onEvent);
  }

  void _onEvent(MapsEvent event, Emitter<MapsState> emit) {
    emit(MapsInitial());
  }
}