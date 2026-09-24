import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:cash_for_trash/features/payment/presentation/screens/widgets/payment_method_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomBarRequestCollectionWidget extends StatelessWidget {
  const BottomBarRequestCollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom: MediaQuery.paddingOf(context).bottom + 16.h,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BlocBuilder<RequestCollectionBloc, RequestCollectionState>(
        builder: (context, state) {
          final requiresWasteDetails =
              state.selectedCollectionType == 'recyclable_only' ||
              state.selectedCollectionType == 'furniture';
          final isReady =
              (!requiresWasteDetails || state.selectedWasteTypes.isNotEmpty) &&
              state.selectedAddress != null &&
              state.selectedAvailability != null;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: isReady
                      ? () {
                          if (state.selectedCollectionType ==
                              'recyclable_only') {
                            context.read<RequestCollectionBloc>().add(
                              const SubmitCollectionRequestEvent(
                                paymentMethod: 'CASH',
                              ),
                            );
                          } else {
                            PaymentMethodBottomSheet.show(
                              context,
                              state.cost ?? 0.0,
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colorScheme.primary,
                    foregroundColor: context.colorScheme.onPrimary,
                    disabledBackgroundColor: context.colorScheme.outlineVariant,
                    disabledForegroundColor:
                        context.colorScheme.onSurfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    context.tr(
                      state.selectedCollectionType == 'recyclable_only'
                          ? 'confirm_free_request'
                          : 'proceed_to_payment',
                    ),
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
    );
  }
}
