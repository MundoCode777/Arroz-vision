import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/auth_header.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/fade_slide.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final auth = context.read<AuthProvider>();
    final ok = await auth.sendPasswordReset(_emailCtrl.text.trim());

    if (!mounted) return;
    if (ok) {
      AppSnackbar.show(
        context,
        'Te enviamos un enlace para restablecer tu contraseña.',
      );
      Navigator.pop(context);
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
                  title: 'Recupera tu acceso',
                  subtitle:
                      'Escribe tu correo y te enviaremos un enlace para crear una nueva contraseña',
                  showBack: true,
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: FadeSlide(
                  delay: const Duration(milliseconds: 150),
                  child: CustomTextField(
                    controller: _emailCtrl,
                    label: 'Correo electrónico',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: Validators.email,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FadeSlide(
                delay: const Duration(milliseconds: 250),
                child: PrimaryButton(
                  label: 'Enviar enlace',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
