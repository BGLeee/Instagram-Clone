import 'package:instagram_clone/features/credentials/domain/repository/firebase_repository_credentials.dart';
import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';

class SignInUseCase {
  final FirebaseRepositoryCredentials repository;

  SignInUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.signInUser(userEntity);
  }
}
