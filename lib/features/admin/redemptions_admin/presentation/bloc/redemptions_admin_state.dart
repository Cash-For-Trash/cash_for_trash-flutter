import 'package:equatable/equatable.dart';
import '../../data/model/redemption_admin_model.dart';

abstract class RedemptionsAdminState extends Equatable {
  const RedemptionsAdminState();

  @override
  List<Object?> get props => [];
}

class RedemptionsAdminInitialState extends RedemptionsAdminState {}

class RedemptionsAdminLoadingState extends RedemptionsAdminState {}

class RedemptionsAdminLoadedState extends RedemptionsAdminState {
  final List<RedemptionAdminModel> redemptions;
  final bool isActionLoading;
  final String? successMessage;

  const RedemptionsAdminLoadedState({
    required this.redemptions,
    this.isActionLoading = false,
    this.successMessage,
  });

  RedemptionsAdminLoadedState copyWith({
    List<RedemptionAdminModel>? redemptions,
    bool? isActionLoading,
    String? successMessage,
  }) {
    return RedemptionsAdminLoadedState(
      redemptions: redemptions ?? this.redemptions,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [redemptions, isActionLoading, successMessage];
}

class RedemptionsAdminErrorState extends RedemptionsAdminState {
  final String errorMessage;

  const RedemptionsAdminErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
