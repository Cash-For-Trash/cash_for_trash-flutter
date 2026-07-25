import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:cash_for_trash/features/address/data/model/address_model.dart';
import 'package:cash_for_trash/features/maps/data/model/address_save_response_model.dart';
import 'package:cash_for_trash/features/maps/data/model/create_address_request_model.dart';
import 'package:cash_for_trash/features/maps/domain/repository/maps_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsRepositoryImpl implements MapsRepository {
  final ApiConsumer apiConsumer;

  static const LatLng _qenaEgypt = LatLng(26.155061, 32.716012);

  MapsRepositoryImpl({required this.apiConsumer});

  @override
  LatLng getDefaultLocation() => _qenaEgypt;

  @override
  Future<LatLng?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isEmpty) return _fallbackAddress(latLng);

      final place = placemarks.first;

      final parts = <String>[
        if (place.street?.isNotEmpty == true) place.street!,
        if (place.subLocality?.isNotEmpty == true) place.subLocality!,
        if (place.locality?.isNotEmpty == true) place.locality!,
        if (place.country?.isNotEmpty == true) place.country!,
      ];

      return parts.isNotEmpty ? parts.join('، ') : _fallbackAddress(latLng);
    } catch (_) {
      return _fallbackAddress(latLng);
    }
  }

  @override
  Future<Either<String, AddressModel>> createAddress(
    CreateAddressRequestModel request,
  ) async {
    return await apiConsumer.post<AddressModel>(
      EndPoint.addresses,
      data: request.toJson(),
      fromJson: (json) => AddressSaveResponseModel.fromJson(json).data,
    );
  }

  @override
  Future<Either<String, AddressModel>> updateAddress(
    String addressId,
    CreateAddressRequestModel request,
  ) async {
    return await apiConsumer.put<AddressModel>(
      '${EndPoint.addresses}/$addressId',
      data: request.toJson(),
      fromJson: (json) => AddressSaveResponseModel.fromJson(json).data,
    );
  }

  String _fallbackAddress(LatLng latLng) {
    final lat = latLng.latitude.toStringAsFixed(5);
    final lng = latLng.longitude.toStringAsFixed(5);
    return '$lat°N, $lng°E';
  }
}