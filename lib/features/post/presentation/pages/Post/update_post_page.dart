import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/post/presentation/cubit/post/get_posts/cubit/post_cubit.dart';
import 'package:instagram_clone/features/post/presentation/widgets/update_post_widget.dart';

class UpdatePostPage extends StatefulWidget {
  final PostEntity post;
  const UpdatePostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ic.sl<PostCubit>(),
      child: UpdatePostWidget(post: widget.post),
    );
  }
}
