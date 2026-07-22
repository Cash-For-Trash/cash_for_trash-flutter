import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/theme/app_assets.dart';
import 'package:cash_for_trash/features/onboarding/presentation/widgets/onboarding_page_content.dart';
import 'package:cash_for_trash/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, String>> _pages = [
    {
      'title': 'النظافة تبدأ بخطوة',
      'body': 'اطلب جمع المخلفات من منزلك في دقائق,\nونحن نهتم بالباقي.',
    },
    {
      'title': 'مخلفاتك لها قيمة',
      'body':
          'حوّل ما لا تحتاجه إلى نقاط يمكنك استخدامها\nللحصول على مكافآت حقيقية.',
    },
    {
      'title': 'أثرك يبدأ من منزلك',
      'body':
          'كل طلب يساهم في تقليل النفايات ودعم زراعة\nالأشجار من أجل بيئة أفضل.',
    },
  ];

  Future<void> _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    } else {
      await CacheHelper.saveData(key: "onboarding", value: true);

      if (!mounted) return;

      _navigateToAuth();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToAuth() {
    context.go(AppRoutes.loginScreen);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child:
            Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await CacheHelper.saveData(
                                key: "onboarding",
                                value: true,
                              );
                              _navigateToAuth();
                            },
                            child: Text(
                              'تخطى',
                              style: context.textTheme.labelLarge?.copyWith(
                                color: context.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: _currentPage > 0 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: IgnorePointer(
                              ignoring: _currentPage == 0,
                              child: OutlinedButton.icon(
                                onPressed: _previousPage,
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14.sp,
                                ),
                                label: Text(
                                  'رجوع',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                        color: context.colorScheme.primary,
                                      ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: context.colorScheme.primary
                                        .withValues(alpha: 0.4),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          return OnboardingPageContent(
                            imagePath: AppAssets.onBoardingPhoto,
                            title: _pages[index]['title']!,
                            body: _pages[index]['body']!,
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                        bottom: 32.h,
                      ),
                      child: Column(
                        children: [
                          PageIndicator(
                            count: _pages.length,
                            currentIndex: _currentPage,
                          ),
                          SizedBox(height: 24.h),
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: _nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colorScheme.primary,
                                foregroundColor: context.colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                elevation: 0,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  _currentPage == _pages.length - 1
                                      ? 'ابدأ الآن'
                                      : 'متابعة',
                                  key: ValueKey<int>(_currentPage),
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                        color: context.colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.05, end: 0, duration: 500.ms),
      ),
    );
  }
}
