import 'package:instagram_clone/features/post/data/data_sources/remote_data_sources/remote_data_post_source.dart';
import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/post/domain/repository/firebase_post_repository.dart';

class FirebasePostRepositoryImpl implements FirebasePostRepository {
  final FirebaseRemotePostDataSource firebaseRemotePostDataSource;
  FirebasePostRepositoryImpl({required this.firebaseRemotePostDataSource});
  @override
  Future<void> createPost(PostEntity post) {
    return firebaseRemotePostDataSource.createPost(post);
  }

  @override
  Future<void> deletePost(PostEntity post) {
    return firebaseRemotePostDataSource.deletePost(post);
  }

  @override
  Future<String> getCurrentUid() {
    return firebaseRemotePostDataSource.getCurrentUid();
  }

  @override
  Future<void> likePost(PostEntity post) {
    return firebaseRemotePostDataSource.likePost(post);
  }

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) {
    return firebaseRemotePostDataSource.readPost(post);
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    return firebaseRemotePostDataSource.readSinglePost(postId);
  }

  @override
  Future<void> updatePost(PostEntity post) {
    return firebaseRemotePostDataSource.updatePost(post);
  }
}
