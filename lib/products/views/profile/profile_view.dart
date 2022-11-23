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
  final TextEditingController _areaController = TextEditingController();

  bool isLoading = true;
  bool changeLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    return isLoading;
  }

  String country = '';

  Future<String> getCountry() async {
    final area = await FirebaseFirestore.instance
        .collection('users')
        .doc(
          FirebaseAuth.instance.currentUser?.uid,
        )
        .get();
    country = area['country'] as String;
    return country = await getCountry();
  }

  @override
  void initState() {
    isLoading = changeLoading();
    getCountry();
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
                            SizedBox(
                              width: context.dynamicWidth(0.04),
                            ),
                            const UserInfo(),
                            const Spacer(),
                            UpdateProfile(
                                nameController: _nameController,
                                emailController: _emailController,
                                country: country,
                                verifyEmailController: _verifyEmailController,
                                verifyPasswordController: _verifyPasswordController,
                                newPasswordController: _newPasswordController,
                                areaController: _areaController),
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

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({
    super.key,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required this.country,
    required TextEditingController verifyEmailController,
    required TextEditingController verifyPasswordController,
    required TextEditingController newPasswordController,
    required TextEditingController areaController,
  })  : _nameController = nameController,
        _emailController = emailController,
        _verifyEmailController = verifyEmailController,
        _verifyPasswordController = verifyPasswordController,
        _newPasswordController = newPasswordController,
        _areaController = areaController;

  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final String country;
  final TextEditingController _verifyEmailController;
  final TextEditingController _verifyPasswordController;
  final TextEditingController _newPasswordController;
  final TextEditingController _areaController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SingleChildScrollView(
            child: AlertDialog(
              title: Padding(
                padding: ProjectPaddings.cardMedium,
                child: Text(
                  'Update Profile',
                  style: context.textTheme.headline1,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: ProjectPaddings.cardLarge,
                    child: CircleAvatar(
                      backgroundColor: ProjectColors.white,
                      radius: 50,
                      backgroundImage: AssetImage(
                        FirebaseAuth.instance.currentUser?.photoURL ?? '',
                      ),
                    ),
                  ),
                  UpdateName(nameController: _nameController),
                  UpdateEmail(emailController: _emailController),
                  UpdateArea(country: country),
                ],
              ),
              actions: [
                VerifyUserCredentials(
                    verifyEmailController: _verifyEmailController,
                    verifyPasswordController: _verifyPasswordController,
                    newPasswordController: _newPasswordController,
                    emailController: _emailController,
                    nameController: _nameController,
                    areaController: _areaController),
              ],
            ),
          ),
        );
      },
      icon: const Icon(Icons.edit),
    );
  }
}

class UpdateName extends StatelessWidget {
  const UpdateName({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: TextFormField(
        initialValue: FirebaseAuth.instance.currentUser?.displayName,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name',
        ),
        onChanged: (value) {
          _nameController.text = value;
        },
      ),
    );
  }
}

class UpdateEmail extends StatelessWidget {
  const UpdateEmail({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: TextFormField(
        initialValue: FirebaseAuth.instance.currentUser?.email,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
        ),
        onChanged: (value) {
          _emailController.text = value;
        },
      ),
    );
  }
}

class UpdateArea extends StatelessWidget {
  const UpdateArea({
    super.key,
    required this.country,
  });

  final String country;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: SizedBox(
        width: context.dynamicWidth(0.8),
        child: DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: 'Area',
            border: OutlineInputBorder(),
          ),
          hint: Text(country),
          items: [
            for (var index = 0; index < countryFlags.length; index++)
              DropdownMenuItem(
                value: countryFlags.keys.elementAt(index),
                child: Row(
                  children: [
                    Padding(
                      padding: context.onlyRightPaddingLow,
                      child: CachedNetworkImage(
                        imageUrl: countryFlags.values.elementAt(index),
                        height: 32,
                        width: 32,
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                        ),
                      ),
                    ),
                    Text(
                      countryFlags.keys.elementAt(index),
                    ),
                  ],
                ),
              ),
          ],
          onChanged: (value) {
            // setState(() {
            //   _areaController.text =
            //       value.toString();
            // });
          },
        ),
      ),
    );
  }
}

class VerifyUserCredentials extends StatelessWidget {
  const VerifyUserCredentials({
    super.key,
    required TextEditingController verifyEmailController,
    required TextEditingController verifyPasswordController,
    required TextEditingController newPasswordController,
    required TextEditingController emailController,
    required TextEditingController nameController,
    required TextEditingController areaController,
  })  : _verifyEmailController = verifyEmailController,
        _verifyPasswordController = verifyPasswordController,
        _newPasswordController = newPasswordController,
        _emailController = emailController,
        _nameController = nameController,
        _areaController = areaController;

  final TextEditingController _verifyEmailController;
  final TextEditingController _verifyPasswordController;
  final TextEditingController _newPasswordController;
  final TextEditingController _emailController;
  final TextEditingController _nameController;
  final TextEditingController _areaController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    "Verify it's you",
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: ProjectPaddings.cardMedium,
                        child: TextFormField(
                          controller: _verifyEmailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Padding(
                        padding: ProjectPaddings.cardMedium,
                        child: TextFormField(
                          controller: _verifyPasswordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Padding(
                        padding: ProjectPaddings.cardMedium,
                        child: TextFormField(
                          controller: _newPasswordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'New Password',
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    UpdatePassword(
                        verifyEmailController: _verifyEmailController,
                        verifyPasswordController: _verifyPasswordController,
                        newPasswordController: _newPasswordController),
                  ],
                );
              },
            );
          },
          child: const Text(
            'I want\nto change\nmy password',
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        UpdateProfile(
            emailController: _emailController,
            nameController: _nameController,
            areaController: _areaController,
            verifyEmailController: _verifyEmailController,
            verifyPasswordController: _verifyPasswordController),
      ],
    );
  }
}

class UpdatePassword extends StatelessWidget {
  const UpdatePassword({
    super.key,
    required TextEditingController verifyEmailController,
    required TextEditingController verifyPasswordController,
    required TextEditingController newPasswordController,
  })  : _verifyEmailController = verifyEmailController,
        _verifyPasswordController = verifyPasswordController,
        _newPasswordController = newPasswordController;

  final TextEditingController _verifyEmailController;
  final TextEditingController _verifyPasswordController;
  final TextEditingController _newPasswordController;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          final verify =
              await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _verifyEmailController.text,
              password: _verifyPasswordController.text,
            ),
          );
          if (verify?.user != null) {
            await FirebaseAuth.instance.currentUser?.updatePassword(
              _newPasswordController.text,
            );
            Navigator.of(context).pop();
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            print(
              'Wrong password provided for that user.',
            );
          } else if (e.code == 'user-not-found') {
            print(
              'No user found for that email.',
            );
          }
        }
        Navigator.of(context).pop();
      },
      child: const Text('Verify'),
    );
  }
}

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({
    super.key,
    required TextEditingController emailController,
    required TextEditingController nameController,
    required TextEditingController areaController,
    required TextEditingController verifyEmailController,
    required TextEditingController verifyPasswordController,
  })  : _emailController = emailController,
        _nameController = nameController,
        _areaController = areaController,
        _verifyEmailController = verifyEmailController,
        _verifyPasswordController = verifyPasswordController;

  final TextEditingController _emailController;
  final TextEditingController _nameController;
  final TextEditingController _areaController;
  final TextEditingController _verifyEmailController;
  final TextEditingController _verifyPasswordController;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (_emailController.text.isEmpty) {
          _emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
        }
        if (_nameController.text.isEmpty) {
          _nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? '';
        }
        if (_areaController.text.isEmpty) {
          final country = await FirebaseFirestore.instance
              .collection('users')
              .doc(
                FirebaseAuth.instance.currentUser?.uid,
              )
              .get()
              .then(
                (value) => value.data()?['country'] ?? '',
              );
          _areaController.text = country as String;
        }
        final checkEmail =
            _emailController.text == FirebaseAuth.instance.currentUser?.email;

        if (checkEmail == false) {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Verify it's you",
                  style: context.textTheme.headline1,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: ProjectPaddings.cardMedium,
                      child: TextFormField(
                        controller: _verifyEmailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: ProjectPaddings.cardMedium,
                      child: TextFormField(
                        controller: _verifyPasswordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.currentUser
                            ?.reauthenticateWithCredential(
                          EmailAuthProvider.credential(
                            email: FirebaseAuth.instance.currentUser?.email ?? '',
                            password: _verifyPasswordController.text,
                          ),
                        );

                        AlertDialog(
                          content: const Text(
                            'You have successfully updated your profile',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pop();
                              },
                              child: const Text(
                                'OK',
                              ),
                            ),
                          ],
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'wrong-password') {
                          print(
                            'Wrong password provided for that user.',
                          );
                        } else if (e.code == 'user-not-found') {
                          print(
                            'No user found for that email.',
                          );
                        }
                      }
                    },
                    child: const Text('Verify'),
                  ),
                ],
              );
            },
          );
        } else {
          try {
            await FirebaseAuth.instance.currentUser?.updateDisplayName(
              _nameController.text,
            );
            if (checkEmail) {
              // i will add later
              // await FirebaseAuth.instance.currentUser
              //     ?.updatePhotoURL('');
              final userData = UserModels(
                name: _nameController.text,

                // photoURL: AssetsPath.defaultUserImage,
                country: _areaController.text,
              );
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(
                    FirebaseAuth.instance.currentUser?.uid,
                  )
                  .update(userData.toJson());
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text(
                      'You have successfully updated your profile',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pop();
                        },
                        child: const Text(
                          'OK',
                        ),
                      ),
                    ],
                  );
                },
              );
              Navigator.of(context).pop();
            } else {
              await FirebaseAuth.instance.currentUser?.updateEmail(
                _emailController.text,
              );
            }
            // i will add later
            // await FirebaseAuth.instance.currentUser
            //     ?.updatePhotoURL('');
            final userData = UserModels(
              name: _nameController.text,
              email: _emailController.text,
              // photoURL: AssetsPath.defaultUserImage,
              country: _areaController.text,
            );
            await FirebaseFirestore.instance
                .collection('users')
                .doc(
                  FirebaseAuth.instance.currentUser?.uid,
                )
                .update(userData.toJson());
            AlertDialog(
              content: const Text(
                'You have successfully updated your profile',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop();
                  },
                  child: const Text(
                    'OK',
                  ),
                ),
              ],
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Something went wrong',
                ),
              ),
            );
          }
        }
      },
      child: const Text('Update'),
    );
  }
}
