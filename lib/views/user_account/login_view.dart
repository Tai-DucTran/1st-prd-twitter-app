// LoginView:
// ignore_for_file: use_build_context_synchronously

import 'package:finalproject/constants/routes.dart';
import 'package:finalproject/services/firebase_auth_service/auth_exceptions.dart';
import 'package:finalproject/services/firebase_auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          child: Form(
              child: Column(
            children: [
              const Text(
                "See what's happending in the world right now.",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _email,
                key: const Key('login-email-textfield'),
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: 'Enter your email here'),
              ),
              TextField(
                controller: _password,
                key: const Key('login-password-textfield'),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Enter your password here'),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    await AuthService.firebase().logIn(
                      email: email,
                      password: password,
                    );

                    final user = AuthService.firebase().currentUser;
                    final userName =
                        FirebaseAuth.instance.currentUser?.displayName;

                    // user's email is verified
                    if (user?.isEmailVerified ?? false) {
                      if (userName != null) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          twitterRoute,
                          (route) => false,
                        );
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          createUserNameRoute,
                          (route) => false,
                        );
                      }
                    } else {
                      // user's email is NOT verified
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (route) => false,
                      );
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDialog(
                      context,
                      'User not found',
                    );
                  } on WrongPasswordAuthException {
                    await showErrorDialog(
                      context,
                      'Wrong credentials',
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'Authentication error',
                    );
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              // Register Button
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  },
                  child: const Text(
                    'Not registered yet? Register here!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ))
            ],
          )),
        ));
  }
}
