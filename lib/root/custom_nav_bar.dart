import 'dart:ui';
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          height: 88.h,
          decoration: BoxDecoration(
            color: context.colorScheme.surface.withValues(alpha: 0.08),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              navItem(
                icon: Icons.home,
                label: context.tr("home"),
                index: 0,
                context: context,
              ),
              navItem(
                icon: Icons.explore_outlined,
                label: context.tr("explore"),
                index: 1,
                context: context,
              ),
              navItem(
                icon: Icons.school_outlined,
                label: context.tr("my_learning"),
                index: 2,
                context: context,
              ),
              navItem(
                icon: Icons.person,
                label: context.tr("profile"),
                index: 3,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.surface.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurface.withValues(alpha: 0.5),
              size: 24.sp,
            ),
            if (isSelected) ...[
              SizedBox(height: 3.h),
              Text(
                label,
                style: context.textTheme.labelSmall!.copyWith(
                  color: context.colorScheme.primary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
