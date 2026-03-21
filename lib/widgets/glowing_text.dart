import 'package:flutter/material.dart';
import '../theme.dart';

class GlowingText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const GlowingText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The Glow
        Text(
          text,
          textAlign: textAlign,
          style: (style ?? const TextStyle()).copyWith(
            color: Colors.transparent,
            shadows: [
              Shadow(
                color: AppTheme.lavenderAccent.withValues(alpha: 0.5),
                blurRadius: 20,
              ),
              Shadow(
                color: AppTheme.softPurple.withValues(alpha: 0.3),
                blurRadius: 40,
              ),
            ],
          ),
        ),
        // The Actual Text
        Text(
          text,
          textAlign: textAlign,
          style: style,
        ),
      ],
    );
  }
}
