import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsSectionAddressFormWidget extends StatelessWidget {
  final TextEditingController locationController;
  final TextEditingController buildingNumController;
  final TextEditingController floorController;
  final TextEditingController additionalNoteController;

  const DetailsSectionAddressFormWidget({
    super.key,
    required this.locationController,
    required this.buildingNumController,
    required this.floorController,
    required this.additionalNoteController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('address'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            hintText: context.tr('location'),
            controller: locationController,
            prefixIcon: const Icon(Icons.location_on_outlined),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.tr('field_required');
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  hintText: context.tr('building_num'),
                  controller: buildingNumController,
                  prefixIcon: const Icon(Icons.apartment_outlined),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.tr('field_required');
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return context.tr('invalid_number');
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextFormField(
                  hintText: context.tr('floor_number'),
                  controller: floorController,
                  prefixIcon: const Icon(Icons.layers_outlined),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.tr('field_required');
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomTextFormField(
            hintText: context.tr('additional_note_optional'),
            controller: additionalNoteController,
            prefixIcon: const Icon(Icons.note_outlined),
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
