import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBack;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBack)
          IconButton(
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.fieldFill,
              foregroundColor: AppColors.textDark,
            ),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          )
        else
          const AppLogo(size: 56),
        const SizedBox(height: 28),
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textLight,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
