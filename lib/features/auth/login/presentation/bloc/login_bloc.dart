import 'package:bloc/bloc.dart';
import 'package:cash_for_trash/features/auth/login/data/models/login_model.dart';
import 'package:cash_for_trash/features/auth/login/domain/repositories/login_repository.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      final result = await loginRepository.login(event.email, event.password);
      
      result.fold(
        (error) => emit(LoginFailure(error: error)),
        (loginModel) => emit(LoginSuccess(loginModel: loginModel)),
      );
    });
  }
}
