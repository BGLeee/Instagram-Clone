import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/post/get_signle_post/cubit/get_single_post_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Post/widget/post_detail_main_widget.dart';

class PostDetailPage extends StatelessWidget {
  final String? postId;
  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: ic.sl<GetSinglePostCubit>(),
        ),
        BlocProvider.value(value: ic.sl<PostCubit>())
      ],
      child: PostDetailMainWidget(
        postId: postId,
      ),
    );
  }
}
