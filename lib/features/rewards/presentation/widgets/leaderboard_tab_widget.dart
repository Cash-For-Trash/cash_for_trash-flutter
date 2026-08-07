import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderboardTabWidget extends StatelessWidget {
  const LeaderboardTabWidget({super.key});

  static const List<Map<String, dynamic>> _leaders = [
    {'name': 'سارة أحمد', 'points': 1240, 'rank': 1},
    {'name': 'محمد علي', 'points': 980, 'rank': 2},
    {'name': 'أنت (أنت)', 'points': 350, 'rank': 3, 'isMe': true},
    {'name': 'فاطمة حسن', 'points': 310, 'rank': 4},
    {'name': 'خالد إبراهيم', 'points': 290, 'rank': 5},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final warning = context.extraColors.warning ?? colorScheme.secondary;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: _leaders.asMap().entries.map((entry) {
          final index = entry.key;
          final leader = entry.value;
          final isMe = leader['isMe'] == true;
          final rank = leader['rank'] as int;

          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isMe
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isMe
                    ? colorScheme.primary.withValues(alpha: 0.3)
                    : colorScheme.outline,
                width: isMe ? 1.5 : 1.2,
              ),
            ),
            child: Row(
              children: [
                _buildRankBadge(rank, warning, colorScheme, context),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        leader['name'] as String,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: isMe
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: warning,
                            size: 13.r,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            '${leader['points']} ${context.tr('points')}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: warning,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.emoji_events_rounded,
                    color: warning,
                    size: 24.r,
                  ),
                ],
              ],
            ),
          ).animate(delay: (index * 70).ms).fade(duration: 350.ms).slideX(
                begin: 0.05,
                curve: Curves.easeOut,
              );
        }).toList(),
      ),
    );
  }

  Widget _buildRankBadge(
    int rank,
    Color warning,
    ColorScheme colorScheme,
    BuildContext context,
  ) {
    Color badgeColor;
    Color textColor;
    IconData? icon;

    if (rank == 1) {
      badgeColor = const Color(0xFFFFD700);
      textColor = const Color(0xFF7A5B00);
      icon = Icons.emoji_events_rounded;
    } else if (rank == 2) {
      badgeColor = const Color(0xFFB0BEC5);
      textColor = const Color(0xFF37474F);
      icon = Icons.emoji_events_rounded;
    } else if (rank == 3) {
      badgeColor = const Color(0xFFD7815A);
      textColor = Colors.white;
      icon = Icons.emoji_events_rounded;
    } else {
      badgeColor = colorScheme.surfaceContainerHigh;
      textColor = colorScheme.onSurface;
      icon = null;
    }

    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: icon != null && rank <= 3
            ? Icon(icon, color: textColor, size: 18.r)
            : Text(
                '#$rank',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  fontFamily: 'Tajawal',
                ),
              ),
      ),
    );
  }
}
