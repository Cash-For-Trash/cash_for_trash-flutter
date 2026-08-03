import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/area_admin_model.dart';

class AreaCardAreasAdminWidget extends StatelessWidget {
  final AreaAdminModel area;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const AreaCardAreasAdminWidget({
    super.key,
    required this.area,
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
            Icons.map_rounded,
            color: context.colorScheme.primary,
          ),
        ),
        title: Text(
          area.name,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${context.tr('admin_service_price')}: ${area.servicePrice} ${context.tr('currency_egp')}',
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
