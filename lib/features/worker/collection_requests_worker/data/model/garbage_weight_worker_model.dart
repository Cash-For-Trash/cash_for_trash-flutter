import 'package:equatable/equatable.dart';

class GarbageWeightWorkerModel extends Equatable {
  final String requestGarbageId;
  final String garbageTypeId;
  final String garbageTypeName;
  final double pricePerKg;
  final double expectedWeight;
  final double actualWeight;

  const GarbageWeightWorkerModel({
    required this.requestGarbageId,
    required this.garbageTypeId,
    required this.garbageTypeName,
    required this.pricePerKg,
    required this.expectedWeight,
    required this.actualWeight,
  });

  GarbageWeightWorkerModel copyWith({
    String? requestGarbageId,
    String? garbageTypeId,
    String? garbageTypeName,
    double? pricePerKg,
    double? expectedWeight,
    double? actualWeight,
  }) {
    return GarbageWeightWorkerModel(
      requestGarbageId: requestGarbageId ?? this.requestGarbageId,
      garbageTypeId: garbageTypeId ?? this.garbageTypeId,
      garbageTypeName: garbageTypeName ?? this.garbageTypeName,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      expectedWeight: expectedWeight ?? this.expectedWeight,
      actualWeight: actualWeight ?? this.actualWeight,
    );
  }

  static double _parseDouble(dynamic val) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  factory GarbageWeightWorkerModel.fromJson(Map<String, dynamic> json) {
    final garbageTypeObj = json['garbageType'] as Map<String, dynamic>? ??
        json['garbage_type'] as Map<String, dynamic>? ??
        {};

    return GarbageWeightWorkerModel(
      requestGarbageId:
          (json['request_garbage_id'] ?? json['requestGarbageId'] ?? json['id'] ?? '').toString(),
      garbageTypeId: (garbageTypeObj['garbage_type_id'] ??
              garbageTypeObj['id'] ??
              json['garbage_type_id'] ??
              json['id'] ??
              '')
          .toString(),
      garbageTypeName: (garbageTypeObj['name'] ??
              garbageTypeObj['garbage_type_name'] ??
              json['garbage_type_name'] ??
              json['name'] ??
              '')
          .toString(),
      pricePerKg: _parseDouble(garbageTypeObj['price_per_kg'] ?? json['price_per_kg']),
      expectedWeight: _parseDouble(json['expected_weight'] ?? json['quantity']),
      actualWeight: _parseDouble(json['actual_weight']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_garbage_id': requestGarbageId.isNotEmpty ? requestGarbageId : garbageTypeId,
      'actual_weight': actualWeight,
    };
  }

  @override
  List<Object?> get props => [
        requestGarbageId,
        garbageTypeId,
        garbageTypeName,
        pricePerKg,
        expectedWeight,
        actualWeight,
      ];
}
