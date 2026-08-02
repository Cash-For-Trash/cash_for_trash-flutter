import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/redemptions_admin_bloc.dart';
import '../bloc/redemptions_admin_event.dart';
import '../bloc/redemptions_admin_state.dart';
import '../widgets/redemption_card_redemptions_admin_widget.dart';

class RedemptionsAdminScreen extends StatefulWidget {
  const RedemptionsAdminScreen({super.key});

  @override
  State<RedemptionsAdminScreen> createState() =>
      _RedemptionsAdminScreenState();
}

class _RedemptionsAdminScreenState extends State<RedemptionsAdminScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<RedemptionsAdminBloc>()
        .add(const GetRedemptionsAdminEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_redemptions'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<RedemptionsAdminBloc, RedemptionsAdminState>(
        listener: (context, state) {
          if (state is RedemptionsAdminLoadedState && state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is RedemptionsAdminErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: context.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is RedemptionsAdminLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RedemptionsAdminLoadedState) {
            if (state.redemptions.isEmpty) {
              return CustomErrorOrEmptyWidget(
                isError: false,
                title: context.tr('empty_no_items'),
                message: context.tr('empty_no_items_desc'),
                icon: Icons.card_giftcard_outlined,
              );
            }
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<RedemptionsAdminBloc>()
                        .add(const GetRedemptionsAdminEvent());
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: state.redemptions.length,
                    itemBuilder: (context, index) {
                      final item = state.redemptions[index];
                      return RedemptionCardRedemptionsAdminWidget(
                        redemption: item,
                        onApprove: () {
                          context
                              .read<RedemptionsAdminBloc>()
                              .add(ApproveRedemptionAdminEvent(item.id));
                        },
                        onReject: () {
                          context
                              .read<RedemptionsAdminBloc>()
                              .add(RejectRedemptionAdminEvent(item.id));
                        },
                      );
                    },
                  ),
                ),
                if (state.isActionLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          } else if (state is RedemptionsAdminErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context
                    .read<RedemptionsAdminBloc>()
                    .add(const GetRedemptionsAdminEvent());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
