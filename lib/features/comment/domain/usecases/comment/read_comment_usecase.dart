import 'package:instagram_clone/features/comment/domain/repository/firebase_comment_repository.dart';
import '../../entities/comment/comment_entity.dart';

class ReadCommentUseCase {
  final FirebaseCommentRepository repository;

  ReadCommentUseCase({required this.repository});

  Stream<List<CommentEntity>> call(String postId) {
    return repository.readComment(postId);
  }
}
