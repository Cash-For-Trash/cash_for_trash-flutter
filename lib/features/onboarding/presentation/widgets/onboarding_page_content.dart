import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.body,
  });

  final String imagePath;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Image.asset(imagePath, height: 320.h, fit: BoxFit.contain),
          SizedBox(height: 32.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            body,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.6,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
