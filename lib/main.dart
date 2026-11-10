import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _pageFor(String? name) {
    switch (name) {
      case AppRoutes.login:
        return const LoginScreen();
      case AppRoutes.register:
        return const RegisterScreen();
      case AppRoutes.forgotPassword:
        return const ForgotPasswordScreen();
      case AppRoutes.home:
        return const HomeScreen();
      case AppRoutes.splash:
      default:
        return const SplashScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(AuthService()),
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: (settings) {
          final page = _pageFor(settings.name);
          return PageRouteBuilder(
            settings: settings,
            transitionDuration: const Duration(milliseconds: 450),
            reverseTransitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (_, animation, __, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );
              return FadeTransition(
                opacity: curved,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(curved),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
