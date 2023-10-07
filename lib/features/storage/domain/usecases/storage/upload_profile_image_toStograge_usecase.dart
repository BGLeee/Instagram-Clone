import 'dart:io';
import 'package:instagram_clone/features/storage/domain/repository/firebase_storage_repository.dart';

class UploadImageToStorageUseCase {
  final FirebaseStorageRepository repository;

  UploadImageToStorageUseCase({required this.repository});

  Future<String> call(File? imageFile, bool isPost, String childName) {
    return repository.uploadProfileImageToStorage(imageFile, isPost, childName);
  }
}
