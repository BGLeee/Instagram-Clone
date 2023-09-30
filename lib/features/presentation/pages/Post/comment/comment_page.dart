import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/post/get_signle_post/cubit/get_single_post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Post/comment/comment_main_widget.dart';

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
        ],
        child: CommentMainWidget(
          appEntity: appEntity,
        ));
  }
}
