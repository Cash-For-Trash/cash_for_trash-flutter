import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/data/model/collection_request_worker_model.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_bloc.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/bloc/collection_requests_worker_event.dart';
import 'package:cash_for_trash/features/worker/collection_requests_worker/presentation/widgets/weight_recording_modal_worker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class PickupDetailsWorkerScreen extends StatelessWidget {
  final CollectionRequestWorkerModel request;

  const PickupDetailsWorkerScreen({
    super.key,
    required this.request,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openMap(double lat, double lng) async {
    final Uri googleMapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    }
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.customerName.isNotEmpty ? request.customerName : context.tr('customer'),
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: context.colorScheme.primary, size: 20.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          request.address.isNotEmpty ? request.address : context.tr('default_address_street'),
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.business_rounded, color: context.colorScheme.secondary, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        '${context.tr('building')}: ${request.buildingNum} | ${context.tr('floor')}: ${request.floor}',
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (request.formattedScheduledSlot.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, color: context.colorScheme.tertiary, size: 20.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            request.formattedScheduledSlot,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: request.customerPhone.isNotEmpty
                        ? () => _makePhoneCall(request.customerPhone)
                        : null,
                    icon: Icon(Icons.phone_rounded, size: 18.sp),
                    label: Text(context.tr('call_customer')),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (request.latitude != 0.0 && request.longitude != 0.0)
                        ? () => _openMap(request.latitude, request.longitude)
                        : null,
                    icon: Icon(Icons.map_rounded, size: 18.sp),
                    label: Text(context.tr('view_on_map')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: context.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              context.tr('select_type_and_quantity'),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: request.garbageTypes.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final item = request.garbageTypes[index];
                return Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.garbageTypeName.isNotEmpty ? item.garbageTypeName : context.tr('waste_type_title'),
                        style: context.textTheme.bodyLarge,
                      ),
                      Text(
                        '${item.expectedWeight} ${context.tr('kg_unit')}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 32.h),
            if (request.status == 'ASSIGNED')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CollectionRequestsWorkerBloc>().add(
                          UpdateCollectionRequestStatusEvent(
                            requestId: request.id,
                            status: 'ACCEPTED',
                          ),
                        );
                    Navigator.pop(context);
                  },
                  child: Text(context.tr('accept_request')),
                ),
              )
            else if (request.status == 'ACCEPTED')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CollectionRequestsWorkerBloc>().add(
                          UpdateCollectionRequestStatusEvent(
                            requestId: request.id,
                            status: 'ON_THE_WAY',
                          ),
                        );
                    Navigator.pop(context);
                  },
                  child: Text(context.tr('start_heading_there')),
                ),
              )
            else if (request.status == 'ON_THE_WAY')
              SizedBox(
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
                  child: Text(context.tr('record_weight_btn')),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
