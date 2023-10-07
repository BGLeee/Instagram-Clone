import 'package:instagram_clone/features/auth/domain/repository/firebase_repository_auth.dart';

class SignOutUseCase {
  final FirebaseRepositoryAuth repository;

  SignOutUseCase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}
