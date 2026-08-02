import 'package:equatable/equatable.dart';
import '../../data/model/availability_admin_model.dart';

abstract class AvailabilitiesAdminState extends Equatable {
  const AvailabilitiesAdminState();

  @override
  List<Object?> get props => [];
}

class AvailabilitiesAdminInitialState extends AvailabilitiesAdminState {}

class AvailabilitiesAdminLoadingState extends AvailabilitiesAdminState {}

class AvailabilitiesAdminLoadedState extends AvailabilitiesAdminState {
  final List<AvailabilityAdminModel> availabilities;
  final bool isActionLoading;
  final String? successMessage;

  const AvailabilitiesAdminLoadedState({
    required this.availabilities,
    this.isActionLoading = false,
    this.successMessage,
  });

  AvailabilitiesAdminLoadedState copyWith({
    List<AvailabilityAdminModel>? availabilities,
    bool? isActionLoading,
    String? successMessage,
  }) {
    return AvailabilitiesAdminLoadedState(
      availabilities: availabilities ?? this.availabilities,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [availabilities, isActionLoading, successMessage];
}

class AvailabilitiesAdminErrorState extends AvailabilitiesAdminState {
  final String errorMessage;

  const AvailabilitiesAdminErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
