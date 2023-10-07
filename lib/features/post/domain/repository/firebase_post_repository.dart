import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';

abstract class FirebasePostRepository {
  //User
  Future<String> getCurrentUid();

  //post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPost(PostEntity post);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
}
