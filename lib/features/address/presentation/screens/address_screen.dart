import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/features/address/data/model/address_model.dart';
import 'package:cash_for_trash/features/address/presentation/bloc/address_bloc.dart';
import 'package:cash_for_trash/features/address/presentation/screens/widgets/address_card_address_widget.dart';
import 'package:cash_for_trash/features/address/presentation/screens/widgets/empty_state_address_widget.dart';
import 'package:cash_for_trash/features/address/presentation/screens/widgets/header_address_widget.dart';
import 'package:cash_for_trash/features/maps/data/model/selected_location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Column(
        children: [
          const HeaderAddressWidget(),
          Expanded(
            child: BlocBuilder<AddressBloc, AddressState>(
              builder: (context, state) {
                if (state is AddressLoadingState ||
                    state is AddressInitialState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: context.colorScheme.primary,
                    ),
                  );
                }

                if (state is AddressErrorState) {
                  return _ErrorBody(message: state.message);
                }

                final addresses = state is AddressLoadedState
                    ? state.addresses
                    : state is AddressDeletingState
                        ? state.addresses
                        : <AddressModel>[];

                final deletingId = state is AddressDeletingState
                    ? state.deletingId
                    : null;

                if (addresses.isEmpty) {
                  return const EmptyStateAddressWidget();
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return AddressCardAddressWidget(
                      address: address,
                      isDeleting: deletingId == address.addressId,
                      onEdit: () => _navigateToEditAddress(context, address),
                      onDelete: () => _confirmDelete(context, address),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddAddress(context),
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(context.tr('add_new_location')),
      ),
    );
  }

  Future<void> _navigateToAddAddress(BuildContext context) async {
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
      context.read<AddressBloc>().add(AddAddressEvent(result));
    }
  }

  Future<void> _navigateToEditAddress(
    BuildContext context,
    AddressModel address,
  ) async {
    final initialLatLng = LatLng(
      double.tryParse(address.latitude) ?? 0.0,
      double.tryParse(address.longitude) ?? 0.0,
    );

    final selectedLocation = await context.push<SelectedLocationModel>(
      AppRoutes.mapsScreen,
      extra: {'initialLatLng': initialLatLng},
    );
    if (selectedLocation == null || !context.mounted) return;

    final result = await context.push<AddressModel>(
      AppRoutes.addressFormScreen,
      extra: {
        'selectedLocation': selectedLocation,
        'existingAddress': address,
      },
    );
    if (result != null && context.mounted) {
      context.read<AddressBloc>().add(UpdateAddressLocallyEvent(result));
    }
  }

  void _confirmDelete(BuildContext context, AddressModel address) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.tr('delete_address')),
        content: Text(context.tr('delete_address_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.tr('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
              context
                  .read<AddressBloc>()
                  .add(DeleteAddressEvent(address.addressId));
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            child: Text(context.tr('delete')),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;

  const _ErrorBody({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 52.sp,
              color: context.colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: () =>
                  context.read<AddressBloc>().add(const GetAddressesEvent()),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.tr('retry')),
            ),
          ],
        ),
      ),
    );
  }
}