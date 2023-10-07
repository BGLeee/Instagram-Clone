import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/features/auth/data/data_sources/remote_data_sources/remote_data_source_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseRemoteDataSourceAuthImpl implements FirebaseRemoteDataAuthSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  FirebaseRemoteDataSourceAuthImpl(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  @override
  Future<String> getCurrentUid() async {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Future<bool> isSignIn() async {
    return firebaseAuth.currentUser?.uid != null;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
