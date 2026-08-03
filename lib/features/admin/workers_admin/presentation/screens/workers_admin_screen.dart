import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../bloc/workers_admin_bloc.dart';
import '../bloc/workers_admin_event.dart';
import '../bloc/workers_admin_state.dart';
import '../widgets/worker_card_workers_admin_widget.dart';

class WorkersAdminScreen extends StatefulWidget {
  const WorkersAdminScreen({super.key});

  @override
  State<WorkersAdminScreen> createState() => _WorkersAdminScreenState();
}

class _WorkersAdminScreenState extends State<WorkersAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkersAdminBloc>().add(const GetWorkersAdminEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_workers'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<WorkersAdminBloc, WorkersAdminState>(
        listener: (context, state) {
          if (state is WorkersAdminLoadedState &&
              state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is WorkersAdminErrorState) {
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
          if (state is WorkersAdminLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkersAdminLoadedState) {
            if (state.workers.isEmpty) {
              return CustomErrorOrEmptyWidget(
                isError: false,
                title: context.tr('empty_no_items'),
                message: context.tr('empty_no_items_desc'),
                icon: Icons.engineering_outlined,
              );
            }
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    context.read<WorkersAdminBloc>().add(
                      const GetWorkersAdminEvent(),
                    );
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: state.workers.length,
                    itemBuilder: (context, index) {
                      final worker = state.workers[index];
                      return WorkerCardWorkersAdminWidget(
                        worker: worker,
                        onTap: () {
                          context.push(
                            AppRoutes.adminWorkerDetailScreen,
                            extra: worker.id,
                          );
                        },
                        onApprove: () {
                          context.read<WorkersAdminBloc>().add(
                            ApproveWorkerAdminEvent(worker.id),
                          );
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
          } else if (state is WorkersAdminErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<WorkersAdminBloc>().add(
                  const GetWorkersAdminEvent(),
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
