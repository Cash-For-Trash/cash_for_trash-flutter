// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double? iconPadding;
  final double? iconSize;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final Color? color;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.width,
    this.height,
    this.iconPadding,
    this.iconSize,
    this.style,
    this.textStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // final Color defaultColor =
    //     style?.foregroundColor?.resolve({}) ?? context.colorScheme.primary;
    final Color defaultColor =
        textStyle?.color ??
        style?.foregroundColor?.resolve({}) ??
        context.colorScheme.primary;

    return SizedBox(
      width: width?.w ?? 278.w,
      height: height?.h ?? 50.h,
      child: OutlinedButton(
        style: style,
        onPressed: onTap,

        child: IconTheme(
          data: IconThemeData(color: defaultColor, size: iconSize?.w ?? 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if prefix icon exists
              if (prefixIcon != null) ...[
                prefixIcon!,
                SizedBox(width: iconPadding?.w ?? 8.w),
              ],

              Flexible(
                child: Text(
                  text,
                  style: (textStyle ?? context.textTheme.labelLarge)?.copyWith(
                    color: defaultColor,
                  ),
                ),
              ),

              // if suffix icon exists
              if (suffixIcon != null) ...[
                SizedBox(width: iconPadding?.w ?? 8.w),
                suffixIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
