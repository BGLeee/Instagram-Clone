import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:instagram_clone/Injection_container.dart" as ic;
import 'package:instagram_clone/features/replay/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/comment/presentation/widgets/comment_widgets/widget/edit_replay_widget.dart';
import 'package:instagram_clone/features/replay/presentation/cubit/replay/cubit/replay_cubit.dart';

class EditReplayPage extends StatelessWidget {
  final ReplayEntity? replay;
  const EditReplayPage({super.key, this.replay});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ic.sl<ReplayCubit>(),
      child: EditReplayWidget(
        replay: replay,
      ),
    );
  }
}
