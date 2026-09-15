import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:cash_for_trash/features/home/presentation/bloc/home_bloc.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/home_header.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/quick_actions_section.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/current_order_section.dart';
import 'package:cash_for_trash/features/home/presentation/screens/widgets/recent_orders_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(
          const GetCustomerCollectionRecentRequests(status: "PENDING"),
        );
    context.read<HomeBloc>().add(const GetCustomerCollectionRequests());
    context.read<HomeBloc>().add(GetCustomerProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.currentOrdersStatus == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.currentOrdersStatus == HomeStatus.success) {
            final currentCollectionRequest = state.currentCollectionRequest;
            final recentCollectionRequests = state.recentCollectionRequests;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(
                      const GetCustomerCollectionRecentRequests(
                        status: "PENDING",
                      ),
                    );
                context.read<HomeBloc>().add(const GetCustomerCollectionRequests());
                context.read<HomeBloc>().add(GetCustomerProfile());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    HomeHeader(data: state.headerData),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        children: [
                          const QuickActionsSection(),
                          SizedBox(height: 12.h),
                          // MonthlyImpactSection(data: collectionRequest),
                          // SizedBox(height: 12.h),
                          if (currentCollectionRequest?.customerCollectionRequests != null) ...[
                            CurrentOrderSection(
                              currentCollectionRequest:
                                  currentCollectionRequest?.customerCollectionRequests ?? [],
                              hasMore: state.hasMoreCurrentOrders,
                              isLoadingMore: state.isFetchingMoreCurrentOrders,
                              onShowMore: () {
                                context.read<HomeBloc>().add(
                                      GetCustomerCollectionRecentRequests(
                                        page: state.currentOrdersPage + 1,
                                        pageSize: 4,
                                        status: "PENDING",
                                        isLoadMore: true,
                                      ),
                                    );
                              },
                            ),
                            SizedBox(height: 12.h),
                          ],
                          if (recentCollectionRequests?.customerCollectionRequests != null) ...[
                            RecentOrdersSection(
                              collectionRequests:
                                  recentCollectionRequests!.customerCollectionRequests,
                              hasMore: state.hasMoreRecentOrders,
                              isLoadingMore: state.isFetchingMoreRecentOrders,
                              onShowMore: () {
                                context.read<HomeBloc>().add(
                                      GetCustomerCollectionRequests(
                                        page: state.recentOrdersPage + 1,
                                        pageSize: 10,
                                        isLoadMore: true,
                                      ),
                                    );
                              },
                            ),
                          ],
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
          } else if (state.currentOrdersStatus == HomeStatus.error) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () => context.read<HomeBloc>().add(
                    const GetCustomerCollectionRecentRequests(
                      status: "PENDING",
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
