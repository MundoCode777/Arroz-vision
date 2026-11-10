class Validators {
  Validators._();

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tus nombres';
    }
    if (value.trim().length < 3) {
      return 'Ingresa un nombre válido';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa tu correo electrónico';
    }
    final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  /// Devuelve un validador que compara con el campo de contraseña original.
  static String? Function(String?) confirmPassword(String Function() original) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Confirma tu contraseña';
      }
      if (value != original()) {
        return 'Las contraseñas no coinciden';
      }
      return null;
    };
  }
}
