import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/collection_request_worker_model.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_bloc.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_event.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_state.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/widgets/pickup_details_worker_action_buttons_widget.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/widgets/pickup_details_worker_customer_info_widget.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/widgets/pickup_details_worker_garbage_types_widget.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/widgets/pickup_details_worker_record_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickupDetailsWorkerScreen extends StatefulWidget {
  final CollectionRequestWorkerModel request;

  const PickupDetailsWorkerScreen({
    super.key,
    required this.request,
  });

  @override
  State<PickupDetailsWorkerScreen> createState() => _PickupDetailsWorkerScreenState();
}

class _PickupDetailsWorkerScreenState extends State<PickupDetailsWorkerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionRequestsWorkerBloc>().add(
          GetWorkerCollectionRequestDetailsEvent(widget.request.id),
        );
  }

  Widget _buildContent(BuildContext context, CollectionRequestWorkerModel req) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PickupDetailsWorkerCustomerInfoWidget(request: req),
          SizedBox(height: 16.h),
          PickupDetailsWorkerActionButtonsWidget(request: req),
          SizedBox(height: 24.h),
          PickupDetailsWorkerGarbageTypesWidget(garbageTypes: req.garbageTypes),
          SizedBox(height: 32.h),
          PickupDetailsWorkerRecordActionWidget(request: req),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('pickup_details'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<CollectionRequestsWorkerBloc, CollectionRequestsWorkerState>(
        listener: (context, state) {
          if (state is CollectionRequestsWorkerSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<CollectionRequestsWorkerBloc>().add(
                  GetWorkerCollectionRequestDetailsEvent(widget.request.id),
                );
          }
        },
        builder: (context, state) {
          if (state is CollectionRequestsWorkerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CollectionRequestsWorkerErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<CollectionRequestsWorkerBloc>().add(
                      GetWorkerCollectionRequestDetailsEvent(widget.request.id),
                    );
              },
            );
          } else if (state is CollectionRequestDetailsLoadedState) {
            return _buildContent(context, state.requestDetails);
          }
          return _buildContent(context, widget.request);
        },
      ),
    );
  }
}
