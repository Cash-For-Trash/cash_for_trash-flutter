import 'package:cash_for_trash/core/extensions/context_extensions.dart';
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
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingReward?.name ?? '');
    _pointsController = TextEditingController(
        text: widget.existingReward?.requiredPoints.toString() ?? '100');
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _pointsController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveReward() {
    if (_formKey.currentState?.validate() ?? false) {
      final formData = FormData.fromMap({
        'name': _titleController.text.trim(),
        'required_points': int.parse(_pointsController.text.trim()),
      });

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
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              CustomTextFormField(
                controller: _titleController,
                hintText: 'Reward Title (e.g. 50 EGP Voucher)',
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
                hintText: '${context.tr('admin_points_required')} (e.g. 500)',
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
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: _descController,
                hintText: 'Description',
              ),
              const Spacer(),
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
}
