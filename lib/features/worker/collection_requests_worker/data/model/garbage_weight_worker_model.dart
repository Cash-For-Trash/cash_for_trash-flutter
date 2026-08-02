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

  static double _parseDouble(dynamic val) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  factory GarbageWeightWorkerModel.fromJson(Map<String, dynamic> json) {
    return GarbageWeightWorkerModel(
      garbageTypeId: (json['garbage_type_id'] ?? json['id'] ?? '').toString(),
      garbageTypeName: (json['garbage_type_name'] ?? json['name'] ?? '').toString(),
      pricePerKg: _parseDouble(json['price_per_kg']),
      expectedWeight: _parseDouble(json['expected_weight']),
      actualWeight: _parseDouble(json['actual_weight']),
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
