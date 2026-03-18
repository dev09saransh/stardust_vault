import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/auth_screens.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const StardustVaultApp());
}

class StardustVaultApp extends StatelessWidget {
  const StardustVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stardust Vault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final routes = <String, WidgetBuilder>{
          '/': (_) => const SplashScreen(),
          '/intro': (_) => const IntroScreen(),
          '/auth': (_) => const AuthSelectionScreen(),
          '/login': (_) => const LoginScreen(),
          '/signup': (_) => const SignupScreen(),
          '/forgot-password': (_) => const ForgotPasswordScreen(),
          '/recover-account': (_) => const RecoverAccountScreen(),
          '/otp-verification': (_) => const OTPVerificationScreen(),
          '/dashboard': (_) => const DashboardScreen(),
        };

        final builder = routes[settings.name];
        if (builder != null) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (ctx, anim, _) => builder(ctx),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          );
        }
        return null;
      },
    );
  }
}
