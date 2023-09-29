import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
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

  const PostEntity(
      {this.postId,
      this.creatorUid,
      this.username,
      this.description,
      this.postImageUrl,
      this.likes,
      this.totalLikes,
      this.totalcomments,
      this.createAt,
      this.userProfileUrl});

  @override
  // TODO: implement props
  List<Object?> get props => [
        postId,
        creatorUid,
        username,
        description,
        postImageUrl,
        likes,
        totalLikes,
        totalcomments,
        createAt,
        userProfileUrl,
      ];
}
