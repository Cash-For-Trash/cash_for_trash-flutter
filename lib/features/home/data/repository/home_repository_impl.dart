import 'package:dartz/dartz.dart';
import 'package:cash_for_trash/features/home/data/model/home_model.dart';
import 'package:cash_for_trash/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<Either<String, HomeDataModel>> getHome() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return const Right(HomeDataModel(
        userName: "Abdallah",
        points: 350,
        levelProgress: 0.72,
        nextLevelCurrent: 350,
        nextLevelTotal: 500,
        monthlyImpactTrees: 3,
        monthlyImpactRecycledKg: 8.1,
        monthlyImpactCollectedKg: 12.4,
        currentOrder: CurrentOrderModel(
          title: "بلاستيك مختلط",
          timeLeft: "وصول خلال ~15 دقيقة",
          status: "في الطريق",
          progress: 0.4,
        ),
        recentOrders: [
          OrderModel(
            id: "#1042",
            title: "ورق وكرتون",
            status: "مكتمل",
            points: "+45",
            time: "أمس",
          ),
          OrderModel(
            id: "#1041",
            title: "بلاستيك مختلط",
            status: "جاري",
            points: "+30",
            time: "اليوم",
          ),
          OrderModel(
            id: "#1040",
            title: "مخلفات عامة",
            status: "مكتمل",
            points: "+20",
            time: "الجمعة",
          ),
        ],
      ));
    } catch (e) {
      return Left(e.toString());
    }
  }
}