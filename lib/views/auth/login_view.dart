import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  late Box<String> rememberBox;
  bool isChecked = false;
  late var loginData;

  @override
  void initState() {
    createOpenBox();
    loginData = login();
    super.initState();
  }

  Future<void> createOpenBox() async {
    rememberBox = await Hive.openBox('logindata');
    await getdata();
  }

  Future<void> getdata() async {
    if (rememberBox.get('email') != null) {
      _emailController.text = rememberBox.get('email')!;
      isChecked = true;
      setState(() {});
    }
  }

  login() async {
    if (isChecked) {
      await rememberBox.put('email', _emailController.value.text);
    } else {
      await rememberBox.put('email', '');
    }
  }

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
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          isChecked = !isChecked;
                          setState(() {});
                        },
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: context.dynamicHeight(0.06),
                //   width: context.dynamicWidth(0.6),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: ProjectColors.yellow,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: context.normalBorderRadius,
                //       ),
                //     ),
                //     onPressed: () async {
                //       if (_formKey.currentState!.validate()) {
                //         await FirebaseAuth.instance.signInWithEmailAndPassword(
                //           email: _emailController.text,
                //           password: _passwordController.text,
                //         );
                //       }
                //       if (FirebaseAuth.instance.currentUser != null) {
                //         FirebaseAuth.instance.authStateChanges();
                //         context.goNamed('home');
                //       }
                //       login();
                //     },
                //     child: Text(
                //       'Login',
                //       style: context.textTheme.bodyText2,
                //     ),
                //   ),
                // ),
                LoginButton(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  data: loginData,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.02),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('forgot');
                  },
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

class LoginButton extends StatelessWidget {
  LoginButton({
    super.key,
    required this.formKey,
    required this.data,
    required this.emailController,
    required this.passwordController,
  });
  late final dynamic data;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          if (formKey.currentState!.validate()) {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
          }
          if (FirebaseAuth.instance.currentUser != null) {
            FirebaseAuth.instance.authStateChanges();
            context.goNamed('home');
          }
          data;
        },
        child: Text(
          'Login',
          style: context.textTheme.bodyText2,
        ),
      ),
    );
  }
}
