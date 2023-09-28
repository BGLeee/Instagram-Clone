import 'dart:io';

import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';

import '../../repository/firebase_repository.dart';

class UploadImageToStorageUseCase {
  final FirebaseRepository repository;

  UploadImageToStorageUseCase({required this.repository});

  Future<void> call(File imageFile, bool isPost, String childName) {
    return repository.uploadProfileImageToStorage(imageFile, isPost, childName);
  }
}
