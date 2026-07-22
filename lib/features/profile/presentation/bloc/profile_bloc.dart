import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitialState()) {
    on<GetProfileDataEvent>(_onGetProfileData);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onGetProfileData(
    GetProfileDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final firstName = CacheHelper.getData(key: ApiKey.firstName) as String? ?? '';
    final lastName = CacheHelper.getData(key: ApiKey.lastName) as String? ?? '';
    final email = CacheHelper.getData(key: ApiKey.email) as String? ?? '';

    emit(ProfileLoadedState(
      firstName: firstName,
      lastName: lastName,
      email: email,
    ));
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    final result = await repository.logout();

    result.fold(
      (error) => emit(ProfileErrorState(message: error)),
      (_) => emit(ProfileLogoutSuccessState()),
    );
  }
}