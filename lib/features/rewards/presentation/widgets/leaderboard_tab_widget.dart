import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:cash_for_trash/features/rewards/data/model/rewards_leaderboard_model.dart';
import 'package:cash_for_trash/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderboardTabWidget extends StatefulWidget {
  const LeaderboardTabWidget({super.key});

  @override
  State<LeaderboardTabWidget> createState() => _LeaderboardTabWidgetState();
}

class _LeaderboardTabWidgetState extends State<LeaderboardTabWidget> {
  @override
  void initState() {
    super.initState();
    context.read<RewardsBloc>().add(const GetLeaderboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final warning = context.extraColors.warning ?? colorScheme.secondary;

    return BlocBuilder<RewardsBloc, RewardsState>(
      builder: (context, state) {
        if (state.isLeaderboardLoading) {
          return Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          );
        }

        if (state.leaderboardErrorMessage != null &&
            state.leaderboard.isEmpty) {
          return CustomErrorOrEmptyWidget(
            isError: true,
            errorMessage: state.leaderboardErrorMessage,
            onRetry: () {
              context.read<RewardsBloc>().add(const GetLeaderboardEvent());
            },
          );
        }

        if (state.leaderboard.isEmpty) {
          return CustomErrorOrEmptyWidget(
            isError: false,
            title: context.tr('leaderboard'),
            message: context.tr('no_leaderboard_desc'),
            icon: Icons.emoji_events_outlined,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<RewardsBloc>().add(const GetLeaderboardEvent());
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            itemCount: state.leaderboard.length,
            itemBuilder: (context, index) {
              final leader = state.leaderboard[index];
              return _LeaderboardCardWidget(
                leader: leader,
                index: index,
                warning: warning,
              );
            },
          ),
        );
      },
    );
  }
}

class _LeaderboardCardWidget extends StatelessWidget {
  final RewardsLeaderboardModel leader;
  final int index;
  final Color warning;

  const _LeaderboardCardWidget({
    required this.leader,
    required this.index,
    required this.warning,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

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
              _buildRankBadge(leader.rank, warning, colorScheme),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      leader.name,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.star_rounded, color: warning, size: 13.r),
                        SizedBox(width: 3.w),
                        Text(
                          '${leader.points} ${context.tr('points')}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: warning,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: (index * 60).ms)
        .fade(duration: 350.ms)
        .slideX(begin: 0.05, curve: Curves.easeOut);
  }

  Widget _buildRankBadge(int rank, Color warning, ColorScheme colorScheme) {
    Color badgeColor;
    Color textColor;
    IconData? icon;

    if (rank == 1) {
      badgeColor = const Color(0xFFFFD700);
      textColor = const Color(0xFF7A5B00);
      icon = Icons.emoji_events_rounded;
    } else if (rank == 2) {
      badgeColor = const Color(0xFFB0BEC5);
      textColor = const Color(0xFF37474F);
      icon = Icons.emoji_events_rounded;
    } else if (rank == 3) {
      badgeColor = const Color(0xFFD7815A);
      textColor = const Color(0xFFFFFFFF);
      icon = Icons.emoji_events_rounded;
    } else {
      badgeColor = colorScheme.surfaceContainerHigh;
      textColor = colorScheme.onSurface;
      icon = null;
    }

    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
      child: Center(
        child: icon != null && rank <= 3
            ? Icon(icon, color: textColor, size: 18.r)
            : Text(
                '#$rank',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  fontFamily: 'Tajawal',
                ),
              ),
      ),
    );
  }
}
