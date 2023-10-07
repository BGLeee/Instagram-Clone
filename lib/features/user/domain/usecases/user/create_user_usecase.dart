import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';

import '../../repository/firebase_repository.dart';

class CreateUserUseCase {
  final FirebaseRepository repository;

  CreateUserUseCase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.createUser(user);
  }
}
