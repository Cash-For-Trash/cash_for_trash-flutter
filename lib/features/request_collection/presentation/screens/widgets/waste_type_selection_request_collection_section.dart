// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/request_collection/data/model/garbage_type_model.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasteTypeSelectionRequestCollectionSection extends StatelessWidget {
  const WasteTypeSelectionRequestCollectionSection({super.key});

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
            context.tr('waste_type_title'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          BlocBuilder<RequestCollectionBloc, RequestCollectionState>(
            builder: (context, state) {
              if (state.isGarbageTypesLoading) {
                return SizedBox(
                  height: 160.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.colorScheme.primary,
                    ),
                  ),
                );
              }

              if (state.garbageTypesErrorMessage != null) {
                return _buildStatusMessage(
                  context,
                  message: state.garbageTypesErrorMessage!,
                  icon: Icons.error_outline_rounded,
                  iconColor: context.colorScheme.error,
                  iconBgColor: context.colorScheme.errorContainer.withValues(
                    alpha: 0.35,
                  ),
                );
              }

              if (state.garbageTypes.isEmpty) {
                return _buildStatusMessage(
                  context,
                  message: context.tr('no_waste_types_available'),
                  icon: Icons.recycling_rounded,
                  iconColor: context.colorScheme.primary,
                  iconBgColor: context.colorScheme.primaryContainer.withValues(
                    alpha: 0.5,
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.garbageTypes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final item = state.garbageTypes[index];
                  final isSelected = state.selectedWasteTypes.contains(
                    item.garbageTypeId,
                  );

                  return _buildTypeCard(
                    context,
                    item: item,
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

  Widget _buildTypeCard(
    BuildContext context, {
    required GarbageTypeItemModel item,
    required bool isSelected,
  }) {
    final activeColor = context.colorScheme.primary;
    final inactiveBg = context.colorScheme.surfaceContainerLow.withValues(
      alpha: 0.5,
    );
    final activeBg = context.colorScheme.primaryContainer.withValues(
      alpha: 0.12,
    );

    return InkWell(
      onTap: () {
        context.read<RequestCollectionBloc>().add(
          ToggleWasteTypeEvent(item.garbageTypeId),
        );
      },
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 1.5.r,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? activeColor
                    : context.colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
              ),
              // child: Icon(
              //   _getIconForWasteType(item.garbageTypeName),
              //   size: 24.sp,
              //   color: isSelected
              //       ? context.colorScheme.onPrimary
              //       : context.colorScheme.onSurfaceVariant.withValues(
              //           alpha: 0.6,
              //         ),
              // ),
              // In case we want to use the network images again:
              child: CachedNetworkImage(
                imageUrl: item.garbageTypeImage,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                placeholder: (context, url) => SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colorScheme.primary,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.recycling_rounded,
                  size: 22.sp,
                  color: isSelected
                      ? context.colorScheme.onPrimary
                      : context.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              item.garbageTypeName,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? activeColor
                    : context.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              '${item.pricePerKg} ${context.tr('currency_egp')}/${context.tr('kg')}',
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? activeColor.withValues(alpha: 0.9)
                    : context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    final cleanMessage = message
        .replaceAll(
          RegExp(r'^\.?(Not found|Error):\s*', caseSensitive: false),
          '',
        )
        .trim();
    final displayMessage = cleanMessage.isNotEmpty
        ? cleanMessage
        : context.tr('failed_to_load_waste_types');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            displayMessage,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          OutlinedButton.icon(
            onPressed: () {
              context.read<RequestCollectionBloc>().add(
                const GetGarbageTypesEvent(),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.primary,
              side: BorderSide(
                color: context.colorScheme.primary.withValues(alpha: 0.4),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            ),
            icon: Icon(Icons.refresh_rounded, size: 16.sp),
            label: Text(
              context.tr('retry'),
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForWasteType(String typeName) {
    final lower = typeName.toLowerCase();
    if (lower.contains('plastic') || lower.contains('بلاستيك')) {
      return Icons.layers_outlined;
    } else if (lower.contains('paper') ||
        lower.contains('cardboard') ||
        lower.contains('ورق') ||
        lower.contains('كرتون')) {
      return Icons.inventory_2_outlined;
    } else if (lower.contains('metal') || lower.contains('معادن')) {
      return Icons.bolt_outlined;
    } else if (lower.contains('glass') || lower.contains('زجاج')) {
      return Icons.diamond_outlined;
    } else if (lower.contains('organic') || lower.contains('عضوية')) {
      return Icons.eco_outlined;
    } else if (lower.contains('mixed') || lower.contains('مختلطة')) {
      return Icons.delete_outline;
    }
    return Icons.recycling_rounded;
  }
}
