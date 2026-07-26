import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmButtonMapsWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmButtonMapsWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomPrimaryButton(
        text: context.tr('confirm_location'),
        onTap: onPressed,
        width: 1.sw,
      ),
    );
  }
}
