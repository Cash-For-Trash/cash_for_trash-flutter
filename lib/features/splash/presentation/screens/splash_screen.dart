import 'package:cash_for_trash/core/constants/user_role.dart';
import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/theme/app_assets.dart';
import 'package:cash_for_trash/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:cash_for_trash/features/splash/presentation/bloc/splash_event.dart';
import 'package:cash_for_trash/features/splash/presentation/bloc/splash_state.dart';
import 'package:cash_for_trash/features/splash/presentation/widgets/animated_letters.dart';
import 'package:cash_for_trash/features/splash/presentation/widgets/error_dialog_splash_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(CheckTokenEvent());
  }

  void _handleNavigation(SplashState state) {
    if (state is SplashAuthenticatedState) {
      final userRole = UserRole.fromString(state.role);
      if (userRole == UserRole.customer) {
        context.go(AppRoutes.homeScreen);
      } else if (userRole == UserRole.worker) {
        context.go(AppRoutes.workerHomeScreen);
      } else if (userRole == UserRole.admin) {
        context.go(AppRoutes.adminHomeScreen);
      } else {
        context.go(AppRoutes.loginScreen);
      }
    } else if (state is SplashUnauthenticatedState) {
      final bool isOnboardingCompleted =
          CacheHelper.getData(key: "onboarding") ?? false;
      if (isOnboardingCompleted) {
        context.go(AppRoutes.loginScreen);
      } else {
        context.go(AppRoutes.onbordingScreen);
      }
    } else if (state is SplashErrorState) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => ErrorDialogSplashWidget(
          errorMessage: state.errorMessage,
          onRefresh: () {
            Navigator.of(dialogContext).pop();
            context.read<SplashBloc>().add(CheckTokenEvent());
          },
          onLogout: () async {
            Navigator.of(dialogContext).pop();
            await CacheHelper.removeAllSecretData();
            await CacheHelper().clearUserData();
            if (mounted) {
              context.go(AppRoutes.loginScreen);
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        // Process navigation only if the splash animation has finished
        if (_animationCompleted) {
          _handleNavigation(state);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Rich Eco Gradient Background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0F3814), // Deep forest green
                    Color(0xFF1B5E20), // Rich brand green
                    Color(0xFF2E7D32), // Vibrant eco green
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Decorative background glowing ambient circles for premium visual depth
            Positioned(
              top: -60.h,
              right: -50.w,
              child: Container(
                width: 240.w,
                height: 240.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ).animate().scale(
                    duration: 3.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),
            Positioned(
              bottom: -80.h,
              left: -60.w,
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF66BB6A).withValues(alpha: 0.12),
                ),
              ).animate().scale(
                    duration: 4.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),

            // Main Splash Content
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Brand Logo with glassmorphic halo ring
                    Container(
                      padding: EdgeInsets.all(22.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 32,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: 'logo',
                        child: Image.asset(
                          AppAssets.appLogoPng,
                          width: 160.w,
                          height: 160.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                          begin: const Offset(0.7, 0.7),
                          end: const Offset(1, 1),
                          duration: 1000.ms,
                          curve: Curves.easeOutBack,
                        )
                        .then(delay: 200.ms)
                        .shimmer(duration: 800.ms),

                    SizedBox(height: 28.h),

                    // App Title
                    AnimatedLetters(
                      text: context.tr('cash_for_trash'),
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 26.sp,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      delay: 900.ms,
                    ),

                    SizedBox(height: 12.h),

                    // Subtitle / Tagline
                    AnimatedLetters(
                      text: context.tr('recycle_today_better_tomorrow'),
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 15.sp,
                        height: 1.4,
                      ),
                      delay: 1500.ms,
                    ),
                  ],
                )
                    .animate(
                      onComplete: (_) {
                        setState(() {
                          _animationCompleted = true;
                        });
                        // Trigger navigation checks now that animation is completed
                        _handleNavigation(context.read<SplashBloc>().state);
                      },
                    )
                    .then(delay: 2.seconds)
                    .fadeOut(duration: 600.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
