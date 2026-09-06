import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/garbage_weight_worker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickupDetailsWorkerGarbageTypesWidget extends StatelessWidget {
  final List<GarbageWeightWorkerModel> garbageTypes;

  const PickupDetailsWorkerGarbageTypesWidget({
    super.key,
    required this.garbageTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('select_type_and_quantity'),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        if (garbageTypes.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Text(
              context.tr('no_waste_types_available'),
              style: context.textTheme.bodyMedium,
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: garbageTypes.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final item = garbageTypes[index];
              final weightDisplay = item.actualWeight > 0 ? item.actualWeight : item.expectedWeight;

              return Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.garbageTypeName.isNotEmpty ? item.garbageTypeName : context.tr('waste_type_title'),
                        style: context.textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      '$weightDisplay ${context.tr('kg_unit')}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
