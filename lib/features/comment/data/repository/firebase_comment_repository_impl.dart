import 'package:instagram_clone/features/comment/data/data_sources/remote_data_comment_sources.dart';
import 'package:instagram_clone/features/comment/domain/repository/firebase_comment_repository.dart';
import 'package:instagram_clone/features/comment/domain/entities/comment/comment_entity.dart';

class FirebaseCommentRepositoryImpl implements FirebaseCommentRepository {
  final FirebaseRemoteCommentDataSource remoteDataSource;
  FirebaseCommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> getCurrentUid() async {
    return remoteDataSource.getCurrentUid();
  }

  @override
  Future<void> createComment(CommentEntity comment) {
    return remoteDataSource.createComment(comment);
  }

  @override
  Future<void> deleteComment(CommentEntity comment) {
    return remoteDataSource.deleteComment(comment);
  }

  @override
  Future<void> likeComment(CommentEntity comment) {
    return remoteDataSource.likeComment(comment);
  }

  @override
  Stream<List<CommentEntity>> readComment(String postId) {
    return remoteDataSource.readComment(postId);
  }

  @override
  Future<void> updateComment(CommentEntity comment) {
    return remoteDataSource.updateComment(comment);
  }
}
