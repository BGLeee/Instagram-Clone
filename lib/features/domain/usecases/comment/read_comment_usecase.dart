import 'package:instagram_clone/features/domain/repository/firebase_repository.dart';

import '../../entities/comment/comment_entity.dart';

class ReadCommentUseCase {
  final FirebaseRepository repository;

  ReadCommentUseCase({required this.repository});

  Stream<List<CommentEntity>> call(String postId) {
    return repository.readComment(postId);
  }
}
