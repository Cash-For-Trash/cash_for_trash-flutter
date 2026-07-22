import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedLetters extends StatelessWidget {
  const AnimatedLetters({
    super.key,
    required this.text,
    required this.style,
    this.delay = Duration.zero,
  });

  final String text;
  final TextStyle? style;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final letters = text.split('');

    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(
        letters.length,
        (index) => Text(letters[index], style: style)
            .animate(delay: delay + (index * 70).ms)
            .moveY(
              begin: 25,
              end: 0,
              duration: 700.ms,
              curve: Curves.easeOutCubic,
            )
            .blur(
              begin: const Offset(12, 12),
              end: Offset.zero,
              duration: 700.ms,
            )
            .fadeIn(),
      ),
    );
  }
}
