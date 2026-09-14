import 'package:cash_for_trash/core/utils/date_formatter.dart';
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

  String get formattedScheduledSlot => AppDateFormatter.formatScheduledSlot(
        day: scheduledDay,
        fromTime: scheduledFromTime,
        toTime: scheduledToTime,
      );

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

  static double _parseDouble(dynamic val) {
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  factory CollectionRequestWorkerModel.fromJson(Map<String, dynamic> json) {
    final customerObj = json['user'] as Map<String, dynamic>? ?? {};
    final addressObj = json['address'] as Map<String, dynamic>? ?? {};
    final rawGarbageList = (json['requestGarbages'] ??
            json['request_garbages'] ??
            json['garbage_types'] ??
            []) as List<dynamic>;

    return CollectionRequestWorkerModel(
      id: (json['collection_request_id'] ?? json['request_id'] ?? json['id'] ?? json['_id'] ?? '')
          .toString(),
      customerName: '${customerObj['first_name'] ?? ''} ${customerObj['last_name'] ?? ''}'.trim(),
      customerPhone:
          (customerObj['mobile'] ?? customerObj['email'] ?? customerObj['telephone'] ?? '')
              .toString(),
      address: (addressObj['location'] ?? addressObj['address'] ?? '').toString(),
      buildingNum: (addressObj['building_num'] ?? '').toString(),
      floor: (addressObj['floor'] ?? '').toString(),
      latitude: _parseDouble(addressObj['latitude']),
      longitude: _parseDouble(addressObj['longitude']),
      scheduledDay: (json['scheduled_day'] ?? '').toString(),
      scheduledFromTime: (json['scheduled_from_time'] ?? '').toString(),
      scheduledToTime: (json['scheduled_to_time'] ?? '').toString(),
      paymentMethod: (json['payment_method'] ?? 'CASH').toString(),
      status: (json['status'] ?? 'PENDING').toString(),
      garbageTypes: rawGarbageList
          .map((item) => GarbageWeightWorkerModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalWeight: _parseDouble(json['quantity'] ?? json['total_weight']),
      earnedPoints: _parseDouble(json['earned_points']),
      workerIncome: _parseDouble(json['worker_income']),
      createdAt: (json['created_at'] ?? '').toString(),
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
