import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/garbage_type_admin_model.dart';

class GarbageTypeCardGarbageTypesAdminWidget extends StatelessWidget {
  final GarbageTypeAdminModel item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const GarbageTypeCardGarbageTypesAdminWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.all(12.r),
        leading: CircleAvatar(
          backgroundColor: context.colorScheme.primaryContainer,
          child: Icon(
            Icons.delete_sweep_rounded,
            color: context.colorScheme.primary,
          ),
        ),
        title: Text(
          item.name,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${context.tr('admin_price_per_kg')}: ${item.pricePerKg} ${context.tr('currency_egp')}',
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
