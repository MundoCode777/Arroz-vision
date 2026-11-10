import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_logo.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.4, curve: Curves.easeOut),
    );
    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1, curve: Curves.easeOut),
    );

    _controller.forward();
    _decideRoute();
  }

  Future<void> _decideRoute() async {
    await Future.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;
    final isLoggedIn = context.read<AuthProvider>().isAuthenticated;
    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: _logoOpacity,
              child: ScaleTransition(
                scale: _logoScale,
                child: const AppLogo(size: 96),
              ),
            ),
            const SizedBox(height: 28),
            FadeTransition(
              opacity: _textOpacity,
              child: const Column(
                children: [
                  Text(
                    AppStrings.appName,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    AppStrings.fincaName,
                    style: TextStyle(color: AppColors.textLight, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            FadeTransition(
              opacity: _textOpacity,
              child: const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
