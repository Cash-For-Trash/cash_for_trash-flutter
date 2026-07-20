import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

class MenuGroupProfileSection extends StatelessWidget {
  final String groupTitle;
  final List<ProfileMenuItem> items;

  const MenuGroupProfileSection({
    super.key,
    required this.groupTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            groupTitle,
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            border: Border.all(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.1),
              width: 0.8.w,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 3.h,
                offset: Offset(0, 1.h),
              ),
            ],
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: [
                  ListTile(
                    onTap: item.onTap,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    leading: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        item.icon,
                        color: context.colorScheme.primary,
                        size: 18.w,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: item.subtitle != null
                        ? Text(
                            item.subtitle!,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          )
                        : null,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.w,
                      color: context.colorScheme.outline,
                    ),
                  ),
                  if (index < items.length - 1)
                    Divider(
                      height: 3.h,
                      thickness: 0.8.h,
                      color: context.colorScheme.outlineVariant,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
