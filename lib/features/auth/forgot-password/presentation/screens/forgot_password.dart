import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/utils/auth_validations.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              "Forgot Password",
              style: context.textTheme.titleLarge?.copyWith(
                color: context.theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Enter your email address to reset your password",
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.colorScheme.primary,
              ),
            ),

            SizedBox(height: 30.h),
            CustomTextFormField(
              controller: _emailcontroller,
              hintText: context.tr('email_address'),
              prefixIcon: Icon(Icons.alternate_email_rounded, size: 22.sp),
              validator: (value) => validateEmail(value),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 30.h),
            Center(
              child: CustomPrimaryButton(
                text: context.tr('send_reset_link'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
