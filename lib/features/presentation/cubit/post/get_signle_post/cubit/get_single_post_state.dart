part of 'get_single_post_cubit.dart';

sealed class GetSinglePostState extends Equatable {
  const GetSinglePostState();

  @override
  List<Object> get props => [];
}

final class GetSinglePostInitial extends GetSinglePostState {
  @override
  List<Object> get props => [];
}

final class GetSinglePostLoading extends GetSinglePostState {
  @override
  List<Object> get props => [];
}

final class GetSinglePostLoaded extends GetSinglePostState {
  final PostEntity post;
  GetSinglePostLoaded({required this.post});
  @override
  List<Object> get props => [post];
}

final class GetSinglePostFailure extends GetSinglePostState {
  @override
  List<Object> get props => [];
}
