import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/features/data/data_sources/remote_data_sources/remote_data_source.dart';
import 'package:instagram_clone/features/data/model/post/post_model.dart';
import 'package:instagram_clone/features/data/model/user_model.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../const.dart';
import 'package:uuid/uuid.dart';

import '../../model/comment/comment_model.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  FirebaseRemoteDataSourceImpl(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  Future<void> createUserWithProfileImage(
      UserEntity user, String imageUrl) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        email: user.email,
        bio: user.bio,
        following: user.following,
        website: user.website,
        profileUrl: imageUrl,
        username: user.username,
        totalFollowers: user.totalFollowers,
        followers: user.followers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
      ).toJson();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Some error occur while createing new user");
    });
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        name: user.name,
        email: user.email,
        bio: user.bio,
        following: user.following,
        website: user.website,
        profileUrl: user.profileUrl,
        username: user.username,
        totalFollowers: user.totalFollowers,
        followers: user.followers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
      ).toJson();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Some error occur while createing new user");
    });
  }

  @override
  Future<String> getCurrentUid() async {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    });
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async {
    return firebaseAuth.currentUser?.uid != null;
  }

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        toast("Fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toast("user Not found");
      } else if (e.code == "wrong-password") {
        toast("Invalid email or password");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth
            .createUserWithEmailAndPassword(
                email: user.email!, password: user.password!)
            .then((value) async {
          if (value.user?.uid != null) {
            if (user.imageFile != null) {
              uploadProfileImageToStorage(
                      user.imageFile, false, "profileImages")
                  .then((profileUrl) {
                createUserWithProfileImage(user, profileUrl);
              });
            } else {
              createUserWithProfileImage(user, "");
            }
          }
        });
      } else {
        toast("Fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("email is already taken");
      } else {
        toast("something went wrong");
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    Map<String, dynamic> userInformation = Map();

    if (user.username != "" && user.username != null)
      userInformation['username'] = user.username;

    if (user.website != "" && user.website != null)
      userInformation['website'] = user.website;

    if (user.profileUrl != "" && user.profileUrl != null)
      userInformation['profileUrl'] = user.profileUrl;

    if (user.bio != "" && user.bio != null) userInformation['bio'] = user.bio;

    if (user.name != "" && user.name != null)
      userInformation['name'] = user.name;

    if (user.totalFollowing != null)
      userInformation['totalFollowing'] = user.totalFollowing;

    if (user.totalFollowers != null)
      userInformation['totalFollowers'] = user.totalFollowers;
    if (user.totalPosts != null)
      userInformation['totalPosts'] = user.totalPosts;

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> uploadProfileImageToStorage(
      File? imageFile, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);
    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }
    final uploadTask = ref.putFile(imageFile!);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final newPost = PostModel(
      userProfileUrl: post.userProfileUrl,
      username: post.username,
      totalLikes: 0,
      totalcomments: 0,
      postImageUrl: post.postImageUrl,
      postId: post.postId,
      likes: [],
      description: post.description,
      creatorUid: post.creatorUid,
      createAt: post.createAt,
    ).toJson();
    try {
      final postRef = await postCollection.doc(post.postId).get();
      if (!postRef.exists) {
        postCollection.doc(post.postId).set(newPost);
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      toast("some shit happened when creating new post");
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    try {
      await postCollection.doc(post.postId).delete();
    } catch (e) {
      toast("some shit happened when deleting new post");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    final postRef = await postCollection.doc(post.postId).get();
    final currentUserId = await getCurrentUid();
    final totalLikes = postRef.get("totalLikes");
    if (postRef.exists) {
      List likes = postRef.get("likes");
      if (likes.contains(currentUserId)) {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUserId]),
          "totalLikes": totalLikes - 1,
        });
      } else {
        log('YOUR ID IS LIVE');
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUserId]),
          "totalLikes": totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    Map<String, dynamic> postInfo = Map();
    if (post.description != "" && post.description != null) {
      postInfo["description"] = post.description;
    }
    if (post.postImageUrl != "" && post.postImageUrl != null) {
      postInfo["postImageUrl"] = post.postImageUrl;
    }

    postCollection.doc(post.postId).update(postInfo);
  }

  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    final newComment = CommentModel(
            userProfileUrl: comment.userProfileUrl,
            username: comment.username,
            totalReplays: comment.totalReplays,
            postId: comment.postId,
            likes: [],
            description: comment.description,
            creatorUid: comment.creatorUid,
            createAt: comment.createAt,
            commentId: comment.commentId)
        .toJson();
    try {
      final commentRef = await commentCollection.doc(comment.commentId).get();
      if (!commentRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection = firebaseFirestore
              .collection(FirebaseConst.posts)
              .doc(comment.postId);
          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get("totalComments");
              postCollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        commentCollection.doc(comment.postId).update(newComment);
      }
    } catch (e) {
      toast("some shit happened when creating new comment");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);
    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection = firebaseFirestore
            .collection(FirebaseConst.posts)
            .doc(comment.postId);
        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get("totalComments");
            postCollection.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      toast("some shit happened when delete comment");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);
    final currentUserUid = await getCurrentUid();
    final commentRef = await commentCollection.doc(comment.commentId).get();
    if (commentRef.exists) {
      List likes = commentRef.get("likes");
      if (likes.contains(currentUserUid)) {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUserUid])
        });
      } else {
        log("liking post");
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUserUid])
        });
      }
      ;
    }
  }

  @override
  Stream<List<CommentEntity>> readComment(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(postId)
        .collection(FirebaseConst.comment)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    log("Its in updateComment");
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);
    Map<String, dynamic> commentInfo = Map();
    if (comment.description != "" && comment.description != null) {
      commentInfo["description"] = comment.description;
    }
    postCollection.doc(comment.commentId).update(commentInfo);
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy("createAt", descending: true)
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }
}
