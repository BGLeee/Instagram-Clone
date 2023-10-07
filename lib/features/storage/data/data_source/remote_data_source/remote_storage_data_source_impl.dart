import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/features/storage/data/data_source/remote_data_source/remote_storage_data_source.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageRemoteDataSourceImpl
    implements FirebaseStorageRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  FirebaseStorageRemoteDataSourceImpl(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  @override
  Future<String> getCurrentUid() async {
    return firebaseAuth.currentUser!.uid;
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
}
