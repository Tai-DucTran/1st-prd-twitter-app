import 'package:finalproject/services/firebase_auth_service/auth_provider.dart';
import 'package:finalproject/services/firebase_auth_service/auth_user.dart';
import 'package:finalproject/services/firebase_auth_service/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider(
        FirebaseAuth.instance,
      ));

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
