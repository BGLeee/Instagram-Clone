import '../../entities/posts/post_entity.dart';
import '../../repository/firebase_repository.dart';
import '../../entities/comment/comment_entity.dart';

class CreateCommentUseCase {
  final FirebaseRepository repository;

  CreateCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.createComment(comment);
  }
}
