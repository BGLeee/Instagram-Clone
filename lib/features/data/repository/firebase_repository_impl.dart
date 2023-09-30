import 'dart:io';

import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/entities/replay/replay_entity.dart';
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

  @override
  Future<void> createPost(PostEntity post) {
    return remoteDataSource.createPost(post);
  }

  @override
  Future<void> deletePost(PostEntity post) {
    return remoteDataSource.deletePost(post);
  }

  @override
  Future<void> likePost(PostEntity post) {
    return remoteDataSource.likePost(post);
  }

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) {
    return remoteDataSource.readPost(post);
  }

  @override
  Future<void> updatePost(PostEntity post) {
    return remoteDataSource.updatePost(post);
  }

  @override
  Future<void> createComment(CommentEntity comment) {
    return remoteDataSource.createComment(comment);
  }

  @override
  Future<void> deleteComment(CommentEntity comment) {
    return remoteDataSource.deleteComment(comment);
  }

  @override
  Future<void> likeComment(CommentEntity comment) {
    return remoteDataSource.likeComment(comment);
  }

  @override
  Stream<List<CommentEntity>> readComment(String postId) {
    return remoteDataSource.readComment(postId);
  }

  @override
  Future<void> updateComment(CommentEntity comment) {
    return remoteDataSource.updateComment(comment);
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    return remoteDataSource.readSinglePost(postId);
  }

  @override
  Future<void> createReplay(ReplayEntity replay) {
    return remoteDataSource.createReplay(replay);
  }

  @override
  Future<void> deleteReplay(ReplayEntity replay) {
    return remoteDataSource.deleteReplay(replay);
  }

  @override
  Future<void> likeReplay(ReplayEntity replay) {
    return remoteDataSource.likeReplay(replay);
  }

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) {
    return remoteDataSource.readReplays(replay);
  }

  @override
  Future<void> updateReplay(ReplayEntity replay) {
    return remoteDataSource.updateReplay(replay);
  }
}
