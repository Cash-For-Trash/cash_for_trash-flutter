import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/availability_admin_model.dart';

class AvailabilityCardAvailabilitiesAdminWidget extends StatelessWidget {
  final AvailabilityAdminModel availability;
  final VoidCallback onDelete;

  const AvailabilityCardAvailabilitiesAdminWidget({
    super.key,
    required this.availability,
    required this.onDelete,
  });

  String _formatDay(String day) {
    if (day.isEmpty) return '';
    return day[0].toUpperCase() + day.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.r),
        leading: CircleAvatar(
          backgroundColor: context.colorScheme.primaryContainer,
          child: Icon(
            Icons.access_time_filled_rounded,
            color: context.colorScheme.primary,
          ),
        ),
        title: Text(
          _formatDay(availability.dayOfWeek),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${availability.fromTime} - ${availability.toTime}\nArea: ${availability.areaName ?? availability.areaId ?? 'All'}',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: context.colorScheme.error,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
