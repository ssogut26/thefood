import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/user.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTempPath = File(image.path);
    setState(() {
      _image = imageTempPath;
    });
    final user = UserModels(
      image: imageTempPath.toString().getPath(),
    );
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .withConverter(
          fromFirestore: (snapshot, _) => UserModels.fromFirestore(snapshot),
          toFirestore: (UserModels user, options) => user.toFirestore(),
        )
        .doc(FirebaseAuth.instance.currentUser?.uid);
    if (user.image?.isNotNullOrNoEmpty ?? false) {
      await docRef.set(user);
    } else {
      await docRef.update(user.toFirestore());
    }
  }

  int _current = 0;
  final CarouselController _carouselController = CarouselController();

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

  @override
  void initState() {
    print(_image);
    imagess = getUserImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      // for adding recipes to firestore
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
                    radius: 40,
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
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              )
                            : Image.file(
                                File(_image?.path ?? ''),
                                fit: BoxFit.scaleDown,
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
            Expanded(
              child: SizedBox(
                height: context.dynamicHeight(0.2),
                width: context.dynamicWidth(1),
                child: Card(
                  child: Column(
                    children: [
                      CarouselSlider(
                        items: const [],
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Image.network(
                            'https://picsum.photos/250?image=9',
                            width: context.dynamicWidth(0.2),
                            height: context.dynamicHeight(0.12),
                          ),
                          const Text('Recipe Name'),
                        ],
                      ),
                    ],
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
