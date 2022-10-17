import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/views/auth/auth_models.dart';

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
                  ProjectTexts.appName,
                  style: context.textTheme.headline1,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.05),
                ),
                NameField(nameController: _nameController),
                EmailField(emailController: _emailController),
                PasswordField(passwordController: _passwordController),
                ConfirmPasswordField(
                  confirmPasswordController: _confirmPasswordController,
                  passwordController: _passwordController,
                ),
                RegisterButton(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  nameController: _nameController,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.07),
                ),
                Padding(
                  padding: context.verticalPaddingLow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(ProjectTexts.alreadyHaveAccount),
                      TextButton(
                        onPressed: () {
                          context.goNamed('login');
                        },
                        child: const Text(
                          ProjectTexts.login,
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
