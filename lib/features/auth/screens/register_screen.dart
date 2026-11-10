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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;
    if (ok) {
      AppSnackbar.show(context, 'Cuenta creada correctamente');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FadeSlide(
                child: AuthHeader(
                  title: 'Crea tu cuenta',
                  subtitle: 'Regístrate para empezar a diagnosticar',
                  showBack: true,
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FadeSlide(
                      delay: const Duration(milliseconds: 120),
                      child: CustomTextField(
                        controller: _nameCtrl,
                        label: 'Nombres',
                        icon: Icons.person_outline_rounded,
                        validator: Validators.name,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeSlide(
                      delay: const Duration(milliseconds: 200),
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
                      delay: const Duration(milliseconds: 280),
                      child: CustomTextField(
                        controller: _passCtrl,
                        label: 'Contraseña',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: Validators.password,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeSlide(
                      delay: const Duration(milliseconds: 360),
                      child: CustomTextField(
                        controller: _confirmCtrl,
                        label: 'Confirmar contraseña',
                        icon: Icons.lock_reset_rounded,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: Validators.confirmPassword(
                          () => _passCtrl.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              FadeSlide(
                delay: const Duration(milliseconds: 440),
                child: PrimaryButton(
                  label: 'Crear cuenta',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ),
              const SizedBox(height: 20),
              FadeSlide(
                delay: const Duration(milliseconds: 520),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Ya tienes cuenta?',
                      style: TextStyle(color: AppColors.textLight),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Inicia sesión'),
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
