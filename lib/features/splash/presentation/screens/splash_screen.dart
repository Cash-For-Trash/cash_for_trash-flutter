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
        // TODO: Add admin home screen
        // context.go(AppRoutes.adminHomeScreen);
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
        body: Container(
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
          child: Column(
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
                text: context.tr('cash_for_trash'),
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSecondary,
                ),
                delay: 1700.ms,
              ),
              AnimatedLetters(
                text: context.tr('recycle_today_better_tomorrow'),
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
                  setState(() {
                    _animationCompleted = true;
                  });
                  // Trigger navigation checks now that animation is completed
                  _handleNavigation(context.read<SplashBloc>().state);
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
      ),
    );
  }
}
