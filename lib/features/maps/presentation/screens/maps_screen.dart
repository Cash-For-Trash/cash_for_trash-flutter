import 'dart:async';

import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/features/maps/data/model/selected_location_model.dart';
import 'package:cash_for_trash/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:cash_for_trash/features/maps/presentation/screens/widgets/center_pin_maps_widget.dart';
import 'package:cash_for_trash/features/maps/presentation/screens/widgets/location_info_bottom_sheet_maps_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _lastCameraTarget;

  static const double _defaultZoom = 15.0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapsBloc, MapsState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context),
          body: _buildBody(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.colorScheme.surface.withValues(alpha: 0.92),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: context.colorScheme.onSurface,
          size: 20.sp,
        ),
        onPressed: () => context.pop(null),
      ),
      title: Text(
        context.tr('select_location'),
        style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, MapsState state) {
    if (state is MapsInitialState || state is MapsLoadingState) {
      return Center(
        child: CircularProgressIndicator(
          color: context.colorScheme.primary,
        ),
      );
    }

    if (state is MapsLocationActiveState) {
      return Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: state.initialPosition,
              zoom: _defaultZoom,
            ),
            onMapCreated: (controller) {
              if (!_mapController.isCompleted) {
                _mapController.complete(controller);
              }
            },
            onCameraMove: (position) {
              _lastCameraTarget = position.target;
            },
            onCameraIdle: () {
              if (_lastCameraTarget != null) {
                context.read<MapsBloc>().add(
                      MapsCameraMovedEvent(_lastCameraTarget!),
                    );
              }
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          const CenterPinMapsWidget(),
          Align(
            alignment: Alignment.bottomCenter,
            child: LocationInfoBottomSheetMapsWidget(
              address: state.currentAddress,
              isResolvingAddress: state.isResolvingAddress,
              onConfirm: () => context.read<MapsBloc>().add(
                    const MapsConfirmLocationEvent(),
                  ),
            ),
          ),
        ],
      );
    }

    if (state is MapsErrorState) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Text(
            state.message,
            style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.error,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Center(
      child: CircularProgressIndicator(
        color: context.colorScheme.primary,
      ),
    );
  }

  void _handleStateChanges(BuildContext context, MapsState state) {
    if (state is MapsLocationConfirmedState) {
      context.pop<SelectedLocationModel>(state.selectedLocation);
    }
  }
}
