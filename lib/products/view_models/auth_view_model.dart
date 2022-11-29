import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/assets_path.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/flags.dart';
import 'package:thefood/core/constants/hive_constants.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/features/components/loading.dart';
import 'package:thefood/products/models/user.dart';
import 'package:thefood/products/views/auth/bloc/login/login_cubit.dart';
import 'package:thefood/products/views/auth/bloc/sign_up/sign_up_cubit.dart';

class NameField extends StatelessWidget {
  const NameField({
    super.key,
    required TextEditingController nameController,
    required void Function(String?)? onChanged,
  })  : _nameController = nameController,
        _onChanged = onChanged;

  final TextEditingController _nameController;
  final void Function(String?)? _onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.verticalPaddingLow,
      child: SizedBox(
        width: context.dynamicWidth(0.8),
        height: context.dynamicHeight(0.10),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: ProjectTexts.name,
          ),
          onChanged: _onChanged,
          controller: _nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required void Function(String?)? onChanged,
    required TextEditingController? controller,
    Widget? suffixIcon,
  })  : _controller = controller,
        _suffixIcon = suffixIcon,
        _onChanged = onChanged;

  final TextEditingController? _controller;
  final void Function(String?)? _onChanged;
  final Widget? _suffixIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.verticalPaddingLow,
      child: SizedBox(
        width: context.dynamicWidth(0.8),
        height: context.dynamicHeight(0.10),
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: ProjectTexts.email,
            suffixIcon: _suffixIcon,
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: _onChanged,
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required void Function(String)? onChanged,
    TextEditingController? passwordController,
    String? initialValue,
    Widget? suffixIcon,
  })  : _passwordController = passwordController,
        _initialValue = initialValue,
        _suffixIcon = suffixIcon,
        _onChanged = onChanged;

  static bool isVisible = true;
  final TextEditingController? _passwordController;
  final String? _initialValue;
  final Widget? _suffixIcon;
  final void Function(String)? _onChanged;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.verticalPaddingLow,
      child: SizedBox(
        width: context.dynamicWidth(0.8),
        height: context.dynamicHeight(0.10),
        child: TextFormField(
          enabled: widget._suffixIcon == null,
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: widget._onChanged,
          initialValue: widget._initialValue,
          obscureText: PasswordField.isVisible,
          decoration: InputDecoration(
            suffixIcon: widget._suffixIcon ??
                IconButton(
                  onPressed: () {
                    setState(() {
                      PasswordField.isVisible = !PasswordField.isVisible;
                    });
                  },
                  icon: PasswordField.isVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
            border: const OutlineInputBorder(),
            labelText: ProjectTexts.password,
          ),
          controller: widget._passwordController,
        ),
      ),
    );
  }
}

class ConfirmPasswordField extends StatefulWidget {
  const ConfirmPasswordField({
    super.key,
    required TextEditingController confirmPasswordController,
    required void Function(String)? onChanged,
    required TextEditingController passwordController,
  })  : _confirmPasswordController = confirmPasswordController,
        _onChanged = onChanged,
        _passwordController = passwordController;

  static bool isVisible = true;
  final TextEditingController _confirmPasswordController;
  final TextEditingController _passwordController;
  final void Function(String)? _onChanged;

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.verticalPaddingLow,
      child: SizedBox(
        width: context.dynamicWidth(0.8),
        height: context.dynamicHeight(0.10),
        child: TextFormField(
          onChanged: widget._onChanged,
          obscureText: ConfirmPasswordField.isVisible,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  ConfirmPasswordField.isVisible = !ConfirmPasswordField.isVisible;
                });
              },
              icon: ConfirmPasswordField.isVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
            border: const OutlineInputBorder(),
            labelText: ProjectTexts.confirmPassword,
          ),
          controller: widget._confirmPasswordController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }
}

class CheckBoxAndLoginButton extends StatefulWidget {
  CheckBoxAndLoginButton({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool isChecked,
  })  : _emailController = emailController,
        _passwordController = passwordController,
        _isChecked = isChecked;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  late bool _isChecked;

  @override
  State<CheckBoxAndLoginButton> createState() => _CheckBoxAndLoginButtonState();
}

class _CheckBoxAndLoginButtonState extends State<CheckBoxAndLoginButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: context.onlyBottomPaddingLow,
          child: Row(
            children: [
              Checkbox(
                value: widget._isChecked,
                onChanged: (value) {
                  widget._isChecked = !widget._isChecked;
                  setState(() {});
                },
              ),
              const Text(ProjectTexts.rememberMe),
            ],
          ),
        ),
        LoginButton(
          emailController: widget._emailController,
          passwordController: widget._passwordController,
          isChecked: widget._isChecked,
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool isChecked,
  })  : _emailController = emailController,
        _passwordController = passwordController,
        _isChecked = isChecked;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  late final bool _isChecked;

  Box<String> rememberCrendentialBox = Hive.box<String>(HiveConstants.loginCredentials);

  Future<void> login() async {
    if (_isChecked) {
      await rememberCrendentialBox.put('email', _emailController.text);
    } else {
      await rememberCrendentialBox.delete('email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.06),
      width: context.dynamicWidth(0.6),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? Center(
                  child: CustomLottieLoading(
                    path: AssetsPath.progression,
                    onLoaded: (composition) {},
                  ),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.normalBorderRadius,
                    ),
                  ),
                  onPressed: () async {
                    if (state.status.isValid) {
                      await context.read<LoginCubit>().logInWithCredentials();
                      await login();
                      if (FirebaseAuth.instance.currentUser != null) {
                        context.goNamed('/');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(ProjectTexts.loginError),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }
                  },
                  child: Text(
                    ProjectTexts.login,
                    style: context.textTheme.bodyText2,
                  ),
                );
        },
      ),
    );
  }
}

class AreaDropdown extends StatefulWidget {
  const AreaDropdown({
    super.key,
  });

  @override
  State<AreaDropdown> createState() => _AreaDropdownState();
}

class _AreaDropdownState extends State<AreaDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.verticalPaddingLow,
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          return SizedBox(
            width: context.dynamicWidth(0.8),
            height: context.dynamicHeight(0.10),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              hint: const Text(ProjectTexts.selectArea),
              items: [
                for (var index = 0; index < countryFlags.length; index++)
                  DropdownMenuItem(
                    value: countryFlags.keys.elementAt(index),
                    child: Row(
                      children: [
                        Padding(
                          padding: context.onlyRightPaddingLow,
                          child: CachedNetworkImage(
                            imageUrl: countryFlags.values.elementAt(index),
                            height: 32,
                            width: 32,
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                            ),
                          ),
                        ),
                        Text(countryFlags.keys.elementAt(index)),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  state.country = value.toString();
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.onlyTopPaddingLow,
      child: SizedBox(
        height: context.dynamicHeight(0.06),
        width: context.dynamicWidth(0.6),
        child: BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            return state.status.isSubmissionInProgress
                ? Center(
                    child: CustomLottieLoading(
                      path: AssetsPath.progression,
                      onLoaded: (composition) {},
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ProjectColors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: context.normalBorderRadius,
                      ),
                    ),
                    onPressed: () async {
                      if (state.status.isValid) {
                        await context.read<SignUpCubit>().signUpFormSubmitted();
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await FirebaseAuth.instance.currentUser
                              ?.updateDisplayName(state.name.value);
                          await FirebaseAuth.instance.currentUser
                              ?.updatePhotoURL(AssetsPath.defaultUserImage);
                          final userData = UserModels(
                            userId: user.uid,
                            name: state.name.value,
                            email: state.email.value,
                            photoURL: AssetsPath.defaultUserImage,
                            country: state.country,
                          );
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .set(userData.toJson());
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(ProjectTexts.registerError),
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                      }
                    },
                    child: Text(
                      ProjectTexts.register,
                      style: context.textTheme.bodyText2,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
