import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cash_for_trash/features/address/data/model/address_model.dart';
import 'package:cash_for_trash/features/maps/data/model/create_address_request_model.dart';

abstract class MapsRepository {
  LatLng getDefaultLocation();
  Future<LatLng?> getCurrentLocation();
  Future<String> getAddressFromLatLng(LatLng latLng);
  Future<Either<String, AddressModel>> createAddress(
    CreateAddressRequestModel request,
  );
  Future<Either<String, AddressModel>> updateAddress(
    String addressId,
    CreateAddressRequestModel request,
  );
}