import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/garbage_weight_worker_model.dart';

class WeightRecordingModalWorkerWidget extends StatefulWidget {
  final List<GarbageWeightWorkerModel> garbageTypes;
  final double workerPercentage;
  final Function(List<GarbageWeightWorkerModel>) onConfirm;

  const WeightRecordingModalWorkerWidget({
    super.key,
    required this.garbageTypes,
    this.workerPercentage = 70.0,
    required this.onConfirm,
  });

  @override
  State<WeightRecordingModalWorkerWidget> createState() => _WeightRecordingModalWorkerWidgetState();
}

class _WeightRecordingModalWorkerWidgetState extends State<WeightRecordingModalWorkerWidget> {
  late List<GarbageWeightWorkerModel> items;

  @override
  void initState() {
    super.initState();
    items = widget.garbageTypes.map((item) {
      return item.copyWith(
        actualWeight: item.actualWeight > 0 ? item.actualWeight : item.expectedWeight,
      );
    }).toList();
  }

  double get calculateTotalPoints {
    double total = 0.0;
    for (var item in items) {
      total += item.actualWeight * (item.pricePerKg > 0 ? item.pricePerKg : 10.0);
    }
    return total;
  }

  double get calculateWorkerIncome {
    return calculateTotalPoints * (widget.workerPercentage / 100.0);
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
            context.tr('record_garbage_weights'),
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = items[index];
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.garbageTypeName.isNotEmpty
                            ? item.garbageTypeName
                            : context.tr('waste_type_title'),
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: item.actualWeight.toString(),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: context.tr('enter_actual_weight_hint'),
                          suffixText: context.tr('kg_unit'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                        ),
                        onChanged: (val) {
                          final parsed = double.tryParse(val) ?? 0.0;
                          setState(() {
                            items[index] = item.copyWith(actualWeight: parsed);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('customer_points_earned'),
                      style: context.textTheme.bodyMedium,
                    ),
                    Text(
                      '${calculateTotalPoints.toStringAsFixed(1)} ${context.tr('points')}',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('worker_income_earned'),
                      style: context.textTheme.bodyMedium,
                    ),
                    Text(
                      '${calculateWorkerIncome.toStringAsFixed(1)} ${context.tr('currency_egp')}',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onConfirm(items);
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
                context.tr('confirm_collection'),
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
