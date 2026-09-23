import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/utils/auth_validations.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/create_worker_request_model.dart';
import '../bloc/supervisor_bloc.dart';
import '../bloc/supervisor_event.dart';
import '../bloc/supervisor_state.dart';

class CreateWorkerSupervisorScreen extends StatefulWidget {
  const CreateWorkerSupervisorScreen({super.key});

  @override
  State<CreateWorkerSupervisorScreen> createState() =>
      _CreateWorkerSupervisorScreenState();
}

class _CreateWorkerSupervisorScreenState
    extends State<CreateWorkerSupervisorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = CreateWorkerRequestModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        mobile: _mobileController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
      );

      context
          .read<SupervisorBloc>()
          .add(CreateSupervisorWorkerEvent(request));
    }
  }

  String? _validateNationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('field_required');
    }
    if (value.trim().length < 10) {
      return context.tr('invalid_number');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.tr('create_new_worker'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<SupervisorBloc, SupervisorState>(
          listener: (context, state) {
            if (state.createWorkerStatus == CreateWorkerStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('worker_created_success')),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop();
            } else if (state.createWorkerStatus == CreateWorkerStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.createWorkerErrorMessage.isNotEmpty
                        ? state.createWorkerErrorMessage
                        : context.tr('something_went_wrong'),
                  ),
                  backgroundColor: context.colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading =
                state.createWorkerStatus == CreateWorkerStatus.loading;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('create_new_worker'),
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      context.tr('sign_in_to_continue'),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: _firstNameController,
                            hintText: context.tr('first_name'),
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              size: 20.r,
                            ),
                            validator: validateFirstName,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomTextFormField(
                            controller: _lastNameController,
                            hintText: context.tr('last_name'),
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              size: 20.r,
                            ),
                            validator: validateLastName,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: context.tr('email_address'),
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.alternate_email_rounded,
                        size: 20.r,
                      ),
                      validator: validateEmail,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _passwordController,
                      hintText: context.tr('password'),
                      isPassword: true,
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        size: 20.r,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return context.tr('field_required');
                        }
                        if (val.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _mobileController,
                      hintText: context.tr('mobile'),
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(
                        Icons.phone_android_rounded,
                        size: 20.r,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return context.tr('field_required');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _nationalIdController,
                      hintText: context.tr('national_id'),
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        size: 20.r,
                      ),
                      validator: _validateNationalId,
                    ),
                    SizedBox(height: 32.h),
                    CustomPrimaryButton(
                      text: isLoading
                          ? context.tr('creating_worker')
                          : context.tr('create_worker'),
                      prefixIcon: isLoading
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.person_add_rounded),
                      onTap: isLoading ? null : _submitForm,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
