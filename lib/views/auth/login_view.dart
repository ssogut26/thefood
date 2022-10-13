import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/colors.dart';

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: context.durationLow,
                  height: context.isKeyBoardOpen ? 0 : context.dynamicHeight(0.10),
                  width: context.dynamicWidth(0.3),
                ),
                Text(
                  'theFood',
                  style: context.textTheme.headline1,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.08),
                ),
                Padding(
                  padding: context.verticalPaddingLow,
                  child: SizedBox(
                    width: context.dynamicWidth(0.8),
                    height: context.dynamicHeight(0.08),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                      ),
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
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
                    height: context.dynamicHeight(0.08),
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
                Padding(
                  padding: context.onlyBottomPaddingLow,
                  child: Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      const Text('Remember me'),
                    ],
                  ),
                ),
                SizedBox(
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
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      }
                      if (FirebaseAuth.instance.currentUser != null) {
                        setState(() {
                          FirebaseAuth.instance.authStateChanges();
                        });
                        context.goNamed('home');
                      }
                    },
                    child: Text(
                      'Login',
                      style: context.textTheme.bodyText2,
                    ),
                  ),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.02),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.19),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        context.goNamed('singup');
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
                SizedBox(
                  height: context.dynamicHeight(0.02),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
