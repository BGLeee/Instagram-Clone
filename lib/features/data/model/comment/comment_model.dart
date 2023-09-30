import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';

import '../../../domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  final String? commentId;
  final String? postId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplays;

  const CommentModel(
      {required this.commentId,
      required this.postId,
      required this.creatorUid,
      required this.description,
      required this.username,
      required this.userProfileUrl,
      required this.createAt,
      required this.likes,
      required this.totalReplays})
      : super(
          commentId: commentId,
          postId: postId,
          creatorUid: creatorUid,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          createAt: createAt,
          likes: likes,
          totalReplays: totalReplays,
        );

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
        postId: snapshot['postId'],
        creatorUid: snapshot['creatorUid'],
        createAt: snapshot['createAt'],
        username: snapshot['username'],
        description: snapshot['description'],
        commentId: snapshot['commentId'],
        totalReplays: snapshot['totalReplays'],
        likes: List.from(snap.get("likes")),
        userProfileUrl: snapshot['userProfileUrl']);
  }
  Map<String, dynamic> toJson() => {
        "postId": postId,
        "creatorUid": creatorUid,
        "createAt": createAt,
        "username": username,
        "description": description,
        "commentId": commentId,
        "totalReplays": totalReplays,
        "likes": likes,
        "userProfileUrl": userProfileUrl,
      };
}
