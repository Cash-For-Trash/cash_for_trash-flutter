import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../bloc/supervisor_bloc.dart';
import '../bloc/supervisor_event.dart';
import '../bloc/supervisor_state.dart';
import '../widgets/supervisor_worker_card_widget.dart';
import '../widgets/supervisor_workers_header_widget.dart';

class SupervisorWorkersScreen extends StatefulWidget {
  const SupervisorWorkersScreen({super.key});

  @override
  State<SupervisorWorkersScreen> createState() => _SupervisorWorkersScreenState();
}

class _SupervisorWorkersScreenState extends State<SupervisorWorkersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SupervisorBloc>().add(const GetSupervisorWorkersEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<SupervisorBloc>()
          .add(const FetchMoreSupervisorWorkersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final supervisorBloc = context.read<SupervisorBloc>();
          context.push(
            AppRoutes.createWorkerSupervisorScreen,
            extra: supervisorBloc,
          );
        },
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        icon: const Icon(Icons.person_add_rounded),
        label: Text(
          context.tr('create_worker'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<SupervisorBloc, SupervisorState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<SupervisorBloc>()
                    .add(const GetSupervisorWorkersEvent());
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SupervisorWorkersHeaderWidget(),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Builder(
                        builder: (context) {
                          if (state.workersStatus ==
                              SupervisorWorkersStatus.loading) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: context.colorScheme.primary,
                                ),
                              ),
                            );
                          }

                          if (state.workersStatus ==
                              SupervisorWorkersStatus.failure) {
                            return CustomErrorOrEmptyWidget(
                              isError: true,
                              errorMessage: state.workersErrorMessage,
                              onRetry: () {
                                context.read<SupervisorBloc>().add(
                                      const GetSupervisorWorkersEvent(),
                                    );
                              },
                            );
                          }

                          final displayedWorkers = state.filteredWorkers;

                          if (displayedWorkers.isEmpty) {
                            return CustomErrorOrEmptyWidget(
                              isError: false,
                              title: context.tr('empty_no_items'),
                              message: context.tr('empty_no_items_desc'),
                              icon: Icons.people_outline_rounded,
                              actionLabel: context.tr('create_worker'),
                              onAction: () {
                                final supervisorBloc =
                                    context.read<SupervisorBloc>();
                                context.push(
                                  AppRoutes.createWorkerSupervisorScreen,
                                  extra: supervisorBloc,
                                );
                              },
                            );
                          }

                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: displayedWorkers.length,
                                itemBuilder: (context, index) {
                                  return SupervisorWorkerCardWidget(
                                    worker: displayedWorkers[index],
                                  );
                                },
                              ),
                              if (state.isLoadingMore) ...[
                                SizedBox(height: 16.h),
                                Center(
                                  child: CircularProgressIndicator(
                                    color: context.colorScheme.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
