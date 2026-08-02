import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/request_collection/data/model/availability_model.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeSlotRequestCollectionSection extends StatelessWidget {
  const TimeSlotRequestCollectionSection({super.key});

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
              if (state.isAvailabilitiesLoading) {
                return SizedBox(
                  height: 60.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.colorScheme.primary,
                    ),
                  ),
                );
              }

              if (state.availabilitiesErrorMessage != null &&
                  state.availabilities.isEmpty) {
                final addressId = state.selectedAddress?.addressId;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.availabilitiesErrorMessage!,
                        style: TextStyle(
                          color: context.colorScheme.error,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    if (addressId != null)
                      TextButton(
                        onPressed: () {
                          context.read<RequestCollectionBloc>().add(
                            GetAvailabilitiesEvent(addressId),
                          );
                        },
                        child: Text(context.tr('retry')),
                      ),
                  ],
                );
              }

              final items = state.availabilities;
              if (items.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    context.tr('no_availabilities'),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontSize: 13.sp,
                    ),
                  ),
                );
              }

              return Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: items.map((availability) {
                  final isSelected =
                      state.selectedAvailability?.id == availability.id ||
                      state.selectedTimeSlot == availability.id;
                  return SizedBox(
                    width:
                        (MediaQuery.sizeOf(context).width -
                            32.w -
                            32.w -
                            10.w) /
                        2,
                    child: _buildTimeSlotCard(
                      context,
                      availability: availability,
                      isSelected: isSelected,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotCard(
    BuildContext context, {
    required AvailabilityItemModel availability,
    required bool isSelected,
  }) {
    final activeColor = context.colorScheme.primary;
    final inactiveBg = context.colorScheme.surfaceContainerLow;
    final activeBg = context.colorScheme.primaryContainer.withValues(
      alpha: 0.3,
    );

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final String displayText = availability.getDisplayLabel(isArabic);

    return InkWell(
      onTap: () {
        context.read<RequestCollectionBloc>().add(
          SelectAvailabilityEvent(availability),
        );
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
                displayText,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 11.5.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? activeColor
                      : context.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
