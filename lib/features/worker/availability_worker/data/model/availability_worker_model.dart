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
    this.areaName = '',
    required this.dayOfWeek,
    required this.fromTime,
    required this.toTime,
    this.isActive = true,
  });

  factory AvailabilityWorkerModel.fromJson(Map<String, dynamic> json) {
    final areaObj = json['area'] is Map<String, dynamic>
        ? json['area'] as Map<String, dynamic>
        : <String, dynamic>{};
    return AvailabilityWorkerModel(
      id: json['availability_id'] as String? ??
          json['id'] as String? ??
          json['availabilityId'] as String? ??
          '',
      areaId: json['area_id'] as String? ??
          json['areaId'] as String? ??
          areaObj['area_id'] as String? ??
          areaObj['id'] as String? ??
          '',
      areaName: json['area_name'] as String? ??
          json['areaName'] as String? ??
          areaObj['name'] as String? ??
          '',
      dayOfWeek: json['day_of_week'] as String? ??
          json['dayOfWeek'] as String? ??
          '',
      fromTime: json['from_time'] as String? ??
          json['fromTime'] as String? ??
          '',
      toTime: json['to_time'] as String? ??
          json['toTime'] as String? ??
          '',
      isActive: json['is_active'] as bool? ??
          json['isActive'] as bool? ??
          true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'availability_id': id,
      'area_id': areaId,
      if (areaName.isNotEmpty) 'area_name': areaName,
      'day_of_week': dayOfWeek,
      'from_time': fromTime,
      'to_time': toTime,
      'is_active': isActive,
    };
  }

  AvailabilityWorkerModel copyWith({
    String? id,
    String? areaId,
    String? areaName,
    String? dayOfWeek,
    String? fromTime,
    String? toTime,
    bool? isActive,
  }) {
    return AvailabilityWorkerModel(
      id: id ?? this.id,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      isActive: isActive ?? this.isActive,
    );
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
