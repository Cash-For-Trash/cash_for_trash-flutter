import 'dart:async';
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/features/auth/otp/presentation/bloc/otp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _start = 600; // 10 minutes
  String _otpCode = '';
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 600;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _pinController.dispose();
    super.dispose();
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: context.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: context.colorScheme.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: context.colorScheme.primary.withValues(alpha: 0.1),
        border: Border.all(color: context.colorScheme.primary, width: 2),
      ),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state is OtpVerifySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.verifyModel.message),
                  backgroundColor: Colors.green,
                ),
              );
              context.go(AppRoutes.loginScreen);
            } else if (state is OtpVerifyFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is OtpResendSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.resendModel.message),
                  backgroundColor: Colors.green,
                ),
              );
              startTimer(); // Restart timer
            } else if (state is OtpResendFailure) {
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: context.colorScheme.primary,
                            size: 20.w,
                          ),
                        ),
                        onPressed: () =>
                            context.replace(AppRoutes.registerScreen),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.verified_outlined,
                        size: 40.w,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      context.tr('verify_otp'),
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      context.tr('otp_subtitle'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Pinput(
                      length: 6,
                      controller: _pinController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      onChanged: (value) {
                        _otpCode = value;
                        setState(() {});
                      },
                      onCompleted: (pin) {
                        context.read<OtpBloc>().add(
                          VerifyOtpPressed(email: widget.email, otp: pin),
                        );
                      },
                      animationCurve: Curves.easeInOut,
                      animationDuration: const Duration(milliseconds: 300),
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _start > 0
                              ? context.tr('resend_code_in')
                              : context.tr('didnt_receive_code'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        if (_start > 0)
                          Text(
                            timerText,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.primary,
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: state is OtpResendLoading
                                ? null
                                : () {
                                    context.read<OtpBloc>().add(
                                      ResendOtpPressed(email: widget.email),
                                    );
                                  },
                            child: state is OtpResendLoading
                                ? SizedBox(
                                    height: 16.h,
                                    width: 16.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: context.colorScheme.primary,
                                    ),
                                  )
                                : Text(
                                    context.tr('resend_now'),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                          ),
                      ],
                    ),
                    SizedBox(height: 100.h),
                    CustomPrimaryButton(
                      text: state is OtpVerifyLoading
                          ? context.tr('verifying')
                          : context.tr('verify_otp'),
                      prefixIcon: state is OtpVerifyLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 20.w,
                            ),
                      onTap: state is OtpVerifyLoading || _otpCode.length < 6
                          ? null
                          : () {
                              context.read<OtpBloc>().add(
                                VerifyOtpPressed(
                                  email: widget.email,
                                  otp: _otpCode,
                                ),
                              );
                            },
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
