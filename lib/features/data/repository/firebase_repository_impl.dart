import 'dart:io';

import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/domain/repository/firebase_repository.dart';

import '../data_sources/remote_data_sources/remote_data_source.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;
  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createUser(UserEntity user) async {
    return remoteDataSource.createUser(user);
  }

  @override
  Future<String> getCurrentUid() async {
    return remoteDataSource.getCurrentUid();
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    return remoteDataSource.getSingleUser(uid);
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    return remoteDataSource.getUsers(user);
  }

  @override
  Future<bool> isSignIn() async {
    return remoteDataSource.isSignIn();
  }

  @override
  Future<void> signInUser(UserEntity user) async {
    return remoteDataSource.signInUser(user);
  }

  @override
  Future<void> signOut() async {
    return remoteDataSource.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    print("Yea this is running");
    return remoteDataSource.signUpUser(user);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    return remoteDataSource.updateUser(user);
  }

  @override
  Future<String> uploadProfileImageToStorage(
      File? imageFile, bool isPost, String childName) {
    return remoteDataSource.uploadProfileImageToStorage(
        imageFile, isPost, childName);
  }
}
