import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/models/user.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;
  final picker = ImagePicker();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> pickImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return;
    final imageTempPath = File(image.path);
    setState(() {
      _image = imageTempPath;
    });
    final user = UserModels(
      image: imageTempPath.toString().getPath(),
    );
    final docRef = _firestore
        .collection('users')
        .withConverter(
          fromFirestore: (snapshot, _) => UserModels.fromFirestore(snapshot),
          toFirestore: (UserModels user, options) => user.toFirestore(),
        )
        .doc(_auth.currentUser?.uid);
    if (user.image?.isNotNullOrNoEmpty ?? false) {
      await docRef.set(user);
    } else {
      await docRef.update(user.toFirestore());
    }
  }

  Future<String> getUserImage() async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .withConverter(
          fromFirestore: (snapshot, _) => UserModels.fromFirestore(snapshot),
          toFirestore: (UserModels user, _) => user.toFirestore(),
        );
    final docSnap = await ref.get();
    final userImage = docSnap.data()?.image;
    return userImage ?? '';
  }

  late Future<String> imagess;
  late final Future<Meals> userMealData;
  @override
  void initState() {
    userMealData = getUserRecipes();
    imagess = getUserImage();
    super.initState();
  }

  Future<Meals> getUserRecipes() async {
    final ref = FirebaseFirestore.instance
        .collection('recipes')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    final docSnap = await ref.get().then((value) => value.data());
    return Meals.fromJson(docSnap ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      // for adding recipes to firestore
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add');
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: ProjectPaddings.pageLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 35,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Center(
                        child: _image == null
                            ? FutureBuilder<String>(
                                future: imagess,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.file(
                                      File(snapshot.data ?? ''),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              )
                            : Image.file(
                                File(_image?.path ?? ''),
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(FirebaseAuth.instance.currentUser?.displayName.toString() ?? ''),
                    const Text('Place'),
                  ],
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
              ],
            ),
            const Text(
              'My Recipes',
              style: TextStyle(fontSize: 20),
            ),
            ConstrainedBox(
              constraints:
                  BoxConstraints.loose(Size(context.width, context.dynamicHeight(0.2))),
              child: Swiper(
                curve: Curves.easeIn,
                scale: 0.9,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return FutureBuilder<Meals>(
                    future: userMealData,
                    builder: (context, snapshot) {
                      final meals = snapshot.data?.strMeal;

                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return const ListTile(
                              title: Text(
                                '',
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: Text('noData'));
                      // return Card(
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //         height: context.dynamicHeight(0.2),
                      //         width: context.dynamicWidth(0.4),
                      //         child: Text(
                      //           snapshot.data
                      //                   ?.map((e) => e?.data()?['strMeal'])
                      //                   .toString() ??
                      //               '',
                      //         ),
                      //       ),
                      //       Text(
                      //         snapshot.data
                      //                 ?.map((e) => e?.data()?['strMeal'])
                      //                 .toString() ??
                      //             '',
                      //         style: context.textTheme.headline1,
                      //       ),
                      //     ],
                      //   ),
                      // );
                    },
                  );
                },
                pagination: const SwiperPagination(
                  margin: EdgeInsets.all(5),
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.grey,
                    activeColor: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [File] when converted to string like "File: 'path/path/'"
///  so i fixed like this to get path
extension on String {
  String getPath() {
    return substring(7, length - 1);
  }
}
