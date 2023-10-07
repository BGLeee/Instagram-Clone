import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/post/presentation/cubit/post/get_posts/cubit/post_cubit.dart';
import 'package:instagram_clone/features/post/presentation/widgets/upload_post_widget.dart';

class UploadPostPage extends StatelessWidget {
  final UserEntity currentUser;
  UploadPostPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ic.sl<PostCubit>(),
      child: UploadPostWidget(
        currentUser: currentUser,
      ),
    );
  }
}
