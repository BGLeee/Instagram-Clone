import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/activity/activity_main_widget.dart';
import '../../../../const.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String? _currentUserUid;

  @override
  void initState() {
    super.initState();
    ic.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUserUid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          "Activity",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: BlocProvider.value(
        value: ic.sl<PostCubit>()..getPosts(post: const PostEntity()),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, postState) {
            if (postState is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (postState is PostLoaded) {
              // log("you are success ${postState.posts.length}");
              final post = postState.posts
                  .where((post) => post.likes!.contains(_currentUserUid))
                  .toList();
              return post.isEmpty
                  ? _noPostsWidget()
                  : ListView.builder(
                      itemCount: post.length,
                      itemBuilder: (context, index) {
                        // if (post.likes!.contains(_currentUserUid)) {
                        return BlocProvider.value(
                          value: ic.sl<PostCubit>(),
                          child: ActivityMainWidget(post: post[index]),
                        );
                      });
            }

            if (postState is PostFailure) {
              toast("Some thing happen while trying to display posts");
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  _noPostsWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon(Icons.emoji_emotions_outlined),
        Center(
          child: Text(
            "You haven't liked any post",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
