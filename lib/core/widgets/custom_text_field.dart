import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _obscure = true;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.isPassword && _obscure,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      style: const TextStyle(fontSize: 16, color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            end: _focused ? AppColors.primary : AppColors.textLight,
          ),
          duration: const Duration(milliseconds: 200),
          builder: (_, color, __) => Icon(widget.icon, color: color),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    key: ValueKey(_obscure),
                    color: AppColors.textLight,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
