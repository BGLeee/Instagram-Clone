import 'dart:io';

abstract class FirebaseStorageRemoteDataSource {
  // User
  Future<String> getCurrentUid();

  //Storage

  Future<String> uploadProfileImageToStorage(
      File? imageFile, bool isPost, String childName);
}
