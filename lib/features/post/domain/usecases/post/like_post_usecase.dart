import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/post/domain/repository/firebase_post_repository.dart';

class LikePostUseCase {
  final FirebasePostRepository repository;

  LikePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.likePost(post);
  }
}
