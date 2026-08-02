import 'package:equatable/equatable.dart';

/// Worker availability (GET /api/availabilities/my)
/// swagger: availability_id, area_id, day_of_week (string enum), from_time, to_time
class AvailabilityAdminModel extends Equatable {
  final String id;
  final String? areaId;
  final String? areaName;
  final String dayOfWeek;
  final String fromTime;
  final String toTime;

  const AvailabilityAdminModel({
    required this.id,
    this.areaId,
    this.areaName,
    required this.dayOfWeek,
    required this.fromTime,
    required this.toTime,
  });

  factory AvailabilityAdminModel.fromJson(Map<String, dynamic> json) {
    final areaObj = json['area'] is Map ? json['area'] as Map<String, dynamic> : <String, dynamic>{};
    return AvailabilityAdminModel(
      id: (json['availability_id'] ?? json['id'] ?? '').toString(),
      areaId: (json['area_id'] ?? areaObj['area_id'] ?? areaObj['id']) as String?,
      areaName: (json['area_name'] ?? areaObj['name']) as String?,
      dayOfWeek: (json['day_of_week'] ?? '').toString(),
      fromTime: (json['from_time'] ?? '').toString(),
      toTime: (json['to_time'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'availability_id': id,
        'area_id': areaId,
        'area_name': areaName,
        'day_of_week': dayOfWeek,
        'from_time': fromTime,
        'to_time': toTime,
      };

  @override
  List<Object?> get props => [id, areaId, areaName, dayOfWeek, fromTime, toTime];
}
