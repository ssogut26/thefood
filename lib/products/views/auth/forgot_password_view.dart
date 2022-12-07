import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/assets_path.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/features/components/alerts.dart';
import 'package:thefood/features/components/loading.dart';
import 'package:thefood/products/view_models/auth_view_model.dart';

class ForgotPassView extends StatefulWidget {
  const ForgotPassView({super.key});

  @override
  State<ForgotPassView> createState() => _ForgotPassViewState();
}

class _ForgotPassViewState extends State<ForgotPassView> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
          child: Stack(
            children: [
              AnimatedContainer(
                duration: context.durationLow,
                height: context.isKeyBoardOpen
                    ? context.dynamicHeight(0.1)
                    : context.dynamicHeight(0.2),
                width: context.dynamicWidth(0.3),
              ),
              Align(
                alignment: const Alignment(0, -0.5),
                child: Text(
                  ProjectTexts.appName,
                  style: context.textTheme.headline1,
                ),
              ),
              Align(
                child: EmailField(
                  controller: _emailController,
                  onChanged: (value) {
                    value = _emailController.text;
                  },
                ),
              ),
              SizedBox(
                height: context.dynamicHeight(0.02),
              ),
              if (isLoading)
                Align(
                  alignment: const Alignment(0, 0.2),
                  child: Center(
                    child: CustomLottieLoading(
                      path: AssetsPath.progression,
                      onLoaded: (composition) {},
                    ),
                  ),
                )
              else
                Align(
                  alignment: context.isKeyBoardOpen
                      ? const Alignment(0, 0.30)
                      : const Alignment(0, 0.25),
                  child: SizedBox(
                    height: context.dynamicHeight(0.06),
                    width: context.dynamicWidth(0.6),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: _emailController.text)
                              .whenComplete(
                                () => AlertWidgets.showMessageDialog(
                                  context,
                                  'Success',
                                  'Please check your email to reset your password.',
                                ),
                              );
                        }
                      },
                      child: Text(
                        ProjectTexts.send,
                        style: context.textTheme.headline3,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: context.dynamicHeight(0.4),
              ),
              Align(
                alignment: const Alignment(0, 0.95),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Press login back to',
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed('login');
                      },
                      child: Text(
                        ProjectTexts.login,
                        style: context.textTheme.headline3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: context.dynamicHeight(0.16),
              ),
              SizedBox(
                height: context.dynamicHeight(0.02),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
