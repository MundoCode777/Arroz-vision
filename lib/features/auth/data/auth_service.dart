import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

/// Error de autenticación con mensaje listo para mostrar al usuario.
class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : AppUser.fromFirebase(user);
  }

  /// Emite cada vez que inicia/cierra sesión o cambia el perfil.
  Stream<AppUser?> get userChanges => _auth.userChanges().map(
    (user) => user == null ? null : AppUser.fromFirebase(user),
  );

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapError(e.code));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapError(e.code));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapError(e.code));
    }
  }

  Future<void> logout() => _auth.signOut();

  String _mapError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta de nuevo más tarde.';
      case 'network-request-failed':
        return 'Sin conexión. Revisa tu internet.';
      default:
        return 'Ocurrió un error. Intenta nuevamente.';
    }
  }
}
