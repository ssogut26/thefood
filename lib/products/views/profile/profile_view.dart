import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/flags.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/features/compoments/loading.dart';
import 'package:thefood/products//views/profile/cubit/profile_cubit.dart';

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
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: isLoading
          ? Center(
              child: CustomLottieLoading(
                onLoaded: (composition) {
                  isLoading = false;
                },
              ),
            )
          : Scaffold(
              appBar: _appBar(),
              // for adding recipes to firestore
              floatingActionButton: FloatingActionButton(
                backgroundColor: ProjectColors.darkGrey,
                onPressed: () {
                  context.pushNamed('add');
                },
                child: const Icon(Icons.add),
              ),
              body: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return Padding(
                    padding: ProjectPaddings.pageLarge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const PickImageOnTap(),
                            SizedBox(
                              width: context.dynamicWidth(0.04),
                            ),
                            const UserInfo(),
                            const Spacer(),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                          ],
                        ),
                        SizedBox(
                          height: context.dynamicHeight(0.03),
                        ),
                        const Text(
                          ProjectTexts.myRecipe,
                          style: TextStyle(fontSize: 20),
                        ),
                        FutureUserRecipe(getUserRecipe: getUserRecipe),
                        // I have planned to add follow and fallowed list
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: context.dynamicHeight(0.08),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ProjectColors.lightGrey,
              ProjectColors.yellow,
            ],
          ),
        ),
      ),
      title: const Text(ProjectTexts.account),
    );
  }
}
