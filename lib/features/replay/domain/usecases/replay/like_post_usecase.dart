import 'package:instagram_clone/features/replay/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/replay/domain/repository/firebase_replay_repository.dart';

class LikeReplayUseCase {
  final FirebaseReplayRepository repository;

  LikeReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.likeReplay(replay);
  }
}
