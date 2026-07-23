import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/bottom_bar_request_collection_widget.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/header_request_collection_widget.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/image_upload_request_collection_section.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/location_request_collection_section.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/quantity_selection_request_collection_section.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/time_slot_request_collection_section.dart';
import 'package:cash_for_trash/features/request_collection/presentation/screens/widgets/waste_type_selection_request_collection_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestCollectionScreen extends StatelessWidget {
  const RequestCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Column(
        children: [
          const HeaderRequestCollectionWidget(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
    );
  }
}
