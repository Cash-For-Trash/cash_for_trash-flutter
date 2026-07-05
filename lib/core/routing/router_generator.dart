import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final RouteObserver<ModalRoute<void>> homeRouteObserver =
    RouteObserver<ModalRoute<void>>();

class RouterGenerator {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    observers: [homeRouteObserver],
    routes: [],
  );
}
