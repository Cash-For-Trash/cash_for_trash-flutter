import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:cash_for_trash/features/payment/presentation/bloc/payment_state.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/bottom_bar_request_collection_widget.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/header_request_collection_widget.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/image_upload_request_collection_section.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/location_request_collection_section.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/quantity_selection_request_collection_section.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/success_collection_dialog.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/time_slot_request_collection_section.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/waste_type_selection_request_collection_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RequestCollectionScreen extends StatelessWidget {
  final bool isFromBottomNav;

  const RequestCollectionScreen({super.key, this.isFromBottomNav = false});

  String _resolveError(BuildContext context, String key) {
    final known = {
      'waste_type_required',
      'address_required',
      'availability_required',
    };
    if (known.contains(key)) return context.tr(key);
    return key;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RequestCollectionBloc, RequestCollectionState>(
          listenWhen: (prev, curr) =>
              curr.submitErrorMessage != prev.submitErrorMessage ||
              curr.submitSuccess != prev.submitSuccess,
          listener: (context, state) {
            if (state.submitErrorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _resolveError(context, state.submitErrorMessage!),
                  ),
                  backgroundColor: context.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              );
            } else if (state.submitSuccess &&
                state.selectedCollectionType == 'recyclable_only') {
              SuccessCollectionDialog.show(context);
            }
          },
        ),
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('card_payment_success')),
                  backgroundColor: context.colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              );
              context.go(AppRoutes.homeScreen);
            } else if (state is PaymentErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: context.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              );
            } else if (state is PaymentInitiatePaymentCardSuccessState) {
              context.push(AppRoutes.paymentWebView, extra: state.iFrameUrl);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Column(
          children: [
            HeaderRequestCollectionWidget(isFromBottomNav: isFromBottomNav),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: [
                    _buildCollectionTypeSection(context),
                    SizedBox(height: 16.h),
                    BlocBuilder<RequestCollectionBloc, RequestCollectionState>(
                      builder: (context, state) {
                        final showWasteDetails =
                            state.selectedCollectionType == 'recyclable_only' ||
                            state.selectedCollectionType == 'furniture' ||
                            state.selectedCollectionType == 'household';
                        if (!showWasteDetails) {
                          return const SizedBox.shrink();
                        }
                        return const Column(
                          children: [
                            WasteTypeSelectionRequestCollectionSection(),
                            SizedBox(height: 16),
                            QuantitySelectionRequestCollectionSection(),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                    _buildExpandableSection(
                      context,
                      icon: Icons.local_shipping_outlined,
                      title: context.tr('pickup_details'),
                      subtitle: context.tr('pickup_details_hint'),
                      children: const [
                        LocationRequestCollectionSection(),
                        SizedBox(height: 12),
                        TimeSlotRequestCollectionSection(),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 12.h),
                        _buildExpandableSection(
                          context,
                          icon: Icons.photo_camera_outlined,
                          title: context.tr('waste_picture_optional'),
                          subtitle: context.tr('optional_photo_hint'),
                          children: const [
                            ImageUploadRequestCollectionSection(),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            const BottomBarRequestCollectionWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        childrenPadding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Container(
          padding: EdgeInsets.all(9.r),
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: context.colorScheme.primary, size: 21.sp),
        ),
        title: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        children: children,
      ),
    );
  }

  Widget _buildCollectionTypeCard(
    BuildContext context, {
    required String type,
    required String titleKey,
    required String subtitleKey,
    required IconData icon,
    required bool isSelected,
    String? badgeKey,
    bool isFree = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () => context.read<RequestCollectionBloc>().add(
          SelectCollectionTypeEvent(type),
        ),
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primaryContainer.withValues(alpha: 0.6)
                : context.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                _buildSelectionIndicator(context, isSelected),
                SizedBox(width: 14.w),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (badgeKey != null) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isFree
                                      ? const Color(0xffa5f3b5)
                                      : const Color(0xffffd9bd),
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                                child: Text(
                                  context.tr(badgeKey),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isFree
                                        ? context.colorScheme.primary
                                        : const Color(0xff7a3511),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                            ],
                            Flexible(
                              child: Text(
                                context.tr(titleKey),
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          context.tr(subtitleKey),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.onSurfaceVariant,
                    size: 36.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context, bool isSelected) {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.surfaceContainerHighest,
          width: 8.r,
        ),
        color: isSelected
            ? context.colorScheme.primary
            : context.colorScheme.surfaceContainerHighest,
      ),
      child: isSelected
          ? Padding(
              padding: EdgeInsets.all(5.r),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colorScheme.onPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCollectionTypeSection(BuildContext context) {
    return BlocBuilder<RequestCollectionBloc, RequestCollectionState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr('collection_service_type'),
                textAlign: TextAlign.right,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 18.h),
              _buildCollectionTypeCard(
                context,
                type: 'recyclable_only',
                titleKey: 'recyclable_only',
                subtitleKey: 'recyclable_only_hint',
                badgeKey: 'free_label',
                isFree: true,
                icon: Icons.recycling_rounded,
                isSelected: state.selectedCollectionType == 'recyclable_only',
              ),
              _buildCollectionTypeCard(
                context,
                type: 'furniture',
                titleKey: 'furniture_collection',
                subtitleKey: 'furniture_collection_hint',
                badgeKey: 'most_requested',
                icon: Icons.all_inclusive_rounded,
                isSelected: state.selectedCollectionType == 'furniture',
              ),
              _buildCollectionTypeCard(
                context,
                type: 'household',
                titleKey: 'household_waste',
                subtitleKey: 'household_waste_hint',
                icon: Icons.delete_outline_rounded,
                isSelected: state.selectedCollectionType == 'household',
              ),
            ],
          ),
        );
      },
    );
  }
}
