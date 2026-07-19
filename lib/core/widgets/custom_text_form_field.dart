import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/utils/get_responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final double? width;
  final double? height;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.width,
    this.height,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        width: widget.width?.w,
        child: Material(
          type: MaterialType.transparency,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            validator: widget.validator,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.isPassword ? _obscureText : false,
            style: context.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.height ?? (context.isDesktop ? 12 : 12.h),
                horizontal: context.isDesktop ? 12 : 12.w,
              ),
              prefixIconColor: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.7,
              ),
              suffixIconColor: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.7,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    )
                  : widget.suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}
