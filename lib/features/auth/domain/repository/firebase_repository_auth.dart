abstract class FirebaseRepositoryAuth {
  // Credential

  Future<bool> isSignIn();

  Future<void> signOut();

  // User

  Future<String> getCurrentUid();
}
