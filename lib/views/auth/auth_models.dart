import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/texts.dart';

class NameField extends StatelessWidget {
  const NameField({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

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
          controller: _nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return ProjectTexts.nameError;
            } else if (value.contains(RegExp('[0-9]'))) {
              return ProjectTexts.nameValidError;
            }
            return null;
          },
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

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
            labelText: ProjectTexts.email,
          ),
          controller: _emailController,
          validator: (value) {
            if (value!.isEmpty) {
              return ProjectTexts.emailError;
            }
            return null;
          },
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  static bool isVisible = false;
  final TextEditingController _passwordController;

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
          obscureText: PasswordField.isVisible,
          decoration: InputDecoration(
            suffixIcon: IconButton(
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
          validator: (value) {
            if (value!.isEmpty) {
              return ProjectTexts.passwordEmptyError;
            } else if (value.length < 6) {
              return ProjectTexts.password6CharError;
            }
            return null;
          },
        ),
      ),
    );
  }
}

class ConfirmPasswordField extends StatefulWidget {
  const ConfirmPasswordField({
    super.key,
    required TextEditingController confirmPasswordController,
    required TextEditingController passwordController,
  })  : _confirmPasswordController = confirmPasswordController,
        _passwordController = passwordController;

  static bool isVisible = false;
  final TextEditingController _confirmPasswordController;
  final TextEditingController _passwordController;

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
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value!.isEmpty) {
              return ProjectTexts.passwordEmptyError;
            } else if (value != widget._passwordController.text) {
              return ProjectTexts.passwordMatchError;
            }
            return null;
          },
        ),
      ),
    );
  }
}

class CheckBoxAndLoginButton extends StatefulWidget {
  CheckBoxAndLoginButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool isChecked,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController,
        _isChecked = isChecked;

  final GlobalKey<FormState> _formKey;
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
          formKey: widget._formKey,
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
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool isChecked,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController,
        _isChecked = isChecked;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  late final bool _isChecked;

  Box<String> rememberCrendentialBox = Hive.box<String>('rememberCrendential');

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
            context.goNamed('navigator');
          }
          await login();
        },
        child: Text(
          ProjectTexts.login,
          style: context.textTheme.bodyText2,
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  RegisterButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController,
        _nameController = nameController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _nameController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            final name = _nameController.text;
            final email = _emailController.text;
            final password = _passwordController.text;
            try {
              if (_formKey.currentState!.validate()) {
                final result = await _auth.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = await result.user?.updateDisplayName(name);
                if (FirebaseAuth.instance.currentUser != null) {
                  FirebaseAuth.instance.authStateChanges();
                  context.goNamed('home');
                  return user;
                }
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('The password provided is too weak.'),
                  ),
                );
              } else if (e.code == 'email-already-in-use') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('The account already exists for that email.'),
                  ),
                );
              }
            } catch (e) {
              SnackBar(
                content: Text('Error: $e'),
              );
            }
          },
          child: Text(
            ProjectTexts.register,
            style: context.textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
