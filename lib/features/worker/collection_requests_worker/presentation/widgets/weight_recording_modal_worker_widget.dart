import 'package:cash_for_trash/core/di/service_locator.dart';
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/request_collection/data/model/garbage_type_model.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/domain/repository/collection_requests_worker_repository.dart';
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
  List<GarbageTypeItemModel> catalogTypes = [];
  bool isCatalogLoading = false;

  @override
  void initState() {
    super.initState();
    items = widget.garbageTypes.map((item) {
      return item.copyWith(
        actualWeight: item.actualWeight > 0 ? item.actualWeight : item.expectedWeight,
      );
    }).toList();
    _fetchCatalog();
  }

  Future<void> _fetchCatalog() async {
    setState(() {
      isCatalogLoading = true;
    });
    final result = await sl<CollectionRequestsWorkerRepository>().getGarbageTypes();
    if (mounted) {
      result.fold(
        (error) {
          setState(() {
            isCatalogLoading = false;
          });
        },
        (types) {
          setState(() {
            catalogTypes = types;
            isCatalogLoading = false;
          });
        },
      );
    }
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

  void _addItemFromCatalog(GarbageTypeItemModel catalogItem) {
    final parsedPrice = double.tryParse(catalogItem.pricePerKg) ?? 10.0;
    final newItem = GarbageWeightWorkerModel(
      requestGarbageId: '',
      garbageTypeId: catalogItem.garbageTypeId,
      garbageTypeName: catalogItem.garbageTypeName,
      pricePerKg: parsedPrice,
      expectedWeight: 5.0,
      actualWeight: 5.0,
    );
    setState(() {
      items.add(newItem);
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            context.tr('select_waste_type'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: isCatalogLoading
                ? SizedBox(
                    height: 100.h,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : catalogTypes.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Text(
                          context.tr('no_waste_types_available'),
                          style: context.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: catalogTypes.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final opt = catalogTypes[index];
                          return ListTile(
                            title: Text(opt.garbageTypeName, style: context.textTheme.bodyLarge),
                            subtitle: Text(
                              '${opt.pricePerKg} ${context.tr('currency_egp')} / ${context.tr('kg_unit')}',
                              style: context.textTheme.bodySmall,
                            ),
                            trailing: Icon(
                              Icons.add_circle_outline_rounded,
                              color: context.colorScheme.primary,
                            ),
                            onTap: () {
                              Navigator.pop(dialogContext);
                              _addItemFromCatalog(opt);
                            },
                          );
                        },
                      ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.tr('cancel')),
            ),
          ],
        );
      },
    );
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
      child: SingleChildScrollView(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('record_garbage_weights'),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAddDialog,
                  icon: Icon(Icons.add_rounded, size: 20.sp),
                  label: Text(context.tr('add_garbage_type')),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (items.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: Text(
                    context.tr('cannot_be_empty'),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                        flex: 2,
                        child: Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: context.colorScheme.primary,
                                size: 22.sp,
                              ),
                              onPressed: () {
                                if (item.actualWeight > 1) {
                                  setState(() {
                                    items[index] = item.copyWith(
                                      actualWeight: item.actualWeight - 1,
                                    );
                                  });
                                }
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                key: ValueKey('${item.garbageTypeId}_${index}_${item.actualWeight}'),
                                initialValue: item.actualWeight.toStringAsFixed(1),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  suffixText: context.tr('kg_unit'),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                                ),
                                onChanged: (val) {
                                  final parsed = double.tryParse(val) ?? 0.0;
                                  items[index] = item.copyWith(actualWeight: parsed);
                                  setState(() {});
                                },
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: context.colorScheme.primary,
                                size: 22.sp,
                              ),
                              onPressed: () {
                                setState(() {
                                  items[index] = item.copyWith(
                                    actualWeight: item.actualWeight + 1,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: context.colorScheme.error,
                          size: 22.sp,
                        ),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  );
                },
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
                onPressed: items.isEmpty
                    ? null
                    : () {
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
      ),
    );
  }
}
