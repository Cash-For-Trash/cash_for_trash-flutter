import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../bloc/collection_requests_worker_bloc.dart';
import '../bloc/collection_requests_worker_event.dart';
import '../bloc/collection_requests_worker_state.dart';
import '../widgets/request_card_collection_worker_widget.dart';
import '../widgets/weight_recording_modal_worker_widget.dart';

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
          const GetAssignedCollectionRequestsEvent(status: 'PENDING'),
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
            final status = index == 0 ? 'PENDING' : 'COLLECTED';
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
            final status = tabController.index == 0 ? 'PENDING' : 'COLLECTED';
            context.read<CollectionRequestsWorkerBloc>().add(
                  GetAssignedCollectionRequestsEvent(status: status),
                );
          }
        },
        builder: (context, state) {
          if (state is CollectionRequestsWorkerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CollectionRequestsWorkerLoadedState) {
            final requests = state.requests;

            if (requests.isEmpty) {
              return CustomErrorOrEmptyWidget(
                isError: false,
                title: context.tr('no_assigned_requests'),
                message: context.tr('no_assigned_requests'),
                icon: Icons.assignment_outlined,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                final status = tabController.index == 0 ? 'PENDING' : 'COLLECTED';
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

                  // if (req.status != 'COLLECTED' && req.status != 'COMPLETED') {
                  //   actionText = context.tr('record_weight_btn');
                  //   onAction = () {
                  //     showModalBottomSheet(
                  //       context: context,
                  //       isScrollControlled: true,
                  //       backgroundColor: Colors.transparent,
                  //       builder: (_) => WeightRecordingModalWorkerWidget(
                  //         garbageTypes: req.garbageTypes,
                  //         onConfirm: (weights) {
                  //           context.read<CollectionRequestsWorkerBloc>().add(
                  //                 SubmitGarbageWeightsEvent(
                  //                   requestId: req.id,
                  //                   weights: weights,
                  //                 ),
                  //               );
                  //         },
                  //       ),
                  //     );
                  //   };
                  // }

                  return RequestCardCollectionWorkerWidget(
                    request: req,
                    actionButtonText: actionText,
                    onStatusAction: onAction,
                    onTap: () async {
                      await context.push(
                        AppRoutes.pickupDetailsWorkerScreen,
                        extra: req,
                      );
                      if (context.mounted) {
                        final status = tabController.index == 0 ? 'PENDING' : 'COLLECTED';
                        context.read<CollectionRequestsWorkerBloc>().add(
                              GetAssignedCollectionRequestsEvent(status: status),
                            );
                      }
                    },
                  );
                },
              ),
            );
          } else if (state is CollectionRequestsWorkerErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                final status = tabController.index == 0 ? 'PENDING' : 'COLLECTED';
                context.read<CollectionRequestsWorkerBloc>().add(
                      GetAssignedCollectionRequestsEvent(status: status),
                    );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
