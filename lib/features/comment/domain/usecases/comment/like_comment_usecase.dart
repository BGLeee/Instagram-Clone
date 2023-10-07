import 'package:instagram_clone/features/comment/domain/repository/firebase_comment_repository.dart';
import '../../entities/comment/comment_entity.dart';

class LikeCommentUseCase {
  final FirebaseCommentRepository repository;

  LikeCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.likeComment(comment);
  }
}
