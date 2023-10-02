part of 'get_single_other_user_cubit.dart';

sealed class GetSingleOtherUserState extends Equatable {
  const GetSingleOtherUserState();

  @override
  List<Object> get props => [];
}

final class GetSingleOtherUserInitial extends GetSingleOtherUserState {
  @override
  List<Object> get props => [];
}

final class GetSingleOtherUserLoading extends GetSingleOtherUserState {
  @override
  List<Object> get props => [];
}

final class GetSingleOtherUserLoaded extends GetSingleOtherUserState {
  final UserEntity otherUser;
  const GetSingleOtherUserLoaded({required this.otherUser});
  @override
  List<Object> get props => [otherUser];
}

final class GetSingleOtherUserFailure extends GetSingleOtherUserState {
  @override
  List<Object> get props => [];
}
