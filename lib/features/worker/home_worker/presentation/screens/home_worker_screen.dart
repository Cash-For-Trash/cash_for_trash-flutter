import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/home_worker_bloc.dart';
import '../bloc/home_worker_event.dart';
import '../bloc/home_worker_state.dart';
import '../widgets/status_banner_home_worker_widget.dart';
import '../widgets/quick_stats_home_worker_widget.dart';
import '../widgets/active_pickup_card_home_worker_widget.dart';

class HomeWorkerScreen extends StatelessWidget {
  final VoidCallback? onNavigateToPickups;

  const HomeWorkerScreen({super.key, this.onNavigateToPickups});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('worker_dashboard'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<HomeWorkerBloc, HomeWorkerState>(
        builder: (context, state) {
          if (state is HomeWorkerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeWorkerLoadedState) {
            final data = state.data;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeWorkerBloc>().add(
                  const GetHomeWorkerDataEvent(),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBannerHomeWorkerWidget(isApproved: data.isApproved),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25.r,
                            backgroundColor: context.colorScheme.onPrimary
                                .withValues(alpha: 0.16),
                            child: Icon(
                              Icons.person_rounded,
                              color: context.colorScheme.onPrimary,
                              size: 27.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.workerName.isEmpty
                                      ? context.tr('worker_dashboard')
                                      : data.workerName,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    color: context.colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  data.isApproved
                                      ? context.tr('status_approved')
                                      : context.tr('pending_approval_title'),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.onPrimary
                                        .withValues(alpha: 0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.verified_rounded,
                            color: data.isApproved
                                ? context.colorScheme.onPrimary
                                : context.colorScheme.onPrimary.withValues(
                                    alpha: 0.35,
                                  ),
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),
                    QuickStatsHomeWorkerWidget(data: data),
                    SizedBox(height: 24.h),
                    ActivePickupCardHomeWorkerWidget(
                      pickupCount: data.todayPickupsCount,
                      onTap: () {
                        if (onNavigateToPickups != null) {
                          onNavigateToPickups!();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (state is HomeWorkerErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<HomeWorkerBloc>().add(
                  const GetHomeWorkerDataEvent(),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
