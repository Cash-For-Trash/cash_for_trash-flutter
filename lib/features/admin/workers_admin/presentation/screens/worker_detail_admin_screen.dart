import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/workers_admin_bloc.dart';
import '../bloc/workers_admin_event.dart';
import '../bloc/workers_admin_state.dart';

class WorkerDetailAdminScreen extends StatelessWidget {
  final String userId;

  const WorkerDetailAdminScreen({
    super.key,
    required this.userId,
  });

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
      ),
      body: BlocConsumer<WorkersAdminBloc, WorkersAdminState>(
        listener: (context, state) {
          if (state is WorkersAdminLoadedState && state.successMessage != null) {
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
            final worker = state.selectedWorker;
            if (worker == null) {
              return CustomErrorOrEmptyWidget(
                isError: false,
                title: context.tr('empty_no_items'),
              );
            }

            final isActive = worker.isActive ?? false;
            final isVerified = worker.isVerified ?? false;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 100.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile header
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 44.r,
                              backgroundColor:
                                  context.colorScheme.primaryContainer,
                              child: Icon(
                                Icons.engineering_rounded,
                                size: 44.r,
                                color: context.colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              worker.fullName.isNotEmpty
                                  ? worker.fullName
                                  : 'Worker',
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              worker.email ?? '',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _InfoChip(
                                  icon: isActive
                                      ? Icons.check_circle_rounded
                                      : Icons.pause_circle_rounded,
                                  label: isActive
                                      ? context.tr('admin_approved_workers')
                                      : context.tr('admin_pending_workers'),
                                  color: isActive ? Colors.green : Colors.orange,
                                ),
                                SizedBox(width: 8.w),
                                _InfoChip(
                                  icon: isVerified
                                      ? Icons.mark_email_read_rounded
                                      : Icons.email_outlined,
                                  label: isVerified
                                      ? context.tr('admin_verified')
                                      : context.tr('admin_not_verified'),
                                  color: isVerified ? Colors.blue : Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Details card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.r),
                          child: Column(
                            children: [
                              _DetailRow(
                                icon: Icons.badge_outlined,
                                label: 'National ID',
                                value: worker.nationalId ?? 'N/A',
                              ),
                              if (worker.areaId != null) ...[
                                const Divider(height: 1, indent: 56),
                                _DetailRow(
                                  icon: Icons.map_outlined,
                                  label: 'Area ID',
                                  value: worker.areaId!,
                                ),
                              ],
                              if (worker.createdAt != null) ...[
                                const Divider(height: 1, indent: 56),
                                _DetailRow(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Joined',
                                  value: worker.createdAt!.split('T').first,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action loading overlay
                if (state.isActionLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),

                // Approve button pinned at bottom
                if (!isActive)
                  Positioned(
                    left: 20.r,
                    right: 20.r,
                    bottom: 24.r,
                    child: CustomPrimaryButton(
                      text: context.tr('admin_approve_worker'),
                      onTap: () {
                        context
                            .read<WorkersAdminBloc>()
                            .add(ApproveWorkerAdminEvent(worker.id));
                      },
                    ),
                  ),
              ],
            );
          } else if (state is WorkersAdminErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context
                    .read<WorkersAdminBloc>()
                    .add(GetWorkerDetailAdminEvent(userId));
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colorScheme.primary),
      title: Text(
        label,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
