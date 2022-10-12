import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';

class SingUpView extends StatefulWidget {
  const SingUpView({super.key});

  @override
  State<SingUpView> createState() => _SingUpViewState();
}

class _SingUpViewState extends State<SingUpView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.horizontalPaddingMedium,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                const Text('Sing Up'),
                Padding(
                  padding: context.verticalPaddingLow,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                    ),
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      } else if (value.contains(RegExp('[0-9]'))) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: context.verticalPaddingLow,
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
                Padding(
                  padding: context.verticalPaddingLow,
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
                Padding(
                  padding: context.verticalPaddingLow,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                    ),
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password again';
                      } else if (value != _passwordController.text) {
                        return 'The passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('login');
                  },
                  child: const Text('Already have an account? Login'),
                ),
                Padding(
                  padding: context.onlyTopPaddingLow,
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (FirebaseAuth.instance.currentUser != null) {
                            context.goNamed('home');
                          }
                        }
                      },
                      child: const Text('Sing Up'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
