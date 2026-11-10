import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/auth_service.dart';
import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;
  late final StreamSubscription<AppUser?> _subscription;

  AppUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._service) {
    _user = _service.currentUser;
    _subscription = _service.userChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _run(
      () => _service.register(name: name, email: email, password: password),
    );
  }

  Future<bool> login({required String email, required String password}) {
    return _run(() => _service.login(email: email, password: password));
  }

  Future<bool> sendPasswordReset(String email) {
    return _run(() => _service.sendPasswordReset(email));
  }

  Future<void> logout() => _service.logout();

  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AuthFailure catch (e) {
      _errorMessage = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
