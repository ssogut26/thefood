import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/products/view_models/auth_view_model.dart';
import 'package:thefood/products/views/auth/bloc/sign_up/sign_up_cubit.dart';

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
      body: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pop();
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
              );
          }
        },
        child: SingleChildScrollView(
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
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return NameField(
                        nameController: _nameController,
                        onChanged: (name) {
                          context.read<SignUpCubit>().nameChanged(name ?? '');
                        },
                      );
                    },
                  ),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return EmailField(
                        onChanged: (email) {
                          context.read<SignUpCubit>().emailChanged(email ?? '');
                        },
                        controller: _emailController,
                      );
                    },
                  ),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return PasswordField(
                        passwordController: _passwordController,
                        onChanged: (password) =>
                            context.read<SignUpCubit>().passwordChanged(password),
                      );
                    },
                  ),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return ConfirmPasswordField(
                        confirmPasswordController: _confirmPasswordController,
                        passwordController: _passwordController,
                        onChanged: (password) => context
                            .read<SignUpCubit>()
                            .confirmedPasswordChanged(password),
                      );
                    },
                  ),
                  const RegisterButton(),
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
      ),
    );
  }
}
