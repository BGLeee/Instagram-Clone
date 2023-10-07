import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/post/domain/repository/firebase_post_repository.dart';

class ReadPostUseCase {
  final FirebasePostRepository repository;

  ReadPostUseCase({required this.repository});

  Stream<List<PostEntity>> call(PostEntity post) {
    return repository.readPost(post);
  }
}
