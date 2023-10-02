import 'dart:io';

import '../../repository/firebase_repository.dart';

class UploadImageToStorageUseCase {
  final FirebaseRepository repository;

  UploadImageToStorageUseCase({required this.repository});

  Future<String> call(File? imageFile, bool isPost, String childName) {
    return repository.uploadProfileImageToStorage(imageFile, isPost, childName);
  }
}
