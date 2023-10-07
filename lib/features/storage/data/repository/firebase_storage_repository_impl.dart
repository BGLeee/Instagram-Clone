import 'dart:io';
import 'package:instagram_clone/features/storage/data/data_source/remote_data_source/remote_storage_data_source.dart';
import 'package:instagram_clone/features/storage/domain/repository/firebase_storage_repository.dart';

class FirebaseStorageRepositoryImpl implements FirebaseStorageRepository {
  final FirebaseStorageRemoteDataSource remoteDataSource;
  FirebaseStorageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> getCurrentUid() async {
    return remoteDataSource.getCurrentUid();
  }

  @override
  Future<String> uploadProfileImageToStorage(
      File? imageFile, bool isPost, String childName) {
    return remoteDataSource.uploadProfileImageToStorage(
        imageFile, isPost, childName);
  }
}
