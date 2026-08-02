import 'package:cash_for_trash/core/constants/user_role.dart';
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/theme/app_assets.dart';
import 'package:cash_for_trash/core/utils/auth_validations.dart';
import 'package:cash_for_trash/core/utils/get_responsive_size.dart';
import 'package:cash_for_trash/core/widgets/auth_toggle_widget.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:cash_for_trash/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.loginModel.message),
                  backgroundColor: Colors.green,
                ),
              );
              final String userRole = state.loginModel.data.user.role;
              if (userRole == UserRole.customer.value) {
                context.go(AppRoutes.homeScreen);
              } else if (userRole == UserRole.worker.value) {
                context.go(AppRoutes.workerHomeScreen);
              } else if (userRole == UserRole.admin.value) {
                context.go(AppRoutes.adminHomeScreen);
              }
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.h),
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
                        context.tr('welcome_back'),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.tr('sign_in_to_continue'),
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      const AuthToggleWidget(isLogin: true),
                      SizedBox(height: 24.h),
                      CustomTextFormField(
                        controller: _emailcontroller,
                        hintText: context.tr('email_address'),
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          size: context.isDesktop ? 22 : 22.w,
                        ),
                        validator: (value) => validateEmail(value),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: context.tr('password'),
                        isPassword: true,
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: context.isDesktop ? 22 : 22.w,
                        ),
                        validator: (value) => validatePassword(value),
                      ),
                      SizedBox(height: 32.h),
                      CustomPrimaryButton(
                        text: state is LoginLoading
                            ? context.tr('loading')
                            : context.tr('sign_in'),
                        prefixIcon: state is LoginLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : null,
                        onTap: state is LoginLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginBloc>().add(
                                    LoginButtonPressed(
                                      email: _emailcontroller.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                }
                              },
                        width: double.infinity,
                      ),
                      // SizedBox(height: 5.h),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () {
                            context.push(AppRoutes.forgotPasswordScreen);
                          },
                          child: Text(context.tr('Forget Password?')),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(278.w, 50.h),
                            side: BorderSide(
                              color: context.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            context.tr('continue_as_guest'),
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.go(AppRoutes.registerScreen),
                          child: RichText(
                            text: TextSpan(
                              text: context.tr('do_not_have_account'),
                              style: context.textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: context.tr('create_account'),
                                  style: TextStyle(
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
