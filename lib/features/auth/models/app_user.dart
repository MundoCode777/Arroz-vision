import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;

  const AppUser({required this.uid, required this.name, required this.email});

  factory AppUser.fromFirebase(User user) {
    return AppUser(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
