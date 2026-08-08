import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedLetters extends StatelessWidget {
  const AnimatedLetters({
    super.key,
    required this.text,
    required this.style,
    this.delay = Duration.zero,
    this.animateByWords = true,
  });

  final String text;
  final TextStyle? style;
  final Duration delay;
  final bool animateByWords;

  @override
  Widget build(BuildContext context) {
    // Arabic script ranges check (\u0600-\u06FF) to preserve cursive shaping
    final bool containsArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    final bool useWords = animateByWords || containsArabic;

    if (useWords) {
      final words = text.split(' ');
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6.w,
        runSpacing: 4.h,
        children: List.generate(
          words.length,
          (index) => Text(
            words[index],
            style: style,
            textAlign: TextAlign.center,
          )
              .animate(delay: delay + (index * 120).ms)
              .moveY(
                begin: 18,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              )
              .blur(
                begin: const Offset(6, 6),
                end: Offset.zero,
                duration: 600.ms,
              )
              .fadeIn(duration: 500.ms),
        ),
      );
    } else {
      final letters = text.split('');
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(
          letters.length,
          (index) => Text(letters[index], style: style)
              .animate(delay: delay + (index * 40).ms)
              .moveY(
                begin: 18,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              )
              .blur(
                begin: const Offset(6, 6),
                end: Offset.zero,
                duration: 600.ms,
              )
              .fadeIn(duration: 500.ms),
        ),
      );
    }
  }
}

