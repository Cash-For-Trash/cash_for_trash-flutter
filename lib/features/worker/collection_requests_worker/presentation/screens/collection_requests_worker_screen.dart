import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/collection_requests_worker_bloc.dart';
import '../bloc/collection_requests_worker_event.dart';
import '../bloc/collection_requests_worker_state.dart';
import '../widgets/request_card_collection_worker_widget.dart';
import '../widgets/weight_recording_modal_worker_widget.dart';
import 'pickup_details_worker_screen.dart';

class CollectionRequestsWorkerScreen extends StatefulWidget {
  const CollectionRequestsWorkerScreen({super.key});

  @override
  State<CollectionRequestsWorkerScreen> createState() => _CollectionRequestsWorkerScreenState();
}

class _CollectionRequestsWorkerScreenState extends State<CollectionRequestsWorkerScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    context.read<CollectionRequestsWorkerBloc>().add(
          const GetAssignedCollectionRequestsEvent(status: 'active'),
        );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('todays_pickups'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          onTap: (index) {
            final status = index == 0 ? 'active' : 'COLLECTED';
            context.read<CollectionRequestsWorkerBloc>().add(
                  GetAssignedCollectionRequestsEvent(status: status),
                );
          },
          tabs: [
            Tab(text: context.tr('active_pickups')),
            Tab(text: context.tr('history_pickups')),
          ],
        ),
      ),
      body: BlocConsumer<CollectionRequestsWorkerBloc, CollectionRequestsWorkerState>(
        listener: (context, state) {
          if (state is CollectionRequestsWorkerSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<CollectionRequestsWorkerBloc>().add(
                  const GetAssignedCollectionRequestsEvent(status: 'active'),
                );
          }
        },
        builder: (context, state) {
          if (state is CollectionRequestsWorkerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CollectionRequestsWorkerLoadedState) {
            final requests = state.requests;

            if (requests.isEmpty) {
              return Center(
                child: Text(
                  context.tr('no_assigned_requests'),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                final status = tabController.index == 0 ? 'active' : 'COLLECTED';
                context.read<CollectionRequestsWorkerBloc>().add(
                      GetAssignedCollectionRequestsEvent(status: status),
                    );
              },
              child: ListView.builder(
                padding: EdgeInsets.all(20.r),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final req = requests[index];
                  String? actionText;
                  VoidCallback? onAction;

                  if (req.status == 'ASSIGNED') {
                    actionText = context.tr('accept_request');
                    onAction = () {
                      context.read<CollectionRequestsWorkerBloc>().add(
                            UpdateCollectionRequestStatusEvent(
                              requestId: req.id,
                              status: 'ACCEPTED',
                            ),
                          );
                    };
                  } else if (req.status == 'ACCEPTED') {
                    actionText = context.tr('start_heading_there');
                    onAction = () {
                      context.read<CollectionRequestsWorkerBloc>().add(
                            UpdateCollectionRequestStatusEvent(
                              requestId: req.id,
                              status: 'ON_THE_WAY',
                            ),
                          );
                    };
                  } else if (req.status == 'ON_THE_WAY') {
                    actionText = context.tr('record_weight_btn');
                    onAction = () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => WeightRecordingModalWorkerWidget(
                          garbageTypes: req.garbageTypes,
                          onConfirm: (weights) {
                            context.read<CollectionRequestsWorkerBloc>().add(
                                  SubmitGarbageWeightsEvent(
                                    requestId: req.id,
                                    weights: weights,
                                  ),
                                );
                          },
                        ),
                      );
                    };
                  }

                  return RequestCardCollectionWorkerWidget(
                    request: req,
                    actionButtonText: actionText,
                    onStatusAction: onAction,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<CollectionRequestsWorkerBloc>(),
                            child: PickupDetailsWorkerScreen(request: req),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is CollectionRequestsWorkerErrorState) {
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
