import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
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

class RequestCollectionScreen extends StatelessWidget {
  const RequestCollectionScreen({super.key});

  String _resolveError(BuildContext context, String key) {
    // If the key maps to a known translation, use it; otherwise show as-is.
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
    return BlocListener<RequestCollectionBloc, RequestCollectionState>(
      listenWhen: (prev, curr) =>
          curr.submitSuccess != prev.submitSuccess ||
          curr.submitErrorMessage != prev.submitErrorMessage,
      listener: (context, state) {
        if (state.submitSuccess) {
          SuccessCollectionDialog.show(context);
        } else if (state.submitErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_resolveError(context, state.submitErrorMessage!)),
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
        body: Column(
          children: [
            const HeaderRequestCollectionWidget(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: [
                    const WasteTypeSelectionRequestCollectionSection(),
                    SizedBox(height: 16.h),
                    const QuantitySelectionRequestCollectionSection(),
                    SizedBox(height: 16.h),
                    const ImageUploadRequestCollectionSection(),
                    SizedBox(height: 16.h),
                    const LocationRequestCollectionSection(),
                    SizedBox(height: 16.h),
                    const TimeSlotRequestCollectionSection(),
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
}
