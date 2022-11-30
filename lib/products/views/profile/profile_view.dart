import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/assets_path.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/flags.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/features/components/alerts.dart';
import 'package:thefood/features/components/loading.dart';
import 'package:thefood/features/components/widgets.dart';
import 'package:thefood/products//views/profile/cubit/profile_cubit.dart';
import 'package:thefood/products/models/user.dart';

part '../../view_models/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final getUserRecipe = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('recipes')
      .get();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verifyEmailController = TextEditingController();
  final TextEditingController _verifyPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool isLoading = true;
  bool changeLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    return isLoading;
  }

  @override
  void initState() {
    isLoading = changeLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CustomLottieLoading(
              onLoaded: (composition) {
                isLoading = false;
              },
            ),
          )
        : Scaffold(
            appBar: _appBar(context),
            // for adding recipes to firestore
            floatingActionButton: FloatingActionButton(
              backgroundColor: ProjectColors.darkGrey,
              onPressed: () {
                context.pushNamed('add');
              },
              child: const Icon(Icons.add),
            ),
            body: BlocProvider(
              create: (context) => ProfileCubit(),
              child: SingleChildScrollView(
                padding: ProjectPaddings.pageLarge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          const UserImage(),
                          SizedBox(
                            width: context.dynamicWidth(0.04),
                          ),
                          const UserInfo(),
                          const Spacer(),
                          UpdateUserProfile(
                            nameController: _nameController,
                            emailController: _emailController,
                            verifyEmailController: _verifyEmailController,
                            verifyPasswordController: _verifyPasswordController,
                            newPasswordController: _newPasswordController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.dynamicHeight(0.03),
                    ),
                    const Text(
                      ProjectTexts.myRecipe,
                      style: TextStyle(fontSize: 20),
                    ),
                    FutureUserRecipe(getUserRecipe: getUserRecipe),
                    // I have planned to add follow and followed list
                  ],
                ),
              ),
            ),
          );
  }
}
