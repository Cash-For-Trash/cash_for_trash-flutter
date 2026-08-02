import 'package:equatable/equatable.dart';
import '../../data/model/garbage_type_admin_model.dart';

abstract class GarbageTypesAdminState extends Equatable {
  const GarbageTypesAdminState();

  @override
  List<Object?> get props => [];
}

class GarbageTypesAdminInitialState extends GarbageTypesAdminState {}

class GarbageTypesAdminLoadingState extends GarbageTypesAdminState {}

class GarbageTypesAdminLoadedState extends GarbageTypesAdminState {
  final List<GarbageTypeAdminModel> garbageTypes;
  final bool isActionLoading;
  final String? successMessage;

  const GarbageTypesAdminLoadedState({
    required this.garbageTypes,
    this.isActionLoading = false,
    this.successMessage,
  });

  GarbageTypesAdminLoadedState copyWith({
    List<GarbageTypeAdminModel>? garbageTypes,
    bool? isActionLoading,
    String? successMessage,
  }) {
    return GarbageTypesAdminLoadedState(
      garbageTypes: garbageTypes ?? this.garbageTypes,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [garbageTypes, isActionLoading, successMessage];
}

class GarbageTypesAdminErrorState extends GarbageTypesAdminState {
  final String errorMessage;

  const GarbageTypesAdminErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
