import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/availabilities_admin_bloc.dart';
import '../bloc/availabilities_admin_event.dart';
import '../bloc/availabilities_admin_state.dart';
import '../widgets/availability_card_availabilities_admin_widget.dart';

class AvailabilitiesAdminScreen extends StatefulWidget {
  const AvailabilitiesAdminScreen({super.key});

  @override
  State<AvailabilitiesAdminScreen> createState() =>
      _AvailabilitiesAdminScreenState();
}

class _AvailabilitiesAdminScreenState
    extends State<AvailabilitiesAdminScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<AvailabilitiesAdminBloc>()
        .add(const GetAvailabilitiesAdminEvent());
  }

  void _showAddSlotDialog(BuildContext context) {
    int selectedDay = 0;
    final fromController = TextEditingController(text: '09:00');
    final toController = TextEditingController(text: '17:00');
    final areaIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.tr('add_availability')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  controller: areaIdController,
                  hintText: 'Area ID (Optional)',
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<int>(
                  initialValue: selectedDay,
                  decoration: InputDecoration(
                    labelText: context.tr('select_day'),
                    border: const OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Sunday')),
                    DropdownMenuItem(value: 1, child: Text('Monday')),
                    DropdownMenuItem(value: 2, child: Text('Tuesday')),
                    DropdownMenuItem(value: 3, child: Text('Wednesday')),
                    DropdownMenuItem(value: 4, child: Text('Thursday')),
                    DropdownMenuItem(value: 5, child: Text('Friday')),
                    DropdownMenuItem(value: 6, child: Text('Saturday')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        selectedDay = val;
                      });
                    }
                  },
                ),
                SizedBox(height: 12.h),
                CustomTextFormField(
                  controller: fromController,
                  hintText: 'From: HH:mm (e.g. 09:00)',
                ),
                SizedBox(height: 12.h),
                CustomTextFormField(
                  controller: toController,
                  hintText: 'To: HH:mm (e.g. 17:00)',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.tr('cancel')),
            ),
            CustomPrimaryButton(
              text: context.tr('admin_save'),
              onTap: () {
                final data = {
                  'day_of_week': selectedDay,
                  'from_time': fromController.text.trim(),
                  'to_time': toController.text.trim(),
                  if (areaIdController.text.trim().isNotEmpty)
                    'area_id': areaIdController.text.trim(),
                };
                context
                    .read<AvailabilitiesAdminBloc>()
                    .add(CreateAvailabilityAdminEvent(data));
                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_availabilities'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSlotDialog(context),
        icon: const Icon(Icons.more_time_rounded),
        label: Text(context.tr('add_availability')),
      ),
      body: BlocBuilder<AvailabilitiesAdminBloc, AvailabilitiesAdminState>(
        builder: (context, state) {
          if (state is AvailabilitiesAdminLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AvailabilitiesAdminLoadedState) {
            if (state.availabilities.isEmpty) {
              return CustomErrorOrEmptyWidget(
                isError: false,
                title: context.tr('empty_no_items'),
                message: context.tr('empty_no_items_desc'),
                icon: Icons.access_time_rounded,
                actionLabel: context.tr('add_availability'),
                onAction: () => _showAddSlotDialog(context),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<AvailabilitiesAdminBloc>()
                    .add(const GetAvailabilitiesAdminEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: state.availabilities.length,
                itemBuilder: (context, index) {
                  final slot = state.availabilities[index];
                  return AvailabilityCardAvailabilitiesAdminWidget(
                    availability: slot,
                    onDelete: () {
                      context
                          .read<AvailabilitiesAdminBloc>()
                          .add(DeleteAvailabilityAdminEvent(slot.id));
                    },
                  );
                },
              ),
            );
          } else if (state is AvailabilitiesAdminErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context
                    .read<AvailabilitiesAdminBloc>()
                    .add(const GetAvailabilitiesAdminEvent());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
