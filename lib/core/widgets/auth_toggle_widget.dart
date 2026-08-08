import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AuthToggleWidget extends StatelessWidget {
  final bool isLogin;

  const AuthToggleWidget({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isLogin) {
                  context.pushReplacement(AppRoutes.loginScreen);
                }
              },
              child: Container(
                margin: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: isLogin ? context.colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: isLogin
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  context.tr("login"),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: isLogin ? FontWeight.bold : FontWeight.w500,
                    color: isLogin
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isLogin) {
                  context.pushReplacement(AppRoutes.registerScreen);
                }
              },
              child: Container(
                margin: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: !isLogin ? context.colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: !isLogin
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  context.tr("register"),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: !isLogin ? FontWeight.bold : FontWeight.w500,
                    color: !isLogin
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
