import 'package:flutter/material.dart';

/// A dynamic background with a deep indigo gradient, slowly breathing 
/// radial glow spots, a glowing background logo, and interactive mouse-following glow.
class StardustBackground extends StatefulWidget {
  final Widget child;
  const StardustBackground({super.key, required this.child});

  @override
  State<StardustBackground> createState() => _StardustBackgroundState();
}

class _StardustBackgroundState extends State<StardustBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) => setState(() => _mousePos = e.localPosition),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              // ─── Base gradient ───
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0A0A1A),
                      Color(0xFF110E2E),
                      Color(0xFF1A1040),
                      Color(0xFF110E2E),
                      Color(0xFF0A0A1A),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // ─── Interactive Mouse Glow ───
              Positioned(
                left: _mousePos.dx - 200,
                top: _mousePos.dy - 200,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF7C4DFF).withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Glowing spot: top-right ───
              Positioned(
                top: -80 + (20 * _animation.value),
                right: -60 + (20 * _animation.value),
                child: Container(
                  width: 320 + (40 * _animation.value),
                  height: 320 + (40 * _animation.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF7C4DFF).withValues(alpha: 0.12 + (0.04 * _animation.value)),
                        const Color(0xFF7C4DFF).withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // ─── Glowing spot: center-left ───
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4 - (30 * _animation.value),
                left: -100 + (20 * _animation.value),
                child: Container(
                  width: 360 + (30 * _animation.value),
                  height: 360 + (30 * _animation.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6C63FF).withValues(alpha: 0.10 + (0.03 * _animation.value)),
                        const Color(0xFF6C63FF).withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // ─── Glowing spot: bottom-right ───
              Positioned(
                bottom: -60 + (15 * _animation.value),
                right: -40 + (15 * _animation.value),
                child: Container(
                  width: 280 + (20 * _animation.value),
                  height: 280 + (20 * _animation.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF9C27B0).withValues(alpha: 0.08 + (0.02 * _animation.value)),
                        const Color(0xFF9C27B0).withValues(alpha: 0.02),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // ─── Child content ───
              widget.child,
            ],
          );
        },
      ),
    );
  }
}
