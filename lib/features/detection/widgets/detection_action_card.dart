import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DetectionActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;
  final VoidCallback onTap;

  const DetectionActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.filled = false,
  });

  @override
  State<DetectionActionCard> createState() => _DetectionActionCardState();
}

class _DetectionActionCardState extends State<DetectionActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final filled = widget.filled;
    final textColor = filled ? Colors.white : AppColors.textDark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: filled ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (filled ? AppColors.primary : Colors.black).withValues(
                  alpha: filled ? 0.28 : 0.06,
                ),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: filled
                      ? Colors.white.withValues(alpha: 0.18)
                      : AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 28,
                  color: filled ? Colors.white : AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: filled
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: textColor.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
