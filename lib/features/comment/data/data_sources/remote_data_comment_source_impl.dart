import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/features/comment/data/data_sources/remote_data_comment_sources.dart';
import 'package:instagram_clone/features/comment/domain/entities/comment/comment_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../const.dart';

import '../../../comment/data/model/comment/comment_model.dart';

class FirebaseRemoteCommentDataSourceImpl
    implements FirebaseRemoteCommentDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  FirebaseRemoteCommentDataSourceImpl(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  @override
  Future<String> getCurrentUid() async {
    return firebaseAuth.currentUser!.uid;
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
}
