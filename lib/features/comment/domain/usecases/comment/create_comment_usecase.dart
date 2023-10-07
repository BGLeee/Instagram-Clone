import 'package:instagram_clone/features/comment/domain/repository/firebase_comment_repository.dart';
import '../../entities/comment/comment_entity.dart';

class CreateCommentUseCase {
  final FirebaseCommentRepository repository;

  CreateCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.createComment(comment);
  }
}
