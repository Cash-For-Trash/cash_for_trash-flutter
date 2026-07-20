import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/splash/domain/repositories/splash_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SplashRepository repository;

  SplashBloc({required this.repository}) : super(SplashInitialState()) {
    on<CheckTokenEvent>(_onCheckToken);
  }

  Future<void> _onCheckToken(
    CheckTokenEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoadingState());

    final token = await CacheHelper.getSecretData(key: ApiKey.accessToken);
    if (token == null || token.isEmpty) {
      emit(SplashUnauthenticatedState());
      return;
    }

    final result = await repository.checkToken();

    result.fold(
      (errorString) {
        final lowercaseError = errorString.toLowerCase();
        if (lowercaseError.contains('unauthorized') ||
            lowercaseError.contains('forbidden') ||
            lowercaseError.contains('invalid') ||
            lowercaseError.contains('not found')) {
          emit(SplashUnauthenticatedState());
        } else {
          emit(SplashErrorState(errorMessage: errorString));
        }
      },
      (response) {
        if (response.data != null && response.data!.valid) {
          emit(SplashAuthenticatedState(role: response.data!.role));
        } else {
          emit(SplashUnauthenticatedState());
        }
      },
    );
  }
}
