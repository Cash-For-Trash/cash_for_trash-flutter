import 'dart:io';
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/helpers/image_picker_helper.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/reward_admin_model.dart';
import '../bloc/rewards_admin_bloc.dart';
import '../bloc/rewards_admin_event.dart';

class RewardFormAdminScreen extends StatefulWidget {
  final RewardAdminModel? existingReward;

  const RewardFormAdminScreen({
    super.key,
    this.existingReward,
  });

  @override
  State<RewardFormAdminScreen> createState() => _RewardFormAdminScreenState();
}

class _RewardFormAdminScreenState extends State<RewardFormAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _pointsController;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingReward?.name ?? '');
    _pointsController = TextEditingController(
        text: widget.existingReward?.requiredPoints.toString() ?? '100');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImagePickerHelper.pickImageFromGallery();
    if (path != null) {
      setState(() => _selectedImagePath = path);
    }
  }

  Future<void> _saveReward() async {
    if (_formKey.currentState?.validate() ?? false) {
      final formFields = <String, dynamic>{
        'name': _titleController.text.trim(),
        'required_points': int.parse(_pointsController.text.trim()),
      };

      if (_selectedImagePath != null) {
        formFields['image'] = await MultipartFile.fromFile(
          _selectedImagePath!,
          filename: _selectedImagePath!.split('/').last,
        );
      }

      if (!mounted) return;

      final formData = FormData.fromMap(formFields);

      if (widget.existingReward == null) {
        context
            .read<RewardsAdminBloc>()
            .add(CreateRewardAdminEvent(formData));
      } else {
        context.read<RewardsAdminBloc>().add(UpdateRewardAdminEvent(
              id: widget.existingReward!.id,
              formData: formData,
            ));
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingReward != null;
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? context.tr('edit_address') : context.tr('admin_add_reward'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 160.h,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: colorScheme.outline,
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: _selectedImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15.r),
                          child: Image.file(
                            File(_selectedImagePath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : (widget.existingReward?.image != null &&
                              widget.existingReward!.image!.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.network(
                                widget.existingReward!.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _imagePlaceholder(colorScheme),
                              ),
                            )
                          : _imagePlaceholder(colorScheme),
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: _titleController,
                hintText: context.tr('reward_title_hint'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return context.tr('field_required');
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: _pointsController,
                hintText: context.tr('points_required_hint'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return context.tr('field_required');
                  }
                  if (int.tryParse(val) == null) {
                    return context.tr('invalid_number');
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),
              CustomPrimaryButton(
                text: context.tr('admin_save'),
                onTap: _saveReward,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(ColorScheme  colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 40.r,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(height: 8.h),
        Text(
          context.tr('tap_to_add_image'),
          style: context.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
