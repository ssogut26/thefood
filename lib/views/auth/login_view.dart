import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/views/auth/auth_models.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  late Box<String> rememberCrendentialBox;

  @override
  void initState() {
    super.initState();
    rememberCrendentialBox = Hive.box<String>('rememberCrendential');
    createOpenBox();
  }

  Future<void> createOpenBox() async {
    rememberCrendentialBox = Hive.box<String>('rememberCrendential');
    await getdata();
  }

  Future<void> getdata() async {
    if (rememberCrendentialBox.get('email') != null) {
      _emailController.text = rememberCrendentialBox.get('email')!;
      setState(() {});
      isChecked = true;
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
                  ProjectTexts.appName,
                  style: context.textTheme.headline1,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.08),
                ),
                EmailField(emailController: _emailController),
                PasswordField(passwordController: _passwordController),
                CheckBoxAndLoginButton(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isChecked: isChecked,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.02),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed('forgot');
                  },
                  child: const Text(ProjectTexts.forgotPassword),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(ProjectTexts.dontHaveAccount),
                    TextButton(
                      onPressed: () {
                        context.goNamed('singup');
                      },
                      child: const Text(ProjectTexts.register),
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
