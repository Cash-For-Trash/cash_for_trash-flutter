import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/customer_admin_model.dart';

class CustomerCardCustomersAdminWidget extends StatelessWidget {
  final CustomerAdminModel customer;
  final VoidCallback onTap;

  const CustomerCardCustomersAdminWidget({
    super.key,
    required this.customer,
    required this.onTap,
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
            Icons.person_outline_rounded,
            color: context.colorScheme.primary,
          ),
        ),
        title: Text(
          customer.fullName.isNotEmpty
              ? customer.fullName
              : (customer.email ?? 'Customer #${customer.id}'),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(customer.email ?? ''),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            '${customer.points ?? 0} pts',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
