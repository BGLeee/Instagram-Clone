part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

final class CommentInitial extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoaded extends CommentState {
  final List<CommentEntity> comment;
  CommentLoaded({required this.comment});
  @override
  List<Object> get props => [comment];
}

class CommentFailure extends CommentState {
  @override
  List<Object> get props => [];
}
