import 'package:equatable/equatable.dart';

class TrashCategoryModel extends Equatable {
  final String id;
  final String name;
  final String image;
  final double pricePerKg;

  const TrashCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.pricePerKg,
  });

  @override
  List<Object?> get props => [id, name, image, pricePerKg];
}

class EcoTipModel extends Equatable {
  final String title;
  final String description;
  final String icon;

  const EcoTipModel({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  List<Object?> get props => [title, description, icon];
}

class RecyclingCenterModel extends Equatable {
  final String name;
  final String address;
  final double rating;
  final double distanceKm;

  const RecyclingCenterModel({
    required this.name,
    required this.address,
    required this.rating,
    required this.distanceKm,
  });

  @override
  List<Object?> get props => [name, address, rating, distanceKm];
}

class HomeDataModel extends Equatable {
  final String userName;
  final double walletBalance;
  final int ecoPoints;
  final List<TrashCategoryModel> categories;
  final List<EcoTipModel> ecoTips;
  final List<RecyclingCenterModel> centers;

  const HomeDataModel({
    required this.userName,
    required this.walletBalance,
    required this.ecoPoints,
    required this.categories,
    required this.ecoTips,
    required this.centers,
  });

  @override
  List<Object?> get props => [
        userName,
        walletBalance,
        ecoPoints,
        categories,
        ecoTips,
        centers,
      ];
}