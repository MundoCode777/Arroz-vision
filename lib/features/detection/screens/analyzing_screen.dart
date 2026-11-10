import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../providers/detection_provider.dart';

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  static const double _imageSize = 260;
  static const List<String> _messages = [
    'Preparando la imagen...',
    'Buscando patrones en la hoja...',
    'Clasificando el resultado...',
  ];

  late final AnimationController _scan;
  Timer? _messageTimer;
  int _messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _messageTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      if (mounted) {
        setState(() => _messageIndex = (_messageIndex + 1) % _messages.length);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    final detection = context.read<DetectionProvider>();
    final ok = await detection.analyze();

    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.result);
    } else {
      AppSnackbar.show(
        context,
        detection.errorMessage ?? 'No se pudo analizar la imagen.',
        isError: true,
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final path = context.read<DetectionProvider>().imagePath;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: SizedBox(
                    width: _imageSize,
                    height: _imageSize,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (path != null)
                          Image.file(File(path), fit: BoxFit.cover),
                        Container(color: Colors.black.withValues(alpha: 0.12)),
                        AnimatedBuilder(
                          animation: _scan,
                          builder: (_, __) => Align(
                            alignment: Alignment(0, -1 + 2 * _scan.value),
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white,
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryLight.withValues(
                                      alpha: 0.9,
                                    ),
                                    blurRadius: 14,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'Analizando hoja',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  _messages[_messageIndex],
                  key: ValueKey(_messageIndex),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
