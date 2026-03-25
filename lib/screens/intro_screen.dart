import 'package:flutter/material.dart';
import '../widgets/stardust_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../theme.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Animation<double> _fade(double start, double end) =>
      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, end, curve: Curves.easeOut)));

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.timer_outlined,
        'title': 'Inactivity Trigger',
        'desc': 'Automatically execute your digital will when inactivity is detected'
      },
      {
        'icon': Icons.notifications_active_outlined,
        'title': 'Smart Alerts',
        'desc': 'Intelligent notifications keep your nominees informed'
      },
      {
        'icon': Icons.people_outline,
        'title': 'Trusted Nominees',
        'desc': 'Designate trusted individuals to manage your digital legacy'
      },
    ];

    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: _fade(0, 0.3),
                      child: Column(children: [
                        // Logo instead of icon
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.lavenderAccent.withValues(alpha: 0.25),
                                AppTheme.lavenderAccent.withValues(alpha: 0.10),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.lavenderAccent
                                    .withValues(alpha: 0.15),
                                blurRadius: 30,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shield_rounded,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Secure Your\nDigital Legacy',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.2,
                                letterSpacing: 1)),
                        const SizedBox(height: 10),
                        Text('Your assets, your rules, forever protected',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                fontSize: 14,
                                letterSpacing: 0.5)),
                      ]),
                    ),
                    const SizedBox(height: 40),
                    ...List.generate(features.length, (i) {
                      final f = features[i];
                      final start = 0.2 + i * 0.15;
                      return FadeTransition(
                        opacity: _fade(start, (start + 0.3).clamp(0, 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GlassCard(
                            child: Row(children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.lavenderAccent
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(f['icon'] as IconData,
                                    color: AppTheme.lavenderAccent, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(f['title'] as String,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).colorScheme.onSurface)),
                                    const SizedBox(height: 4),
                                    Text(f['desc'] as String,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: _fade(0.7, 1),
                      child: GradientButton(
                        text: 'Get Started',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/auth'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
