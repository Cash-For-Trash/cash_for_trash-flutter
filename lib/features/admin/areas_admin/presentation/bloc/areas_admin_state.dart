import 'package:equatable/equatable.dart';
import '../../data/model/area_admin_model.dart';

abstract class AreasAdminState extends Equatable {
  const AreasAdminState();

  @override
  List<Object?> get props => [];
}

class AreasAdminInitialState extends AreasAdminState {}

class AreasAdminLoadingState extends AreasAdminState {}

class AreasAdminLoadedState extends AreasAdminState {
  final List<AreaAdminModel> areas;
  final bool isActionLoading;
  final String? successMessage;

  const AreasAdminLoadedState({
    required this.areas,
    this.isActionLoading = false,
    this.successMessage,
  });

  AreasAdminLoadedState copyWith({
    List<AreaAdminModel>? areas,
    bool? isActionLoading,
    String? successMessage,
  }) {
    return AreasAdminLoadedState(
      areas: areas ?? this.areas,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [areas, isActionLoading, successMessage];
}

class AreasAdminErrorState extends AreasAdminState {
  final String errorMessage;

  const AreasAdminErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
