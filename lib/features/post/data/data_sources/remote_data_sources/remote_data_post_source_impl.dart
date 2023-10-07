import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/post/data/model/post/post_model.dart';
import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/features/post/data/data_sources/remote_data_sources/remote_data_post_source.dart';

class FirebaseRemotePostDataSourceImpl implements FirebaseRemotePostDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  FirebaseRemotePostDataSourceImpl(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  @override
  Future<String> getCurrentUid() async {
    return firebaseAuth.currentUser!.uid;
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
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConst.users)
              .doc(post.creatorUid);
          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get('totalPosts');
              userCollection.update({"totalPosts": totalPosts + 1});
              return;
            }
          });
        });
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
      postCollection.doc(post.postId).delete().then((value) {
        final userCollection = firebaseFirestore
            .collection(FirebaseConst.users)
            .doc(post.creatorUid);
        userCollection.get().then((value) {
          if (value.exists) {
            final totalPosts = value.get('totalPosts');
            userCollection.update({"totalPosts": totalPosts - 1});
            return;
          } else {
            log("value doesn't not exist man");
          }
        });
      });
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
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .orderBy("createAt", descending: true)
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }
}
