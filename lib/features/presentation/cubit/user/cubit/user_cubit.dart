import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/domain/usecases/user/follow_UnFollow_user_usecase.dart';

import '../../../../domain/entities/user/user_entity.dart';
import '../../../../domain/usecases/user/get_users_usecases.dart';
import '../../../../domain/usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUseCase updateUserUseCase;
  final GetUsersUseCase getUsersUseCase;
  final FollowUnFollowUserUseCase followUnFollowUserUseCase;
  UserCubit(
      {required this.updateUserUseCase,
      required this.getUsersUseCase,
      required this.followUnFollowUserUseCase})
      : super(UserInitial());

  Future<void> getUsers({required UserEntity user}) async {
    emit(UserLoading());
    try {
      final streamResponse = getUsersUseCase.call(user);
      streamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUser({required UserEntity user}) async {
    try {
      await updateUserUseCase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> followUnFollowerUser({required UserEntity user}) async {
    try {
      await followUnFollowUserUseCase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
