class CustomerPointsModel {
  final int points;
  final double? valueInEgp;

  const CustomerPointsModel({required this.points, this.valueInEgp});

  factory CustomerPointsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    return CustomerPointsModel(
      points: _parseInt(
        data['points'] ?? data['green_points'] ?? json['points'],
      ),
      valueInEgp: _parseDouble(
        data['value'] ??
            data['points_value'] ??
            data['points_egp'] ??
            data['amount'] ??
            json['value'] ??
            json['points_value'] ??
            json['points_egp'] ??
            json['amount'],
      ),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    final parsed = double.tryParse(value?.toString() ?? '');
    return parsed;
  }
}
