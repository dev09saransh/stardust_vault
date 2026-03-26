import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.onTap,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    final Color bgColor = isDark 
        ? Colors.white.withValues(alpha: _isHovered ? 0.07 : 0.04)
        : Colors.white.withValues(alpha: _isHovered ? 1.0 : 0.98);
    
    final Color borderColor = isDark
        ? colorScheme.primary.withValues(alpha: _isHovered ? 0.4 : 0.15)
        : colorScheme.primary.withValues(alpha: _isHovered ? 0.3 : 0.4); 

    Widget card = AnimatedScale(
      scale: _isHovered ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? colorScheme.primary.withValues(alpha: _isHovered ? 0.15 : 0.05)
                  : Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.04),
              blurRadius: _isHovered ? 40 : 20,
              spreadRadius: _isHovered ? 2 : 0,
              offset: Offset(0, _isHovered ? 12 : 6),
            ),
            if (isDark && _isHovered)
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: -2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: isDark ? 20 : 10, sigmaY: isDark ? 20 : 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: widget.padding ?? const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: borderColor,
                  width: _isHovered ? 1.5 : 1.0,
                ),
                gradient: !isDark ? null : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.01),
                  ],
                ),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (widget.margin != null) {
      card = Padding(padding: widget.margin!, child: card);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: card,
      ),
    );
  }
}
