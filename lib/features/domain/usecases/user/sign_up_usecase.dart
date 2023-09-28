import 'package:instagram_clone/features/domain/repository/firebase_repository.dart';

import '../../entities/user/user_entity.dart';

class SignUpUseCase {
  final FirebaseRepository repository;

  SignUpUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.signUpUser(userEntity);
  }
}
