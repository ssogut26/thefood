part of '../views/profile/profile_view.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({
    super.key,
  });

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final userRef = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FirebaseAuth.instance.currentUser?.displayName.toString() ?? '',
        ),
        FutureBuilder(
          future: userRef.doc(FirebaseAuth.instance.currentUser?.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data?.data();
              return Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: countryFlags['${data?['country']}'] ?? '',
                    height: 32,
                    width: 32,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                    ),
                    progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: ProjectPaddings.textHorizontalSmall,
                    child: Text(
                      '${data?['country']}',
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Center(
          child: FutureBuilder<String>(
            future: context.read<ProfileCubit>().getUserImage(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.asset(
                  snapshot.data ?? '',
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
          ),
        );
      },
    );
  }
}

class FutureUserRecipe extends StatelessWidget {
  const FutureUserRecipe({
    super.key,
    required this.getUserRecipe,
  });

  final Future<QuerySnapshot<Map<String, dynamic>>> getUserRecipe;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>?>?>(
      future: getUserRecipe,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(ProjectTexts.somethingWentWrong);
        }
        if (snapshot.hasData && (snapshot.data?.docs.isEmpty ?? true)) {
          return const NoRecipeCard();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data?.docs;
          return UserRecipesCard(data: data);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class NoRecipeCard extends StatelessWidget {
  const NoRecipeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.2),
      child: const Card(
        elevation: 2,
        child: Center(child: Text(ProjectTexts.userNoRecipesYet)),
      ),
    );
  }
}

class UserRecipesCard extends StatelessWidget {
  const UserRecipesCard({
    super.key,
    required this.data,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>?>>? data;

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: context.dynamicHeight(0.12),
                  width: context.dynamicWidth(0.4),
                  child: Image.network(
                    fit: BoxFit.cover,
                    "${data?[index]['strMealThumb']}",
                  ),
                ),
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
}

AppBar _appBar(BuildContext context) {
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

class UpdateUserProfile extends StatefulWidget {
  const UpdateUserProfile({
    super.key,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController verifyEmailController,
    required TextEditingController verifyPasswordController,
    required TextEditingController newPasswordController,
  })  : _nameController = nameController,
        _emailController = emailController,
        _verifyEmailController = verifyEmailController,
        _verifyPasswordController = verifyPasswordController,
        _newPasswordController = newPasswordController;

  final TextEditingController _nameController;
  final TextEditingController _emailController;
  final TextEditingController _verifyEmailController;
  final TextEditingController _verifyPasswordController;
  final TextEditingController _newPasswordController;

  @override
  State<UpdateUserProfile> createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return IconButton(
            onPressed: () {
              showDialog<AlertDialog>(
                context: context,
                builder: (context) => Center(
                  child: AlertDialog(
                    scrollable: true,
                    title: Text(
                      'Update Profile',
                      style: context.textTheme.headline1,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: ProjectPaddings.cardLarge,
                          child: CircleAvatar(
                            backgroundColor: ProjectColors.white,
                            radius: 35,
                            backgroundImage: AssetImage(
                              FirebaseAuth.instance.currentUser?.photoURL ?? '',
                            ),
                          ),
                        ),
                        UpdateName(nameController: widget._nameController),
                        UpdateEmail(emailController: widget._emailController),
                      ],
                    ),
                    actions: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () async {
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
                                            controller: widget._verifyEmailController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Email',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: ProjectPaddings.cardMedium,
                                          child: TextFormField(
                                            controller: widget._verifyPasswordController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Password',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: ProjectPaddings.cardMedium,
                                          child: TextFormField(
                                            controller: widget._newPasswordController,
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
                                        child: Text(
                                          'Cancel',
                                          style: context.textTheme.headline4,
                                        ),
                                      ),
                                      UpdatePassword(
                                        verifyEmailController:
                                            widget._verifyEmailController,
                                        verifyPasswordController:
                                            widget._verifyPasswordController,
                                        newPasswordController:
                                            widget._newPasswordController,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Change\npassword',
                              style: context.textTheme.headline4,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: context.textTheme.headline4,
                            ),
                          ),
                          BlocProvider(
                            create: (context) => ProfileCubit(),
                            child: BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                return UpdateProfile(
                                  verifyPasswordController:
                                      widget._verifyPasswordController,
                                  verifyEmailController: widget._verifyEmailController,
                                  nameController: widget._nameController,
                                  emailController: widget._emailController,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          );
        },
      ),
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
      padding: ProjectPaddings.cardSmall,
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
                child: Text(
                  'OK',
                  style: context.textTheme.headline4,
                ),
              ),
            ],
          );
          Navigator.of(context).pop();
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
      child: Text('Verify', style: context.textTheme.headline4),
    );
  }
}

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({
    super.key,
    required TextEditingController emailController,
    required TextEditingController nameController,
    required TextEditingController verifyEmailController,
    required TextEditingController verifyPasswordController,
  })  : _emailController = emailController,
        _nameController = nameController,
        _verifyEmailController = verifyEmailController,
        _verifyPasswordController = verifyPasswordController;

  final TextEditingController _emailController;
  final TextEditingController _nameController;
  final TextEditingController _verifyEmailController;
  final TextEditingController _verifyPasswordController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return TextButton(
          onPressed: () async {
            final currentUser = FirebaseAuth.instance.currentUser;
            final ref = FirebaseFirestore.instance.collection('users').doc(
                  currentUser?.uid,
                );
            if (_emailController.text.isEmpty) {
              _emailController.text = currentUser?.email ?? '';
            }
            if (_nameController.text.isEmpty) {
              _nameController.text = currentUser?.displayName ?? '';
            }

            final checkEmail = _emailController.text == currentUser?.email;
            if (checkEmail == false) {
              await AlertWidgets.showActionDialog(
                context,
                "Verify it's you",
                Column(
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
                [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: context.textTheme.headline4,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.currentUser
                            ?.reauthenticateWithCredential(
                          EmailAuthProvider.credential(
                            email: currentUser?.email ?? '',
                            password: _verifyPasswordController.text,
                          ),
                        );
                        await AlertWidgets.showMessageDialog(
                          context,
                          'Success',
                          'You have successfully updated your profile',
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
                    child: Text(
                      'Verify',
                      style: context.textTheme.headline4,
                    ),
                  ),
                ],
              );
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
                        child: Text(
                          'Cancel',
                          style: context.textTheme.headline4,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.currentUser
                                ?.reauthenticateWithCredential(
                              EmailAuthProvider.credential(
                                email: currentUser?.email ?? '',
                                password: _verifyPasswordController.text,
                              ),
                            );

                            await AlertWidgets.showMessageDialog(
                              context,
                              'Success',
                              'You have successfully updated your profile',
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
                        child: Text(
                          'Verify',
                          style: context.textTheme.headline4,
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              try {
                await currentUser?.updateDisplayName(
                  _nameController.text,
                );
                if (checkEmail) {
                  final userData = UserModels(
                    name: _nameController.text,
                    email: _emailController.text,
                    photoURL: currentUser?.photoURL,
                    userId: currentUser?.uid,
                  );

                  await ref.update(userData.toJson());
                  await AlertWidgets.showMessageDialog(
                    context,
                    'Success',
                    'You have successfully updated your profile',
                  );
                  Navigator.of(context).pop();
                } else {
                  await currentUser?.updateEmail(
                    _emailController.text,
                  );
                  final userData = UserModels(
                    photoURL: currentUser?.photoURL,
                    name: _nameController.text,
                    email: _emailController.text,
                    userId: currentUser?.uid,
                  );
                  await ref.update(userData.toJson());
                  await AlertWidgets.showMessageDialog(
                    context,
                    'Success',
                    'You have successfully updated your profile',
                  );
                }
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
          child: Text(
            'Update',
            style: context.textTheme.headline4,
          ),
        );
      },
    );
  }
}
