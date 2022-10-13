import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/colors.dart';

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
                AnimatedContainer(
                  duration: context.durationLow,
                  height: context.isKeyBoardOpen ? 0 : context.dynamicHeight(0.10),
                  width: context.dynamicWidth(0.3),
                ),
                Text(
                  'the Food',
                  style: context.textTheme.headline1,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.08),
                ),
                Padding(
                  padding: context.verticalPaddingLow,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                    ),
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
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
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
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
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.visiblePassword,
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
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
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
                Padding(
                  padding: context.onlyTopPaddingLow,
                  child: SizedBox(
                    height: context.dynamicHeight(0.06),
                    width: context.dynamicWidth(0.6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ProjectColors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: context.normalBorderRadius,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (FirebaseAuth.instance.currentUser != null) {
                            setState(() {
                              FirebaseAuth.instance.authStateChanges();
                            });
                            context.goNamed('home');
                          }
                        }
                      },
                      child: Text(
                        'Sing Up',
                        style: context.textTheme.bodyText2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.12),
                ),
                Padding(
                  padding: context.verticalPaddingLow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          context.goNamed('login');
                        },
                        child: const Text(
                          'Login',
                        ),
                      ),
                      SizedBox(
                        height: context.dynamicHeight(0.02),
                      )
                    ],
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
