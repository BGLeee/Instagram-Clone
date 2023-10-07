import 'package:instagram_clone/features/auth/data/data_sources/remote_data_sources/remote_data_source_auth.dart';
import 'package:instagram_clone/features/auth/domain/repository/firebase_repository_auth.dart';

class FirebaseRepositoryAuthImpl implements FirebaseRepositoryAuth {
  final FirebaseRemoteDataAuthSource remoteDataSource;
  FirebaseRepositoryAuthImpl({required this.remoteDataSource});

  @override
  Future<String> getCurrentUid() async {
    return remoteDataSource.getCurrentUid();
  }

  @override
  Future<bool> isSignIn() async {
    return remoteDataSource.isSignIn();
  }

  @override
  Future<void> signOut() async {
    return remoteDataSource.signOut();
  }
}
