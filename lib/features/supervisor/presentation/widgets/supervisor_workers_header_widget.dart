import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../bloc/supervisor_bloc.dart';
import '../bloc/supervisor_event.dart';

class SupervisorWorkersHeaderWidget extends StatelessWidget {
  const SupervisorWorkersHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('supervisor_dashboard'),
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      context.tr('managed_workers'),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  final supervisorBloc = context.read<SupervisorBloc>();
                  context.push(
                    AppRoutes.createWorkerSupervisorScreen,
                    extra: supervisorBloc,
                  );
                },
                icon: Icon(Icons.person_add_rounded, size: 18.r),
                label: Text(
                  context.tr('create_worker'),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.onPrimary,
                  foregroundColor: context.colorScheme.primary,
                  elevation: 2,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            hintText: context.tr('search_workers'),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: context.colorScheme.primary,
              size: 20.r,
            ),
            onChanged: (value) {
              context
                  .read<SupervisorBloc>()
                  .add(SearchSupervisorWorkersEvent(value));
            },
          ),
        ],
      ),
    );
  }
}
