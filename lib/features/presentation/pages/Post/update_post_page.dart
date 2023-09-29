import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/presentation/pages/Post/widget/update_post_widget.dart';

import '../../cubit/post/cubit/post_cubit.dart';

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
