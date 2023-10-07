import 'package:instagram_clone/features/replay/domain/entities/replay/replay_entity.dart';

abstract class FirebaseReplayRepository {
  // User

  Future<String> getCurrentUid();

  //replay Features
  Future<void> createReplay(ReplayEntity replay);
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay);
  Future<void> updateReplay(ReplayEntity replay);
  Future<void> deleteReplay(ReplayEntity replay);
  Future<void> likeReplay(ReplayEntity replay);
}
