import 'package:equatable/equatable.dart';

abstract class RedemptionsAdminEvent extends Equatable {
  const RedemptionsAdminEvent();

  @override
  List<Object?> get props => [];
}

class GetRedemptionsAdminEvent extends RedemptionsAdminEvent {
  const GetRedemptionsAdminEvent();
}

class ApproveRedemptionAdminEvent extends RedemptionsAdminEvent {
  final String redemptionId;

  const ApproveRedemptionAdminEvent(this.redemptionId);

  @override
  List<Object?> get props => [redemptionId];
}

class RejectRedemptionAdminEvent extends RedemptionsAdminEvent {
  final String redemptionId;

  const RejectRedemptionAdminEvent(this.redemptionId);

  @override
  List<Object?> get props => [redemptionId];
}
