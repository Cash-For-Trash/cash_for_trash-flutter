import 'package:equatable/equatable.dart';

class GarbageWeightWorkerModel extends Equatable {
  final String garbageTypeId;
  final String garbageTypeName;
  final double pricePerKg;
  final double expectedWeight;
  final double actualWeight;

  const GarbageWeightWorkerModel({
    required this.garbageTypeId,
    required this.garbageTypeName,
    required this.pricePerKg,
    required this.expectedWeight,
    required this.actualWeight,
  });

  GarbageWeightWorkerModel copyWith({
    String? garbageTypeId,
    String? garbageTypeName,
    double? pricePerKg,
    double? expectedWeight,
    double? actualWeight,
  }) {
    return GarbageWeightWorkerModel(
      garbageTypeId: garbageTypeId ?? this.garbageTypeId,
      garbageTypeName: garbageTypeName ?? this.garbageTypeName,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      expectedWeight: expectedWeight ?? this.expectedWeight,
      actualWeight: actualWeight ?? this.actualWeight,
    );
  }

  factory GarbageWeightWorkerModel.fromJson(Map<String, dynamic> json) {
    return GarbageWeightWorkerModel(
      garbageTypeId: json['garbage_type_id'] as String? ?? json['id'] as String? ?? '',
      garbageTypeName: json['garbage_type_name'] as String? ?? json['name'] as String? ?? '',
      pricePerKg: (json['price_per_kg'] as num?)?.toDouble() ?? 0.0,
      expectedWeight: (json['expected_weight'] as num?)?.toDouble() ?? 0.0,
      actualWeight: (json['actual_weight'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'garbage_type_id': garbageTypeId,
      'actual_weight': actualWeight,
    };
  }

  @override
  List<Object?> get props => [
        garbageTypeId,
        garbageTypeName,
        pricePerKg,
        expectedWeight,
        actualWeight,
      ];
}
