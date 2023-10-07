import 'package:instagram_clone/features/auth/domain/repository/firebase_repository_auth.dart';

class IsSignInUseCase {
  final FirebaseRepositoryAuth repository;

  IsSignInUseCase({required this.repository});

  Future<bool> call() {
    return repository.isSignIn();
  }
}
