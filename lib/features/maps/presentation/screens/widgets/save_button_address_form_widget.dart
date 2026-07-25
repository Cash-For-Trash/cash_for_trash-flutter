import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaveButtonAddressFormWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SaveButtonAddressFormWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomPrimaryButton(
        text: isLoading
            ? context.tr('saving')
            : context.tr('save_address'),
        width: double.infinity,
        onTap: isLoading ? null : onPressed,
        prefixIcon: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.h,
                child: CircularProgressIndicator(
                  color: context.colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save_rounded),
      ),
    );
  }
}
