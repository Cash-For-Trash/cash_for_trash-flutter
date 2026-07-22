import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class QuantitySelectionRequestCollectionSection extends StatelessWidget {
  const QuantitySelectionRequestCollectionSection({super.key});

  static const List<Map<String, String>> _quantities = [
    {'id': 'large_qty', 'labelKey': 'large_qty'},
    {'id': 'medium_qty', 'labelKey': 'medium_qty'},
    {'id': 'small_qty', 'labelKey': 'small_qty'},
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
            context.tr('approximate_quantity'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          BlocBuilder<RequestCollectionBloc, RequestCollectionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: _quantities.map((item) {
                      final id = item['id']!;
                      final labelKey = item['labelKey']!;
                      final isSelected = state.selectedQuantity == id;

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: _buildQuantityPill(
                            context,
                            id: id,
                            labelKey: labelKey,
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (state.exactWeight != null) ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          width: 1.r,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.scale_rounded,
                                size: 18.sp,
                                color: context.colorScheme.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '${context.tr('exact_weight_label')}${state.exactWeight!.toStringAsFixed(1)} ${context.tr('kg_unit')}',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5.sp,
                                  color: context.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              context.read<RequestCollectionBloc>().add(
                                const SetExactWeightEvent(null),
                              );
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18.sp,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityPill(
    BuildContext context, {
    required String id,
    required String labelKey,
    required bool isSelected,
  }) {
    final activeBg = context.colorScheme.primary;
    final inactiveBg = context.colorScheme.surfaceContainerLow;

    return InkWell(
      onTap: () {
        context.read<RequestCollectionBloc>().add(SelectQuantityEvent(id));
        _showExactWeightDialog(context, id);
      },
      borderRadius: BorderRadius.circular(24.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Text(
          context.tr(labelKey),
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? context.colorScheme.onPrimary
                : context.colorScheme.onSurface,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showExactWeightDialog(BuildContext context, String quantityId) {
    final controller = TextEditingController();
    final bloc = context.read<RequestCollectionBloc>();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: dialogContext.colorScheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Text(
                dialogContext.tr('exact_quantity_dialog_title'),
                style: dialogContext.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dialogContext.colorScheme.onSurface,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dialogContext.tr('exact_quantity_dialog_subtitle'),
                    style: dialogContext.textTheme.bodySmall?.copyWith(
                      color: dialogContext.colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) {
                      if (errorMessage != null) {
                        setDialogState(() {
                          errorMessage = null;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: dialogContext.tr('enter_exact_weight_hint'),
                      hintStyle: dialogContext.textTheme.bodyMedium?.copyWith(
                        color: dialogContext.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.6),
                        fontSize: 13.sp,
                      ),
                      suffixText: dialogContext.tr('kg_unit'),
                      suffixStyle: dialogContext.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dialogContext.colorScheme.primary,
                      ),
                      filled: true,
                      fillColor: dialogContext.colorScheme.surfaceContainerLow,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: errorMessage != null
                              ? dialogContext.colorScheme.error
                              : dialogContext.colorScheme.primary,
                          width: 1.5.r,
                        ),
                      ),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      errorMessage!,
                      style: dialogContext.textTheme.bodySmall?.copyWith(
                        color: dialogContext.colorScheme.error,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              actionsPadding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    dialogContext.tr('skip'),
                    style: dialogContext.textTheme.bodyMedium?.copyWith(
                      color: dialogContext.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final input = controller.text.trim();
                    if (input.isEmpty) {
                      Navigator.of(dialogContext).pop();
                      return;
                    }

                    final weight = double.tryParse(input);
                    bool isValid = false;
                    String errorKey = '';

                    if (quantityId == 'small_qty') {
                      if (weight != null && weight > 0 && weight < 10) {
                        isValid = true;
                      } else {
                        errorKey = 'weight_out_of_bounds_small';
                      }
                    } else if (quantityId == 'medium_qty') {
                      if (weight != null && weight >= 10 && weight <= 50) {
                        isValid = true;
                      } else {
                        errorKey = 'weight_out_of_bounds_medium';
                      }
                    } else if (quantityId == 'large_qty') {
                      if (weight != null && weight >= 50) {
                        isValid = true;
                      } else {
                        errorKey = 'weight_out_of_bounds_large';
                      }
                    }

                    if (isValid && weight != null) {
                      bloc.add(SetExactWeightEvent(weight));
                      Navigator.of(dialogContext).pop();
                    } else {
                      setDialogState(() {
                        errorMessage = dialogContext.tr(errorKey);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dialogContext.colorScheme.primary,
                    foregroundColor: dialogContext.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    dialogContext.tr('confirm'),
                    style: dialogContext.textTheme.bodyMedium?.copyWith(
                      color: dialogContext.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
