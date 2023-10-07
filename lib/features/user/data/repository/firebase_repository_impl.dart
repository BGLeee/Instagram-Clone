import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/user/domain/repository/firebase_repository.dart';

import '../data_sources/remote_data_sources/remote_data_source.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;
  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createUser(UserEntity user) async {
    return remoteDataSource.createUser(user);
  }

  @override
  Future<String> getCurrentUid() async {
    return remoteDataSource.getCurrentUid();
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    return remoteDataSource.getSingleUser(uid);
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    return remoteDataSource.getUsers(user);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    return remoteDataSource.updateUser(user);
  }

  @override
  Future<void> followUnFollowUser(UserEntity user) {
    return remoteDataSource.followUnFollowUser(user);
  }

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    return remoteDataSource.getSingleOtherUser(otherUid);
  }
}
