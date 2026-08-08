import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:cash_for_trash/core/routing/app_routes.dart';
import '../bloc/rewards_admin_bloc.dart';
import '../bloc/rewards_admin_event.dart';
import '../widgets/reward_card_rewards_admin_widget.dart';

class RewardsAdminScreen extends StatefulWidget {
  const RewardsAdminScreen({super.key});

  @override
  State<RewardsAdminScreen> createState() => _RewardsAdminScreenState();
}

class _RewardsAdminScreenState extends State<RewardsAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RewardsAdminBloc>().add(const GetRewardsAdminEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_rewards'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(AppRoutes.adminRewardFormScreen);
          if (context.mounted) {
            context.read<RewardsAdminBloc>().add(const GetRewardsAdminEvent());
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(context.tr('admin_add_reward')),
      ),
      body: BlocBuilder<RewardsAdminBloc, RewardsAdminState>(
        builder: (context, state) {
          if (state is RewardsAdminLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RewardsAdminLoadedState) {
            if (state.rewards.isEmpty) {
              return CustomErrorOrEmptyWidget(
                isError: false,
                title: context.tr('empty_no_items'),
                message: context.tr('empty_no_items_desc'),
                icon: Icons.card_giftcard_rounded,
                actionLabel: context.tr('admin_add_reward'),
                onAction: () async {
                  await context.push(AppRoutes.adminRewardFormScreen);
                  if (context.mounted) {
                    context.read<RewardsAdminBloc>().add(const GetRewardsAdminEvent());
                  }
                },
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RewardsAdminBloc>().add(const GetRewardsAdminEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: state.rewards.length,
                itemBuilder: (context, index) {
                  final reward = state.rewards[index];
                  return RewardCardRewardsAdminWidget(
                    reward: reward,
                    onTap: () async {
                      await context.push(AppRoutes.adminRewardFormScreen, extra: reward);
                      if (context.mounted) {
                        context.read<RewardsAdminBloc>().add(const GetRewardsAdminEvent());
                      }
                    },
                    onDelete: () {
                      context
                          .read<RewardsAdminBloc>()
                          .add(DeleteRewardAdminEvent(reward.id));
                    },
                  );
                },
              ),
            );
          } else if (state is RewardsAdminErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<RewardsAdminBloc>().add(const GetRewardsAdminEvent());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
