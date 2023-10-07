import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/post/presentation/cubit/post/get_posts/cubit/post_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/pages/Profile/single_user_profile_widget.dart';

class SingleUserProfilePage extends StatelessWidget {
  final String? otherUserId;
  const SingleUserProfilePage({super.key, required this.otherUserId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [BlocProvider.value(value: ic.sl<PostCubit>())],
        child: SingleUserProfileWidget(otherUserId: otherUserId));
  }
}
