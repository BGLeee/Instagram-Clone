import 'package:instagram_clone/features/replay/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/replay/domain/repository/firebase_replay_repository.dart';

class ReadReplaysUseCase {
  final FirebaseReplayRepository repository;

  ReadReplaysUseCase({required this.repository});

  Stream<List<ReplayEntity>> call(ReplayEntity replay) {
    return repository.readReplays(replay);
  }
}
