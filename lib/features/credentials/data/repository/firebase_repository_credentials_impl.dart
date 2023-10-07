import 'dart:io';

import 'package:instagram_clone/features/comment/data/data_sources/remote_data_comment_sources.dart';
import 'package:instagram_clone/features/comment/domain/repository/firebase_comment_repository.dart';
import 'package:instagram_clone/features/comment/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/credentials/data/data_sources/remote_data_sources/remote_data_source_credentials.dart';
import 'package:instagram_clone/features/credentials/domain/repository/firebase_repository_credentials.dart';
import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';

class FirebaseRepositoryCredentialsImpl
    implements FirebaseRepositoryCredentials {
  final FirebaseRemoteDataCredentialsSource remoteDataSource;
  FirebaseRepositoryCredentialsImpl({required this.remoteDataSource});

  @override
  Future<String> getCurrentUid() async {
    return remoteDataSource.getCurrentUid();
  }

  @override
  Future<void> signInUser(UserEntity user) {
    return remoteDataSource.signInUser(user);
  }

  @override
  Future<void> signUpUser(UserEntity user) {
    return remoteDataSource.signUpUser(user);
  }

  @override
  Future<String> uploadProfileImageToStorage(
      File? imageFile, bool isPost, String childName) {
    return remoteDataSource.uploadProfileImageToStorage(
        imageFile, isPost, childName);
  }
}
