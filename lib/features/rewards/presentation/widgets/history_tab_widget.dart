import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/utils/date_formatter.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:cash_for_trash/features/rewards/data/model/redemption_model.dart';
import 'package:cash_for_trash/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryTabWidget extends StatefulWidget {
  const HistoryTabWidget({super.key});

  @override
  State<HistoryTabWidget> createState() => _HistoryTabWidgetState();
}

class _HistoryTabWidgetState extends State<HistoryTabWidget> {
  @override
  void initState() {
    super.initState();
    context.read<RewardsBloc>().add(const GetMyRedemptionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RewardsBloc, RewardsState>(
      builder: (context, state) {
        if (state.isRedemptionsLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: context.colorScheme.primary,
            ),
          );
        }

        if (state.redemptionsErrorMessage != null &&
            state.redemptions.isEmpty) {
          return CustomErrorOrEmptyWidget(
            isError: true,
            errorMessage: state.redemptionsErrorMessage,
            onRetry: () {
              context.read<RewardsBloc>().add(const GetMyRedemptionsEvent());
            },
          );
        }

        if (state.redemptions.isEmpty) {
          return CustomErrorOrEmptyWidget(
            isError: false,
            title: context.tr('no_history'),
            message: context.tr('no_history_desc'),
            icon: Icons.history_rounded,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<RewardsBloc>().add(const GetMyRedemptionsEvent());
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            itemCount: state.redemptions.length,
            itemBuilder: (context, index) {
              return _RedemptionCard(
                redemption: state.redemptions[index],
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}

class _RedemptionCard extends StatelessWidget {
  final RedemptionModel redemption;
  final int index;

  const _RedemptionCard({required this.redemption, required this.index});

  Color _statusColor(
    String status,
    ColorScheme colorScheme,
    dynamic extraColors,
  ) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return extraColors.success ?? colorScheme.primary;
      case 'REJECTED':
        return colorScheme.error;
      default:
        return colorScheme.secondary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Icons.check_circle_rounded;
      case 'REJECTED':
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  String _statusLabel(BuildContext context, String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return context.tr('status_approved');
      case 'REJECTED':
        return context.tr('status_rejected');
      default:
        return context.tr('status_pending');
    }
  }

  String _formatDate(String dateStr) {
    return AppDateFormatter.format(dateStr);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final extraColors = context.extraColors;
    final statusColor = _statusColor(
      redemption.status,
      colorScheme,
      extraColors,
    );

    return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colorScheme.outline, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _statusIcon(redemption.status),
                  color: statusColor,
                  size: 22.r,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      redemption.rewardName,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 13.r,
                          color: colorScheme.primary,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '${redemption.requiredPoints} ${context.tr('points')}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          _formatDate(redemption.createdAt),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _statusLabel(context, redemption.status),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: (index * 60).ms)
        .fade(duration: 350.ms)
        .slideY(begin: 0.06, curve: Curves.easeOut);
  }
}
