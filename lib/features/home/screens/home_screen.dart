import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/fade_slide.dart';
import '../../auth/providers/auth_provider.dart';
import '../../detection/screens/detection_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final fullName = (user?.name.isNotEmpty ?? false) ? user!.name : 'Usuario';
    final firstName = fullName.split(' ').first;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FadeSlide(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 12, 0),
                child: Row(
                  children: [
                    const AppLogo(size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola, $firstName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const Text(
                            AppStrings.fincaName,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar sesión',
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.textLight,
                      ),
                      onPressed: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: DetectionHomeScreen()),
          ],
        ),
      ),
    );
  }
}
