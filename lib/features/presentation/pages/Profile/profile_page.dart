import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Profile/widget/profile_main_widget.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class ProfilePage extends StatelessWidget {
  final UserEntity currentUser;
  const ProfilePage({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: ic.sl<PostCubit>(),
        child: ProfileMainWidget(currentUser: currentUser));
  }
}
