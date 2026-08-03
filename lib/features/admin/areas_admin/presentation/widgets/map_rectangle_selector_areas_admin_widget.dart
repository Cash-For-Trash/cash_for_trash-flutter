import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRectangleSelectorAreasAdminWidget extends StatefulWidget {
  final double? initialNeLat;
  final double? initialNeLng;
  final double? initialSwLat;
  final double? initialSwLng;
  final Function(double neLat, double neLng, double swLat, double swLng)
  onBoundsChanged;

  const MapRectangleSelectorAreasAdminWidget({
    super.key,
    this.initialNeLat,
    this.initialNeLng,
    this.initialSwLat,
    this.initialSwLng,
    required this.onBoundsChanged,
  });

  @override
  State<MapRectangleSelectorAreasAdminWidget> createState() =>
      _MapRectangleSelectorAreasAdminWidgetState();
}

class _MapRectangleSelectorAreasAdminWidgetState
    extends State<MapRectangleSelectorAreasAdminWidget> {
  late LatLng _ne;
  late LatLng _sw;

  @override
  void initState() {
    super.initState();
    _ne = LatLng(
      widget.initialNeLat ?? 26.1700,
      widget.initialNeLng ?? 32.7300,
    );
    _sw = LatLng(
      widget.initialSwLat ?? 26.1400,
      widget.initialSwLng ?? 32.7000,
    );
  }

  void _updateBounds() {
    widget.onBoundsChanged(
      _ne.latitude,
      _ne.longitude,
      _sw.latitude,
      _sw.longitude,
    );
  }

  Set<Polygon> _buildPolygons(BuildContext context) {
    final primaryColor = context.colorScheme.primary;
    final points = [
      _ne,
      LatLng(_ne.latitude, _sw.longitude),
      _sw,
      LatLng(_sw.latitude, _ne.longitude),
    ];

    return {
      Polygon(
        polygonId: const PolygonId('selected_area_rectangle'),
        points: points,
        fillColor: primaryColor.withValues(alpha: 0.25),
        strokeColor: primaryColor,
        strokeWidth: 3,
      ),
    };
  }

  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: const MarkerId('ne_marker'),
        position: _ne,
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'North-East Corner'),
        onDragEnd: (newPos) {
          setState(() {
            _ne = newPos;
          });
          _updateBounds();
        },
      ),
      Marker(
        markerId: const MarkerId('sw_marker'),
        position: _sw,
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'South-West Corner'),
        onDragEnd: (newPos) {
          setState(() {
            _sw = newPos;
          });
          _updateBounds();
        },
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final centerLat = (_ne.latitude + _sw.latitude) / 2;
    final centerLng = (_ne.longitude + _sw.longitude) / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            height: 250.h,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(centerLat, centerLng),
                zoom: 12,
              ),
              markers: _buildMarkers(),
              polygons: _buildPolygons(context),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
            ),
          ),
        ),
      ],
    );
  }
}
