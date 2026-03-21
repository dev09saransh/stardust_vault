import 'package:flutter/material.dart';
import '../widgets/stardust_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/glowing_text.dart';
import '../theme.dart';

// ─── Auth Selection ───
class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    // Shield icon logo
                    Container(
                      width: 56,
                      height: 56,
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
                    GlowingText('Welcome',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.platinum,
                            letterSpacing: 2)),
                    const SizedBox(height: 8),
                    Text('Choose how you want to continue',
                        style: TextStyle(
                            color: AppTheme.silverMist.withValues(alpha: 0.5),
                            fontSize: 14)),
                    const SizedBox(height: 48),
                    GradientButton(
                        text: 'Login',
                        icon: Icons.login_rounded,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/login')),
                    const SizedBox(height: 16),
                    _OutlineButton(
                        text: 'Sign Up',
                        icon: Icons.person_add_outlined,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signup')),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, '/dashboard'),
                      child: Text('Do it later →',
                          style: TextStyle(
                              color: AppTheme.silverMist.withValues(alpha: 0.4),
                              fontSize: 14)),
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

// ─── Login ───
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    _backButton(context),
                    const SizedBox(height: 16),
                    GlowingText('Login',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.platinum,
                            letterSpacing: 1)),
                    const SizedBox(height: 32),
                    GlassCard(
                      child: Column(children: [
                        TextField(
                            decoration:
                                const InputDecoration(labelText: 'Email')),
                        const SizedBox(height: 16),
                        TextField(
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: 'Password')),
                        const SizedBox(height: 24),
                        GradientButton(
                            text: 'Login',
                            onPressed: () =>
                                Navigator.pushNamed(
                                    context, '/otp-verification')),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/forgot-password'),
                                child: Text('Forgot Password?',
                                    style: TextStyle(
                                        color: AppTheme.lavenderAccent,
                                        fontSize: 13))),
                            TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/recover-account'),
                                child: Text('Recover Account',
                                    style: TextStyle(
                                        color: AppTheme.lavenderAccent,
                                        fontSize: 13))),
                          ],
                        ),
                      ]),
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

// ─── Signup ───
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    _backButton(context),
                    const SizedBox(height: 16),
                    Text('Create Account',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.platinum,
                            letterSpacing: 1)),
                    const SizedBox(height: 32),
                    GlassCard(
                      child: Column(children: [
                        TextField(
                            decoration:
                                const InputDecoration(labelText: 'Email')),
                        const SizedBox(height: 16),
                        TextField(
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: 'Password')),
                        const SizedBox(height: 16),
                        TextField(
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'Confirm Password')),
                        const SizedBox(height: 24),
                        GradientButton(
                            text: 'Create Account',
                            onPressed: () =>
                                Navigator.pushNamed(
                                    context, '/otp-verification')),
                      ]),
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

// ─── Forgot Password ───
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    _backButton(context),
                    const SizedBox(height: 16),
                    Text('Forgot Password',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.platinum,
                            letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Text('Enter your email to receive a reset link',
                        style: TextStyle(
                            color: AppTheme.silverMist.withValues(alpha: 0.5),
                            fontSize: 14)),
                    const SizedBox(height: 32),
                    GlassCard(
                      child: Column(children: [
                        TextField(
                            decoration:
                                const InputDecoration(labelText: 'Email')),
                        const SizedBox(height: 24),
                        GradientButton(
                          text: 'Reset Password',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Password reset link sent to your email!'),
                              ),
                            );
                          },
                        ),
                      ]),
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

// ─── Recover Account ───
class RecoverAccountScreen extends StatelessWidget {
  const RecoverAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    _backButton(context),
                    const SizedBox(height: 16),
                    Text('Recover Account',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.platinum,
                            letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Text('Enter your email or recovery identifier',
                        style: TextStyle(
                            color: AppTheme.silverMist.withValues(alpha: 0.5),
                            fontSize: 14)),
                    const SizedBox(height: 32),
                    GlassCard(
                      child: Column(children: [
                        TextField(
                            decoration: const InputDecoration(
                                labelText: 'Email / Recovery ID')),
                        const SizedBox(height: 24),
                        GradientButton(
                          text: 'Recover',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Recovery instructions sent! Check your inbox.'),
                              ),
                            );
                          },
                        ),
                      ]),
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

// ─── OTP Verification ───
class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StardustBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    _backButton(context),
                    const SizedBox(height: 16),
                    Text('Verification',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.platinum,
                            letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Text('Enter the 4-digit code sent to your email',
                        style: TextStyle(
                            color: AppTheme.silverMist.withValues(alpha: 0.5),
                            fontSize: 14)),
                    const SizedBox(height: 32),
                    GlassCard(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.platinum),
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppTheme.lavenderAccent,
                                        width: 2),
                                  ),
                                ),
                                onChanged: (v) => _onChanged(v, index),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        GradientButton(
                          text: 'Verify',
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/dashboard');
                          },
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {},
                          child: Text('Resend Code',
                              style: TextStyle(
                                  color: AppTheme.lavenderAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ]),
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

// ─── Shared helpers ───
Widget _backButton(BuildContext context) {
  return Align(
    alignment: Alignment.centerLeft,
    child: IconButton(
      icon: Icon(Icons.arrow_back_ios_rounded, color: AppTheme.silverMist),
      onPressed: () => Navigator.pop(context),
    ),
  );
}

class _OutlineButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const _OutlineButton(
      {required this.text, required this.icon, required this.onPressed});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: _hov
                    ? AppTheme.lavenderAccent
                    : Colors.white.withValues(alpha: 0.15),
                width: 1.5),
            color: _hov
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: AppTheme.silverMist, size: 20),
              const SizedBox(width: 8),
              Text(widget.text,
                  style: TextStyle(
                      color: AppTheme.silverMist,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
