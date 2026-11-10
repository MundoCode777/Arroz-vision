import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/auth_header.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/fade_slide.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final auth = context.read<AuthProvider>();
    final ok = await auth.login(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      AppSnackbar.show(
        context,
        auth.errorMessage ?? 'Ocurrió un error',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              const FadeSlide(
                child: AuthHeader(
                  title: 'Bienvenido de nuevo',
                  subtitle: 'Inicia sesión para diagnosticar tus cultivos',
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FadeSlide(
                      delay: const Duration(milliseconds: 150),
                      child: CustomTextField(
                        controller: _emailCtrl,
                        label: 'Correo electrónico',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeSlide(
                      delay: const Duration(milliseconds: 250),
                      child: CustomTextField(
                        controller: _passCtrl,
                        label: 'Contraseña',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: Validators.password,
                      ),
                    ),
                  ],
                ),
              ),
              FadeSlide(
                delay: const Duration(milliseconds: 320),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeSlide(
                delay: const Duration(milliseconds: 400),
                child: PrimaryButton(
                  label: 'Ingresar',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ),
              const SizedBox(height: 28),
              FadeSlide(
                delay: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes cuenta?',
                      style: TextStyle(color: AppColors.textLight),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                      child: const Text('Crear cuenta'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
