import '../../domain/entities/comment/comment_entity.dart';

abstract class FirebaseRemoteCommentDataSource {
  // User
  Future<String> getCurrentUid();

  //comment Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComment(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);
}
