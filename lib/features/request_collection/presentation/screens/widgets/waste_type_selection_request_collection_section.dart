import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasteTypeSelectionRequestCollectionSection extends StatelessWidget {
  const WasteTypeSelectionRequestCollectionSection({super.key});

  static const List<Map<String, dynamic>> _wasteTypes = [
    {'id': 'plastic', 'labelKey': 'plastic', 'icon': Icons.recycling_rounded},
    {
      'id': 'paper_and_cardboard',
      'labelKey': 'paper_and_cardboard',
      'icon': Icons.inventory_2_outlined,
    },
    {'id': 'metals', 'labelKey': 'metals', 'icon': Icons.hardware_outlined},
    {'id': 'glass', 'labelKey': 'glass', 'icon': Icons.local_bar_outlined},
    {
      'id': 'electronic_waste',
      'labelKey': 'electronic_waste',
      'icon': Icons.devices_outlined,
    },
    {'id': 'mixed', 'labelKey': 'mixed', 'icon': Icons.delete_outline_rounded},
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
            context.tr('waste_type_title'),
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
                itemCount: _wasteTypes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final item = _wasteTypes[index];
                  final String id = item['id'] as String;
                  final String labelKey = item['labelKey'] as String;
                  final IconData icon = item['icon'] as IconData;
                  final isSelected = state.selectedWasteTypes.contains(id);

                  return _buildTypeCard(
                    context,
                    id: id,
                    labelKey: labelKey,
                    icon: icon,
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
    required String id,
    required String labelKey,
    required IconData icon,
    required bool isSelected,
  }) {
    final activeColor = context.colorScheme.primary;
    final inactiveBg = context.colorScheme.surfaceContainerLow;
    final activeBg = context.colorScheme.primaryContainer.withValues(
      alpha: 0.35,
    );

    return InkWell(
      onTap: () {
        context.read<RequestCollectionBloc>().add(ToggleWasteTypeEvent(id));
      },
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
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
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? activeColor
                    : context.colorScheme.surfaceContainerHighest,
              ),
              child: Icon(
                icon,
                size: 22.sp,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              context.tr(labelKey),
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? activeColor
                    : context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
