import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapsRepository {
  LatLng getDefaultLocation();
  Future<LatLng?> getCurrentLocation();
  Future<String> getAddressFromLatLng(LatLng latLng);
}