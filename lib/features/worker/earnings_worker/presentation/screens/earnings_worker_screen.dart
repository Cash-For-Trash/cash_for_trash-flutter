import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/earnings_worker_bloc.dart';
import '../bloc/earnings_worker_event.dart';
import '../bloc/earnings_worker_state.dart';
import '../widgets/summary_card_earnings_worker_widget.dart';
import '../widgets/payout_history_earnings_worker_widget.dart';

class EarningsWorkerScreen extends StatefulWidget {
  const EarningsWorkerScreen({super.key});

  @override
  State<EarningsWorkerScreen> createState() => _EarningsWorkerScreenState();
}

class _EarningsWorkerScreenState extends State<EarningsWorkerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EarningsWorkerBloc>().add(const GetWorkerEarningsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('total_earnings'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<EarningsWorkerBloc, EarningsWorkerState>(
        builder: (context, state) {
          if (state is EarningsWorkerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EarningsWorkerLoadedState) {
            final data = state.data;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<EarningsWorkerBloc>().add(const GetWorkerEarningsEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SummaryCardEarningsWorkerWidget(data: data),
                    SizedBox(height: 24.h),
                    Text(
                      context.tr('payout_history'),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    PayoutHistoryEarningsWorkerWidget(payouts: data.payoutHistory),
                  ],
                ),
              ),
            );
          } else if (state is EarningsWorkerErrorState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
