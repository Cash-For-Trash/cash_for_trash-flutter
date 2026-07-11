import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/home/presentation/bloc/home_bloc.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/home_header.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/quick_actions_section.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/monthly_impact_section.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/current_order_section.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/recent_orders_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            final data = state.data;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(GetHomeData());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    HomeHeader(data: data),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child:
                          Column(
                                children: [
                                  const QuickActionsSection(),
                                  SizedBox(height: 24.h),
                                  MonthlyImpactSection(data: data),
                                  SizedBox(height: 24.h),
                                  if (data.currentOrder != null) ...[
                                    CurrentOrderSection(
                                      order: data.currentOrder!,
                                    ),
                                    SizedBox(height: 24.h),
                                  ],
                                  RecentOrdersSection(
                                    orders: data.recentOrders,
                                  ),
                                ],
                              )
                              .animate()
                              .fade(duration: 400.ms)
                              .slideY(begin: 0.05, curve: Curves.easeOut),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is HomeStateError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: TextStyle(color: colorScheme.error, fontSize: 16.sp),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<HomeBloc>().add(GetHomeData()),
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
