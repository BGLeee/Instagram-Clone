import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/comment/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:instagram_clone/features/home/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post/get_signle_post/cubit/get_single_post_cubit.dart';
import 'package:instagram_clone/features/comment/presentation/widgets/comment_widgets/comment_main_widget.dart';
import 'package:instagram_clone/features/replay/presentation/cubit/replay/cubit/replay_cubit.dart';
import 'package:instagram_clone/features/user/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';

class CommentPage extends StatelessWidget {
  final AppEntity appEntity;
  const CommentPage({super.key, required this.appEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: ic.sl<CommentCubit>(),
          ),
          BlocProvider.value(
            value: ic.sl<GetSingleUserCubit>(),
          ),
          BlocProvider.value(
            value: ic.sl<GetSinglePostCubit>(),
          ),
          BlocProvider.value(
            value: ic.sl<ReplayCubit>(),
          ),
        ],
        child: CommentMainWidget(
          appEntity: appEntity,
        ));
  }
}
