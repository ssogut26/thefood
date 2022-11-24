import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(
          ProfileState(),
        ) {
    getUserImage();
    getUserCountryFromFirebase();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? country = '';

  Future<String> getUserImage() async {
    final ref = await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((value) => value.data()?['photoURL']);
    return ref as String;
  }

  Future<String> getUserCountryFromFirebase() async {
    final ref = await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((value) => value.data()?['country']);
    if (ref != null && ref != '') {
      country = ref as String;
    } else {
      country = '';
    }
    return country ?? '';
  }
}
