import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/collection_request_worker_model.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_bloc.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_event.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/widgets/weight_recording_modal_worker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickupDetailsWorkerRecordActionWidget extends StatelessWidget {
  final CollectionRequestWorkerModel request;

  const PickupDetailsWorkerRecordActionWidget({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    if (request.status == 'COLLECTED' || request.status == 'COMPLETED') {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => WeightRecordingModalWorkerWidget(
              garbageTypes: request.garbageTypes,
              onConfirm: (weights) {
                context.read<CollectionRequestsWorkerBloc>().add(
                      SubmitGarbageWeightsEvent(
                        requestId: request.id,
                        weights: weights,
                      ),
                    );
                Navigator.pop(context);
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          context.tr('record_weight_btn'),
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
