import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: context.horizontalPaddingMedium,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Login'),
              Padding(
                padding: context.verticalPaddingLow,
                child: SizedBox(
                  width: context.dynamicWidth(0.8),
                  height: context.dynamicHeight(0.1),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (value.isValidEmail) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: context.verticalPaddingLow,
                child: SizedBox(
                  width: context.dynamicWidth(0.8),
                  height: context.dynamicHeight(0.1),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  } else if (FirebaseAuth.instance.currentUser != null) {
                    context.goNamed('home');
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
