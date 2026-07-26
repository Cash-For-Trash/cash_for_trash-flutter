import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeSlotRequestCollectionSection extends StatelessWidget {
  const TimeSlotRequestCollectionSection({super.key});

  static const List<Map<String, String>> _timeSlots = [
    {
      'id': 'today_4pm',
      'labelKey': 'today_4pm',
    },
    {
      'id': 'today_6pm',
      'labelKey': 'today_6pm',
    },
    {
      'id': 'tomorrow_9am',
      'labelKey': 'tomorrow_9am',
    },
    {
      'id': 'tomorrow_11am',
      'labelKey': 'tomorrow_11am',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('pickup_time'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          BlocBuilder<RequestCollectionBloc, RequestCollectionState>(
            builder: (context, state) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _timeSlots.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  final item = _timeSlots[index];
                  final id = item['id']!;
                  final labelKey = item['labelKey']!;
                  final isSelected = state.selectedTimeSlot == id;

                  return _buildTimeSlotCard(
                    context,
                    id: id,
                    labelKey: labelKey,
                    isSelected: isSelected,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotCard(
    BuildContext context, {
    required String id,
    required String labelKey,
    required bool isSelected,
  }) {
    final activeColor = context.colorScheme.primary;
    final inactiveBg = context.colorScheme.surfaceContainerLow;
    final activeBg = context.colorScheme.primaryContainer.withValues(alpha: 0.3);

    return InkWell(
      onTap: () {
        context.read<RequestCollectionBloc>().add(SelectTimeSlotEvent(id));
      },
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 1.5.r,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 18.sp,
              color: isSelected
                  ? activeColor
                  : context.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                context.tr(labelKey),
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 11.5.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color:
                      isSelected ? activeColor : context.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
