import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:cash_for_trash/features/payment/presentation/bloc/payment_event.dart';
import 'package:cash_for_trash/features/payment/presentation/bloc/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CardPaymentScreen extends StatefulWidget {
  final String collectionRequestId;

  const CardPaymentScreen({super.key, required this.collectionRequestId});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _obscureCvv = true;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<PaymentBloc>().add(
        InitiatePaymentEvent(widget.collectionRequestId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccessState) {
          _showSuccessDialog(context);
        } else if (state is PaymentErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: context.colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: context.colorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: context.colorScheme.onSurface,
              size: 20.r,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            context.tr('card_payment'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: context.colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardPreviewWidget(
                  cardNumber: _cardNumberController.text,
                  cardHolder: _cardHolderController.text,
                  expiry: _expiryController.text,
                ),
                SizedBox(height: 32.h),
                Text(
                  context.tr('card_details'),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16.h),
                _CardTextField(
                  controller: _cardNumberController,
                  label: context.tr('card_number'),
                  hint: '0000 0000 0000 0000',
                  icon: Icons.credit_card_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    _CardNumberFormatter(),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.replaceAll(' ', '').length < 16) {
                      return context.tr('invalid_card_number');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14.h),
                _CardTextField(
                  controller: _cardHolderController,
                  label: context.tr('card_holder_name'),
                  hint: context.tr('card_holder_hint'),
                  icon: Icons.person_outline_rounded,
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return context.tr('field_required');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: _CardTextField(
                        controller: _expiryController,
                        label: context.tr('expiry_date'),
                        hint: 'MM/YY',
                        icon: Icons.calendar_today_rounded,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          _ExpiryFormatter(),
                        ],
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          if (v == null || v.length < 5) {
                            return context.tr('invalid_expiry');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _CardTextField(
                        controller: _cvvController,
                        label: 'CVV',
                        hint: '***',
                        icon: Icons.lock_outline_rounded,
                        keyboardType: TextInputType.number,
                        obscureText: _obscureCvv,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCvv
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: context.colorScheme.onSurfaceVariant,
                            size: 18.r,
                          ),
                          onPressed: () =>
                              setState(() => _obscureCvv = !_obscureCvv),
                        ),
                        validator: (v) {
                          if (v == null || v.length < 3) {
                            return context.tr('invalid_cvv');
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: state is PaymentLoadingState
                            ? null
                            : () => _submit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          foregroundColor: context.colorScheme.onPrimary,
                          disabledBackgroundColor: context.colorScheme.primary
                              .withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: state is PaymentLoadingState
                            ? SizedBox(
                                width: 24.r,
                                height: 24.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: context.colorScheme.onPrimary,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    size: 18.r,
                                    color: context.colorScheme.onPrimary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    context.tr('pay_now'),
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(
                                          color: context.colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.security_rounded,
                        size: 14.r,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        context.tr('secure_payment'),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: context.colorScheme.surfaceContainerLowest,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: context.colorScheme.onPrimary,
                  size: 44.r,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                context.tr('card_payment_success'),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                context.tr('card_payment_success_desc'),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontSize: 13.sp,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.homeScreen),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                    foregroundColor: context.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    context.tr('track_order_now'),
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardPreviewWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiry;

  const _CardPreviewWidget({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    final displayNumber = cardNumber.isEmpty
        ? '**** **** **** ****'
        : cardNumber.padRight(19, '*').substring(0, 19);

    return Container(
      width: double.infinity,
      height: 190.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.credit_card_rounded,
                color: context.colorScheme.onPrimary.withValues(alpha: 0.9),
                size: 32.r,
              ),
              Text(
                'PAYMOB',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          Text(
            displayNumber,
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onPrimary,
              fontSize: 20.sp,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onPrimary.withValues(
                        alpha: 0.6,
                      ),
                      fontSize: 9.sp,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    cardHolder.isEmpty ? '—' : cardHolder.toUpperCase(),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onPrimary.withValues(
                        alpha: 0.6,
                      ),
                      fontSize: 9.sp,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    expiry.isEmpty ? 'MM/YY' : expiry,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const _CardTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 15.sp,
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.5,
              ),
            ),
            prefixIcon: Icon(
              icon,
              color: context.colorScheme.primary,
              size: 20.r,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: context.colorScheme.surfaceContainerLowest,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: context.colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: context.colorScheme.outlineVariant,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: context.colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: context.colorScheme.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
