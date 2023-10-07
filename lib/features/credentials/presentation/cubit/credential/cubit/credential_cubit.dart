import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/credentials/domain/usecases/sign_in_usecase.dart';
import 'package:instagram_clone/features/credentials/domain/usecases/sign_up_usecase.dart';
import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';
part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInUseCase signInUserUseCase;
  final SignUpUseCase signUpUseCase;
  CredentialCubit(
      {required this.signInUserUseCase, required this.signUpUseCase})
      : super(CredentialInitial());

  Future<void> signInUser(
      {required String email, required String password}) async {
    emit(CredentialLoading());

    try {
      await signInUserUseCase
          .call(UserEntity(email: email, password: password));
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpUser({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await signUpUseCase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}