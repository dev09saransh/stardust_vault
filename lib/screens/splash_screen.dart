import 'package:flutter/material.dart';
import '../widgets/stardust_background.dart';
import '../widgets/glowing_text.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.7, curve: Curves.easeInOut)));
    _scale = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/intro');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Shield icon with elegant pulse
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lavenderAccent.withValues(alpha: 0.25),
                              AppTheme.softPurple.withValues(alpha: 0.10),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lavenderAccent.withValues(alpha: 0.2 + (0.1 * value)),
                              blurRadius: 60 + (20 * value),
                              spreadRadius: 20 + (10 * value),
                            ),
                          ],
                        ),
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.shield_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  GlowingText('Stardust Vault',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.platinum,
                          letterSpacing: 6)),
                  const SizedBox(height: 12),
                  Text('SECURE YOUR DIGITAL LEGACY',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.silverMist.withValues(alpha: 0.5),
                          letterSpacing: 3,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
