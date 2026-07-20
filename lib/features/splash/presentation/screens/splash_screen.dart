import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/theme/app_assets.dart';
import 'package:cash_for_trash/features/splash/presentation/widgets/animated_letters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();

  //   _navigate();
  // }

  // Future<void> _navigate() async {
  //   await Future.onComplete();
  //   context.go(AppRoutes.homeScreen);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.colorScheme.onPrimaryContainer,
                      context.colorScheme.primary,
                    ],
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
                child:
                    Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Hero(
                                  tag: 'logo',
                                  child: Image.asset(
                                    AppAssets.splashPhoto,
                                    width: 220.w,
                                    color: context.colorScheme.onSecondary,
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 500.ms)
                                .scale(
                                  begin: const Offset(.15, .15),
                                  end: const Offset(1, 1),
                                  duration: 1200.ms,
                                  curve: Curves.elasticOut,
                                )
                                .rotate(
                                  begin: -.9,
                                  end: 0,
                                  duration: 900.ms,
                                  curve: Curves.easeOutBack,
                                )
                                .then()
                                .shimmer(duration: 800.ms),

                            AnimatedLetters(
                              text: "Cash for Trash",
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.onSecondary,
                              ),
                              delay: 1700.ms,
                            ),
                            AnimatedLetters(
                              text: "Recycle Today, Better Tomorrow ",
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.onSecondary,
                              ),
                              delay: 2700.ms,
                            ),
                          ],
                        )
                        .animate(
                          onComplete: (_) {
                            bool isOnboardingCompleted =
                                CacheHelper.getData(key: "onboarding") ?? false;
                            if (isOnboardingCompleted == true) {
                              //todo افتكر انك تعدل دى تخليها ال login screen لما تعمل ال auth علشان تتاكد
                              context.go(AppRoutes.loginScreen);
                            } else {
                              context.go(AppRoutes.onbordingScreen);
                            }
                          },
                        )
                        .then(delay: 6.seconds)
                        .fadeOut(duration: 700.ms),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(
                begin: const Offset(1.08, 1.08),
                end: const Offset(1, 1),
                duration: 8.seconds,
                curve: Curves.easeOut,
              ),
    );
  }
}
