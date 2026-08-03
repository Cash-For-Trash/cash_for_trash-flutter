import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/worker_admin_model.dart';

class WorkerCardWorkersAdminWidget extends StatelessWidget {
  final WorkerAdminModel worker;
  final VoidCallback onTap;
  final VoidCallback? onApprove;

  const WorkerCardWorkersAdminWidget({
    super.key,
    required this.worker,
    required this.onTap,
    this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    final isVerified = worker.isVerified ?? false;
    final isActive = worker.isActive ?? true;
    final isApproved = worker.isApproved ?? false;

    return Card(
      elevation: 1.5,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: context.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.engineering_rounded,
                      color: context.colorScheme.primary,
                      size: 24.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.fullName.isNotEmpty
                              ? worker.fullName
                              : (worker.email ?? 'Worker'),
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (worker.email != null)
                          Text(
                            worker.email!,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Active badge
                  _StatusChip(
                    label: isActive
                        ? context.tr('admin_approved_workers')
                        : context.tr('admin_pending_workers'),
                    color: isActive ? Colors.green : Colors.orange,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  // Email verified badge
                  Icon(
                    isVerified
                        ? Icons.mark_email_read_rounded
                        : Icons.email_outlined,
                    size: 16.r,
                    color: isVerified
                        ? Colors.green
                        : context.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    isVerified
                        ? context.tr('admin_verified')
                        : context.tr('admin_not_verified'),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isVerified
                          ? Colors.green
                          : context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  // View details hint
                  Text(
                    context.tr('view_details'),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16.r,
                    color: context.colorScheme.primary,
                  ),
                ],
              ),
              if (!isApproved && onApprove != null) ...[
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: Icon(Icons.check_circle_outline, size: 18.r),
                    label: Text(context.tr('admin_approve')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
