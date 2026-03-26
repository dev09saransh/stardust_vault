import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../theme.dart';

class GuidedTour extends StatefulWidget {
  final List<TourStep> steps;
  final VoidCallback onFinish;
  final Function(int)? onStepChange;

  const GuidedTour({
    super.key,
    required this.steps,
    required this.onFinish,
    this.onStepChange,
  });

  @override
  State<GuidedTour> createState() => _GuidedTourState();
}

class _GuidedTourState extends State<GuidedTour> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    // Trigger first step change
    if (widget.onStepChange != null && widget.steps.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onStepChange!(_currentStep);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStep >= widget.steps.length) return const SizedBox.shrink();

    final step = widget.steps[_currentStep];

    return Stack(
      children: [
        // Semi-transparent overlay for contrast
        Positioned.fill(
          child: FadeIn(
            duration: const Duration(milliseconds: 300),
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                    ? const Color(0xFF1E1E2C).withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.98),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (step.icon != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.lavenderAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lavenderAccent.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(step.icon, size: 40, color: AppTheme.lavenderAccent),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      step.description,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
                        height: 1.5,
                        shadows: Theme.of(context).brightness == Brightness.dark ? [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ] : [],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step ${_currentStep + 1} of ${widget.steps.length}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: widget.onFinish,
                              child: Text('Skip',
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                if (_currentStep < widget.steps.length - 1) {
                                  setState(() => _currentStep++);
                                  if (widget.onStepChange != null) {
                                    widget.onStepChange!(_currentStep);
                                  }
                                } else {
                                  widget.onFinish();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.lavenderAccent,
                                foregroundColor: Colors.white,
                                elevation: 12,
                                shadowColor: AppTheme.lavenderAccent.withValues(alpha: 0.8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: Text(_currentStep == widget.steps.length - 1 ? 'Finish' : 'Next',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TourStep {
  final String title;
  final String description;
  final IconData? icon;
  final int? targetIndex;

  TourStep({
    required this.title,
    required this.description,
    this.icon,
    this.targetIndex,
  });
}
