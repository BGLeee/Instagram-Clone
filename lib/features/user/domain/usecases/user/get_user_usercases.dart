import '../../entities/user/user_entity.dart';
import '../../repository/firebase_repository.dart';

class GetUserUseCase {
  final FirebaseRepository repository;

  GetUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String uid) {
    return repository.getSingleUser(uid);
  }
}
