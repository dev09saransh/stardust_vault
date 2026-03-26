import 'package:flutter/material.dart';
import '../theme.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = isEnabled),
      onExit: (_) => setState(() => _hovering = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width ?? double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
          decoration: BoxDecoration(
            gradient: isEnabled
                ? AppTheme.buttonGradient
                : LinearGradient(
                    colors: [
                      Colors.grey.withValues(alpha: 0.2),
                      Colors.grey.withValues(alpha: 0.1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppTheme.lavenderAccent
                          .withValues(alpha: _hovering ? 0.4 : 0.2),
                      blurRadius: _hovering ? 24 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon,
                    color: isEnabled
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                    size: 20),
                const SizedBox(width: AppSpacing.small),
              ],
              Text(
                widget.text,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isEnabled
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
