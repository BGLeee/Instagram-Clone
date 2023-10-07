import 'dart:io';

abstract class FirebaseStorageRepository {
  // User

  Future<String> getCurrentUid();

  //Storage

  Future<String> uploadProfileImageToStorage(
      File? imageFile, bool isPost, String childName);
}
