import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Icon(Icons.eco_rounded, color: Colors.white, size: size * 0.55),
    );
  }
}
