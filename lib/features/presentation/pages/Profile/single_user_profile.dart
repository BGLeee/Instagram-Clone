import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Profile/single_user_profile_widget.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class SingleUserProfilePage extends StatelessWidget {
  final String? otherUserId;
  const SingleUserProfilePage({super.key, required this.otherUserId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider.value(value: ic.sl<GetSingleUserCubit>()),
      BlocProvider.value(value: ic.sl<PostCubit>())
    ], child: SingleUserProfileWidget(otherUserId: otherUserId));
  }
}
