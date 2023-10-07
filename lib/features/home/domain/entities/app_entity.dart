import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';

class AppEntity {
  final UserEntity? userEntity;
  final PostEntity? postEntity;
  final String? uid;
  final String? postId;

  AppEntity({this.postEntity, this.postId, this.uid, this.userEntity});
}
