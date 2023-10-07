import 'package:instagram_clone/features/replay/data/data_source/remote_data_replay_source.dart';
import 'package:instagram_clone/features/replay/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/replay/domain/repository/firebase_replay_repository.dart';

class FirebaseReplayRepositoryImpl implements FirebaseReplayRepository {
  final FirebaseRemoteReplayDataSource remoteDataSource;
  FirebaseReplayRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> getCurrentUid() async {
    return remoteDataSource.getCurrentUid();
  }

  @override
  Future<void> createReplay(ReplayEntity replay) {
    return remoteDataSource.createReplay(replay);
  }

  @override
  Future<void> deleteReplay(ReplayEntity replay) {
    return remoteDataSource.deleteReplay(replay);
  }

  @override
  Future<void> likeReplay(ReplayEntity replay) {
    return remoteDataSource.likeReplay(replay);
  }

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) {
    return remoteDataSource.readReplays(replay);
  }

  @override
  Future<void> updateReplay(ReplayEntity replay) {
    return remoteDataSource.updateReplay(replay);
  }
}
