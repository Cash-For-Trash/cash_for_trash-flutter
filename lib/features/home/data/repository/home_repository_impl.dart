import 'package:dartz/dartz.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:cash_for_trash/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<Either<String, HomeDataModel>> getHome() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return const Right(HomeDataModel(
        userName: "Mayoora",
        walletBalance: 125.50,
        ecoPoints: 450,
        categories: [
          TrashCategoryModel(id: "1", name: "Plastics", image: "assets/images/plastic.png", pricePerKg: 1.5),
          TrashCategoryModel(id: "2", name: "Paper", image: "assets/images/paper.png", pricePerKg: 0.8),
          TrashCategoryModel(id: "3", name: "Metal", image: "assets/images/metal.png", pricePerKg: 2.5),
          TrashCategoryModel(id: "4", name: "Glass", image: "assets/images/glass.png", pricePerKg: 1.0),
        ],
        ecoTips: [
          EcoTipModel(title: "Save Water", description: "Turn off the tap while brushing your teeth.", icon: "water_drop"),
          EcoTipModel(title: "Recycle Paper", description: "1 ton of recycled paper saves 17 trees.", icon: "eco"),
        ],
        centers: [
          RecyclingCenterModel(name: "Green Life Center", address: "123 Eco Way", rating: 4.8, distanceKm: 1.2),
          RecyclingCenterModel(name: "Eco Cycle Depot", address: "456 Clean St", rating: 4.5, distanceKm: 3.4),
        ],
      ));
    } catch (e) {
      return Left(e.toString());
    }
  }
}