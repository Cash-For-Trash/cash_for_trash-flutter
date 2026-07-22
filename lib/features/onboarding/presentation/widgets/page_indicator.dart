import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: index == currentIndex ? 28.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: index == currentIndex
                ? context.colorScheme.primary
                : context.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}
