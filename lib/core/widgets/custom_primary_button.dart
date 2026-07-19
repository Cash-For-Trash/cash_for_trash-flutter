// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/utils/get_responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? iconPadding;
  final double? iconSize;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final Color? color;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.width,
    this.height,
    this.iconPadding,
    this.iconSize,
    this.textStyle,
    this.style,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultColor =
        textStyle?.color ??
        style?.foregroundColor?.resolve({}) ??
        context.colorScheme.onPrimary;

    return SizedBox(
      width: width?.w ?? (context.isDesktop ? 320 : 278.w),
      height: height?.h ?? (context.isDesktop ? 48 : 50.h),
      child: ElevatedButton(
        onPressed: onTap,

        style: style ?? ElevatedButton.styleFrom(backgroundColor: color),
        child: IconTheme(
          data: IconThemeData(
            color: defaultColor,
            size: iconSize ?? (context.isDesktop ? 20 : 20.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                SizedBox(width: iconPadding ?? (context.isDesktop ? 8 : 8.w)),
              ],

              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  style: (textStyle ?? context.textTheme.labelLarge)?.copyWith(
                    color: defaultColor,
                  ),
                ),
              ),

              if (suffixIcon != null) ...[
                SizedBox(width: iconPadding ?? (context.isDesktop ? 8 : 8.w)),
                suffixIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
