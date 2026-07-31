import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/availability_worker_model.dart';

class AddSlotModalWorkerWidget extends StatefulWidget {
  final List<Map<String, dynamic>> areas;
  final Function(AvailabilityWorkerModel) onSave;

  const AddSlotModalWorkerWidget({
    super.key,
    required this.areas,
    required this.onSave,
  });

  @override
  State<AddSlotModalWorkerWidget> createState() => _AddSlotModalWorkerWidgetState();
}

class _AddSlotModalWorkerWidgetState extends State<AddSlotModalWorkerWidget> {
  final days = [
    'SATURDAY',
    'SUNDAY',
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
  ];

  late String selectedDay;
  String? selectedAreaId;
  String fromTime = '09:00:00';
  String toTime = '12:00:00';

  @override
  void initState() {
    super.initState();
    selectedDay = days.first;
    if (widget.areas.isNotEmpty) {
      selectedAreaId = widget.areas.first['area_id'] as String? ?? widget.areas.first['id'] as String?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20.r,
        left: 20.r,
        right: 20.r,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.r,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            context.tr('add_availability'),
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(context.tr('select_day'), style: context.textTheme.labelLarge),
          SizedBox(height: 6.h),
          DropdownButtonFormField<String>(
            initialValue: selectedDay,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            ),
            items: days.map((day) {
              return DropdownMenuItem(value: day, child: Text(day));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => selectedDay = val);
            },
          ),
          if (widget.areas.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(context.tr('select_area'), style: context.textTheme.labelLarge),
            SizedBox(height: 6.h),
            DropdownButtonFormField<String>(
              initialValue: selectedAreaId,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              ),
              items: widget.areas.map((area) {
                final id = area['area_id'] as String? ?? area['id'] as String? ?? '';
                final name = area['name'] as String? ?? 'Area';
                return DropdownMenuItem(value: id, child: Text(name));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => selectedAreaId = val);
              },
            ),
          ],
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('from_time'), style: context.textTheme.labelLarge),
                    SizedBox(height: 6.h),
                    TextFormField(
                      initialValue: fromTime,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      ),
                      onChanged: (val) => fromTime = val,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('to_time'), style: context.textTheme.labelLarge),
                    SizedBox(height: 6.h),
                    TextFormField(
                      initialValue: toTime,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      ),
                      onChanged: (val) => toTime = val,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final model = AvailabilityWorkerModel(
                  id: '',
                  areaId: selectedAreaId ?? '',
                  areaName: '',
                  dayOfWeek: selectedDay,
                  fromTime: fromTime,
                  toTime: toTime,
                  isActive: true,
                );
                widget.onSave(model);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: context.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                context.tr('confirm'),
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
