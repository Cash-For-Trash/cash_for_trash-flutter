import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/features/address/data/model/address_model.dart';
import 'package:cash_for_trash/features/maps/data/model/selected_location_model.dart';
import 'package:cash_for_trash/features/request_collection/data/model/address_model.dart' as rc;
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_bloc.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_event.dart';
import 'package:cash_for_trash/features/request_collection/presentation/bloc/request_collection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationRequestCollectionSection extends StatelessWidget {
  const LocationRequestCollectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('location'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 14.h),
          BlocBuilder<RequestCollectionBloc, RequestCollectionState>(
            builder: (context, state) {
              if (state.isAddressesLoading) {
                return SizedBox(
                  height: 50.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.colorScheme.primary,
                    ),
                  ),
                );
              }

              if (state.addressesErrorMessage != null &&
                  state.selectedAddress == null) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.addressesErrorMessage!,
                        style: TextStyle(
                          color: context.colorScheme.error,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<RequestCollectionBloc>().add(
                              const GetAddressesEvent(),
                            );
                      },
                      child: Text(context.tr('retry')),
                    ),
                  ],
                );
              }

              final address = state.selectedAddress;
              if (address == null) {
                return InkWell(
                  onTap: () => _openAddNewAddressFlow(context, null),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: context.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_location_alt_rounded,
                          color: context.colorScheme.primary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          context.tr('add_new_location'),
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final locationTitle = address.location;
              final locationSub = '${context.tr('building_num')}: ${address.buildingNum}  •  ${context.tr('floor_number')}: ${address.floor}${address.additionalNote.isNotEmpty ? '  •  ${address.additionalNote}' : ''}';

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: context.colorScheme.primary,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locationTitle,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: context.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            locationSub,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: () => _openAddressOptions(context, state),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primaryContainer
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          context.tr('change'),
                          style: context.textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openAddressOptions(
    BuildContext context,
    RequestCollectionState state,
  ) {
    if (state.addresses.isEmpty) {
      _openAddNewAddressFlow(context, null);
      return;
    }

    final bloc = context.read<RequestCollectionBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('location'),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => bottomSheetContext.pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.addresses.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = state.addresses[index];
                      final isSelected =
                          state.selectedAddress?.addressId == item.addressId;

                      return ListTile(
                        leading: Icon(
                          Icons.location_on_rounded,
                          color: isSelected
                              ? context.colorScheme.primary
                              : context.colorScheme.onSurfaceVariant,
                        ),
                        title: Text(
                          item.location,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          '${context.tr('building_num')}: ${item.buildingNum}  •  ${context.tr('floor_number')}: ${item.floor}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: context.colorScheme.primary,
                                size: 20.sp,
                              ),
                            SizedBox(width: 4.w),
                            IconButton(
                              onPressed: () {
                                bottomSheetContext.pop();
                                _openEditAddressFlow(context, item);
                              },
                              icon: Icon(
                                Icons.edit_rounded,
                                size: 18.sp,
                                color: context.colorScheme.primary,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        onTap: () {
                          bloc.add(SelectAddressEvent(item));
                          bottomSheetContext.pop();
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                OutlinedButton.icon(
                  onPressed: () {
                    bottomSheetContext.pop();
                    _openAddNewAddressFlow(context, null);
                  },
                  icon: const Icon(Icons.add_location_alt_rounded),
                  label: Text(context.tr('add_new_location')),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 44.h),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openAddNewAddressFlow(
    BuildContext context,
    rc.AddressItemModel? prefillFrom,
  ) async {
    final selectedLocation = await context.push<SelectedLocationModel>(
      AppRoutes.mapsScreen,
    );
    if (selectedLocation == null || !context.mounted) return;

    final result = await context.push<AddressModel>(
      AppRoutes.addressFormScreen,
      extra: {
        'selectedLocation': selectedLocation,
        'existingAddress': null,
      },
    );
    if (result != null && context.mounted) {
      context
          .read<RequestCollectionBloc>()
          .add(AddAddressToCollectionEvent(result));
    }
  }

  Future<void> _openEditAddressFlow(
    BuildContext context,
    rc.AddressItemModel item,
  ) async {
    final initialLatLng = LatLng(
      double.tryParse(item.latitude) ?? 0.0,
      double.tryParse(item.longitude) ?? 0.0,
    );

    final selectedLocation = await context.push<SelectedLocationModel>(
      AppRoutes.mapsScreen,
      extra: {'initialLatLng': initialLatLng},
    );
    if (selectedLocation == null || !context.mounted) return;

    final existingForForm = AddressModel(
      addressId: item.addressId,
      buildingNum: item.buildingNum,
      floor: item.floor,
      location: item.location,
      latitude: item.latitude,
      longitude: item.longitude,
      additionalNote: item.additionalNote,
      userId: item.userId,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );

    final result = await context.push<AddressModel>(
      AppRoutes.addressFormScreen,
      extra: {
        'selectedLocation': selectedLocation,
        'existingAddress': existingForForm,
      },
    );
    if (result != null && context.mounted) {
      context
          .read<RequestCollectionBloc>()
          .add(UpdateAddressInCollectionEvent(result));
    }
  }
}
