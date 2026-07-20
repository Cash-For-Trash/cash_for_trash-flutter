import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/theme/app_assets.dart';
import 'package:cash_for_trash/core/utils/auth_validations.dart';
import 'package:cash_for_trash/core/utils/get_responsive_size.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: resetPasswordFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      AppAssets.appLogoPng,
                      width: 120.w,
                      height: 120.w,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      context.tr('cash_for_trash'),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    context.tr('create_new_password'),
                    style: context.textTheme.displaySmall!.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 30.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    context.tr('new_password_must_be_different'),
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: 12.h),
                  CustomTextFormField(
                    controller: newPasswordController,
                    hintText: context.tr('new_password'),
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: context.isDesktop ? 22 : 18.w,
                    ),
                    validator: (value) => validatePassword(value),
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  SizedBox(height: 16.h),

                  CustomTextFormField(
                    controller: confirmNewPasswordController,
                    hintText: context.tr('confirm_new_password'),
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_reset_rounded,
                      size: context.isDesktop ? 22 : 18.w,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('please_confirm_password');
                      }
                      if (value != newPasswordController.text) {
                        return context.tr('passwords_do_not_match');
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  SizedBox(height: 32.h),

                  CustomPrimaryButton(
                    text: context.tr('updating'),
                    // : context.tr('update_password'),
                    onTap: null,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            Center(
              child: SizedBox(
                width: 200,
                child: CustomPrimaryButton(
                  text: context.tr('back_to_login'),
                  onTap: () => context.go(AppRoutes.loginScreen),
                  width: double.infinity,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                      (states) => context.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
