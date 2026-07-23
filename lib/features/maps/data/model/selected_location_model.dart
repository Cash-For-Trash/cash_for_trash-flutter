import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedLocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final String displayAddress;

  const SelectedLocationModel({
    required this.latitude,
    required this.longitude,
    required this.displayAddress,
  });

  factory SelectedLocationModel.fromLatLng(
    LatLng latLng, {
    String displayAddress = '',
  }) {
    return SelectedLocationModel(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      displayAddress: displayAddress,
    );
  }

  SelectedLocationModel copyWith({
    double? latitude,
    double? longitude,
    String? displayAddress,
  }) {
    return SelectedLocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      displayAddress: displayAddress ?? this.displayAddress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'display_address': displayAddress,
    };
  }

  factory SelectedLocationModel.fromJson(Map<String, dynamic> json) {
    return SelectedLocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      displayAddress: json['display_address'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, displayAddress];
}
