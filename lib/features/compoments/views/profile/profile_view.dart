import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/features/compoments/models/user.dart';

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
    final userImage = docSnap.data();
    return userImage?.image ?? '';
  }

  late Future<String> userImage;

  @override
  void initState() {
    userImage = getUserImage();
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
                                future: userImage,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.file(
                                      File(snapshot.data ?? ''),
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    kDebugMode ? print(snapshot.error) : null;
                                    return const Icon(Icons.error);
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              )
                            : _image?.path.isNotNullOrNoEmpty ?? true
                                ? const Icon(Icons.person)
                                : Image.file(
                                    File(_image?.path ?? ''),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
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
            FutureBuilder<QuerySnapshot<Map<String, dynamic>?>?>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('recipes')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.hasData && (snapshot.data?.docs.isEmpty ?? true)) {
                  return SizedBox(
                    height: context.dynamicHeight(0.2),
                    child: const Card(
                      child: Center(child: Text('You have no recipes')),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  final data = snapshot.data?.docs;
                  return SizedBox(
                    height: context.dynamicHeight(0.25),
                    width: context.dynamicWidth(1),
                    child: ListView.builder(
                      itemCount: data?.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              // SizedBox(
                              //   height: context.dynamicHeight(0.12),
                              //   width: context.dynamicWidth(0.4),
                              //   child: Image.network(
                              //     fit: BoxFit.cover,
                              //     "${data?[index]['strMealThumb']}",
                              //   ),
                              // ),
                              Padding(
                                padding: ProjectPaddings.textHorizontalMedium,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${data?[index]['strMeal']}\n'),
                                    Text('${data?[index]['strCategory']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
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
