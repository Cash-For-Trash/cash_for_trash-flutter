import 'package:cash_for_trash/core/di/service_locator.dart';
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:cash_for_trash/features/payment/presentation/bloc/payment_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/success_collection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodBottomSheet extends StatefulWidget {
  final double cost;

  const PaymentMethodBottomSheet({super.key, required this.cost});

  static Future<void> show(BuildContext context, double cost) {
    final requestBloc = context.read<RequestCollectionBloc>();
    final paymentBloc = context.read<PaymentBloc>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: requestBloc),
          BlocProvider.value(value: paymentBloc),
        ],
        child: PaymentMethodBottomSheet(cost: cost),
      ),
    );
  }

  @override
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  String _selected = 'CASH';

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestCollectionBloc, RequestCollectionState>(
      listenWhen: (prev, curr) =>
          curr.submitSuccess != prev.submitSuccess ||
          curr.submitErrorMessage != prev.submitErrorMessage,
      listener: (context, state) {
        if (state.submitSuccess && state.collectionRequestResponse != null) {
          final collectionRequestId =
              state.collectionRequestResponse!.data.collectionRequestId;
          final paymentMethod =
              state.collectionRequestResponse!.data.paymentMethod;
          final paymentBloc = context.read<PaymentBloc>();
          context.pop();
          if (paymentMethod == 'CARD') {
            paymentBloc.add(
              InitiatePaymentCardEvent(collectionRequestId),
            );
          } else {
            _showCashPaymentDialog(context, collectionRequestId);
          }
        } else if (state.submitErrorMessage != null) {
          context.pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        padding: EdgeInsets.fromLTRB(
          24.w,
          20.h,
          24.w,
          MediaQuery.paddingOf(context).bottom + 24.h,
        ),
        child: BlocBuilder<RequestCollectionBloc, RequestCollectionState>(
          buildWhen: (prev, curr) => curr.isSubmitting != prev.isSubmitting,
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: context.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  context.tr('choose_payment_method'),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '${context.tr('total_amount')}: ${widget.cost.toStringAsFixed(0)} ${context.tr('currency_egp')}',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                _PaymentOptionTile(
                  label: context.tr('cash_payment'),
                  subtitle: context.tr('cash_payment_subtitle'),
                  icon: Icons.payments_rounded,
                  value: 'CASH',
                  selected: _selected,
                  onTap: () => setState(() => _selected = 'CASH'),
                ),
                SizedBox(height: 12.h),
                _PaymentOptionTile(
                  label: context.tr('card_payment'),
                  subtitle: context.tr('card_payment_subtitle'),
                  icon: Icons.credit_card_rounded,
                  value: 'CARD',
                  selected: _selected,
                  onTap: () => setState(() => _selected = 'CARD'),
                ),
                SizedBox(height: 28.h),
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            context.read<RequestCollectionBloc>().add(
                              SubmitCollectionRequestEvent(
                                paymentMethod: _selected,
                              ),
                            );
                          },
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
                    child: state.isSubmitting
                        ? SizedBox(
                            width: 22.r,
                            height: 22.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: context.colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            context.tr('confirm_payment_method'),
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCashPaymentDialog(
    BuildContext context,
    String collectionRequestId,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider(
        create: (_) =>
            sl<PaymentBloc>()
              ..add(InitiatePaymentCashEvent(collectionRequestId)),
        child: const SuccessCollectionDialog(),
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primaryContainer
              : context.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colorScheme.onSurfaceVariant,
                size: 24.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: isSelected
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selected,
              onChanged: (_) => onTap(),
              activeColor: context.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
