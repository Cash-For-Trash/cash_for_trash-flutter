import 'dart:io';
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/helpers/image_picker_helper.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/garbage_type_admin_model.dart';
import '../bloc/garbage_types_admin_bloc.dart';
import '../bloc/garbage_types_admin_event.dart';

class GarbageTypeFormAdminScreen extends StatefulWidget {
  final GarbageTypeAdminModel? existingItem;

  const GarbageTypeFormAdminScreen({super.key, this.existingItem});

  @override
  State<GarbageTypeFormAdminScreen> createState() =>
      _GarbageTypeFormAdminScreenState();
}

class _GarbageTypeFormAdminScreenState
    extends State<GarbageTypeFormAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  String? _selectedImagePath;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingItem?.name ?? '',
    );
    _priceController = TextEditingController(
      text: widget.existingItem?.pricePerKg.toString() ?? '5.0',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImagePickerHelper.pickImageFromGallery();
    if (path != null) {
      setState(() => _selectedImagePath = path);
    }
  }

  void _saveItem() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.existingItem == null && _selectedImagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('image_required')),
            backgroundColor: context.colorScheme.error,
          ),
        );
        return;
      }

      final fields = <String, dynamic>{
        'garbage_type_name': _nameController.text.trim(),
        'price_per_kg': double.parse(_priceController.text.trim()),
      };

      setState(() {
        _isSubmitting = true;
      });

      if (widget.existingItem == null) {
        context.read<GarbageTypesAdminBloc>().add(
          CreateGarbageTypeAdminEvent(
            fields: fields,
            imagePath: _selectedImagePath!,
          ),
        );
      } else {
        context.read<GarbageTypesAdminBloc>().add(
          UpdateGarbageTypeAdminEvent(
            id: widget.existingItem!.id,
            fields: fields,
            imagePath: _selectedImagePath,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingItem != null;
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? context.tr('edit_address')
              : context.tr('admin_add_garbage_type'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<GarbageTypesAdminBloc, GarbageTypesAdminState>(
        listener: (context, state) {
          if (_isSubmitting) {
            if (state is GarbageTypesAdminLoadedState && !state.isActionLoading) {
              setState(() {
                _isSubmitting = false;
              });
              context.pop();
            } else if (state is GarbageTypesAdminErrorState) {
              setState(() {
                _isSubmitting = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: context.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final isLoading = _isSubmitting ||
              (state is GarbageTypesAdminLoadedState && state.isActionLoading);

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: isLoading ? null : _pickImage,
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
                          : (widget.existingItem?.image != null &&
                                widget.existingItem!.image!.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.network(
                                widget.existingItem!.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    _imagePlaceholder(colorScheme),
                              ),
                            )
                          : _imagePlaceholder(colorScheme),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFormField(
                    controller: _nameController,
                    hintText: context.tr('garbage_type_name_hint'),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return context.tr('field_required');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFormField(
                    controller: _priceController,
                    hintText: '${context.tr('admin_price_per_kg')} (EGP)',
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return context.tr('field_required');
                      }
                      if (double.tryParse(val) == null) {
                        return context.tr('invalid_number');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.h),
                  CustomPrimaryButton(
                    text: context.tr('admin_save'),
                    isLoading: isLoading,
                    onTap: isLoading ? null : _saveItem,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _imagePlaceholder(ColorScheme colorScheme) {
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
