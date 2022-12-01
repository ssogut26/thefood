import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thefood/features/components/loading.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomLottieLoading(
          onLoaded: (composition) {
            _auth.currentUser != null ? context.goNamed('/') : context.goNamed('onboard');
          },
        ),
      ),
    );
  }
}
