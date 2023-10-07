import 'dart:io';

import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';

abstract class FirebaseRepositoryCredentials {
  // Credential

  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);

  // User
  Future<String> getCurrentUid();

  //Storage

  Future<String> uploadProfileImageToStorage(
      File? imageFile, bool isPost, String childName);
}
