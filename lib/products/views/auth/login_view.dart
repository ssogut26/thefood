import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/hive_constants.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/products/view_models/auth_view_model.dart';
import 'package:thefood/products/views/auth/bloc/login/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;
  late Box<String> rememberCredentialBox;

  @override
  void initState() {
    super.initState();
    rememberCredentialBox = Hive.box<String>(HiveConstants.loginCredentials);
    createOpenBox();
  }

  Future<void> createOpenBox() async {
    rememberCredentialBox = Hive.box<String>(HiveConstants.loginCredentials);
    await getdata();
  }

  Future<void> getdata() async {
    if (rememberCredentialBox.get('email') != null) {
      setState(() {
        _emailController.text = rememberCredentialBox.get('email')!;
      });
      isChecked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.15,
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: context.horizontalPaddingMedium,
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status.isSubmissionFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'Authentication Failure'),
                    ),
                  );
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: context.durationLow,
                    height: context.isKeyBoardOpen
                        ? context.dynamicHeight(0.1)
                        : context.dynamicHeight(0.2),
                    width: context.dynamicWidth(0.3),
                  ),
                  Text(
                    ProjectTexts.appName,
                    style: context.textTheme.headline1,
                  ),
                  SizedBox(
                    height: context.dynamicHeight(0.08),
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      context.read<LoginCubit>().emailChanged(_emailController);
                      return EmailField(
                        controller: _emailController,
                        onChanged: (_) {
                          context.read<LoginCubit>().emailChanged(_emailController);
                        },
                      );
                    },
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.password != current.password,
                    builder: (context, state) {
                      return PasswordField(
                        onChanged: (password) =>
                            context.read<LoginCubit>().passwordChanged(password),
                        passwordController: _passwordController,
                      );
                    },
                  ),
                  CheckBoxAndLoginButton(
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
                    child: Text(
                      ProjectTexts.forgotPassword,
                      style: context.textTheme.headline3,
                    ),
                  ),
                  SizedBox(
                    height: context.dynamicHeight(0.16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        ProjectTexts.dontHaveAccount,
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed('singup');
                        },
                        child: Text(
                          ProjectTexts.register,
                          style: context.textTheme.headline3,
                        ),
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
      ),
    );
  }
}
