import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(ProjectTexts.account),
        ),
        // for adding recipes to firestore
        floatingActionButton: FloatingActionButton(
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
                      const SizedBox(width: 20),
                      const UserInfo(),
                      const Spacer(),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                    ],
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
}
