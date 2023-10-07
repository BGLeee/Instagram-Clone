import 'package:instagram_clone/features/comment/domain/entities/comment/comment_entity.dart';

abstract class FirebaseCommentRepository {
  // User

  Future<String> getCurrentUid();

  //comment Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComment(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);
}
