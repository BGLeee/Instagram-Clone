import 'dart:io';

import '../entities/comment/comment_entity.dart';
import '../entities/posts/post_entity.dart';
import '../entities/user/user_entity.dart';

abstract class FirebaseRepository {
  // Credential

  Future<void> signInUser(UserEntity user);

  Future<void> signUpUser(UserEntity user);

  Future<bool> isSignIn();

  Future<void> signOut();

  // User

  Stream<List<UserEntity>> getUsers(UserEntity user);

  Stream<List<UserEntity>> getSingleUser(String uid);

  Future<String> getCurrentUid();

  Future<void> createUser(UserEntity user);

  Future<void> updateUser(UserEntity user);

  //Storage

  Future<String> uploadProfileImageToStorage(
      File? imageFile, bool isPost, String childName);

  //post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPost(PostEntity post);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);

  //comment Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComment(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);
}
