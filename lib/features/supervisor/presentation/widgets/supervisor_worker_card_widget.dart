import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/worker_supervisor_model.dart';

class SupervisorWorkerCardWidget extends StatelessWidget {
  final WorkerSupervisorModel worker;

  const SupervisorWorkerCardWidget({
    super.key,
    required this.worker,
  });

  Future<void> _onWorkerTap(BuildContext context) async {
    await CacheHelper.saveData(key: 'selected_worker_id', value: worker.userId);
    if (context.mounted) {
      context.push(
        AppRoutes.workerHomeScreen,
        extra: {
          'isSupervisorView': true,
          'workerId': worker.userId,
          'workerName': worker.fullName,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String initials = worker.firstName.isNotEmpty
        ? worker.firstName[0].toUpperCase() +
            (worker.lastName.isNotEmpty ? worker.lastName[0].toUpperCase() : '')
        : 'W';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _onWorkerTap(context),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: context.colorScheme.primaryContainer,
                  backgroundImage: worker.image != null && worker.image!.isNotEmpty
                      ? NetworkImage(worker.image!)
                      : null,
                  child: worker.image == null || worker.image!.isEmpty
                      ? Text(
                          initials,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 14.r,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              worker.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android_rounded,
                            size: 14.r,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            worker.mobile,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      if (worker.nationalId != null &&
                          worker.nationalId!.isNotEmpty) ...[
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              size: 14.r,
                              color: context.colorScheme.primary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${context.tr('national_id')}: ${worker.nationalId}',
                              style: context.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
