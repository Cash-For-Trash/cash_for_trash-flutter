import 'dart:io';

import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/helpers/image_picker_helper.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageUploadRequestCollectionSection extends StatelessWidget {
  const ImageUploadRequestCollectionSection({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final imagePath = await ImagePickerHelper.pickImageFromGallery();

    if (imagePath != null && context.mounted) {
      context.read<RequestCollectionBloc>().add(PickWasteImageEvent(imagePath));
    }
  }

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
            context.tr('waste_picture_optional'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 14.h),
          BlocBuilder<RequestCollectionBloc, RequestCollectionState>(
            builder: (context, state) {
              if (state.imagePath != null && state.imagePath!.isNotEmpty) {
                return _buildImagePreview(context, state.imagePath!);
              }
              return _buildUploadPrompt(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUploadPrompt(BuildContext context) {
    final activeColor = context.colorScheme.primary;
    final bgTint = context.colorScheme.primaryContainer.withValues(alpha: 0.25);

    return InkWell(
      onTap: () => _pickImage(context),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: bgTint,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: activeColor.withValues(alpha: 0.3),
            width: 1.r,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: activeColor,
                size: 26.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              context.tr('tap_to_add_image'),
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, String imagePath) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            height: 140.h,
            width: double.infinity,
            color: context.colorScheme.surfaceContainerHigh,
            child: kIsWeb
                ? Image.network(imagePath, fit: BoxFit.cover)
                : Image.file(File(imagePath), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: IconButton(
            onPressed: () {
              context.read<RequestCollectionBloc>().add(
                const RemoveWasteImageEvent(),
              );
            },
            icon: CircleAvatar(
              backgroundColor: context.colorScheme.error,
              radius: 14.r,
              child: Icon(
                Icons.close,
                size: 16.sp,
                color: context.colorScheme.onError,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
