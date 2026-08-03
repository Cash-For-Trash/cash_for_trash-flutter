import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/availability_worker_bloc.dart';
import '../bloc/availability_worker_event.dart';
import '../bloc/availability_worker_state.dart';
import '../widgets/slot_card_availability_worker_widget.dart';
import '../widgets/add_slot_modal_worker_widget.dart';

class AvailabilityWorkerScreen extends StatefulWidget {
  const AvailabilityWorkerScreen({super.key});

  @override
  State<AvailabilityWorkerScreen> createState() => _AvailabilityWorkerScreenState();
}

class _AvailabilityWorkerScreenState extends State<AvailabilityWorkerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AvailabilityWorkerBloc>().add(const GetMyAvailabilitiesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('availability_management'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final state = context.read<AvailabilityWorkerBloc>().state;
          final areas = state is AvailabilityWorkerLoadedState ? state.areas : <Map<String, dynamic>>[];

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AddSlotModalWorkerWidget(
              areas: areas,
              onSave: (slot) {
                context.read<AvailabilityWorkerBloc>().add(CreateAvailabilityEvent(slot));
              },
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(context.tr('add_availability')),
      ),
      body: BlocConsumer<AvailabilityWorkerBloc, AvailabilityWorkerState>(
        listener: (context, state) {
          if (state is AvailabilityWorkerActionSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<AvailabilityWorkerBloc>().add(const GetMyAvailabilitiesEvent());
          }
        },
        builder: (context, state) {
          if (state is AvailabilityWorkerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AvailabilityWorkerLoadedState) {
            final list = state.availabilities;
            if (list.isEmpty) {
              return Center(
                child: Text(
                  context.tr('availability_slots'),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AvailabilityWorkerBloc>().add(const GetMyAvailabilitiesEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(20.r),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return SlotCardAvailabilityWorkerWidget(
                    availability: list[index],
                  );
                },
              ),
            );
          } else if (state is AvailabilityWorkerErrorState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
