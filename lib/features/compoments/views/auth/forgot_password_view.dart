import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/texts.dart';

class ForgotPassView extends StatefulWidget {
  const ForgotPassView({super.key});

  @override
  State<ForgotPassView> createState() => _ForgotPassViewState();
}

class _ForgotPassViewState extends State<ForgotPassView> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                Padding(
                  padding: context.verticalPaddingLow,
                  child: SizedBox(
                    width: context.dynamicWidth(0.8),
                    height: context.dynamicHeight(0.08),
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
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _emailController.text,
                        );
                      }
                    },
                    child: Text(
                      ProjectTexts.send,
                      style: context.textTheme.bodyText2,
                    ),
                  ),
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
