import 'package:equatable/equatable.dart';

class AvailabilityWorkerModel extends Equatable {
  final String id;
  final String areaId;
  final String areaName;
  final String dayOfWeek;
  final String fromTime;
  final String toTime;
  final bool isActive;

  const AvailabilityWorkerModel({
    required this.id,
    required this.areaId,
    required this.areaName,
    required this.dayOfWeek,
    required this.fromTime,
    required this.toTime,
    required this.isActive,
  });

  factory AvailabilityWorkerModel.fromJson(Map<String, dynamic> json) {
    final areaObj = json['area'] as Map<String, dynamic>? ?? {};
    return AvailabilityWorkerModel(
      id: json['id'] as String? ?? json['availability_id'] as String? ?? '',
      areaId: json['area_id'] as String? ?? areaObj['area_id'] as String? ?? '',
      areaName: areaObj['name'] as String? ?? json['area_name'] as String? ?? '',
      dayOfWeek: json['day_of_week'] as String? ?? 'SATURDAY',
      fromTime: json['from_time'] as String? ?? '09:00:00',
      toTime: json['to_time'] as String? ?? '12:00:00',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area_id': areaId,
      'day_of_week': dayOfWeek,
      'from_time': fromTime,
      'to_time': toTime,
    };
  }

  @override
  List<Object?> get props => [
        id,
        areaId,
        areaName,
        dayOfWeek,
        fromTime,
        toTime,
        isActive,
      ];
}
