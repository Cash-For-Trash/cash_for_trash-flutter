import 'package:cash_for_trash/features/auth/register/data/models/register_model.dart';
import 'package:cash_for_trash/features/auth/register/domain/repositories/register_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;

  RegisterBloc({required this.registerRepository}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      final result = await registerRepository.register(
        event.firstName,
        event.lastName,
        event.phone,
        event.email,
        event.password,
        event.confirmPassword,
        event.role,
      );

      result.fold(
        (error) => emit(RegisterFailure(error: error)),
        (registerModel) => emit(RegisterSuccess(registerModel: registerModel)),
      );
    });
  }
}
