import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';

class PostModel extends PostEntity {
  final String? postId;
  final String? creatorUid;
  final String? username;
  final String? description;
  final String? postImageUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalcomments;
  final Timestamp? createAt;
  final String? userProfileUrl;

  const PostModel(
      {this.postId,
      this.creatorUid,
      this.username,
      this.description,
      this.postImageUrl,
      this.likes,
      this.totalLikes,
      this.totalcomments,
      this.createAt,
      this.userProfileUrl})
      : super(
          postId: postId,
          creatorUid: creatorUid,
          username: username,
          description: description,
          postImageUrl: postImageUrl,
          likes: likes,
          totalLikes: totalLikes,
          totalcomments: totalcomments,
          createAt: createAt,
          userProfileUrl: userProfileUrl,
        );

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
        postId: snapshot['postId'],
        creatorUid: snapshot['creatorUid'],
        createAt: snapshot['createAt'],
        username: snapshot['username'],
        description: snapshot['description'],
        postImageUrl: snapshot['postImageUrl'],
        totalLikes: snapshot['totalLikes'],
        likes: List.from(snap.get("likes")),
        totalcomments: snapshot['totalComments'],
        userProfileUrl: snapshot['userProfileUrl']);
  }
  Map<String, dynamic> toJson() => {
        "postId": postId,
        "creatorUid": creatorUid,
        "createAt": createAt,
        "username": username,
        "description": description,
        "postImageUrl": postImageUrl,
        "totalLikes": totalLikes,
        "likes": likes,
        "totalComments": totalcomments,
        "userProfileUrl": userProfileUrl,
      };
}
