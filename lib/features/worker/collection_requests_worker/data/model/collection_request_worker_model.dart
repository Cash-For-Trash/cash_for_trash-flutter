import 'package:equatable/equatable.dart';
import 'garbage_weight_worker_model.dart';

class CollectionRequestWorkerModel extends Equatable {
  final String id;
  final String customerName;
  final String customerPhone;
  final String address;
  final String buildingNum;
  final String floor;
  final double latitude;
  final double longitude;
  final String scheduledDay;
  final String scheduledFromTime;
  final String scheduledToTime;
  final String paymentMethod;
  final String status;
  final List<GarbageWeightWorkerModel> garbageTypes;
  final double totalWeight;
  final double earnedPoints;
  final double workerIncome;
  final String createdAt;

  const CollectionRequestWorkerModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.buildingNum,
    required this.floor,
    required this.latitude,
    required this.longitude,
    required this.scheduledDay,
    required this.scheduledFromTime,
    required this.scheduledToTime,
    required this.paymentMethod,
    required this.status,
    required this.garbageTypes,
    required this.totalWeight,
    required this.earnedPoints,
    required this.workerIncome,
    required this.createdAt,
  });

  factory CollectionRequestWorkerModel.fromJson(Map<String, dynamic> json) {
    final customerObj = json['user'] as Map<String, dynamic>? ?? {};
    final addressObj = json['address'] as Map<String, dynamic>? ?? {};
    final rawGarbageList = json['garbage_types'] as List<dynamic>? ?? [];

    return CollectionRequestWorkerModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      customerName: '${customerObj['first_name'] ?? ''} ${customerObj['last_name'] ?? ''}'.trim(),
      customerPhone: customerObj['mobile'] as String? ?? customerObj['telephone'] as String? ?? '',
      address: addressObj['location'] as String? ?? addressObj['address'] as String? ?? '',
      buildingNum: (addressObj['building_num'] ?? '').toString(),
      floor: (addressObj['floor'] ?? '').toString(),
      latitude: (addressObj['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (addressObj['longitude'] as num?)?.toDouble() ?? 0.0,
      scheduledDay: json['scheduled_day'] as String? ?? '',
      scheduledFromTime: json['scheduled_from_time'] as String? ?? '',
      scheduledToTime: json['scheduled_to_time'] as String? ?? '',
      paymentMethod: json['payment_method'] as String? ?? 'CASH',
      status: json['status'] as String? ?? 'ASSIGNED',
      garbageTypes: rawGarbageList
          .map((item) => GarbageWeightWorkerModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalWeight: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      earnedPoints: (json['earned_points'] as num?)?.toDouble() ?? 0.0,
      workerIncome: (json['worker_income'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'garbage_types': garbageTypes.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        customerName,
        customerPhone,
        address,
        buildingNum,
        floor,
        latitude,
        longitude,
        scheduledDay,
        scheduledFromTime,
        scheduledToTime,
        paymentMethod,
        status,
        garbageTypes,
        totalWeight,
        earnedPoints,
        workerIncome,
        createdAt,
      ];
}
