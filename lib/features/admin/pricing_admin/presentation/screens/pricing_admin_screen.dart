import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/pricing_admin_model.dart';
import '../bloc/pricing_admin_bloc.dart';
import '../bloc/pricing_admin_event.dart';
import '../bloc/pricing_admin_state.dart';

class PricingAdminScreen extends StatefulWidget {
  const PricingAdminScreen({super.key});

  @override
  State<PricingAdminScreen> createState() => _PricingAdminScreenState();
}

class _PricingAdminScreenState extends State<PricingAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _workerShareController;
  late TextEditingController _subPriceController;

  @override
  void initState() {
    super.initState();
    _workerShareController = TextEditingController();
    _subPriceController = TextEditingController();
    context.read<PricingAdminBloc>().add(const GetPricingAdminEvent());
  }

  @override
  void dispose() {
    _workerShareController.dispose();
    _subPriceController.dispose();
    super.dispose();
  }

  void _populateFields(PricingAdminModel pricing) {
    _workerShareController.text = pricing.workerPercentage.toString();
    _subPriceController.text = pricing.monthlySubscriptionPrice.toString();
  }

  void _savePricing() {
    if (_formKey.currentState?.validate() ?? false) {
      final pricing = PricingAdminModel(
        workerPercentage: double.parse(_workerShareController.text.trim()),
        monthlySubscriptionPrice: double.parse(_subPriceController.text.trim()),
      );
      context
          .read<PricingAdminBloc>()
          .add(UpdatePricingAdminEvent(pricing));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_pricing'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<PricingAdminBloc, PricingAdminState>(
        listener: (context, state) {
          if (state is PricingAdminLoadedState) {
            _populateFields(state.pricing);
          }
        },
        builder: (context, state) {
          if (state is PricingAdminLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PricingAdminLoadedState) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: _workerShareController,
                      hintText: '${context.tr('admin_worker_percentage')} (%)',
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
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _subPriceController,
                      hintText: '${context.tr('admin_subscription_price')} (EGP)',
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
                      isLoading: state.isActionLoading,
                      onTap: state.isActionLoading ? null : _savePricing,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is PricingAdminErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context
                    .read<PricingAdminBloc>()
                    .add(const GetPricingAdminEvent());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
