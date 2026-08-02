import 'package:equatable/equatable.dart';

class CollectionRequestModel extends Equatable {
  final String addressId;
  final String availabilityId;
  final String paymentMethod;
  final double quantity;
  final String? collectionImg;
  final List<CollectionGarbageTypeModel> garbageTypes;

  const CollectionRequestModel({
    required this.addressId,
    required this.availabilityId,
    this.paymentMethod = 'CASH',
    required this.quantity,
    this.collectionImg,
    required this.garbageTypes,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'address_id': addressId,
      'availability_id': availabilityId,
      'payment_method': paymentMethod,
      'quantity': quantity,
      'garbage_types': garbageTypes.map((e) => e.toJson()).toList(),
    };
    if (collectionImg != null && collectionImg!.isNotEmpty) {
      data['collection_img'] = collectionImg;
    }
    return data;
  }

  @override
  List<Object?> get props => [
        addressId,
        availabilityId,
        paymentMethod,
        quantity,
        collectionImg,
        garbageTypes,
      ];
}

class CollectionGarbageTypeModel extends Equatable {
  final String garbageTypeId;
  final double estimatedWeight;

  const CollectionGarbageTypeModel({
    required this.garbageTypeId,
    required this.estimatedWeight,
  });

  Map<String, dynamic> toJson() {
    return {
      'garbage_type_id': garbageTypeId,
      'estimated_weight': estimatedWeight,
    };
  }

  @override
  List<Object?> get props => [garbageTypeId, estimatedWeight];
}
