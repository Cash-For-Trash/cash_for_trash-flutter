import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/utils/auth_validations.dart';
import 'package:cash_for_trash/core/utils/get_responsive_size.dart';
import 'package:cash_for_trash/core/widgets/auth_toggle_widget.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:cash_for_trash/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String selectedRole = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.registerModel.message),
                  backgroundColor: Colors.green,
                ),
              );
              context.go(
                AppRoutes.verifyOtpScreen,
                extra: _emailcontroller.text,
              );
            } else if (state is RegisterFailure) {
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
                      SizedBox(height: 60.h),
                      Text(
                        context.tr('start_clean_journey'),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.tr('create_account_commit'),
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      const AuthToggleWidget(isLogin: false),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: _firstNameController,
                              hintText: context.tr('first_name'),
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                size: context.isDesktop ? 22 : 22.w,
                              ),
                              validator: (value) => validateFirstName(value),
                            ),
                          ),
                          SizedBox(width: context.isDesktop ? 16 : 15.w),
                          Expanded(
                            child: CustomTextFormField(
                              controller: _lastNameController,
                              hintText: context.tr('last_name'),
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                size: context.isDesktop ? 22 : 22.w,
                              ),
                              validator: (value) => validateLastName(value),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
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
                        controller: _phonecontroller,
                        hintText: context.tr('phone'),
                        prefixIcon: Icon(
                          Icons.phone_rounded,
                          size: context.isDesktop ? 22 : 22.w,
                        ),
                        validator: (value) => validatephone(value),
                        keyboardType: TextInputType.phone,
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
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        hintText: context.tr('confirm_password'),
                        isPassword: true,
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: context.isDesktop ? 22 : 22.w,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.tr('please_confirm_password');
                          }
                          if (value != _passwordController.text) {
                            return context.tr('passwords_do_not_match');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Text(context.tr('register_as')),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => setState(() => selectedRole = "customer"),
                            child: Row(
                              children: [
                                Icon(
                                  selectedRole == "customer"
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: context.colorScheme.primary,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(context.tr('customer')),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => setState(() => selectedRole = "worker"),
                            child: Row(
                              children: [
                                Icon(
                                  selectedRole == "worker"
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: context.colorScheme.primary,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(context.tr('worker')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      CustomPrimaryButton(
                        text: state is RegisterLoading
                            ? context.tr('creating_account')
                            : context.tr('create_account'),
                        prefixIcon: state is RegisterLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : null,
                        onTap: state is RegisterLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  if (selectedRole.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.tr('please_select_role'),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  context.read<RegisterBloc>().add(
                                    RegisterButtonPressed(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      phone: _phonecontroller.text,
                                      email: _emailcontroller.text,
                                      password: _passwordController.text,
                                      confirmPassword:
                                          _confirmPasswordController.text,
                                      role: selectedRole,
                                    ),
                                  );
                                }
                              },
                        width: double.infinity,
                      ),

                      SizedBox(height: 10.h),
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
                          onTap: () => context.go(AppRoutes.loginScreen),
                          child: RichText(
                            text: TextSpan(
                              text: context.tr('already_have_account'),
                              style: context.textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: context.tr('sign_in'),
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
