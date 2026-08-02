import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/garbage_type_admin_model.dart';
import '../bloc/garbage_types_admin_bloc.dart';
import '../bloc/garbage_types_admin_event.dart';

class GarbageTypeFormAdminScreen extends StatefulWidget {
  final GarbageTypeAdminModel? existingItem;

  const GarbageTypeFormAdminScreen({
    super.key,
    this.existingItem,
  });

  @override
  State<GarbageTypeFormAdminScreen> createState() =>
      _GarbageTypeFormAdminScreenState();
}

class _GarbageTypeFormAdminScreenState
    extends State<GarbageTypeFormAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingItem?.name ?? '');
    _priceController = TextEditingController(
        text: widget.existingItem?.pricePerKg.toString() ?? '5.0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState?.validate() ?? false) {
      final formData = FormData.fromMap({
        'name': _nameController.text.trim(),
        'price_per_kg': double.parse(_priceController.text.trim()),
      });

      if (widget.existingItem == null) {
        context
            .read<GarbageTypesAdminBloc>()
            .add(CreateGarbageTypeAdminEvent(formData));
      } else {
        context.read<GarbageTypesAdminBloc>().add(UpdateGarbageTypeAdminEvent(
              id: widget.existingItem!.id,
              formData: formData,
            ));
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingItem != null;

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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Name (e.g. Plastic, Paper, Metal)',
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
              const Spacer(),
              CustomPrimaryButton(
                text: context.tr('admin_save'),
                onTap: _saveItem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
