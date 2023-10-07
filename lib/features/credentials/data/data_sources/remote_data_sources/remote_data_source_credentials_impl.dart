import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/features/credentials/data/data_sources/remote_data_sources/remote_data_source_credentials.dart';
import 'package:instagram_clone/features/user/data/model/user_model.dart';
import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';
import 'package:uuid/uuid.dart';

class FirebaseRemoteDataSourceCredentialsImpl
    implements FirebaseRemoteDataCredentialsSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  FirebaseRemoteDataSourceCredentialsImpl(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        toast("Fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toast("user Not found");
      } else if (e.code == "wrong-password") {
        toast("Invalid email or password");
      }
    }
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth
            .createUserWithEmailAndPassword(
                email: user.email!, password: user.password!)
            .then((value) async {
          if (value.user?.uid != null) {
            if (user.imageFile != null) {
              uploadProfileImageToStorage(
                      user.imageFile, false, "profileImages")
                  .then((profileUrl) {
                createUserWithProfileImage(user, profileUrl);
              });
            } else {
              createUserWithProfileImage(user, "");
            }
          }
        });
      } else {
        toast("Fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("email is already taken");
      } else {
        toast("something went wrong");
      }
    }
  }

  @override
  Future<String> uploadProfileImageToStorage(
      File? imageFile, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);
    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }
    final uploadTask = ref.putFile(imageFile!);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }

  Future<void> createUserWithProfileImage(
      UserEntity user, String imageUrl) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        email: user.email,
        bio: user.bio,
        following: user.following,
        website: user.website,
        profileUrl: imageUrl,
        username: user.username,
        totalFollowers: user.totalFollowers,
        followers: user.followers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
      ).toJson();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Some error occur while createing new user");
    });
  }

  @override
  Future<String> getCurrentUid() async {
    return firebaseAuth.currentUser!.uid;
  }
}
